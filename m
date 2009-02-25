From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 24 Feb 2009 16:00:11 -0800
Message-ID: <da824cf30902241600g121d2acfw937020a750a79a57@mail.gmail.com>
References: <20090224093216.GA11813@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:19549 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZBYAAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 19:00:17 -0500
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id n1P00EEp014805
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2009 16:00:14 -0800
Received: from rv-out-0708.google.com (rvfb17.prod.google.com [10.140.179.17])
	by zps78.corp.google.com with ESMTP id n1ONxVbV006451
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2009 16:00:12 -0800
Received: by rv-out-0708.google.com with SMTP id b17so2716135rvf.28
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2009 16:00:11 -0800 (PST)
In-Reply-To: <20090224093216.GA11813@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 24, 2009 at 1:32 AM, Eric Moore <eric.moore@lsi.com> wrote:
> mpt2sas_base
>
> Common API layer interface to MPT (Message Passing Technology) firmwa=
re.
>
> Signed-off-by: Eric Moore <eric.moore@lsi.com>
> ---
>
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c =C2=A0 =C2=A0 =C2=A0 1969-1=
2-31 17:00:00.000000000 -0700
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c =C2=A0 =C2=A0 =C2=A0 2009-0=
2-24 14:27:01.000000000 -0700
> @@ -0,0 +1,3403 @@
> +/*
> + * This is the Fusion MPT base driver providing common API layer int=
erface
> + * for access to MPT (Message Passing Technology) firmware.
> + *
> + * This code is based on drivers/scsi/mpt2sas/mpt2_base.c
> + * Copyright (C) 2007-2008 =C2=A0LSI Corporation
> + * =C2=A0(mailto:DL-MPTFusionLinux@lsi.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =C2=A0See th=
e
> + * GNU General Public License for more details.
> + *
> + * NO WARRANTY
> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES O=
R
> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITH=
OUT
> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEME=
NT,
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipie=
nt is
> + * solely responsible for determining the appropriateness of using a=
nd
> + * distributing the Program and assumes all risks associated with it=
s
> + * exercise of rights under this Agreement, including but not limite=
d to
> + * the risks and costs of program errors, damage to or loss of data,
> + * programs or equipment, and unavailability or interruption of oper=
ations.
> +
> + * DISCLAIMER OF LIABILITY
> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY F=
OR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUS=
ED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY=
, OR
> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT O=
=46 THE
> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED
> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =C2=
=A002110-1301,
> + * USA.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/pci.h>
> +#include <linux/kdev_t.h>
> +#include <linux/blkdev.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/sort.h>
> +#include <linux/io.h>
> +
> +#include "mpt2sas_base.h"
> +
> +static MPT_CALLBACK =C2=A0 =C2=A0mpt_callbacks[MPT_MAX_CALLBACKS];
> +
> +#define FAULT_POLLING_INTERVAL 1000 /* in milliseconds */
> +#define MPT2SAS_MAX_REQUEST_QUEUE 500 /* maximum controller queue de=
pth */
> +
> +static int max_queue_depth =3D -1;
> +module_param(max_queue_depth, int, 0);
> +MODULE_PARM_DESC(max_queue_depth, " max controller queue depth ");
> +
> +static int max_sgl_entries =3D -1;
> +module_param(max_sgl_entries, int, 0);
> +MODULE_PARM_DESC(max_sgl_entries, " max sg entries ");
> +
> +static int msix_disable =3D -1;
> +module_param(msix_disable, int, 0);
> +MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (def=
ault=3D0)");
> +
> +/**
> + * _base_fault_reset_work - workq handling ioc fault conditions
> + * @work: input argument, used to derive ioc
> + * Context: sleep.
> + *
> + * Return nothing.
> + */
> +static void
> +_base_fault_reset_work(struct work_struct *work)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct MPT2SAS_ADAPTER *ioc =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 container_of(work, struct MPT2SA=
S_ADAPTER, fault_reset_work.work);
> + =C2=A0 =C2=A0 =C2=A0 unsigned long =C2=A0 =C2=A0flags;
> + =C2=A0 =C2=A0 =C2=A0 u32 doorbell;
> + =C2=A0 =C2=A0 =C2=A0 int rc;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->ioc_reset_in_progress_=
lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->ioc_reset_in_progress)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto rearm_timer;
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->ioc_reset_in_prog=
ress_lock, flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 doorbell =3D base_get_iocstate(ioc, 0);
> + =C2=A0 =C2=A0 =C2=A0 if ((doorbell & MPI2_IOC_STATE_MASK) =3D=3D MP=
I2_IOC_STATE_FAULT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D base_hard_r=
eset_handler(ioc, CAN_SLEEP, FORCE_BIG_HAMMER);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_WAR=
N_FMT "%s: hard reset: %s\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __fu=
nc__, (rc =3D=3D 0) ? "success" : "failed");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 doorbell =3D base_=
get_iocstate(ioc, 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((doorbell & MP=
I2_IOC_STATE_MASK) =3D=3D MPI2_IOC_STATE_FAULT)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 base_fault_info(ioc, doorbell &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 MPI2_DOORBELL_DATA_MASK);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->ioc_reset_in_progress_=
lock, flags);
> + rearm_timer:
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->fault_reset_work_q)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_delayed_work=
(ioc->fault_reset_work_q,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc=
->fault_reset_work,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msec=
s_to_jiffies(FAULT_POLLING_INTERVAL));
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->ioc_reset_in_prog=
ress_lock, flags);
> +}
> +
> +#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> +/**
> + * _base_sas_ioc_info - verbose translation of the ioc status
> + * @ioc: pointer to scsi command object
> + * @mpi_reply: reply mf payload returned from firmware
> + * @request_hdr: request mf
> + *
> + * Return nothing.
> + */
> +static void
> +_base_sas_ioc_info(struct MPT2SAS_ADAPTER *ioc, MPI2DefaultReply_t *=
mpi_reply,
> + =C2=A0 =C2=A0 MPI2RequestHeader_t *request_hdr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u16 ioc_status =3D le16_to_cpu(mpi_reply->IOCS=
tatus) &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCSTATUS_MASK;
> + =C2=A0 =C2=A0 =C2=A0 char *desc =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 u16 frame_sz;
> + =C2=A0 =C2=A0 =C2=A0 char *func_str =3D NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* SCSI_IO, RAID_PASS are handled from _scsih_=
scsi_ioc_info */
> + =C2=A0 =C2=A0 =C2=A0 if (request_hdr->Function =3D=3D MPI2_FUNCTION=
_SCSI_IO_REQUEST ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 request_hdr->Function =3D=3D MPI=
2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 request_hdr->Function =3D=3D MPI=
2_FUNCTION_EVENT_NOTIFICATION)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (ioc_status) {
> +
> +/*******************************************************************=
*********
> +* =C2=A0Common IOCStatus values for all replies
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INVALID_FUNCTION:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "invalid =
function";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_BUSY:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "busy";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INVALID_SGL:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "invalid =
sgl";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INTERNAL_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "internal=
 error";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INVALID_VPID:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "invalid =
vpid";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INSUFFICIENT_RESOURCES:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "insuffic=
ient resources";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INVALID_FIELD:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "invalid =
field";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_INVALID_STATE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "invalid =
state";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_OP_STATE_NOT_SUPPORTED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "op state=
 not supported";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +/*******************************************************************=
*********
> +* =C2=A0Config IOCStatus values
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_CONFIG_INVALID_ACTION:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "config i=
nvalid action";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_CONFIG_INVALID_TYPE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "config i=
nvalid type";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_CONFIG_INVALID_PAGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "config i=
nvalid page";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_CONFIG_INVALID_DATA:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "config i=
nvalid data";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_CONFIG_NO_DEFAULTS:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "config n=
o defaults";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_CONFIG_CANT_COMMIT:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "config c=
ant commit";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +/*******************************************************************=
*********
> +* =C2=A0SCSI IO Reply
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_RECOVERED_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_INVALID_DEVHANDLE:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_DATA_OVERRUN:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_DATA_UNDERRUN:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_IO_DATA_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_IOC_TERMINATED:
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +/*******************************************************************=
*********
> +* =C2=A0For use by SCSI Initiator and SCSI Target end-to-end data pr=
otection
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "eedp gua=
rd error";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "eedp ref=
 tag error";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "eedp app=
 tag error";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +/*******************************************************************=
*********
> +* =C2=A0SCSI Target values
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_INVALID_IO_INDEX:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target i=
nvalid io index";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_ABORTED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target a=
borted";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_NO_CONN_RETRYABLE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target n=
o conn retryable";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_NO_CONNECTION:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target n=
o connection";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_XFER_COUNT_MISMATCH=
:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target x=
fer count mismatch";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_DATA_OFFSET_ERROR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target d=
ata offset error";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_TOO_MUCH_WRITE_DATA=
:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target t=
oo much write data";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_IU_TOO_SHORT:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target i=
u too short";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_ACK_NAK_TIMEOUT:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target a=
ck nak timeout";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_TARGET_NAK_RECEIVED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "target n=
ak received";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +/*******************************************************************=
*********
> +* =C2=A0Serial Attached SCSI values
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SAS_SMP_REQUEST_FAILED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "smp requ=
est failed";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_SAS_SMP_DATA_OVERRUN:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "smp data=
 overrun";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> +
> +/*******************************************************************=
*********
> +* =C2=A0Diagnostic Buffer Post / Diagnostic Release values
> +********************************************************************=
********/
> +
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_IOCSTATUS_DIAGNOSTIC_RELEASED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "diagnost=
ic released";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 default:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!desc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (request_hdr->Function) {
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_CONFIG:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2ConfigRequest_t) + ioc->sge_size;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "conf=
ig_page";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_SCSI_TASK_MGMT:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2SCSITaskManagementRequest_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "task=
_mgmt";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_SAS_IO_UNIT_CONTROL:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2SasIoUnitControlRequest_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "sas_=
iounit_ctl";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2SepRequest_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "encl=
osure";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_IOC_INIT:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2IOCInitRequest_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "ioc_=
init";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_PORT_ENABLE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2PortEnableRequest_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "port=
_enable";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_FUNCTION_SMP_PASSTHROUGH:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D sizeo=
f(Mpi2SmpPassthroughRequest_t) + ioc->sge_size;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "smp_=
passthru";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 default:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 frame_sz =3D 32;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 func_str =3D "unkn=
own";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_WARN_FMT "ioc_status: %s(0x%04x=
), request(0x%p),"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " (%s)\n", ioc->name, desc, ioc_=
status, request_hdr, func_str);
> +
> + =C2=A0 =C2=A0 =C2=A0 _debug_dump_mf(request_hdr, frame_sz/4);
> +}
> +
> +/**
> + * _base_display_event_data - verbose translation of firmware asyn e=
vents
> + * @ioc: pointer to scsi command object
> + * @mpi_reply: reply mf payload returned from firmware
> + *
> + * Return nothing.
> + */
> +static void
> +_base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
> + =C2=A0 =C2=A0Mpi2EventNotificationReply_t *mpi_reply)
> +{
> + =C2=A0 =C2=A0 =C2=A0 char *desc =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 u16 event;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!(ioc->logging_level & MPT_DEBUG_EVENTS))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 event =3D le16_to_cpu(mpi_reply->Event);
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (event) {
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_LOG_DATA:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Log Data=
";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_STATE_CHANGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Status C=
hange";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_HARD_RESET_RECEIVED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Hard Res=
et Received";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_EVENT_CHANGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Event Ch=
ange";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_TASK_SET_FULL:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Task Set=
 Full";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Device S=
tatus Change";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_IR_OPERATION_STATUS:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "IR Opera=
tion Status";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_DISCOVERY:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D =C2=A0"Di=
scovery";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "SAS Broa=
dcast Primitive";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "SAS Init=
 Device Status Change";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_INIT_TABLE_OVERFLOW:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "SAS Init=
 Table Overflow";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "SAS Topo=
logy Change List";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "SAS Encl=
osure Device Status Change";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_IR_VOLUME:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "IR Volum=
e";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_IR_PHYSICAL_DISK:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "IR Physi=
cal Disk";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "IR Confi=
guration Change List";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPI2_EVENT_LOG_ENTRY_ADDED:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "Log Entr=
y Added";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!desc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "%s\n", ioc->name, des=
c);
> +}
> +#endif
> +
> +/**
> + * _base_sas_log_info - verbose translation of firmware log info
> + * @ioc: pointer to scsi command object
> + * @log_info: log info
> + *
> + * Return nothing.
> + */
> +static void
> +_base_sas_log_info(struct MPT2SAS_ADAPTER *ioc , u32 log_info)
> +{
> + =C2=A0 =C2=A0 =C2=A0 union loginfo_type {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 =C2=A0 =C2=A0 =
loginfo;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 u32 =C2=A0 =C2=A0 subcode:16;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 u32 =C2=A0 =C2=A0 code:8;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 u32 =C2=A0 =C2=A0 originator:4;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 u32 =C2=A0 =C2=A0 bus_type:4;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } dw;
> + =C2=A0 =C2=A0 =C2=A0 };
> + =C2=A0 =C2=A0 =C2=A0 union loginfo_type sas_loginfo;
> + =C2=A0 =C2=A0 =C2=A0 char *originator_str =3D NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 sas_loginfo.loginfo =3D log_info;
> + =C2=A0 =C2=A0 =C2=A0 if (sas_loginfo.dw.bus_type !=3D 3 /*SAS*/)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* eat the loginfos associated with task abort=
s */
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->ignore_loginfos && (log_info =3D=3D 3=
0050000 || log_info =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x31140000 || log_info =3D=3D 0x=
31130000))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 switch (sas_loginfo.dw.originator) {
> + =C2=A0 =C2=A0 =C2=A0 case 0:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 originator_str =3D=
 "IOP";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case 1:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 originator_str =3D=
 "PL";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case 2:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 originator_str =3D=
 "IR";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_WARN_FMT "log_info(0x%08x): ori=
ginator(%s), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "code(0x%02x), sub_code(0x%04x)\=
n", ioc->name, log_info,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0originator_str, sas_loginf=
o.dw.code,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sas_loginfo.dw.subcode);
> +}
> +
> +/**
> + * base_fault_info - verbose translation of firmware FAULT code
> + * @ioc: pointer to scsi command object
> + * @fault_code: fault code
> + *
> + * Return nothing.
> + */
> +void
> +base_fault_info(struct MPT2SAS_ADAPTER *ioc , u16 fault_code)
> +{
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR_FMT "fault_state(0x%04x)!\n=
",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, fault_code);
> +}
> +
> +/**
> + * _base_display_reply_info -
> + * @ioc: pointer to scsi command object
> + * @smid: system request message index
> + * @VF_ID: virtual function id
> + * @reply: reply message frame(lower 32bit addr)
> + *
> + * Return nothing.
> + */
> +static void
> +_base_display_reply_info(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 V=
=46_ID,
> + =C2=A0 =C2=A0u32 reply)
> +{
> + =C2=A0 =C2=A0 =C2=A0 MPI2DefaultReply_t *mpi_reply;
> + =C2=A0 =C2=A0 =C2=A0 u16 ioc_status;
> +
> + =C2=A0 =C2=A0 =C2=A0 mpi_reply =3D =C2=A0base_get_reply_virt_addr(i=
oc, reply);
> + =C2=A0 =C2=A0 =C2=A0 ioc_status =3D le16_to_cpu(mpi_reply->IOCStatu=
s);
> +#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc_status & MPI2_IOCSTATUS_MASK) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (ioc->logging_level & MPT_DEBUG_=
REPLY)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _base_sas_ioc_info=
(ioc , mpi_reply,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base=
_get_msg_frame(ioc, smid));
> + =C2=A0 =C2=A0 =C2=A0 }
> +#endif

Can all the "if (ioc_status...)" gunk get wrapped into a macro that is
conditionally defined?
e.g. the logging level could become a compile time option instead of a
runtime option.

I was able to cut 1% CPU utilization from another driver by allowing
the compiler to get
rid of all the debug messages that would never get printed because
they were below
a particular threshold.

Maybe it doesn't matter in this case. But I've no clue yet how
often/when _base_display_reply_info()
is called.

> + =C2=A0 =C2=A0 =C2=A0 if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_=
AVAILABLE)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _base_sas_log_info=
(ioc, le32_to_cpu(mpi_reply->IOCLogInfo));
> +}
> +
> +/**
> + * base_done - base internal command completion routine
> + * @ioc: pointer to scsi command object
> + * @smid: system request message index
> + * @VF_ID: virtual function id
> + * @reply: reply message frame(lower 32bit addr)
> + *
> + * Return nothing.
> + */
> +void
> +base_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 VF_ID, u32 reply=
)
> +{
> + =C2=A0 =C2=A0 =C2=A0 MPI2DefaultReply_t *mpi_reply;
> +
> + =C2=A0 =C2=A0 =C2=A0 mpi_reply =3D =C2=A0base_get_reply_virt_addr(i=
oc, reply);
> + =C2=A0 =C2=A0 =C2=A0 if (mpi_reply && mpi_reply->Function =3D=3D MP=
I2_FUNCTION_EVENT_ACK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status =3D=3D MPT2_CMD_NOT_=
USED)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status |=3D MPT2_CMD_COMPLETE;
> + =C2=A0 =C2=A0 =C2=A0 if (mpi_reply) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.sta=
tus |=3D MPT2_CMD_REPLY_VALID;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(ioc->base_c=
mds.reply, mpi_reply, mpi_reply->MsgLength*4);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status &=3D ~MPT2_CMD_PENDING;
> + =C2=A0 =C2=A0 =C2=A0 complete(&ioc->base_cmds.done);
> +}
> +
> +/**
> + * _base_async_event - main callback handler for firmware asyn event=
s
> + * @ioc: pointer to scsi command object
> + * @VF_ID: virtual function id
> + * @reply: reply message frame(lower 32bit addr)
> + *
> + * Return nothing.
> + */
> +static void
> +_base_async_event(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, u32 reply)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2EventNotificationReply_t *mpi_reply;
> + =C2=A0 =C2=A0 =C2=A0 Mpi2EventAckRequest_t *ack_request;
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> +
> + =C2=A0 =C2=A0 =C2=A0 mpi_reply =3D =C2=A0base_get_reply_virt_addr(i=
oc, reply);
> + =C2=A0 =C2=A0 =C2=A0 if (!mpi_reply)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> + =C2=A0 =C2=A0 =C2=A0 if (mpi_reply->Function !=3D MPI2_FUNCTION_EVE=
NT_NOTIFICATION)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +#ifdef CONFIG_SCSI_MPT2SAS_LOGGING
> + =C2=A0 =C2=A0 =C2=A0 _base_display_event_data(ioc, mpi_reply);
> +#endif
> + =C2=A0 =C2=A0 =C2=A0 if (!(mpi_reply->AckRequired & MPI2_EVENT_NOTI=
=46ICATION_ACK_REQUIRED))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 smid =3D base_get_smid(ioc, ioc->base_cb_idx);
> + =C2=A0 =C2=A0 =C2=A0 if (!smid) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed obtaining a smid\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ack_request =3D base_get_msg_frame(ioc, smid);
> + =C2=A0 =C2=A0 =C2=A0 memset(ack_request, 0, sizeof(Mpi2EventAckRequ=
est_t));
> + =C2=A0 =C2=A0 =C2=A0 ack_request->Function =3D MPI2_FUNCTION_EVENT_=
ACK;
> + =C2=A0 =C2=A0 =C2=A0 ack_request->Event =3D mpi_reply->Event;
> + =C2=A0 =C2=A0 =C2=A0 ack_request->EventContext =3D mpi_reply->Event=
Context;
> + =C2=A0 =C2=A0 =C2=A0 ack_request->VF_ID =3D VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 base_put_smid_default(ioc, smid, VF_ID);
> +
> + out:
> + =C2=A0 =C2=A0 =C2=A0 scsih_event_callback(ioc, VF_ID, reply); /* sc=
sih callback handler */
> + =C2=A0 =C2=A0 =C2=A0 ctl_event_callback(ioc, VF_ID, reply); /* ctl =
callback handler */
> +}
> +
> +/**
> + * _base_mask_interrupts - disable interrupts
> + * @ioc: pointer to scsi command object
> + *
> + * Disabling ResetIRQ, Reply and Doorbell Interrupts
> + *
> + * Return nothing.
> + */
> +static void
> +_base_mask_interrupts(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 him_register;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->mask_interrupts =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 him_register =3D readl(&ioc->chip->HostInterru=
ptMask);
> + =C2=A0 =C2=A0 =C2=A0 him_register |=3D MPI2_HIM_DIM + MPI2_HIM_RIM =
+ MPI2_HIM_RESET_IRQ_MASK;
> + =C2=A0 =C2=A0 =C2=A0 writel(him_register, &ioc->chip->HostInterrupt=
Mask);

This is a posted write. Does it need to be flushed?
ie do other parts of the driver require this take effect immediately
or will they tolerate some late arriving interrupt?

> +}
> +
> +/**
> + * _base_unmask_interrupts - enable interrupts
> + * @ioc: pointer to scsi command object
> + *
> + * Enabling only Reply Interrupts
> + *
> + * Return nothing.
> + */
> +static void
> +_base_unmask_interrupts(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 him_register;
> +
> + =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->chip->HostInterruptStatus);
> + =C2=A0 =C2=A0 =C2=A0 him_register =3D readl(&ioc->chip->HostInterru=
ptMask);
> + =C2=A0 =C2=A0 =C2=A0 him_register &=3D ~MPI2_HIM_RIM;
> + =C2=A0 =C2=A0 =C2=A0 writel(him_register, &ioc->chip->HostInterrupt=
Mask);
> + =C2=A0 =C2=A0 =C2=A0 ioc->mask_interrupts =3D 0;
> +}
> +
> +/**
> + * base_interrupt - MPT adapter (IOC) specific interrupt handler.
> + * @irq: irq number (not used)
> + * @bus_id: bus identifier cookie =3D=3D pointer to MPT_ADAPTER stru=
cture
> + * @r: pt_regs pointer (not used)
> + *
> + * Return IRQ_HANDLE if processed, else IRQ_NONE.
> + */
> +static irqreturn_t
> +base_interrupt(int irq, void *bus_id)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 post_index, post_index_next, completed_cmd=
s;
> + =C2=A0 =C2=A0 =C2=A0 u8 request_desript_type;
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> + =C2=A0 =C2=A0 =C2=A0 u8 cb_idx;
> + =C2=A0 =C2=A0 =C2=A0 u32 reply;
> + =C2=A0 =C2=A0 =C2=A0 u8 VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 int i;
> + =C2=A0 =C2=A0 =C2=A0 struct MPT2SAS_ADAPTER *ioc =3D bus_id;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->mask_interrupts)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IRQ_NONE;
> +
> + =C2=A0 =C2=A0 =C2=A0 post_index =3D ioc->reply_post_host_index;
> + =C2=A0 =C2=A0 =C2=A0 request_desript_type =3D ioc->reply_post_free[=
post_index].
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Default.ReplyFlags & MPI2_RPY_DE=
SCRIPT_FLAGS_TYPE_MASK;
> + =C2=A0 =C2=A0 =C2=A0 if (request_desript_type =3D=3D MPI2_RPY_DESCR=
IPT_FLAGS_UNUSED)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IRQ_NONE;
> +
> + =C2=A0 =C2=A0 =C2=A0 completed_cmds =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 do {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->reply_pos=
t_free[post_index].Words =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0xFF=
=46FFFFFFFFFFFFFULL)

Would this be better written as "~0ULL" or as a predefined constant?

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reply =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cb_idx =3D 0xFF;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smid =3D le16_to_c=
pu(ioc->reply_post_free[post_index].
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Defa=
ult.DescriptorTypeDependent1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 VF_ID =3D ioc->rep=
ly_post_free[post_index].
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Defa=
ult.VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (request_desrip=
t_type =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2=
_RPY_DESCRIPT_FLAGS_ADDRESS_REPLY) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 reply =3D le32_to_cpu(ioc->reply_post_free[post_index].
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 AddressReply.ReplyFrameAddress);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (request=
_desript_type =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2=
_RPY_DESCRIPT_FLAGS_TARGET_COMMAND_BUFFER)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto next;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (request_d=
esript_type =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2=
_RPY_DESCRIPT_FLAGS_TARGETASSIST_SUCCESS)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto next;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (smid)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cb_idx =3D ioc->scsi_lookup[smid - 1].cb_idx;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (smid && cb_idx=
 !=3D 0xFF) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mpt_callbacks[cb_idx](ioc, smid, VF_ID, reply);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (reply)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _base_display_reply_info(ioc, smid,=
 VF_ID,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reply);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 base_free_smid(ioc, smid);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!smid)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 _base_async_event(ioc, VF_ID, reply);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* reply free queu=
e handling */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (reply) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->reply_free_host_index =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 (ioc->reply_free_host_index =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 (ioc->reply_free_queue_depth - 1)) ?
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 0 : ioc->reply_free_host_index + 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->reply_free[ioc->reply_free_host_index] =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(reply);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 writel(ioc->reply_free_host_index,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 &ioc->chip->ReplyFreeHostIndex);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 wmb();
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> + next:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 post_index_next =3D=
 (post_index =3D=3D (ioc->reply_post_queue_depth -
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1)) =
? 0 : post_index + 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 request_desript_ty=
pe =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>reply_post_free[post_index_next].Default.ReplyFlags
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 & MP=
I2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 completed_cmds++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (request_desrip=
t_type =3D=3D MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 post_index =3D pos=
t_index_next;
> + =C2=A0 =C2=A0 =C2=A0 } while (1);
> +
> + out:
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!completed_cmds)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return IRQ_NONE;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply post descriptor handling */
> + =C2=A0 =C2=A0 =C2=A0 post_index_next =3D ioc->reply_post_host_index=
;
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0 ; i < completed_cmds; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 post_index =3D pos=
t_index_next;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* poison the repl=
y post descriptor */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_fr=
ee[post_index_next].Words =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0xFF=
=46FFFFFFFFFFFFFULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 post_index_next =3D=
 (post_index =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (ioc=
->reply_post_queue_depth - 1))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ? 0 =
: post_index + 1;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_host_index =3D post_index_next=
;
> + =C2=A0 =C2=A0 =C2=A0 writel(post_index_next, &ioc->chip->ReplyPostH=
ostIndex);
> + =C2=A0 =C2=A0 =C2=A0 wmb();

What is the wmb() protecting here? Add a comment?

My impression is the wmb() belongs in front of the writel() and not beh=
ind it.
That is, we want to make sure the updates to ioc->reply_post_free[]
are visible before sending out the writel().

> + =C2=A0 =C2=A0 =C2=A0 return IRQ_HANDLED;
> +}
> +
> +/**
> + * base_release_callback_handler - clear interupt callback handler
> + * @cb_idx: callback index
> + *
> + * Return nothing.
> + */
> +void
> +base_release_callback_handler(u8 cb_idx)
> +{
> + =C2=A0 =C2=A0 =C2=A0 mpt_callbacks[cb_idx] =3D NULL;
> +}
> +
> +/**
> + * base_register_callback_handler - obtain index for the interrupt c=
allback handler
> + * @cb_func: callback function
> + *
> + * Returns cb_func.
> + */
> +u8
> +base_register_callback_handler(MPT_CALLBACK cb_func)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u8 cb_idx;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (cb_idx =3D MPT_MAX_CALLBACKS-1; cb_idx; c=
b_idx--)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mpt_callbacks[=
cb_idx] =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> +
> + =C2=A0 =C2=A0 =C2=A0 mpt_callbacks[cb_idx] =3D cb_func;
> + =C2=A0 =C2=A0 =C2=A0 return cb_idx;
> +}
> +
> +/**
> + * base_initialize_callback_handler - initialize the interrupt callb=
ack handler
> + *
> + * Return nothing.
> + */
> +void
> +base_initialize_callback_handler(void)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u8 cb_idx;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (cb_idx =3D 0; cb_idx < MPT_MAX_CALLBACKS;=
 cb_idx++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base_release_callb=
ack_handler(cb_idx);
> +}
> +
> +/**
> + * base_build_zero_len_sge - build zero length sg entry
> + * @ioc: per adapter object
> + * @paddr: virtual address for SGE
> + *
> + * Create a zero length scatter gather entry to insure the IOCs hard=
ware has
> + * something to use if the target device goes brain dead and tries
> + * to send data even when none is asked for.
> + *
> + * Return nothing.
> + */
> +void
> +base_build_zero_len_sge(struct MPT2SAS_ADAPTER *ioc, void *paddr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 flags_length =3D (u32)((MPI2_SGE_FLAGS_LAS=
T_ELEMENT |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_SGE_FLAGS_END_OF_BUFFER | M=
PI2_SGE_FLAGS_END_OF_LIST |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_SGE_FLAGS_SIMPLE_ELEMENT) <=
<
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_SGE_FLAGS_SHIFT);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_add_sg_single(paddr, flags_length, -=
1);
> +}
> +
> +/**
> + * base_add_sg_single_32 - Place a simple 32 bit SGE at address pAdd=
r.
> + * @paddr: virtual address for SGE
> + * @flags_length: SGE flags and data transfer length
> + * @dma_addr: Physical address
> + *
> + * Return nothing.
> + */
> +static void
> +base_add_sg_single_32(void *paddr, u32 flags_length, dma_addr_t dma_=
addr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2SGESimple32_t *sgel =3D paddr;
> +
> + =C2=A0 =C2=A0 =C2=A0 flags_length |=3D (MPI2_SGE_FLAGS_32_BIT_ADDRE=
SSING |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_SGE_FLAGS_SYSTEM_ADDRESS) <=
< MPI2_SGE_FLAGS_SHIFT;
> + =C2=A0 =C2=A0 =C2=A0 sgel->FlagsLength =3D cpu_to_le32(flags_length=
);
> + =C2=A0 =C2=A0 =C2=A0 sgel->Address =3D cpu_to_le32(dma_addr);
> +}
> +
> +
> +/**
> + * base_add_sg_single_64 - Place a simple 64 bit SGE at address pAdd=
r.
> + * @paddr: virtual address for SGE
> + * @flags_length: SGE flags and data transfer length
> + * @dma_addr: Physical address
> + *
> + * Return nothing.
> + */
> +static void
> +base_add_sg_single_64(void *paddr, u32 flags_length, dma_addr_t dma_=
addr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2SGESimple64_t *sgel =3D paddr;
> +
> + =C2=A0 =C2=A0 =C2=A0 flags_length |=3D (MPI2_SGE_FLAGS_64_BIT_ADDRE=
SSING |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_SGE_FLAGS_SYSTEM_ADDRESS) <=
< MPI2_SGE_FLAGS_SHIFT;
> + =C2=A0 =C2=A0 =C2=A0 sgel->FlagsLength =3D cpu_to_le32(flags_length=
);
> + =C2=A0 =C2=A0 =C2=A0 sgel->Address =3D cpu_to_le64(dma_addr);
> +}
> +
> +#define convert_to_kb(x) ((x) << (PAGE_SHIFT - 10))
> +
> +/**
> + * _base_config_dma_addressing - set dma addressing
> + * @ioc: per adapter object
> + * @pdev: PCI device struct
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_config_dma_addressing(struct MPT2SAS_ADAPTER *ioc, struct pci_=
dev *pdev)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct sysinfo s;
> + =C2=A0 =C2=A0 =C2=A0 char *desc =3D NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (sizeof(dma_addr_t) > 4) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const uint64_t req=
uired_mask =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dma_=
get_required_mask(&pdev->dev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((required_mask=
 > DMA_32BIT_MASK) && !pci_set_dma_mask(pdev,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DMA_=
64BIT_MASK) && !pci_set_consistent_dma_mask(pdev,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 DMA_=
64BIT_MASK)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->base_add_sg_single =3D &base_add_sg_single_64;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->sge_size =3D sizeof(Mpi2SGESimple64_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 desc =3D "64";
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 && !pci_set_consistent_dma_mask(=
pdev, DMA_32BIT_MASK)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->base_add_sg_s=
ingle =3D &base_add_sg_single_32;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->sge_size =3D =
sizeof(Mpi2SGESimple32_t);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desc =3D "32";
> + =C2=A0 =C2=A0 =C2=A0 } else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENODEV;
> +
> + out:
> + =C2=A0 =C2=A0 =C2=A0 si_meminfo(&s);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "%s BIT PCI BUS DMA AD=
DRESSING SUPPORTED, "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "total mem (%ld kB)\n", ioc->nam=
e, desc, convert_to_kb(s.totalram));
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}


Interesting. I would have expected the dma_mask and consistent_dma_mask
to not depend on each other. ie set dma_mask to 64, if that fails, set
dma_mask to 32-bit.
Rinse and repeat for consistent_dma_mask.

> +
> +/**
> + * base_save_msix_table - backup msix vector table
> + * @ioc: per adapter object
> + *
> + * This address an errata where diag reset clears out the table
> + */
> +static void
> +base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->msix_enable || ioc->msix_table_backu=
p =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->msix_vector_count; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->msix_table_ba=
ckup[i] =3D ioc->msix_table[i];
> +}
> +
> +/**
> + * base_restore_msix_table - this restores the msix vector table
> + * @ioc: per adapter object
> + *
> + */
> +static void
> +base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->msix_enable || ioc->msix_table_backu=
p =3D=3D NULL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->msix_vector_count; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->msix_table[i]=
 =3D ioc->msix_table_backup[i];
> +}
> +
> +/**
> + * base_check_enable_msix - checks MSIX capabable.
> + * @ioc: per adapter object
> + *
> + * Check to see if card is capable of MSIX, and set number
> + * of avaliable msix vectors
> + */
> +static int
> +base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int base;
> + =C2=A0 =C2=A0 =C2=A0 u16 message_control;
> + =C2=A0 =C2=A0 =C2=A0 u32 msix_table_offset;
> +
> + =C2=A0 =C2=A0 =C2=A0 base =3D pci_find_capability(ioc->pdev, PCI_CA=
P_ID_MSIX);
> + =C2=A0 =C2=A0 =C2=A0 if (!base) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dfailprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "msix not "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "sup=
ported\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* get msix vector count */
> + =C2=A0 =C2=A0 =C2=A0 pci_read_config_word(ioc->pdev, base + 2, &mes=
sage_control);
> + =C2=A0 =C2=A0 =C2=A0 ioc->msix_vector_count =3D (message_control & =
0x3FF) + 1;


Any comments on why the return value from pci_enable_msix() isn't used =
here?

I wasn't expecting the drivers would need to read the MSIX table direct=
ly.

/**
 * pci_enable_msix - configure device's MSI-X capability structure
 * @dev: pointer to the pci_dev data structure of MSI-X device function
 * @entries: pointer to an array of MSI-X entries
 * @nvec: number of MSI-X irqs requested for allocation by device drive=
r
 *
 * Setup the MSI-X capability structure of device function with the num=
ber
 * of requested irqs upon its software driver call to request for
 * MSI-X mode enabled on its hardware device function. A return of zero
 * indicates the successful configuration of MSI-X capability structure
 * with new allocated MSI-X irqs. A return of < 0 indicates a failure.
 * Or a return of > 0 indicates that driver request is exceeding the nu=
mber
 * of irqs available. Driver should use the returned value to re-send
 * its request.
 **/

> +
> + =C2=A0 =C2=A0 =C2=A0 /* get msix table =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 pci_read_config_dword(ioc->pdev, base + 4, &ms=
ix_table_offset);
> + =C2=A0 =C2=A0 =C2=A0 msix_table_offset &=3D 0xFFFFFFF8;
> + =C2=A0 =C2=A0 =C2=A0 ioc->msix_table =3D (u32 *)((void *)ioc->chip =
+ msix_table_offset);
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix=
 is supported, "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "vector_count(%d), table_offset(=
0x%08x), table(%p)\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->msix_vector_count, msix_tab=
le_offset, ioc->msix_table));
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> + * base_disable_msix - disables msix
> + * @ioc: per adapter object
> + *
> + */
> +static void
> +base_disable_msix(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->msix_enable) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_disable_msix(i=
oc->pdev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(ioc->msix_ta=
ble_backup);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->msix_table_ba=
ckup =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->msix_enable =3D=
 0;
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
> +/**
> + * base_enable_msix - enables msix, failback to io_apic
> + * @ioc: per adapter object
> + *
> + */
> +static int
> +base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct msix_entry *entries =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 int i, r;
> + =C2=A0 =C2=A0 =C2=A0 u8 try_msix =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (msix_disable =3D=3D -1 || msix_disable =3D=
=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 try_msix =3D 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!try_msix)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto try_ioapic;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (base_check_enable_msix(ioc) !=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto try_ioapic;
> +
> + =C2=A0 =C2=A0 =C2=A0 entries =3D kcalloc(ioc->msix_vector_count, si=
zeof(struct msix_entry),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!entries) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dfailprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "allocation for "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "msi=
x_entry failed !!!\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto try_ioapic;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->msix_vector_count; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 entries[i].entry =3D=
 i;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->msix_table_backup =3D kcalloc(ioc->msix_v=
ector_count, 4, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->msix_table_backup) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dfailprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "allocation for "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "msi=
x_table_backup failed!!!\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto try_ioapic;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D pci_enable_msix(ioc->pdev, entries, ioc-=
>msix_vector_count);
> + =C2=A0 =C2=A0 =C2=A0 if (r) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dfailprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "pci_enable_msix "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led (r=3D%d) !!!\n", ioc->name, r));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto try_ioapic;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* current HW implemention uses only one inter=
rupt handler */

Which implementation?
This comment sounds like it expects to be obsolete soon.
Specifying the implementation makes it clear even when other
implementations become available.


> + =C2=A0 =C2=A0 =C2=A0 r =3D request_irq(entries[0].vector, base_inte=
rrupt, IRQF_SHARED,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc);

MSI is never shared. IRQF_SHARED flag is still correct?

I have to stop looking now...back to work. :(

hth,
grant


> + =C2=A0 =C2=A0 =C2=A0 if (r) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dfailprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "unable to allocate "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "int=
errupt %d !!!\n", ioc->name, entries[0].vector));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_disable_msix(i=
oc->pdev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto try_ioapic;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->pci_irq =3D entries[0].vector;
> + =C2=A0 =C2=A0 =C2=A0 ioc->msix_enable =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 kfree(entries);
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> +/* failback to io_apic interrupt routing */
> + try_ioapic:
> + =C2=A0 =C2=A0 =C2=A0 kfree(entries);
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D request_irq(ioc->pdev->irq, base_interru=
pt, IRQF_SHARED,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc);
> + =C2=A0 =C2=A0 =C2=A0 if (r) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "unable to allocate interrupt %d!\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, ioc->pdev->irq);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EBUSY;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_fail;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->pci_irq =3D ioc->pdev->irq;
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + out_fail:
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +
> +/**
> + * base_map_resources - map in controller resources (io/irq/memap)
> + * @ioc: per adapter object
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +int
> +base_map_resources(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct pci_dev *pdev =3D ioc->pdev;
> + =C2=A0 =C2=A0 =C2=A0 u32 memap_sz;
> + =C2=A0 =C2=A0 =C2=A0 u32 pio_sz;
> + =C2=A0 =C2=A0 =C2=A0 int i, r =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->bars =3D pci_select_bars(pdev, IORESOURCE=
_MEM);
> + =C2=A0 =C2=A0 =C2=A0 if (pci_enable_device_mem(pdev)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_WAR=
N_FMT "pci_enable_device_mem: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENODEV;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> +
> + =C2=A0 =C2=A0 =C2=A0 if (pci_request_selected_regions(pdev, ioc->ba=
rs,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPT2SAS_DRIVER_NAME)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_WAR=
N_FMT "pci_request_selected_regions: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -ENODEV;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_fail;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 pci_set_master(pdev);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (_base_config_dma_addressing(ioc, pdev) !=3D=
 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_WAR=
N_FMT "no suitable DMA mask for %s\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, pci_name(pdev));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -ENODEV;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_fail;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0, memap_sz =3D 0, pio_sz =3D 0 ; i=
 < DEVICE_COUNT_RESOURCE; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pci_resource_f=
lags(pdev, i) & PCI_BASE_ADDRESS_SPACE_IO) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (pio_sz)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->pio_chip =3D pci_resource_start(pdev, i);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pio_sz =3D pci_resource_len(pdev, i);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (memap_sz)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->chip_phys =3D pci_resource_start(pdev, i);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 memap_sz =3D pci_resource_len(pdev, i);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->chip =3D ioremap(ioc->chip_phys, memap_sz);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (ioc->chip =3D=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR_FMT "unable to m=
ap adapter "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "memory!\n", ioc->nam=
e);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EINVAL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_fail;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 pci_set_drvdata(pdev, ioc->shost);
> + =C2=A0 =C2=A0 =C2=A0 _base_mask_interrupts(ioc);
> + =C2=A0 =C2=A0 =C2=A0 r =3D base_enable_msix(ioc);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_fail;
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "%s: IRQ %d\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, =C2=A0((ioc->msix_ena=
ble) ? "PCI-MSI-X enabled" :
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "IO-APIC enabled"), ioc->pci_irq=
);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "iomem(0x%lx), mapped(=
0x%p), size(%d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc->chip_phys, ioc->=
chip, memap_sz);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "ioport(0x%lx), size(%=
d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc->pio_chip, pio_sz=
);
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + out_fail:
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->chip_phys)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iounmap(ioc->chip)=
;
> + =C2=A0 =C2=A0 =C2=A0 ioc->chip_phys =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 ioc->pci_irq =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 pci_release_selected_regions(ioc->pdev, ioc->b=
ars);
> + =C2=A0 =C2=A0 =C2=A0 pci_disable_device(pdev);
> + =C2=A0 =C2=A0 =C2=A0 pci_set_drvdata(pdev, NULL);
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +
> +/**
> + * base_get_msg_frame_dma - obtain request mf pointer phys addr
> + * @ioc: per adapter object
> + * @smid: system request message index(smid zero is invalid)
> + *
> + * Returns phys pointer to message frame.
> + */
> +dma_addr_t
> +base_get_msg_frame_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ioc->request_dma + (smid * ioc->request=
_sz);
> +}
> +
> +/**
> + * base_get_msg_frame - obtain request mf pointer
> + * @ioc: per adapter object
> + * @smid: system request message index(smid zero is invalid)
> + *
> + * Returns virt pointer to message frame.
> + */
> +void *
> +base_get_msg_frame(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return (void *)(ioc->request + (smid * ioc->re=
quest_sz));
> +}
> +
> +/**
> + * base_get_sense_buffer - obtain a sense buffer assigned to a mf re=
quest
> + * @ioc: per adapter object
> + * @smid: system request message index
> + *
> + * Returns virt pointer to sense buffer.
> + */
> +void *
> +base_get_sense_buffer(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return (void *)(ioc->sense + ((smid - 1) * SCS=
I_SENSE_BUFFERSIZE));
> +}
> +
> +/**
> + * base_get_sense_buffer_dma - obtain a sense buffer assigned to a m=
f request
> + * @ioc: per adapter object
> + * @smid: system request message index
> + *
> + * Returns phys pointer to sense buffer.
> + */
> +dma_addr_t
> +base_get_sense_buffer_dma(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ioc->sense_dma + ((smid - 1) * SCSI_SEN=
SE_BUFFERSIZE);
> +}
> +
> +/**
> + * base_get_reply_virt_addr - obtain reply frames virt address
> + * @ioc: per adapter object
> + * @phys_addr: lower 32 physical addr of the reply
> + *
> + * Converts 32bit lower physical addr into a virt address.
> + */
> +void *
> +base_get_reply_virt_addr(struct MPT2SAS_ADAPTER *ioc, u32 phys_addr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (!phys_addr)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> + =C2=A0 =C2=A0 =C2=A0 return ioc->reply + (phys_addr - (u32)ioc->rep=
ly_dma);
> +}
> +
> +/**
> + * base_get_smid - obtain a free smid
> + * @ioc: per adapter object
> + * @cb_idx: callback index
> + *
> + * Returns smid (zero is invalid)
> + */
> +u16
> +base_get_smid(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx)
> +{
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> + =C2=A0 =C2=A0 =C2=A0 struct request_tracker *request;
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->scsi_lookup_lock, flag=
s);
> + =C2=A0 =C2=A0 =C2=A0 if (list_empty(&ioc->free_list)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqres=
tore(&ioc->scsi_lookup_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: smid not available\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 request =3D list_entry(ioc->free_list.next,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct request_tracker, tracker_=
list);
> + =C2=A0 =C2=A0 =C2=A0 request->cb_idx =3D cb_idx;
> + =C2=A0 =C2=A0 =C2=A0 smid =3D request->smid;
> + =C2=A0 =C2=A0 =C2=A0 list_del(&request->tracker_list);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->scsi_lookup_lock,=
 flags);
> + =C2=A0 =C2=A0 =C2=A0 return smid;
> +}
> +
> +
> +/**
> + * base_free_smid - put smid back on free_list
> + * @ioc: per adapter object
> + * @smid: system request message index
> + *
> + * Return nothing.
> + */
> +void
> +base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> +{
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->scsi_lookup_lock, flag=
s);
> + =C2=A0 =C2=A0 =C2=A0 ioc->scsi_lookup[smid - 1].cb_idx =3D 0xFF;
> + =C2=A0 =C2=A0 =C2=A0 list_add_tail(&ioc->scsi_lookup[smid - 1].trac=
ker_list,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->free_list);
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->scsi_lookup_lock,=
 flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* See _wait_for_commands_to_complete() c=
all with regards to this code.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->shost_recovery && ioc->pending_io_cou=
nt) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->pending_i=
o_count =3D=3D 1)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 wake_up(&ioc->reset_wq);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->pending_io_co=
unt--;
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
> +/**
> + * _base_writeq - 64 bit write to MMIO
> + * @ioc: per adapter object
> + * @b: data payload
> + * @addr: address in MMIO space
> + * @writeq_lock: spin lock
> + *
> + * Glue for handling an atomic 64 bit word to MMIO. This special han=
dling takes
> + * care of 32 bit environment where its not quarenteed to send the e=
ntire word
> + * in one transfer.
> + */
> +#ifndef writeq
> +static inline void _base_writeq(__u64 b, volatile void __iomem *addr=
,
> + =C2=A0 =C2=A0spinlock_t *writeq_lock)
> +{
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> + =C2=A0 =C2=A0 =C2=A0 __u64 data_out =3D cpu_to_le64(b);
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(writeq_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 writel((u32)(data_out), addr);
> + =C2=A0 =C2=A0 =C2=A0 writel((u32)(data_out >> 32), (addr + 4));
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(writeq_lock, flags);
> +}
> +#else
> +static inline void _base_writeq(__u64 b, volatile void __iomem *addr=
,
> + =C2=A0 =C2=A0spinlock_t *writeq_lock)
> +{
> + =C2=A0 =C2=A0 =C2=A0 writeq(cpu_to_le64(b), addr);
> +}
> +#endif
> +
> +/**
> + * base_put_smid_scsi_io - send SCSI_IO request to firmware
> + * @ioc: per adapter object
> + * @smid: system request message index
> + * @vf_id: virtual function id
> + * @handle: device handle
> + *
> + * Return nothing.
> + */
> +void
> +base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_i=
d,
> + =C2=A0 =C2=A0u16 handle)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2RequestDescriptorUnion_t descriptor;
> + =C2=A0 =C2=A0 =C2=A0 u64 *request =3D (u64 *)&descriptor;
> +
> +
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSIIO.RequestFlags =3D MPI2_REQ_DE=
SCRIPT_FLAGS_SCSI_IO;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSIIO.VF_ID =3D vf_id;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSIIO.SMID =3D cpu_to_le16(smid);
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSIIO.DevHandle =3D cpu_to_le16(ha=
ndle);
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSIIO.LMID =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 _base_writeq(*request, &ioc->chip->RequestDesc=
riptorPostLow,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->scsi_lookup_lock);
> +}
> +
> +
> +/**
> + * base_put_smid_hi_priority - send Task Managment request to firmwa=
re
> + * @ioc: per adapter object
> + * @smid: system request message index
> + * @vf_id: virtual function id
> + *
> + * Return nothing.
> + */
> +void
> +base_put_smid_hi_priority(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 =
vf_id)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2RequestDescriptorUnion_t descriptor;
> + =C2=A0 =C2=A0 =C2=A0 u64 *request =3D (u64 *)&descriptor;
> +
> + =C2=A0 =C2=A0 =C2=A0 descriptor.HighPriority.RequestFlags =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRI=
ORITY;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.HighPriority.VF_ID =3D vf_id;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.HighPriority.SMID =3D cpu_to_le16(s=
mid);
> + =C2=A0 =C2=A0 =C2=A0 descriptor.HighPriority.LMID =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.HighPriority.Reserved1 =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 _base_writeq(*request, &ioc->chip->RequestDesc=
riptorPostLow,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->scsi_lookup_lock);
> +}
> +
> +/**
> + * base_put_smid_default - Default, primarily used for config pages
> + * @ioc: per adapter object
> + * @smid: system request message index
> + * @vf_id: virtual function id
> + *
> + * Return nothing.
> + */
> +void
> +base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 vf_i=
d)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2RequestDescriptorUnion_t descriptor;
> + =C2=A0 =C2=A0 =C2=A0 u64 *request =3D (u64 *)&descriptor;
> +
> + =C2=A0 =C2=A0 =C2=A0 descriptor.Default.RequestFlags =3D MPI2_REQ_D=
ESCRIPT_FLAGS_DEFAULT_TYPE;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.Default.VF_ID =3D vf_id;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.Default.SMID =3D cpu_to_le16(smid);
> + =C2=A0 =C2=A0 =C2=A0 descriptor.Default.LMID =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.Default.DescriptorTypeDependent =3D=
 0;
> + =C2=A0 =C2=A0 =C2=A0 _base_writeq(*request, &ioc->chip->RequestDesc=
riptorPostLow,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->scsi_lookup_lock);
> +}
> +
> +/**
> + * base_put_smid_target_assist - send Target Assist/Status to firmwa=
re
> + * @ioc: per adapter object
> + * @smid: system request message index
> + * @vf_id: virtual function id
> + * @io_index: value used to track the IO
> + *
> + * Return nothing.
> + */
> +void
> +base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid, u=
8 vf_id,
> + =C2=A0 =C2=A0u16 io_index)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2RequestDescriptorUnion_t descriptor;
> + =C2=A0 =C2=A0 =C2=A0 u64 *request =3D (u64 *)&descriptor;
> +
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSITarget.RequestFlags =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_REQ_DESCRIPT_FLAGS_SCSI_TAR=
GET;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSITarget.VF_ID =3D vf_id;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSITarget.SMID =3D cpu_to_le16(smi=
d);
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSITarget.LMID =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 descriptor.SCSITarget.IoIndex =3D cpu_to_le16(=
io_index);
> + =C2=A0 =C2=A0 =C2=A0 _base_writeq(*request, &ioc->chip->RequestDesc=
riptorPostLow,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->scsi_lookup_lock);
> +}
> +
> +/**
> + * _base_display_ioc_capabilities - Disply IOC's capabilities.
> + * @ioc: per adapter object
> + *
> + * Return nothing.
> + */
> +static void
> +_base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int i =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 char desc[16];
> + =C2=A0 =C2=A0 =C2=A0 u8 revision;
> + =C2=A0 =C2=A0 =C2=A0 u32 iounit_pg1_flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 pci_read_config_byte(ioc->pdev, PCI_CLASS_REVI=
SION, &revision);
> + =C2=A0 =C2=A0 =C2=A0 strncpy(desc, ioc->manu_pg0.ChipName, 16);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "%s: FWVersion(%02d.%0=
2d.%02d.%02d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"ChipRevision(0x%02x), BiosVersio=
n(%02d.%02d.%02d.%02d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, desc,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->facts.FWVersion.Word & 0xFF=
000000) >> 24,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->facts.FWVersion.Word & 0x00=
=46F0000) >> 16,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->facts.FWVersion.Word & 0x00=
00FF00) >> 8,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->facts.FWVersion.Word & 0x000=
000FF,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0revision,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->bios_pg3.BiosVersion & 0xFF=
000000) >> 24,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->bios_pg3.BiosVersion & 0x00=
=46F0000) >> 16,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->bios_pg3.BiosVersion & 0x00=
00FF00) >> 8,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->bios_pg3.BiosVersion & 0x00=
0000FF);
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "Protocol=3D(", ioc->n=
ame);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_P=
ROTOCOL_SCSI_INITIATOR) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Initiator"=
);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_P=
ROTOCOL_SCSI_TARGET) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sTarget",=
 i ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 i =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 printk("), ");
> + =C2=A0 =C2=A0 =C2=A0 printk("Capabilities=3D(");
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCFACTS_CAPABILITY_INTEGRA=
TED_RAID) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("Raid");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS=
_CAPABILITY_TLR) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sTLR", i =
? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS=
_CAPABILITY_MULTICAST) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sMulticas=
t", i ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCFACTS_CAPABILITY_BIDIREC=
TIONAL_TARGET) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sBIDI Tar=
get", i ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS=
_CAPABILITY_EEDP) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sEEDP", i=
 ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCFACTS_CAPABILITY_SNAPSHO=
T_BUFFER) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sSnapshot=
 Buffer", i ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCFACTS_CAPABILITY_DIAG_TR=
ACE_BUFFER) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sDiag Tra=
ce Buffer", i ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCFACTS_CAPABILITY_TASK_SE=
T_FULL_HANDLING) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sTask Set=
 Full", i ? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 iounit_pg1_flags =3D le32_to_cpu(ioc->iounit_p=
g1.Flags);
> + =C2=A0 =C2=A0 =C2=A0 if (!(iounit_pg1_flags & MPI2_IOUNITPAGE1_NATI=
VE_COMMAND_Q_DISABLE)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk("%sNCQ", i =
? "," : "");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(")\n");
> +}
> +
> +/**
> + * _base_static_config_pages - static start of day config pages
> + * @ioc: per adapter object
> + *
> + * Return nothing.
> + */
> +static void
> +_base_static_config_pages(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2ConfigReply_t mpi_reply;
> + =C2=A0 =C2=A0 =C2=A0 u32 iounit_pg1_flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 config_get_manufacturing_pg0(ioc, &mpi_reply, =
&ioc->manu_pg0);
> + =C2=A0 =C2=A0 =C2=A0 config_get_bios_pg2(ioc, &mpi_reply, &ioc->bio=
s_pg2);
> + =C2=A0 =C2=A0 =C2=A0 config_get_bios_pg3(ioc, &mpi_reply, &ioc->bio=
s_pg3);
> + =C2=A0 =C2=A0 =C2=A0 config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_=
pg8);
> + =C2=A0 =C2=A0 =C2=A0 config_get_iounit_pg0(ioc, &mpi_reply, &ioc->i=
ounit_pg0);
> + =C2=A0 =C2=A0 =C2=A0 config_get_iounit_pg1(ioc, &mpi_reply, &ioc->i=
ounit_pg1);
> + =C2=A0 =C2=A0 =C2=A0 _base_display_ioc_capabilities(ioc);
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Enable task_set_full handling in iouni=
t_pg1 when the
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* facts capabilities indicate that its s=
upported.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 iounit_pg1_flags =3D le32_to_cpu(ioc->iounit_p=
g1.Flags);
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_IOCFACTS_CAPABILITY_TASK_SE=
T_FULL_HANDLING))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iounit_pg1_flags &=
=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ~MPI=
2_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING;
> + =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iounit_pg1_flags |=
=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2=
_IOUNITPAGE1_DISABLE_TASK_SET_FULL_HANDLING;
> + =C2=A0 =C2=A0 =C2=A0 ioc->iounit_pg1.Flags =3D cpu_to_le32(iounit_p=
g1_flags);
> + =C2=A0 =C2=A0 =C2=A0 config_set_iounit_pg1(ioc, &mpi_reply, ioc->io=
unit_pg1);
> +}
> +
> +/**
> + * _base_release_memory_pools - release memory
> + * @ioc: per adapter object
> + *
> + * Free memory allocated from _base_allocate_memory_pools.
> + *
> + * Return nothing.
> + */
> +static void
> +_base_release_memory_pools(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->request) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_free_consisten=
t(ioc->pdev, ioc->request_dma_sz,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>request, =C2=A0ioc->request_dma);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "request_pool(0x%p)"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ": f=
ree\n", ioc->name, ioc->request));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request =3D N=
ULL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->sense) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_pool_free(ioc-=
>sense_dma_pool, ioc->sense, ioc->sense_dma);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->sense_dma=
_pool)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pci_pool_destroy(ioc->sense_dma_pool);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "sense_pool(0x%p)"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ": f=
ree\n", ioc->name, ioc->sense));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->sense =3D NUL=
L;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->reply) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_pool_free(ioc-=
>reply_dma_pool, ioc->reply, ioc->reply_dma);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->reply_dma=
_pool)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pci_pool_destroy(ioc->reply_dma_pool);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "reply_pool(0x%p)"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
": free\n", ioc->name, ioc->reply));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply =3D NUL=
L;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->reply_free) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_pool_free(ioc-=
>reply_free_dma_pool, ioc->reply_free,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>reply_free_dma);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->reply_fre=
e_dma_pool)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pci_pool_destroy(ioc->reply_free_dma_pool);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT "reply_free_pool"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(0x=
%p): free\n", ioc->name, ioc->reply_free));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_free =3D=
 NULL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->reply_post_free) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_pool_free(ioc-=
>reply_post_free_dma_pool,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>reply_post_free, ioc->reply_post_free_dma);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->reply_pos=
t_free_dma_pool)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pci_pool_destroy(ioc->reply_post_free_dma_pool);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "rep=
ly_post_free_pool(0x%p): free\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>reply_post_free));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_fr=
ee =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->config_page) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, p=
rintk(MPT2SAS_INFO_FMT
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "con=
fig_page(0x%p): free\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>config_page));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pci_free_consisten=
t(ioc->pdev, ioc->config_page_sz,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>config_page, ioc->config_page_dma);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->scsi_lookup);
> +}
> +
> +
> +/**
> + * _base_allocate_memory_pools - allocate start of day memory pools
> + * @ioc: per adapter object
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 success, anything else error
> + */
> +static int
> +_base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc, =C2=A0int s=
leep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2IOCFactsReply_t *facts;
> + =C2=A0 =C2=A0 =C2=A0 u32 queue_size, queue_diff;
> + =C2=A0 =C2=A0 =C2=A0 u16 max_sge_elements;
> + =C2=A0 =C2=A0 =C2=A0 u16 num_of_reply_frames;
> + =C2=A0 =C2=A0 =C2=A0 u16 chains_needed_per_io;
> + =C2=A0 =C2=A0 =C2=A0 u32 sz, total_sz;
> + =C2=A0 =C2=A0 =C2=A0 u16 i;
> + =C2=A0 =C2=A0 =C2=A0 u32 retry_sz;
> + =C2=A0 =C2=A0 =C2=A0 u16 max_request_credit;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 retry_sz =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 facts =3D &ioc->facts;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* command line tunables =C2=A0for max sgl ent=
ries */
> + =C2=A0 =C2=A0 =C2=A0 if (max_sgl_entries !=3D -1) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->shost->sg_tab=
lesize =3D (max_sgl_entries <
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPT2=
SAS_SG_DEPTH) ? max_sgl_entries :
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPT2=
SAS_SG_DEPTH;
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->shost->sg_tab=
lesize =3D MPT2SAS_SG_DEPTH;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* command line tunables =C2=A0for max control=
ler queue depth */
> + =C2=A0 =C2=A0 =C2=A0 if (max_queue_depth !=3D -1) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_request_credit=
 =3D (max_queue_depth < facts->RequestCredit)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ? ma=
x_queue_depth : facts->RequestCredit;
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 max_request_credit=
 =3D (facts->RequestCredit >
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPT2=
SAS_MAX_REQUEST_QUEUE) ? MPT2SAS_MAX_REQUEST_QUEUE :
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fact=
s->RequestCredit;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->request_depth =3D max_request_credit;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* request frame size */
> + =C2=A0 =C2=A0 =C2=A0 ioc->request_sz =3D facts->IOCRequestFrameSize=
 * 4;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply frame size */
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_sz =3D facts->ReplyFrameSize * 4;
> +
> + retry_allocation:
> + =C2=A0 =C2=A0 =C2=A0 total_sz =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 /* calculate number of sg elements left over i=
n the 1st frame */
> + =C2=A0 =C2=A0 =C2=A0 max_sge_elements =3D ioc->request_sz - ((sizeo=
f(Mpi2SCSIIORequest_t) -
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(Mpi2SGEIOUnion_t)) + ioc-=
>sge_size);
> + =C2=A0 =C2=A0 =C2=A0 ioc->max_sges_in_main_message =3D max_sge_elem=
ents/ioc->sge_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* now do the same for a chain buffer */
> + =C2=A0 =C2=A0 =C2=A0 max_sge_elements =3D ioc->request_sz - ioc->sg=
e_size;
> + =C2=A0 =C2=A0 =C2=A0 ioc->max_sges_in_chain_message =3D max_sge_ele=
ments/ioc->sge_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->chain_offset_value_for_main_message =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((sizeof(Mpi2SCSIIORequest_t) - =
sizeof(Mpi2SGEIOUnion_t)) +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ioc->max_sges_in_chain_me=
ssage * ioc->sge_size)) / 4;
> +
> + =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0MPT2SAS_SG_DEPTH =3D CONFIG_FUSI=
ON_MAX_SGE
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 chains_needed_per_io =3D ((ioc->shost->sg_tabl=
esize -
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ioc->max_sges_in_main_message)/io=
c->max_sges_in_chain_message)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 + 1;
> + =C2=A0 =C2=A0 =C2=A0 if (chains_needed_per_io > facts->MaxChainDept=
h) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chains_needed_per_=
io =3D facts->MaxChainDepth;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->shost->sg_tab=
lesize =3D min_t(u16,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->max_sges_in_m=
ain_message + (ioc->max_sges_in_chain_message
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * chains_needed_pe=
r_io), ioc->shost->sg_tablesize);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->chains_needed_per_io =3D chains_needed_pe=
r_io;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply free queue sizing - taking into accou=
nt for events */
> + =C2=A0 =C2=A0 =C2=A0 num_of_reply_frames =3D ioc->request_depth + 3=
2;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* number of replies frames can't be a multipl=
e of 16 */
> + =C2=A0 =C2=A0 =C2=A0 /* decrease number of reply frames by 1 */
> + =C2=A0 =C2=A0 =C2=A0 if (!(num_of_reply_frames % 16))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_of_reply_frame=
s--;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* calculate number of reply free queue entrie=
s
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0(must be multiple of 16)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> +
> + =C2=A0 =C2=A0 =C2=A0 /* (we know reply_free_queue_depth is not a mu=
ltiple of 16) */
> + =C2=A0 =C2=A0 =C2=A0 queue_size =3D num_of_reply_frames;
> + =C2=A0 =C2=A0 =C2=A0 queue_size +=3D 16 - (queue_size % 16);
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_free_queue_depth =3D queue_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply descriptor post queue sizing */
> + =C2=A0 =C2=A0 =C2=A0 /* this size should be the number of request f=
rames + number of reply
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* frames
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> +
> + =C2=A0 =C2=A0 =C2=A0 queue_size =3D ioc->request_depth + num_of_rep=
ly_frames + 1;
> + =C2=A0 =C2=A0 =C2=A0 /* round up to 16 byte boundary */
> + =C2=A0 =C2=A0 =C2=A0 if (queue_size % 16)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_size +=3D 16=
 - (queue_size % 16);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* check against IOC maximum reply post queue =
depth */
> + =C2=A0 =C2=A0 =C2=A0 if (queue_size > facts->MaxReplyDescriptorPost=
QueueDepth) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_diff =3D que=
ue_size -
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fact=
s->MaxReplyDescriptorPostQueueDepth;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* round queue_dif=
f up to multiple of 16 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (queue_diff % 1=
6)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 queue_diff +=3D 16 - (queue_diff % 16);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* adjust request_=
depth, reply_free_queue_depth,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* and queue_=
size
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request_depth=
 -=3D queue_diff;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_free_qu=
eue_depth -=3D queue_diff;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_size -=3D qu=
eue_diff;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_queue_depth =3D queue_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* max scsi host queue depth */
> + =C2=A0 =C2=A0 =C2=A0 ioc->shost->can_queue =3D ioc->request_depth -=
 INTERNAL_CMDS_COUNT;
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scsi=
 host queue: depth"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(%d)\n", ioc->name, ioc->shost-=
>can_queue));
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "scat=
ter gather: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "sge_in_main_msg(%d), sge_per_ch=
ain(%d), sge_per_io(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "chains_per_io(%d)\n", ioc->name=
, ioc->max_sges_in_main_message,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->max_sges_in_chain_message, =
ioc->shost->sg_tablesize,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->chains_needed_per_io));
> +
> + =C2=A0 =C2=A0 =C2=A0 /* contiguous pool for request and chains, 16 =
byte align, one extra "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* "frame for smid=3D0
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 ioc->chain_depth =3D ioc->chains_needed_per_io=
 * ioc->request_depth;
> + =C2=A0 =C2=A0 =C2=A0 sz =3D ((ioc->request_depth + 1 + ioc->chain_d=
epth) * ioc->request_sz);
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->request_dma_sz =3D sz;
> + =C2=A0 =C2=A0 =C2=A0 ioc->request =3D pci_alloc_consistent(ioc->pde=
v, sz, &ioc->request_dma);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->request) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "request pool: pci_alloc_consistent "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led: req_depth(%d), chains_per_io(%d), frame_sz(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "tot=
al(%d kB)\n", ioc->name, ioc->request_depth,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>chains_needed_per_io, ioc->request_sz, sz/1024);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->request_d=
epth < MPT2SAS_SAS_QUEUE_DEPTH)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retry_sz +=3D 64;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request_depth=
 =3D max_request_credit - retry_sz;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto retry_allocat=
ion;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (retry_sz)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "request pool: pci_alloc_consistent "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "suc=
ceed: req_depth(%d), chains_per_io(%d), frame_sz(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "tot=
al(%d kb)\n", ioc->name, ioc->request_depth,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>chains_needed_per_io, ioc->request_sz, sz/1024);
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->chain =3D ioc->request + ((ioc->request_d=
epth + 1) *
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request_sz);
> + =C2=A0 =C2=A0 =C2=A0 ioc->chain_dma =3D ioc->request_dma + ((ioc->r=
equest_depth + 1) *
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request_sz);
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "requ=
est pool(0x%p): "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "depth(%d), frame_size(%d), pool=
_size(%d kB)\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request, ioc->request_depth=
, ioc->request_sz,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((ioc->request_depth + 1) * ioc-=
>request_sz)/1024));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "chai=
n pool(0x%p): depth"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(%d), frame_size(%d), pool_size=
(%d kB)\n", ioc->name, ioc->chain,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->chain_depth, ioc->request_s=
z, ((ioc->chain_depth *
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->request_sz))/1024));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "requ=
est pool: dma(0x%llx)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, (unsigned long long) =
ioc->request_dma));
> + =C2=A0 =C2=A0 =C2=A0 total_sz +=3D sz;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->scsi_lookup =3D kcalloc(ioc->request_dept=
h,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(struct request_tracker), =
GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->scsi_lookup) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "scsi_lookup: kcalloc failed\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/* initialize some bits */
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->request_depth; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->scsi_lookup[i=
].smid =3D i + 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* sense buffers, 4 byte align */
> + =C2=A0 =C2=A0 =C2=A0 sz =3D ioc->request_depth * SCSI_SENSE_BUFFERS=
IZE;
> + =C2=A0 =C2=A0 =C2=A0 ioc->sense_dma_pool =3D pci_pool_create("sense=
 pool", ioc->pdev, sz, 4,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->sense_dma_pool) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "sense pool: pci_pool_create failed\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->sense =3D pci_pool_alloc(ioc->sense_dma_p=
ool , GFP_KERNEL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->sense_dma);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->sense) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "sense pool: pci_pool_alloc failed\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "sense pool(0x%p): depth(%d), el=
ement_size(%d), pool_size"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(%d kB)\n", ioc->name, ioc->sen=
se, ioc->request_depth,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SCSI_SENSE_BUFFERSIZE, sz/1024))=
;
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "sens=
e_dma(0x%llx)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, (unsigned long long)i=
oc->sense_dma));
> + =C2=A0 =C2=A0 =C2=A0 total_sz +=3D sz;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply pool, 4 byte align */
> + =C2=A0 =C2=A0 =C2=A0 sz =3D ioc->reply_free_queue_depth * ioc->repl=
y_sz;
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_dma_pool =3D pci_pool_create("reply=
 pool", ioc->pdev, sz, 4,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->reply_dma_pool) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "reply pool: pci_pool_create failed\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply =3D pci_pool_alloc(ioc->reply_dma_p=
ool , GFP_KERNEL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->reply_dma);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->reply) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "reply pool: pci_pool_alloc failed\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "repl=
y pool(0x%p): depth"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(%d), frame_size(%d), pool_size=
(%d kB)\n", ioc->name, ioc->reply,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_free_queue_depth, ioc=
->reply_sz, sz/1024));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "repl=
y_dma(0x%llx)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, (unsigned long long)i=
oc->reply_dma));
> + =C2=A0 =C2=A0 =C2=A0 total_sz +=3D sz;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply free queue, 16 byte align */
> + =C2=A0 =C2=A0 =C2=A0 sz =3D ioc->reply_free_queue_depth * 4;
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_free_dma_pool =3D pci_pool_create("=
reply_free pool",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->pdev, sz, 16, 0);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->reply_free_dma_pool) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "reply_free pool: pci_pool_create "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_free =3D pci_pool_alloc(ioc->reply_=
free_dma_pool , GFP_KERNEL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->reply_free_dma);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->reply_free) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "reply_free pool: pci_pool_alloc "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 memset(ioc->reply_free, 0, sz);
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "repl=
y_free pool(0x%p): "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "depth(%d), element_size(%d), po=
ol_size(%d kB)\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_free, ioc->reply_free=
_queue_depth, 4, sz/1024));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "repl=
y_free_dma"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(0x%llx)\n", ioc->name, (unsign=
ed long long)ioc->reply_free_dma));
> + =C2=A0 =C2=A0 =C2=A0 total_sz +=3D sz;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* reply post queue, 16 byte align */
> + =C2=A0 =C2=A0 =C2=A0 sz =3D ioc->reply_post_queue_depth * sizeof(Mp=
i2DefaultReplyDescriptor_t);
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_free_dma_pool =3D pci_pool_cre=
ate("reply_post_free pool",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->pdev, sz, 16, 0);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->reply_post_free_dma_pool) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "reply_post_free pool: pci_pool_create "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_free =3D pci_pool_alloc(ioc->r=
eply_post_free_dma_pool ,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_KERNEL, &ioc->reply_post_fre=
e_dma);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->reply_post_free) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "reply_post_free pool: pci_pool_alloc "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 memset(ioc->reply_post_free, 0, sz);
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "repl=
y post free pool"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(0x%p): depth(%d), element_size=
(%d), pool_size(%d kB)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc->reply_post_free,=
 ioc->reply_post_queue_depth, 8,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sz/1024));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "repl=
y_post_free_dma =3D "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(0x%llx)\n", ioc->name, (unsign=
ed long long)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_free_dma));
> + =C2=A0 =C2=A0 =C2=A0 total_sz +=3D sz;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->config_page_sz =3D 512;
> + =C2=A0 =C2=A0 =C2=A0 ioc->config_page =3D pci_alloc_consistent(ioc-=
>pdev,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->config_page_sz, &ioc->confi=
g_page_dma);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->config_page) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "config page: pci_pool_alloc "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "fai=
led\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "conf=
ig page(0x%p): size"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(%d)\n", ioc->name, ioc->config=
_page, ioc->config_page_sz));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "conf=
ig_page_dma"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "(0x%llx)\n", ioc->name, (unsign=
ed long long)ioc->config_page_dma));
> + =C2=A0 =C2=A0 =C2=A0 total_sz +=3D ioc->config_page_sz;
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "Allocated physical me=
mory: size(%d kB)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, total_sz/1024);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "Current Controller Qu=
eue Depth(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Max Controller Queue Depth(%d)\=
n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc->shost->can_queue=
, facts->RequestCredit);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "Scatter Gather Elemen=
ts per IO(%d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ioc->shost->sg_tables=
ize);
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + out:
> + =C2=A0 =C2=A0 =C2=A0 _base_release_memory_pools(ioc);
> + =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> +}
> +
> +
> +/**
> + * base_get_iocstate - Get the current state of a MPT adapter.
> + * @ioc: Pointer to MPT_ADAPTER structure
> + * @cooked: Request raw or cooked IOC state
> + *
> + * Returns all IOC Doorbell register bits if cooked=3D=3D0, else jus=
t the
> + * Doorbell bits in MPI_IOC_STATE_MASK.
> + */
> +u32
> +base_get_iocstate(struct MPT2SAS_ADAPTER *ioc, int cooked)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 s, sc;
> +
> + =C2=A0 =C2=A0 =C2=A0 s =3D readl(&ioc->chip->Doorbell);
> + =C2=A0 =C2=A0 =C2=A0 sc =3D s & MPI2_IOC_STATE_MASK;
> + =C2=A0 =C2=A0 =C2=A0 return cooked ? sc : s;
> +}
> +
> +/**
> + * _base_wait_on_iocstate - waiting on a particular ioc state
> + * @ioc_state: controller state { READY, OPERATIONAL, or RESET }
> + * @timeout: timeout in second
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_wait_on_iocstate(struct MPT2SAS_ADAPTER *ioc, u32 ioc_state, i=
nt timeout,
> + =C2=A0 =C2=A0int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 count, cntdn;
> + =C2=A0 =C2=A0 =C2=A0 u32 current_state;
> +
> + =C2=A0 =C2=A0 =C2=A0 count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 cntdn =3D (sleep_flag =3D=3D CAN_SLEEP) ? 1000=
*timeout : 2000*timeout;
> + =C2=A0 =C2=A0 =C2=A0 do {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 current_state =3D =
base_get_iocstate(ioc, 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (current_state =
=3D=3D ioc_state)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (count && curre=
nt_state =3D=3D MPI2_IOC_STATE_FAULT)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sleep_flag =3D=
=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 msleep(1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 udelay(500);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count++;
> + =C2=A0 =C2=A0 =C2=A0 } while (--cntdn);
> +
> + =C2=A0 =C2=A0 =C2=A0 return current_state;
> +}
> +
> +/**
> + * _base_wait_for_doorbell_int - waiting for controller interrupt(ge=
nerated by
> + * a write to the doorbell)
> + * @ioc: per adapter object
> + * @timeout: timeout in second
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + *
> + * Notes: MPI2_HIS_DOORBELL_INTERRUPT - set to one when IOC writes t=
o doorbell.
> + */
> +static int
> +_base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout=
,
> + =C2=A0 =C2=A0int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 cntdn, count;
> + =C2=A0 =C2=A0 =C2=A0 u32 int_status;
> +
> + =C2=A0 =C2=A0 =C2=A0 count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 cntdn =3D (sleep_flag =3D=3D CAN_SLEEP) ? 1000=
*timeout : 2000*timeout;
> + =C2=A0 =C2=A0 =C2=A0 do {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int_status =3D rea=
dl(&ioc->chip->HostInterruptStatus);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (int_status & M=
PI2_HIS_DOORBELL_INTERRUPT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "successfull count(%d), timeout(%d)\n", ioc->name=
,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 __func__, count, timeout));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sleep_flag =3D=
=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 msleep(1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 udelay(500);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count++;
> + =C2=A0 =C2=A0 =C2=A0 } while (--cntdn);
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR_FMT "%s: failed due to time=
out count(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "int_status(%x)!\n", ioc->name, =
__func__, count, int_status);
> + =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> +}
> +
> +/**
> + * _base_wait_for_doorbell_ack - waiting for controller to read the =
doorbell.
> + * @ioc: per adapter object
> + * @timeout: timeout in second
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + *
> + * Notes: MPI2_HIS_IOP_DOORBELL_STATUS - set to one when host writes=
 to
> + * doorbell.
> + */
> +static int
> +_base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout=
,
> + =C2=A0 =C2=A0int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 cntdn, count;
> + =C2=A0 =C2=A0 =C2=A0 u32 int_status;
> + =C2=A0 =C2=A0 =C2=A0 u32 doorbell;
> +
> + =C2=A0 =C2=A0 =C2=A0 count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 cntdn =3D (sleep_flag =3D=3D CAN_SLEEP) ? 1000=
*timeout : 2000*timeout;
> + =C2=A0 =C2=A0 =C2=A0 do {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int_status =3D rea=
dl(&ioc->chip->HostInterruptStatus);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(int_status &=
 MPI2_HIS_IOP_DOORBELL_STATUS)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "successfull count(%d), timeout(%d)\n", ioc->name=
,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 __func__, count, timeout));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (int_sta=
tus & MPI2_HIS_DOORBELL_INTERRUPT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 doorbell =3D readl(&ioc->chip->Doorbell);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if ((doorbell & MPI2_IOC_STATE_MASK) =3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 MPI2_IOC_STATE_FAULT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base_fault_info(ioc , doorbell);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (int_sta=
tus =3D=3D 0xFFFFFFFF)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sleep_flag =3D=
=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 msleep(1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 udelay(500);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 count++;
> + =C2=A0 =C2=A0 =C2=A0 } while (--cntdn);
> +
> + out:
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR_FMT "%s: failed due to time=
out count(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "int_status(%x)!\n", ioc->name, =
__func__, count, int_status);
> + =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> +}
> +
> +#if defined(MUR)
> +/**
> + * _base_send_ioc_reset - send doorbell reset
> + * @ioc: per adapter object
> + * @reset_type: currently only supports: MPI2_FUNCTION_IOC_MESSAGE_U=
NIT_RESET
> + * @timeout: timeout in second
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_send_ioc_reset(struct MPT2SAS_ADAPTER *ioc, u8 reset_type, int=
 timeout,
> + =C2=A0 =C2=A0int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> + =C2=A0 =C2=A0 =C2=A0 int r =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (reset_type !=3D MPI2_FUNCTION_IOC_MESSAGE_=
UNIT_RESET) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: unknown reset_type\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!(ioc->facts.IOCCapabilities &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MPI2_IOCFACTS_CAPABILITY_EVENT_RE=
PLAY))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "sending message unit =
reset !!\n", ioc->name);
> +
> + =C2=A0 =C2=A0 =C2=A0 writel(reset_type << MPI2_DOORBELL_FUNCTION_SH=
IFT,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->chip->Doorbell);
> + =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_for_doorbell_ack(ioc, 15, slee=
p_flag))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D _base_wait_on_iocstate(ioc, MPI2=
_IOC_STATE_READY,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timeout, sleep_flag);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc_state) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed going to ready state "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " (i=
oc_state=3D0x%x)\n", ioc->name, __func__, ioc_state);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> + out:
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "message unit reset: %=
s\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ((r =3D=3D 0) ? "SUCC=
ESS" : "FAILED"));
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +#endif
> +
> +/**
> + * _base_handshake_req_reply_wait - send request thru doorbell inter=
face
> + * @ioc: per adapter object
> + * @request_bytes: request length
> + * @request: pointer having request payload
> + * @reply_bytes: reply length
> + * @reply: pointer to reply payload
> + * @timeout: timeout in second
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int requ=
est_bytes,
> + =C2=A0 =C2=A0u32 *request, int reply_bytes, u16 *reply, int timeout=
, int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 MPI2DefaultReply_t *default_reply =3D (MPI2Def=
aultReply_t *)reply;
> + =C2=A0 =C2=A0 =C2=A0 int i;
> + =C2=A0 =C2=A0 =C2=A0 u8 failed;
> + =C2=A0 =C2=A0 =C2=A0 u16 dummy;
> + =C2=A0 =C2=A0 =C2=A0 u32 *mfp;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* make sure doorbell is not in use */
> + =C2=A0 =C2=A0 =C2=A0 if ((readl(&ioc->chip->Doorbell) & MPI2_DOORBE=
LL_USED)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "doorbell is in use "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " (l=
ine=3D%d)\n", ioc->name, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* clear pending doorbell interrupts from prev=
ious state changes */
> + =C2=A0 =C2=A0 =C2=A0 if (readl(&ioc->chip->HostInterruptStatus) &
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_HIS_IOC2SYS_DB_STATUS)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->ch=
ip->HostInterruptStatus);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* send message to ioc */
> + =C2=A0 =C2=A0 =C2=A0 writel(((MPI2_FUNCTION_HANDSHAKE<<MPI2_DOORBEL=
L_FUNCTION_SHIFT) |
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((request_bytes/4)<<MPI2_DOORBEL=
L_ADD_DWORDS_SHIFT)),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->chip->Doorbell);
> +
> + =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_for_doorbell_int(ioc, 5, sleep=
_flag))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "doorbell handshake "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"int =
failed (line=3D%d)\n", ioc->name, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->chip->HostInterruptStatus);
> +
> + =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_for_doorbell_ack(ioc, 5, sleep=
_flag))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "doorbell handshake "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ack=
 failed (line=3D%d)\n", ioc->name, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* send message 32-bits at a time */
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0, failed =3D 0; i < request_bytes/=
4 && !failed; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(cpu_to_le32=
(request[i]), &ioc->chip->Doorbell);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_fo=
r_doorbell_ack(ioc, 5, sleep_flag)))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 failed =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (failed) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "doorbell handshake "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "sen=
ding request failed (line=3D%d)\n", ioc->name, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* now wait for the reply */
> + =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_for_doorbell_int(ioc, timeout,=
 sleep_flag))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "doorbell handshake "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"int =
failed (line=3D%d)\n", ioc->name, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* read the first two 16-bits, it gives the to=
tal length of the reply */
> + =C2=A0 =C2=A0 =C2=A0 reply[0] =3D le16_to_cpu(readl(&ioc->chip->Doo=
rbell)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 & MPI2_DOORBELL_DATA_MASK);
> + =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->chip->HostInterruptStatus);
> + =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_for_doorbell_int(ioc, 5, sleep=
_flag))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "doorbell handshake "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"int =
failed (line=3D%d)\n", ioc->name, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 reply[1] =3D le16_to_cpu(readl(&ioc->chip->Doo=
rbell)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 & MPI2_DOORBELL_DATA_MASK);
> + =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->chip->HostInterruptStatus);
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 2; i < default_reply->MsgLength * 2=
; i++) =C2=A0{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((_base_wait_fo=
r_doorbell_int(ioc, 5, sleep_flag))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printk(MPT2SAS_ERR_FMT "doorbell "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "handshake int failed (line=3D%d)\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (i >=3D =C2=A0r=
eply_bytes/2) /* overflow case */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 dummy =3D readl(&ioc->chip->Doorbell);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 reply[i] =3D le16_to_cpu(readl(&ioc->chip->Doorbell)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 & MPI2_DOORBELL_DATA_MASK);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->ch=
ip->HostInterruptStatus);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 _base_wait_for_doorbell_int(ioc, 5, sleep_flag=
);
> + =C2=A0 =C2=A0 =C2=A0 if ((readl(&ioc->chip->Doorbell) & MPI2_DOORBE=
LL_USED)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dhsprintk(ioc, pri=
ntk(MPT2SAS_INFO_FMT "doorbell is in use "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " (l=
ine=3D%d)\n", ioc->name, __LINE__));
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->logging_level & MPT_DEBUG_INIT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mfp =3D (u32 *)rep=
ly;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_DEBUG =
"\toffset:data\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < =
reply_bytes/4; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printk(KERN_DEBUG "\t[0x%02x]:%08x\n", i*4,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu(mfp[i]));
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> + * base_sas_iounit_control - send sas iounit control to FW
> + * @ioc: per adapter object
> + * @mpi_reply: the reply payload from FW
> + * @mpi_request: the request payload sent to FW
> + *
> + * The SAS IO Unit Control Request message allows the host to perfor=
m low-level
> + * operations, such as resets on the PHYs of the IO Unit, also allow=
s the host
> + * to obtain the IOC assigned device handles for a device if it has =
other
> + * identifying information about the device, in addition allows the =
host to
> + * remove IOC resources associated with the device.
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +int
> +base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc, Mpi2SasIoUnitCo=
ntrolReply_t
> + =C2=A0 =C2=A0*mpi_reply, Mpi2SasIoUnitControlRequest_t *mpi_request=
)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long timeleft;
> + =C2=A0 =C2=A0 =C2=A0 u8 issue_reset;
> + =C2=A0 =C2=A0 =C2=A0 int rc;
> + =C2=A0 =C2=A0 =C2=A0 void *request;
> + =C2=A0 =C2=A0 =C2=A0 u16 wait_state_count;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 mutex_lock(&ioc->base_cmds.mutex);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status !=3D MPT2_CMD_NOT_US=
ED) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: base_cmd in use\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 wait_state_count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D base_get_iocstate(ioc, 1);
> + =C2=A0 =C2=A0 =C2=A0 while (ioc_state !=3D MPI2_IOC_STATE_OPERATION=
AL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wait_state_cou=
nt++ =3D=3D 10) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printk(MPT2SAS_ERR_FMT
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "%s: failed due to ioc not operational\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ioc->name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 rc =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssleep(1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc_state =3D base=
_get_iocstate(ioc, 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INF=
O_FMT "%s: waiting for "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ope=
rational state(count=3D%d)\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __fu=
nc__, wait_state_count);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 smid =3D base_get_smid(ioc, ioc->base_cb_idx);
> + =C2=A0 =C2=A0 =C2=A0 if (!smid) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed obtaining a smid\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_PENDING;
> + =C2=A0 =C2=A0 =C2=A0 request =3D base_get_msg_frame(ioc, smid);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.smid =3D smid;
> + =C2=A0 =C2=A0 =C2=A0 memcpy(request, mpi_request, sizeof(Mpi2SasIoU=
nitControlRequest_t));
> + =C2=A0 =C2=A0 =C2=A0 if (mpi_request->Operation =3D=3D MPI2_SAS_OP_=
PHY_HARD_RESET ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_request->Operation =3D=3D MP=
I2_SAS_OP_PHY_LINK_RESET)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->ioc_link_rese=
t_in_progress =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 base_put_smid_default(ioc, smid, mpi_request->=
VF_ID);
> + =C2=A0 =C2=A0 =C2=A0 timeleft =3D wait_for_completion_timeout(&ioc-=
>base_cmds.done,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msecs_to_jiffies(10000));
> + =C2=A0 =C2=A0 =C2=A0 if ((mpi_request->Operation =3D=3D MPI2_SAS_OP=
_PHY_HARD_RESET ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_request->Operation =3D=3D MP=
I2_SAS_OP_PHY_LINK_RESET) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->ioc_link_reset_in_progress)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->ioc_link_rese=
t_in_progress =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 if (!(ioc->base_cmds.status & MPT2_CMD_COMPLET=
E)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: timeout\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _debug_dump_mf(mpi=
_request,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(Mpi2SasIoUnitControlRequest_t)/4);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(ioc->base_cm=
ds.status & MPT2_CMD_RESET))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 issue_reset =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto issue_host_re=
set;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status & MPT2_CMD_REPLY_VAL=
ID)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(mpi_reply, =
ioc->base_cmds.reply,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(Mpi2SasIoUnitControlReply_t));
> + =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(mpi_reply, =
0, sizeof(Mpi2SasIoUnitControlReply_t));
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 goto out;
> +
> + issue_host_reset:
> + =C2=A0 =C2=A0 =C2=A0 if (issue_reset)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base_hard_reset_ha=
ndler(ioc, CAN_SLEEP, FORCE_BIG_HAMMER);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 rc =3D -EFAULT;
> + out:
> + =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ioc->base_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 return rc;
> +}
> +
> +
> +/**
> + * base_scsi_enclosure_processor - sending request to sep device
> + * @ioc: per adapter object
> + * @mpi_reply: the reply payload from FW
> + * @mpi_request: the request payload sent to FW
> + *
> + * The SCSI Enclosure Processor request message causes the IOC to
> + * communicate with SES devices to control LED status signals.
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +int
> +base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc, Mpi2SepRe=
ply_t
> + =C2=A0 =C2=A0*mpi_reply, Mpi2SepRequest_t *mpi_request)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long timeleft;
> + =C2=A0 =C2=A0 =C2=A0 u8 issue_reset;
> + =C2=A0 =C2=A0 =C2=A0 int rc;
> + =C2=A0 =C2=A0 =C2=A0 void *request;
> + =C2=A0 =C2=A0 =C2=A0 u16 wait_state_count;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 mutex_lock(&ioc->base_cmds.mutex);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status !=3D MPT2_CMD_NOT_US=
ED) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: base_cmd in use\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 wait_state_count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D base_get_iocstate(ioc, 1);
> + =C2=A0 =C2=A0 =C2=A0 while (ioc_state !=3D MPI2_IOC_STATE_OPERATION=
AL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wait_state_cou=
nt++ =3D=3D 10) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printk(MPT2SAS_ERR_FMT
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 "%s: failed due to ioc not operational\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 ioc->name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 rc =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ssleep(1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc_state =3D base=
_get_iocstate(ioc, 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INF=
O_FMT "%s: waiting for "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ope=
rational state(count=3D%d)\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __fu=
nc__, wait_state_count);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 smid =3D base_get_smid(ioc, ioc->base_cb_idx);
> + =C2=A0 =C2=A0 =C2=A0 if (!smid) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed obtaining a smid\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_PENDING;
> + =C2=A0 =C2=A0 =C2=A0 request =3D base_get_msg_frame(ioc, smid);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.smid =3D smid;
> + =C2=A0 =C2=A0 =C2=A0 memcpy(request, mpi_request, sizeof(Mpi2SepRep=
ly_t));
> + =C2=A0 =C2=A0 =C2=A0 base_put_smid_default(ioc, smid, mpi_request->=
VF_ID);
> + =C2=A0 =C2=A0 =C2=A0 timeleft =3D wait_for_completion_timeout(&ioc-=
>base_cmds.done,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msecs_to_jiffies(10000));
> + =C2=A0 =C2=A0 =C2=A0 if (!(ioc->base_cmds.status & MPT2_CMD_COMPLET=
E)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: timeout\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _debug_dump_mf(mpi=
_request,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(Mpi2SepRequest_t)/4);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(ioc->base_cm=
ds.status & MPT2_CMD_RESET))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 issue_reset =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto issue_host_re=
set;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status & MPT2_CMD_REPLY_VAL=
ID)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(mpi_reply, =
ioc->base_cmds.reply,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(Mpi2SepReply_t));
> + =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(mpi_reply, =
0, sizeof(Mpi2SepReply_t));
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 goto out;
> +
> + issue_host_reset:
> + =C2=A0 =C2=A0 =C2=A0 if (issue_reset)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base_hard_reset_ha=
ndler(ioc, CAN_SLEEP, FORCE_BIG_HAMMER);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 rc =3D -EFAULT;
> + out:
> + =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ioc->base_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 return rc;
> +}
> +
> +/**
> + * _base_get_port_facts - obtain port facts reply and save in ioc
> + * @ioc: per adapter object
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int port, int slee=
p_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2PortFactsRequest_t mpi_request;
> + =C2=A0 =C2=A0 =C2=A0 Mpi2PortFactsReply_t mpi_reply, *pfacts;
> + =C2=A0 =C2=A0 =C2=A0 int mpi_reply_sz, mpi_request_sz, r;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 mpi_reply_sz =3D sizeof(Mpi2PortFactsReply_t);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request_sz =3D sizeof(Mpi2PortFactsRequest=
_t);
> + =C2=A0 =C2=A0 =C2=A0 memset(&mpi_request, 0, mpi_request_sz);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.Function =3D MPI2_FUNCTION_PORT_FA=
CTS;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.PortNumber =3D port;
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_handshake_req_reply_wait(ioc, mpi_=
request_sz,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (u32 *)&mpi_request, mpi_reply_s=
z, (u16 *)&mpi_reply, 5, CAN_SLEEP);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (r !=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: handshake failed (r=3D%d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__, r);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 pfacts =3D &ioc->pfacts[port];
> + =C2=A0 =C2=A0 =C2=A0 memset(pfacts, 0, sizeof(Mpi2PortFactsReply_t)=
);
> + =C2=A0 =C2=A0 =C2=A0 pfacts->PortNumber =3D mpi_reply.PortNumber;
> + =C2=A0 =C2=A0 =C2=A0 pfacts->VP_ID =3D mpi_reply.VP_ID;
> + =C2=A0 =C2=A0 =C2=A0 pfacts->VF_ID =3D mpi_reply.VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 pfacts->MaxPostedCmdBuffers =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le16_to_cpu(mpi_reply.MaxPostedC=
mdBuffers);
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> + * _base_get_ioc_facts - obtain ioc facts reply and save in ioc
> + * @ioc: per adapter object
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2IOCFactsRequest_t mpi_request;
> + =C2=A0 =C2=A0 =C2=A0 Mpi2IOCFactsReply_t mpi_reply, *facts;
> + =C2=A0 =C2=A0 =C2=A0 int mpi_reply_sz, mpi_request_sz, r;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 mpi_reply_sz =3D sizeof(Mpi2IOCFactsReply_t);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request_sz =3D sizeof(Mpi2IOCFactsRequest_=
t);
> + =C2=A0 =C2=A0 =C2=A0 memset(&mpi_request, 0, mpi_request_sz);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.Function =3D MPI2_FUNCTION_IOC_FAC=
TS;
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_handshake_req_reply_wait(ioc, mpi_=
request_sz,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (u32 *)&mpi_request, mpi_reply_s=
z, (u16 *)&mpi_reply, 5, CAN_SLEEP);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (r !=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: handshake failed (r=3D%d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__, r);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 facts =3D &ioc->facts;
> + =C2=A0 =C2=A0 =C2=A0 memset(facts, 0, sizeof(Mpi2IOCFactsReply_t));
> + =C2=A0 =C2=A0 =C2=A0 facts->MsgVersion =3D le16_to_cpu(mpi_reply.Ms=
gVersion);
> + =C2=A0 =C2=A0 =C2=A0 facts->HeaderVersion =3D le16_to_cpu(mpi_reply=
=2EHeaderVersion);
> + =C2=A0 =C2=A0 =C2=A0 facts->VP_ID =3D mpi_reply.VP_ID;
> + =C2=A0 =C2=A0 =C2=A0 facts->VF_ID =3D mpi_reply.VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 facts->IOCExceptions =3D le16_to_cpu(mpi_reply=
=2EIOCExceptions);
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxChainDepth =3D mpi_reply.MaxChainDep=
th;
> + =C2=A0 =C2=A0 =C2=A0 facts->WhoInit =3D mpi_reply.WhoInit;
> + =C2=A0 =C2=A0 =C2=A0 facts->NumberOfPorts =3D mpi_reply.NumberOfPor=
ts;
> + =C2=A0 =C2=A0 =C2=A0 facts->RequestCredit =3D le16_to_cpu(mpi_reply=
=2ERequestCredit);
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxReplyDescriptorPostQueueDepth =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le16_to_cpu(mpi_reply.MaxReplyDe=
scriptorPostQueueDepth);
> + =C2=A0 =C2=A0 =C2=A0 facts->ProductID =3D le16_to_cpu(mpi_reply.Pro=
ductID);
> + =C2=A0 =C2=A0 =C2=A0 facts->IOCCapabilities =3D le32_to_cpu(mpi_rep=
ly.IOCCapabilities);
> + =C2=A0 =C2=A0 =C2=A0 if ((facts->IOCCapabilities & MPI2_IOCFACTS_CA=
PABILITY_INTEGRATED_RAID))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->ir_firmware =3D=
 1;
> + =C2=A0 =C2=A0 =C2=A0 facts->FWVersion.Word =3D le32_to_cpu(mpi_repl=
y.FWVersion.Word);
> + =C2=A0 =C2=A0 =C2=A0 facts->IOCRequestFrameSize =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le16_to_cpu(mpi_reply.IOCRequest=
=46rameSize);
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxInitiators =3D le16_to_cpu(mpi_reply=
=2EMaxInitiators);
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxTargets =3D le16_to_cpu(mpi_reply.Ma=
xTargets);
> + =C2=A0 =C2=A0 =C2=A0 ioc->shost->max_id =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxSasExpanders =3D le16_to_cpu(mpi_rep=
ly.MaxSasExpanders);
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxEnclosures =3D le16_to_cpu(mpi_reply=
=2EMaxEnclosures);
> + =C2=A0 =C2=A0 =C2=A0 facts->ProtocolFlags =3D le16_to_cpu(mpi_reply=
=2EProtocolFlags);
> + =C2=A0 =C2=A0 =C2=A0 facts->HighPriorityCredit =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le16_to_cpu(mpi_reply.HighPriori=
tyCredit);
> + =C2=A0 =C2=A0 =C2=A0 facts->ReplyFrameSize =3D mpi_reply.ReplyFrame=
Size;
> + =C2=A0 =C2=A0 =C2=A0 facts->MaxDevHandle =3D le16_to_cpu(mpi_reply.=
MaxDevHandle);
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "hba =
queue depth(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "max chains per io(%d)\n", ioc->=
name, facts->RequestCredit,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 facts->MaxChainDepth));
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "requ=
est frame size(%d), "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "reply frame size(%d)\n", ioc->n=
ame,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 facts->IOCRequestFrameSize * 4, =
facts->ReplyFrameSize * 4));
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> + * _base_send_ioc_init - send ioc_init to firmware
> + * @ioc: per adapter object
> + * @VF_ID: virtual function id
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sleep=
_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2IOCInitRequest_t mpi_request;
> + =C2=A0 =C2=A0 =C2=A0 Mpi2IOCInitReply_t mpi_reply;
> + =C2=A0 =C2=A0 =C2=A0 int r;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 memset(&mpi_request, 0, sizeof(Mpi2IOCInitRequ=
est_t));
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.Function =3D MPI2_FUNCTION_IOC_INI=
T;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.WhoInit =3D MPI2_WHOINIT_HOST_DRIV=
ER;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.VF_ID =3D VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.MsgVersion =3D cpu_to_le16(MPI2_VE=
RSION);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.HeaderVersion =3D cpu_to_le16(MPI2=
_HEADER_VERSION);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* In MPI Revision I (0xA), the SystemReplyFra=
meSize(offset 0x18) was
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* removed and made reserved. =C2=A0For t=
hose with older firmware will need
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* this fix. It was decided that the Repl=
y and Request frame sizes are
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* the same.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc->facts.HeaderVersion >> 8) < 0xA) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_request.Reserv=
ed7 =3D cpu_to_le16(ioc->reply_sz);
> +/* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_request.SystemReply=
=46rameSize =3D
> + * =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le16(ioc->=
reply_sz);
> + */
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.SystemRequestFrameSize =3D cpu_to_=
le16(ioc->request_sz/4);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.ReplyDescriptorPostQueueDepth =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16(ioc->reply_post_queu=
e_depth);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.ReplyFreeQueueDepth =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le16(ioc->reply_free_queu=
e_depth);
> +
> +#if BITS_PER_LONG > 32
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.SenseBufferAddressHigh =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(ioc->sense_dma >> 32=
);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.SystemReplyAddressHigh =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(ioc->reply_dma >> 32=
);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.SystemRequestFrameBaseAddress =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le64(ioc->request_dma);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.ReplyFreeQueueAddress =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le64(ioc->reply_free_dma)=
;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.ReplyDescriptorPostQueueAddress =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le64(ioc->reply_post_free=
_dma);
> +#else
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.SystemRequestFrameBaseAddress =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(ioc->request_dma);
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.ReplyFreeQueueAddress =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(ioc->reply_free_dma)=
;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request.ReplyDescriptorPostQueueAddress =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu_to_le32(ioc->reply_post_free=
_dma);
> +#endif
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->logging_level & MPT_DEBUG_INIT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 u32 *mfp;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mfp =3D (u32 *)&mp=
i_request;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_DEBUG =
"\toffset:data\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < =
sizeof(Mpi2IOCInitRequest_t)/4; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 printk(KERN_DEBUG "\t[0x%02x]:%08x\n", i*4,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 le32_to_cpu(mfp[i]));
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_handshake_req_reply_wait(ioc,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(Mpi2IOCInitRequest_t), (u=
32 *)&mpi_request,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(Mpi2IOCInitReply_t), (u16=
 *)&mpi_reply, 10,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sleep_flag);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (r !=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: handshake failed (r=3D%d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__, r);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (mpi_reply.IOCStatus !=3D MPI2_IOCSTATUS_SU=
CCESS ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_reply.IOCLogInfo) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed\n", ioc->name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EIO;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +/**
> + * _base_send_port_enable - send port_enable(discovery stuff) to fir=
mware
> + * @ioc: per adapter object
> + * @VF_ID: virtual function id
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int sl=
eep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2PortEnableRequest_t *mpi_request;
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long timeleft;
> + =C2=A0 =C2=A0 =C2=A0 int r =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "sending port enable !=
!\n", ioc->name);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status & MPT2_CMD_PENDING) =
{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: internal command already in use\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 smid =3D base_get_smid(ioc, ioc->base_cb_idx);
> + =C2=A0 =C2=A0 =C2=A0 if (!smid) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed obtaining a smid\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_PENDING;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request =3D base_get_msg_frame(ioc, smid);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.smid =3D smid;
> + =C2=A0 =C2=A0 =C2=A0 memset(mpi_request, 0, sizeof(Mpi2PortEnableRe=
quest_t));
> + =C2=A0 =C2=A0 =C2=A0 mpi_request->Function =3D MPI2_FUNCTION_PORT_E=
NABLE;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request->VF_ID =3D VF_ID;
> +
> + =C2=A0 =C2=A0 =C2=A0 base_put_smid_default(ioc, smid, VF_ID);
> + =C2=A0 =C2=A0 =C2=A0 timeleft =3D wait_for_completion_timeout(&ioc-=
>base_cmds.done,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 300*HZ);
> + =C2=A0 =C2=A0 =C2=A0 if (!(ioc->base_cmds.status & MPT2_CMD_COMPLET=
E)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: timeout\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _debug_dump_mf(mpi=
_request,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(Mpi2PortEnableRequest_t)/4);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds=
=2Estatus & MPT2_CMD_RESET)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 r =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 r =3D -ETIME;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 } else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, p=
rintk(MPT2SAS_DEBUG_FMT "%s: complete\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D _base_wait_on_iocstate(ioc, MPI2=
_IOC_STATE_OPERATIONAL,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 60, sleep_flag);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc_state) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed going to operational state "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " (i=
oc_state=3D0x%x)\n", ioc->name, __func__, ioc_state);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 }
> + out:
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "port enable: %s\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, ((r =3D=3D 0) ? "SUCC=
ESS" : "FAILED"));
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +
> +/**
> + * _base_unmask_events - turn on notification for this event
> + * @ioc: per adapter object
> + * @event: firmware event
> + *
> + * The mask is stored in ioc->event_masks.
> + */
> +static void
> +_base_unmask_events(struct MPT2SAS_ADAPTER *ioc, u16 event)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 desired_event;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (event >=3D 128)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 desired_event =3D (1 << (event % 32));
> +
> + =C2=A0 =C2=A0 =C2=A0 if (event < 32)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->event_masks[0=
] &=3D ~desired_event;
> + =C2=A0 =C2=A0 =C2=A0 else if (event < 64)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->event_masks[1=
] &=3D ~desired_event;
> + =C2=A0 =C2=A0 =C2=A0 else if (event < 96)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->event_masks[2=
] &=3D ~desired_event;
> + =C2=A0 =C2=A0 =C2=A0 else if (event < 128)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->event_masks[3=
] &=3D ~desired_event;
> +}
> +
> +/**
> + * _base_event_notification - send event notification
> + * @ioc: per adapter object
> + * @VF_ID: virtual function id
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_event_notification(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID, int =
sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 Mpi2EventNotificationRequest_t *mpi_request;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long timeleft;
> + =C2=A0 =C2=A0 =C2=A0 u16 smid;
> + =C2=A0 =C2=A0 =C2=A0 int r =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 int i;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds.status & MPT2_CMD_PENDING) =
{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: internal command already in use\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 smid =3D base_get_smid(ioc, ioc->base_cb_idx);
> + =C2=A0 =C2=A0 =C2=A0 if (!smid) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed obtaining a smid\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_PENDING;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request =3D base_get_msg_frame(ioc, smid);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.smid =3D smid;
> + =C2=A0 =C2=A0 =C2=A0 memset(mpi_request, 0, sizeof(Mpi2EventNotific=
ationRequest_t));
> + =C2=A0 =C2=A0 =C2=A0 mpi_request->Function =3D MPI2_FUNCTION_EVENT_=
NOTIFICATION;
> + =C2=A0 =C2=A0 =C2=A0 mpi_request->VF_ID =3D VF_ID;
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_=
WORDS; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpi_request->Event=
Masks[i] =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 le32=
_to_cpu(ioc->event_masks[i]);
> + =C2=A0 =C2=A0 =C2=A0 base_put_smid_default(ioc, smid, VF_ID);
> + =C2=A0 =C2=A0 =C2=A0 timeleft =3D wait_for_completion_timeout(&ioc-=
>base_cmds.done, 30*HZ);
> + =C2=A0 =C2=A0 =C2=A0 if (!(ioc->base_cmds.status & MPT2_CMD_COMPLET=
E)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: timeout\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _debug_dump_mf(mpi=
_request,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 size=
of(Mpi2EventNotificationRequest_t)/4);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds=
=2Estatus & MPT2_CMD_RESET)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 r =3D -EFAULT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 r =3D -ETIME;
> + =C2=A0 =C2=A0 =C2=A0 } else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, p=
rintk(MPT2SAS_DEBUG_FMT "%s: complete\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__));
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +
> +/**
> + * base_validate_event_type - validating event types
> + * @ioc: per adapter object
> + * @event: firmware event
> + *
> + * This will turn on firmware event notification when application
> + * ask for that event. We don't mask events that are already enabled=
=2E
> + */
> +void
> +base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_typ=
e)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int i, j;
> + =C2=A0 =C2=A0 =C2=A0 u32 event_mask, desired_event;
> + =C2=A0 =C2=A0 =C2=A0 u8 send_update_to_fw;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0, send_update_to_fw =3D 0; i <
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2_EVENT_NOTIFY_EVENTMASK_WORD=
S; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 event_mask =3D ~ev=
ent_type[i];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 desired_event =3D =
1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D 0; j < =
32; j++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (!(event_mask & desired_event) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 (ioc->event_masks[i] & desired_event)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->event_masks[i] &=3D ~desired_e=
vent;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 send_update_to_fw =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 desired_event =3D (desired_event << 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!send_update_to_fw)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 mutex_lock(&ioc->base_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 _base_event_notification(ioc, 0, CAN_SLEEP);
> + =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ioc->base_cmds.mutex);
> +}
> +
> +/**
> + * _base_diag_reset - the "big hammer" start of day reset
> + * @ioc: per adapter object
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 host_diagnostic;
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> + =C2=A0 =C2=A0 =C2=A0 u32 count;
> + =C2=A0 =C2=A0 =C2=A0 u32 hcb_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "sending diag reset !!=
\n", ioc->name);
> +
> + =C2=A0 =C2=A0 =C2=A0 base_save_msix_table(ioc);
> +
> + =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "clear=
 interrupts\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->chip->HostInterruptStatus);
> +
> + =C2=A0 =C2=A0 =C2=A0 count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 do {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Write magic seq=
uence to WriteSequence register
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Loop until=
 in diagnostic mode
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "write magic "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "seq=
uence\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
=46LUSH_KEY_VALUE, &ioc->chip->WriteSequence);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
1ST_KEY_VALUE, &ioc->chip->WriteSequence);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
2ND_KEY_VALUE, &ioc->chip->WriteSequence);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
3RD_KEY_VALUE, &ioc->chip->WriteSequence);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
4TH_KEY_VALUE, &ioc->chip->WriteSequence);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
5TH_KEY_VALUE, &ioc->chip->WriteSequence);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_=
6TH_KEY_VALUE, &ioc->chip->WriteSequence);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* wait 100 msec *=
/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sleep_flag =3D=
=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 msleep(100);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mdelay(100);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (count++ > 20)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 host_diagnostic =3D=
 readl(&ioc->chip->HostDiagnostic);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "wrote magic "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "seq=
uence: count(%d), host_diagnostic(0x%08x)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, count, host_diagnostic));
> +
> + =C2=A0 =C2=A0 =C2=A0 } while ((host_diagnostic & MPI2_DIAG_DIAG_WRI=
TE_ENABLE) =3D=3D 0);
> +
> + =C2=A0 =C2=A0 =C2=A0 hcb_size =3D readl(&ioc->chip->HCBSize);
> +
> + =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "diag =
reset: issued\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 writel(host_diagnostic | MPI2_DIAG_RESET_ADAPT=
ER,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&ioc->chip->HostDiagnostic=
);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* don't access any registers for 50 milliseco=
nds */
> + =C2=A0 =C2=A0 =C2=A0 msleep(50);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* 300 second max wait */
> + =C2=A0 =C2=A0 =C2=A0 for (count =3D 0; count < 3000000 ; count++) {
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 host_diagnostic =3D=
 readl(&ioc->chip->HostDiagnostic);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (host_diagnosti=
c =3D=3D 0xFFFFFFFF)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(host_diagnos=
tic & MPI2_DIAG_RESET_ADAPTER))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* wait 100 msec *=
/
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sleep_flag =3D=
=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 msleep(1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 mdelay(1);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "restart the adapter "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "ass=
uming the HCB Address points to good F/W\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 host_diagnostic &=3D=
 ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 host_diagnostic |=3D=
 MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(host_diagno=
stic, &ioc->chip->HostDiagnostic);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "re-=
enable the HCDW\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 writel(hcb_size | =
MPI2_HCB_SIZE_HCB_ENABLE,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc=
->chip->HCBSize);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "resta=
rt the adapter\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_R=
ESET,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc->chip->HostDiagnostic);
> +
> + =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "disab=
le writes to the "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "diagnostic register\n", ioc->na=
me));
> + =C2=A0 =C2=A0 =C2=A0 writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip-=
>WriteSequence);
> +
> + =C2=A0 =C2=A0 =C2=A0 drsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "Wait =
for FW to go to the "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "READY state\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D _base_wait_on_iocstate(ioc, MPI2=
_IOC_STATE_READY, 20,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sleep_flag);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc_state) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed going to ready state "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " (i=
oc_state=3D0x%x)\n", ioc->name, __func__, ioc_state);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 base_restore_msix_table(ioc);
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n=
", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + out:
> + =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR_FMT "diag reset: FAILED\n",=
 ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 return -EFAULT;
> +}
> +
> +/**
> + * _base_make_ioc_ready - put controller in READY state
> + * @ioc: per adapter object
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + * @type: FORCE_BIG_HAMMER or SOFT_RESET
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_make_ioc_ready(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
> + =C2=A0 =C2=A0enum reset_type type)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D base_get_iocstate(ioc, 0);
> + =C2=A0 =C2=A0 =C2=A0 dhsprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: i=
oc_state(0x%08x)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, __func__, ioc_state))=
;
> +
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc_state & MPI2_IOC_STATE_MASK) =3D=3D M=
PI2_IOC_STATE_READY)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (ioc_state & MPI2_DOORBELL_USED) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dhsprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "unexpected doorbell "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "act=
ive!\n", ioc->name));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto issue_diag_re=
set;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc_state & MPI2_IOC_STATE_MASK) =3D=3D M=
PI2_IOC_STATE_FAULT) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 base_fault_info(io=
c, ioc_state & MPI2_DOORBELL_DATA_MASK);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto issue_diag_re=
set;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (type =3D=3D FORCE_BIG_HAMMER)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto issue_diag_re=
set;
> +
> +#if defined(MUR)
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc_state & MPI2_IOC_STATE_MASK) =3D=3D M=
PI2_IOC_STATE_OPERATIONAL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(_base_send_i=
oc_reset(ioc,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 MPI2=
_FUNCTION_IOC_MESSAGE_UNIT_RESET, 15, CAN_SLEEP)))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return 0;
> +#endif
> +
> + issue_diag_reset:
> + =C2=A0 =C2=A0 =C2=A0 return _base_diag_reset(ioc, CAN_SLEEP);
> +}
> +
> +/**
> + * _base_make_ioc_operational - put controller in OPERATIONAL state
> + * @ioc: per adapter object
> + * @VF_ID: virtual function id
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +static int
> +_base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, u8 VF_ID,
> + =C2=A0 =C2=A0int sleep_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int r, i;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long =C2=A0 flags;
> + =C2=A0 =C2=A0 =C2=A0 u32 reply_address;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 /* initialize the scsi lookup free list */
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->scsi_lookup_lock, flag=
s);
> + =C2=A0 =C2=A0 =C2=A0 INIT_LIST_HEAD(&ioc->free_list);
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->request_depth; i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->scsi_lookup[i=
].cb_idx =3D 0xFF;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&ioc=
->scsi_lookup[i].tracker_list,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc=
->free_list);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->scsi_lookup_lock,=
 flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* initialize Reply Free Queue */
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0, reply_address =3D (u32)ioc->repl=
y_dma ;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i < ioc->reply_free_queue_depth =
; i++, reply_address +=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_sz)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_free[i]=
 =3D cpu_to_le32(reply_address);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* initialize Reply Post Free Queue */
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->reply_post_queue_depth;=
 i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_fr=
ee[i].Words =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0xFF=
=46FFFFFFFFFFFFFULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_send_ioc_init(ioc, VF_ID, sleep_fl=
ag);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* initialize the index's */
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_free_host_index =3D ioc->reply_free=
_queue_depth - 1;
> + =C2=A0 =C2=A0 =C2=A0 ioc->reply_post_host_index =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 writel(ioc->reply_free_host_index, &ioc->chip-=
>ReplyFreeHostIndex);
> + =C2=A0 =C2=A0 =C2=A0 writel(0, &ioc->chip->ReplyPostHostIndex);
> +
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_interrupts(ioc);
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_event_notification(ioc, VF_ID, sle=
ep_flag);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (sleep_flag =3D=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _base_static_confi=
g_pages(ioc);
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_send_port_enable(ioc, VF_ID, sleep=
_flag);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> +
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +
> +/**
> + * base_free_resources - free resources controller resources (io/irq=
/memap)
> + * @ioc: per adapter object
> + *
> + * Return nothing.
> + */
> +void
> +base_free_resources(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct pci_dev *pdev =3D ioc->pdev;
> +
> + =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 _base_mask_interrupts(ioc);
> + =C2=A0 =C2=A0 =C2=A0 _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESE=
T);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->pci_irq) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 synchronize_irq(pd=
ev->irq);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_irq(ioc->pci_=
irq, ioc);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 base_disable_msix(ioc);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->chip_phys)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 iounmap(ioc->chip)=
;
> + =C2=A0 =C2=A0 =C2=A0 ioc->pci_irq =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 ioc->chip_phys =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 pci_release_selected_regions(ioc->pdev, ioc->b=
ars);
> + =C2=A0 =C2=A0 =C2=A0 pci_disable_device(pdev);
> + =C2=A0 =C2=A0 =C2=A0 pci_set_drvdata(pdev, NULL);
> + =C2=A0 =C2=A0 =C2=A0 return;
> +}
> +
> +/**
> + * base_attach - attach controller instance
> + * @ioc: per adapter object
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +int
> +base_attach(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int r, i;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long =C2=A0 =C2=A0flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 dinitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D base_map_resources(ioc);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_make_ioc_ready(ioc, CAN_SLEEP, SOF=
T_RESET);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free_reso=
urces;
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_get_ioc_facts(ioc, CAN_SLEEP);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free_reso=
urces;
> +
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_allocate_memory_pools(ioc, CAN_SLE=
EP);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free_reso=
urces;
> +
> + =C2=A0 =C2=A0 =C2=A0 init_waitqueue_head(&ioc->reset_wq);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* base internal command bits */
> + =C2=A0 =C2=A0 =C2=A0 mutex_init(&ioc->base_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 init_completion(&ioc->base_cmds.done);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.reply =3D kzalloc(ioc->reply_sz=
, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.status =3D MPT2_CMD_NOT_USED;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* transport internal command bits */
> + =C2=A0 =C2=A0 =C2=A0 ioc->transport_cmds.reply =3D kzalloc(ioc->rep=
ly_sz, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 ioc->transport_cmds.status =3D MPT2_CMD_NOT_US=
ED;
> + =C2=A0 =C2=A0 =C2=A0 mutex_init(&ioc->transport_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 init_completion(&ioc->transport_cmds.done);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* task management internal command bits */
> + =C2=A0 =C2=A0 =C2=A0 ioc->tm_cmds.reply =3D kzalloc(ioc->reply_sz, =
GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 ioc->tm_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 mutex_init(&ioc->tm_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 init_completion(&ioc->tm_cmds.done);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* config page internal command bits */
> + =C2=A0 =C2=A0 =C2=A0 ioc->config_cmds.reply =3D kzalloc(ioc->reply_=
sz, GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 ioc->config_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 mutex_init(&ioc->config_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 init_completion(&ioc->config_cmds.done);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* ctl module internal command bits */
> + =C2=A0 =C2=A0 =C2=A0 ioc->ctl_cmds.reply =3D kzalloc(ioc->reply_sz,=
 GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 ioc->ctl_cmds.status =3D MPT2_CMD_NOT_USED;
> + =C2=A0 =C2=A0 =C2=A0 mutex_init(&ioc->ctl_cmds.mutex);
> + =C2=A0 =C2=A0 =C2=A0 init_completion(&ioc->ctl_cmds.done);
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_=
WORDS; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->event_masks[i=
] =3D -1;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* here we enable the events we care about */
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_SAS_DISCOV=
ERY);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_SAS_BROADC=
AST_PRIMITIVE);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_SAS_TOPOLO=
GY_CHANGE_LIST);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_SAS_DEVICE=
_STATUS_CHANGE);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_SAS_ENCL_D=
EVICE_STATUS_CHANGE);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_IR_CONFIGU=
RATION_CHANGE_LIST);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_IR_VOLUME)=
;
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_IR_PHYSICA=
L_DISK);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_IR_OPERATI=
ON_STATUS);
> + =C2=A0 =C2=A0 =C2=A0 _base_unmask_events(ioc, MPI2_EVENT_TASK_SET_F=
ULL);
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->pfacts =3D kcalloc(ioc->facts.NumberOfPor=
ts,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(Mpi2PortFactsReply_t), GF=
P_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->pfacts)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free_reso=
urces;
> +
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0 ; i < ioc->facts.NumberOfPorts; i=
++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D _base_get_po=
rt_facts(ioc, i, CAN_SLEEP);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out_free_resources;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_make_ioc_operational(ioc, 0, CAN_S=
LEEP);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_free_reso=
urces;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* initialize fault polling */
> + =C2=A0 =C2=A0 =C2=A0 INIT_DELAYED_WORK(&ioc->fault_reset_work, _bas=
e_fault_reset_work);
> + =C2=A0 =C2=A0 =C2=A0 snprintf(ioc->fault_reset_work_q_name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(ioc->fault_reset_work_q_n=
ame), "poll_%d_status", ioc->id);
> + =C2=A0 =C2=A0 =C2=A0 ioc->fault_reset_work_q =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_singlethrea=
d_workqueue(ioc->fault_reset_work_q_name);
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->fault_reset_work_q) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: failed (line=3D%d)\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__, __LINE__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto out_free_resources;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->ioc_reset_in_progress_=
lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->fault_reset_work_q)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 queue_delayed_work=
(ioc->fault_reset_work_q,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &ioc=
->fault_reset_work,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 msec=
s_to_jiffies(FAULT_POLLING_INTERVAL));
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->ioc_reset_in_prog=
ress_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + out_free_resources:
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->remove_host =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 base_free_resources(ioc);
> + =C2=A0 =C2=A0 =C2=A0 _base_release_memory_pools(ioc);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->tm_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->transport_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->config_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->base_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->ctl_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->pfacts);
> + =C2=A0 =C2=A0 =C2=A0 ioc->ctl_cmds.reply =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 ioc->base_cmds.reply =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 ioc->tm_cmds.reply =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 ioc->transport_cmds.reply =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 ioc->config_cmds.reply =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 ioc->pfacts =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> +
> +
> +/**
> + * base_detach - remove controller instance
> + * @ioc: per adapter object
> + *
> + * Return nothing.
> + */
> +void
> +base_detach(struct MPT2SAS_ADAPTER *ioc)
> +{
> + =C2=A0 =C2=A0 =C2=A0 unsigned long =C2=A0 =C2=A0flags;
> + =C2=A0 =C2=A0 =C2=A0 struct workqueue_struct *wq;
> +
> + =C2=A0 =C2=A0 =C2=A0 dexitprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s\=
n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->ioc_reset_in_progress_=
lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 wq =3D ioc->fault_reset_work_q;
> + =C2=A0 =C2=A0 =C2=A0 ioc->fault_reset_work_q =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->ioc_reset_in_prog=
ress_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 if (!cancel_delayed_work(&ioc->fault_reset_wor=
k))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 flush_workqueue(wq=
);
> + =C2=A0 =C2=A0 =C2=A0 destroy_workqueue(wq);
> +
> + =C2=A0 =C2=A0 =C2=A0 base_free_resources(ioc);
> + =C2=A0 =C2=A0 =C2=A0 _base_release_memory_pools(ioc);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->pfacts);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->ctl_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->base_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->tm_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->transport_cmds.reply);
> + =C2=A0 =C2=A0 =C2=A0 kfree(ioc->config_cmds.reply);
> +}
> +
> +/**
> + * _base_reset_handler - reset callback handler (for base)
> + * @ioc: per adapter object
> + * @reset_phase: phase
> + *
> + * The handler for doing any required cleanup or initialization.
> + *
> + * The reset phase can be MPT2_IOC_PRE_RESET, MPT2_IOC_AFTER_RESET,
> + * MPT2_IOC_DONE_RESET
> + *
> + * Return nothing.
> + */
> +static void
> +_base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
> +{
> + =C2=A0 =C2=A0 =C2=A0 switch (reset_phase) {
> + =C2=A0 =C2=A0 =C2=A0 case MPT2_IOC_PRE_RESET:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dtmprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "%s: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "MPT=
2_IOC_PRE_RESET\n", ioc->name, __func__));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPT2_IOC_AFTER_RESET:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dtmprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "%s: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "MPT=
2_IOC_AFTER_RESET\n", ioc->name, __func__));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->transport=
_cmds.status & MPT2_CMD_PENDING) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->transport_cmds.status |=3D MPT2_CMD_RESET;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 base_free_smid(ioc, ioc->transport_cmds.smid);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 complete(&ioc->transport_cmds.done);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->base_cmds=
=2Estatus & MPT2_CMD_PENDING) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->base_cmds.status |=3D MPT2_CMD_RESET;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 base_free_smid(ioc, ioc->base_cmds.smid);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 complete(&ioc->base_cmds.done);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->config_cm=
ds.status & MPT2_CMD_PENDING) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->config_cmds.status |=3D MPT2_CMD_RESET;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 base_free_smid(ioc, ioc->config_cmds.smid);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 complete(&ioc->config_cmds.done);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 case MPT2_IOC_DONE_RESET:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dtmprintk(ioc, pri=
ntk(MPT2SAS_DEBUG_FMT "%s: "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "MPT=
2_IOC_DONE_RESET\n", ioc->name, __func__));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 scsih_reset_handler(ioc, reset_phase);
> + =C2=A0 =C2=A0 =C2=A0 ctl_reset_handler(ioc, reset_phase);
> +}
> +
> +/**
> + * _wait_for_commands_to_complete - reset controller
> + * @ioc: Pointer to MPT_ADAPTER structure
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + *
> + * This function waiting(3s) for all pending commands to complete
> + * prior to putting controller in reset.
> + */
> +static void
> +_wait_for_commands_to_complete(struct MPT2SAS_ADAPTER *ioc, int slee=
p_flag)
> +{
> + =C2=A0 =C2=A0 =C2=A0 u32 ioc_state;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> + =C2=A0 =C2=A0 =C2=A0 u16 i;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc->pending_io_count =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 if (sleep_flag !=3D CAN_SLEEP)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 ioc_state =3D base_get_iocstate(ioc, 0);
> + =C2=A0 =C2=A0 =C2=A0 if ((ioc_state & MPI2_IOC_STATE_MASK) !=3D MPI=
2_IOC_STATE_OPERATIONAL)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* pending command count */
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->scsi_lookup_lock, flag=
s);
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < ioc->request_depth; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ioc->scsi_look=
up[i].cb_idx !=3D 0xFF)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ioc->pending_io_count++;
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->scsi_lookup_lock,=
 flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!ioc->pending_io_count)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* wait for pending commands to complete */
> + =C2=A0 =C2=A0 =C2=A0 wait_event_timeout(ioc->reset_wq, ioc->pending=
_io_count =3D=3D 0, 3 * HZ);
> +}
> +
> +/**
> + * base_hard_reset_handler - reset controller
> + * @ioc: Pointer to MPT_ADAPTER structure
> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
> + * @type: FORCE_BIG_HAMMER or SOFT_RESET
> + *
> + * Returns 0 for success, non-zero for failure.
> + */
> +int
> +base_hard_reset_handler(struct MPT2SAS_ADAPTER *ioc, int sleep_flag,
> + =C2=A0 =C2=A0enum reset_type type)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int r, i;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: e=
nter\n", ioc->name,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__));
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->ioc_reset_in_progress_=
lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->ioc_reset_in_progress) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqres=
tore(&ioc->ioc_reset_in_progress_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_ERR=
_FMT "%s: busy\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc-=
>name, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EBUSY;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 ioc->ioc_reset_in_progress =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 ioc->shost_recovery =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 if (ioc->shost->shost_state =3D=3D SHOST_RUNNI=
NG) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* set back to SHO=
ST_RUNNING in mpt2sas_scsih.c */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 scsi_host_set_stat=
e(ioc->shost, SHOST_RECOVERY);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(MPT2SAS_INF=
O_FMT "putting controller into "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "SHO=
ST_RECOVERY\n", ioc->name);
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->ioc_reset_in_prog=
ress_lock, flags);
> +
> + =C2=A0 =C2=A0 =C2=A0 _base_reset_handler(ioc, MPT2_IOC_PRE_RESET);
> + =C2=A0 =C2=A0 =C2=A0 _wait_for_commands_to_complete(ioc, sleep_flag=
);
> + =C2=A0 =C2=A0 =C2=A0 _base_mask_interrupts(ioc);
> + =C2=A0 =C2=A0 =C2=A0 r =3D _base_make_ioc_ready(ioc, sleep_flag, ty=
pe);
> + =C2=A0 =C2=A0 =C2=A0 if (r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> + =C2=A0 =C2=A0 =C2=A0 _base_reset_handler(ioc, MPT2_IOC_AFTER_RESET)=
;
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0 ; i < ioc->facts.NumberOfPorts; i=
++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D _base_make_i=
oc_operational(ioc, ioc->pfacts[i].VF_ID,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 slee=
p_flag);
> + =C2=A0 =C2=A0 =C2=A0 if (!r)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _base_reset_handle=
r(ioc, MPT2_IOC_DONE_RESET);
> + out:
> + =C2=A0 =C2=A0 =C2=A0 dtmprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s: %=
s\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ioc->name, __func__, ((r =3D=3D =
0) ? "SUCCESS" : "FAILED")));
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&ioc->ioc_reset_in_progress_=
lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 ioc->ioc_reset_in_progress =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ioc->ioc_reset_in_prog=
ress_lock, flags);
> + =C2=A0 =C2=A0 =C2=A0 return r;
> +}
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h =C2=A0 =C2=A0 =C2=A0 1969-1=
2-31 17:00:00.000000000 -0700
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h =C2=A0 =C2=A0 =C2=A0 2009-0=
2-24 14:17:02.000000000 -0700
> @@ -0,0 +1,781 @@
> +/*
> + * This is the Fusion MPT base driver providing common API layer int=
erface
> + * for access to MPT (Message Passing Technology) firmware.
> + *
> + * This code is based on drivers/scsi/mpt2sas/mpt2_base.h
> + * Copyright (C) 2007-2008 =C2=A0LSI Corporation
> + * =C2=A0(mai...
>
> [Message clipped]
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
