From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/5] isci: atapi support
Date: Fri, 30 Sep 2011 18:49:34 -0700
Message-ID: <CAA9_cmfbagRe2JZ6bi8-eK+4bpeQHYxDFgfs8CAtHHiPxDVnrQ@mail.gmail.com>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
	<20110929014741.23617.56819.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45408 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1JABtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2011 21:49:35 -0400
Received: by qadb15 with SMTP id b15so695568qad.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2011 18:49:34 -0700 (PDT)
In-Reply-To: <20110929014741.23617.56819.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Maciej Trela <maciej.trela@intel.com>, dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>

On Wed, Sep 28, 2011 at 6:47 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> Based on original implementation from Jiangbi Liu and Maciej Trela.
>
> ATAPI transfers happen in two-to-three stages. =A0The two stage atapi
> commands are those that include a dma data transfer. =A0The data tran=
sfer
> portion of these operations is handled by the hardware packet-dma
> acceleration. =A0The three-stage commands do not have a data transfer=
 and
> are handled without hardware assistance in raw frame mode.
>
> stage1: transmit host-to-device fis to notify the device of an incomi=
ng
> atapi cdb. =A0Upon reception of the pio-setup-fis repost the task_con=
text
> to perform the dma transfer of the cdb+data (go to stage3), or repost
> the task_context to transmit the cdb as a raw frame (go to stage 2).
>
> stage2: wait for hardware notification of the cdb transmission and th=
en
> go to stage 3.
>
> stage3: wait for the arrival of the terminating device-to-host fis an=
d
> terminate the command.
>
> To keep the implementation simple we only support ATAPI packet-dma
> protocol (for commands with data) to avoid needing to handle the data
> transfer manually (like we do for SATA-PIO). =A0This may affect
> compatibility for a small number of devices (see
> ATA_HORKAGE_ATAPI_MOD16_DMA).
>
> If the data-transfer underruns, or encounters an error the
> device-to-host fis is expected to arrive in the unsolicited frame que=
ue
> to pass to libata for disposition. =A0However, in the DONE_UNEXP_FIS =
(data
> underrun) case it appears we need to craft a response. =A0In the
> DONE_REG_ERR case we do receive the UF and propagate it to libsas.
>
> Signed-off-by: Maciej Trela <maciej.trela@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/scsi/isci/remote_device.c =A0 | =A0 24 +++
> =A0drivers/scsi/isci/remote_device.h =A0 | =A0 =A09 +
> =A0drivers/scsi/isci/request.c =A0 =A0 =A0 =A0 | =A0327 +++++++++++++=
+++++++++++++++++++++-
> =A0drivers/scsi/isci/request.h =A0 =A0 =A0 =A0 | =A0 28 +++
> =A0drivers/scsi/libsas/sas_scsi_host.c | =A0 =A02
> =A0include/scsi/libsas.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A05 +
> =A06 files changed, 379 insertions(+), 16 deletions(-)
>
[..]
> diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.=
c
> index b5d3a8c..2bf072f 100644
> --- a/drivers/scsi/isci/request.c
> +++ b/drivers/scsi/isci/request.c
[..]
> @@ -2802,26 +3096,29 @@ static void sci_request_started_state_enter(s=
truct sci_base_state_machine *sm)
> =A0 =A0 =A0 =A0 * substates
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (!task && dev->dev_type =3D=3D SAS_END_DEV) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sci_change_state(sm, SCI_REQ_TASK_WAIT_=
TC_COMP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 state =3D SCI_REQ_TASK_WAIT_TC_COMP;
> =A0 =A0 =A0 =A0} else if (!task &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (isci_request_access_tmf(ireq)->t=
mf_code =3D=3D isci_tmf_sata_srst_high ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0isci_request_access_tmf(ireq)-=
>tmf_code =3D=3D isci_tmf_sata_srst_low)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sci_change_state(sm, SCI_REQ_STP_SOFT_R=
ESET_WAIT_H2D_ASSERTED);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 state =3D SCI_REQ_STP_SOFT_RESET_WAIT_H=
2D_ASSERTED;
> =A0 =A0 =A0 =A0} else if (task && task->task_proto =3D=3D SAS_PROTOCO=
L_SMP) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sci_change_state(sm, SCI_REQ_SMP_WAIT_R=
ESP);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 state =3D SCI_REQ_SMP_WAIT_RESP;
> =A0 =A0 =A0 =A0} else if (task && sas_protocol_ata(task->task_proto) =
&&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !task->ata_task.use_ncq) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 state;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (task->data_dir =3D=3D DMA_NONE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev->sata_dev.command_set =3D=3D AT=
API_COMMAND_SET &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task->ata_task.fis.comm=
and =3D=3D ATA_CMD_PACKET) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state =3D SCI_REQ_ATAPI=
_WAIT_H2D;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (task->data_dir =3D=3D DMA_NO=
NE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D SCI_REQ_STP_=
NON_DATA_WAIT_H2D;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (task->ata_task.dma_xfer)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (task->ata_task.dma_xfer) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D SCI_REQ_STP_=
UDMA_WAIT_TC_COMP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else /* PIO */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else /* PIO */ {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D SCI_REQ_STP_=
PIO_WAIT_H2D;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sci_change_state(sm, state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();

Unfortunately this was part of a last minute "cleanup" that missed the
fact that SSP and STP-NCQ commands are fully accelerated and do not
have a substate.  To prevent this mistake in the future I changed this
to:

@@ -3106,7 +3106,8 @@ static void
sci_request_started_state_enter(struct sci_base_state_machine *sm)
                        state =3D SCI_REQ_STP_PIO_WAIT_H2D;
                }
        } else {
-               BUG();
+               /* SSP or NCQ are fully accelerated, no substates */
+               return;
        }
        sci_change_state(sm, state);
 }

A v2 will be posted shortly and the github branch will be updated.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
