From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [RFC PATCH] mpt3sas: support target smid for [abort|query] task
Date: Fri, 14 Jun 2019 06:05:33 +0900
Message-ID: <20190613210533.GA25375@minwooim-desktop>
References: <CGME20190613075402epcms2p7dbd2e2f7c80bd2aef2c5dd3736393d36@epcms2p7>
 <20190613075402epcms2p7dbd2e2f7c80bd2aef2c5dd3736393d36@epcms2p7>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190613075402epcms2p7dbd2e2f7c80bd2aef2c5dd3736393d36@epcms2p7>
Sender: linux-kernel-owner@vger.kernel.org
To: Minwoo Im <minwoo.im@samsung.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sungjun Park <sj1228.park@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On 19-06-13 16:54:02, Minwoo Im wrote:
> We can request task management IOCTL command(MPI2_FUNCTION_SCSI_TASK_MGMT)
> to /dev/mpt3ctl.  If the given task_type is either abort task or query
> task, it may need a field named "Initiator Port Transfer Tag to Manage"
> in the IU.
> 
> Current code does not support to check target IPTT tag from the
> tm_request.  This patch introduces to check TaskMID given from the
> userspace as a target tag.  We have a rule of relationship between
> (struct request *req->tag) and smid in mpt3sas_base.c:
> 
> 3318 u16
> 3319 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
> 3320         struct scsi_cmnd *scmd)
> 3321 {
> 3322         struct scsiio_tracker *request = scsi_cmd_priv(scmd);
> 3323         unsigned int tag = scmd->request->tag;
> 3324         u16 smid;
> 3325
> 3326         smid = tag + 1;
> 
> So if we want to abort a request tagged #X, then we can pass (X + 1) to
> this IOCTL handler.
> 
> Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
> ---

Sorry for the duplicated patches on the same mailing list.  Please ignore
the first two of it.

Thanks,
