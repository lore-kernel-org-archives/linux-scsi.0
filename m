From: Audio Haven <audiohaven@gmail.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
	task
Date: Tue, 10 Aug 2010 21:10:30 +0200
Message-ID: <AANLkTink9DyvHmgRDDe8WqwTJhAVX=DFQ8_b-U6Fy+Fi@mail.gmail.com>
References: <20100806161622.GA8696@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38155 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab0HJTUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2010 15:20:37 -0400
Received: by bwz3 with SMTP id 3so2137972bwz.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Aug 2010 12:20:35 -0700 (PDT)
In-Reply-To: <20100806161622.GA8696@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, sgruszka@redhat.com, satyasrinivasp@hcl.in, jeff@garzik.org

Hello David,

Does this patch solve the Unplug Notice issues ?

When copying lots of large video files in sequence to a 6 TB XFS
filesystem on top of a 8 TB software raid6 set, I frequently see my
copy (over samba) being stalled for a while, then the following is
reported:

drivers/scsi/mvsas/mv_sas.c 1701:<7>mv_abort_task()
mvi=3Dffff88003d1c0000 task=3Dffff880004285080 slot=3Dffff88003d1de478
slot_idx=3Dx1
drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc=3D 5
drivers/scsi/mvsas/mv_sas.c 2081:port 4 ctrl sts=3D0x89800.
drivers/scsi/mvsas/mv_sas.c 2083:Port 4 irq sts =3D 0x1001
drivers/scsi/mvsas/mv_sas.c 2109:phy4 Unplug Notice
drivers/scsi/mvsas/mv_sas.c 2081:port 4 ctrl sts=3D0x199800.
drivers/scsi/mvsas/mv_sas.c 2083:Port 4 irq sts =3D 0x1081
drivers/scsi/mvsas/mv_sas.c 2081:port 4 ctrl sts=3D0x199800.
drivers/scsi/mvsas/mv_sas.c 2083:Port 4 irq sts =3D 0x10000
drivers/scsi/mvsas/mv_sas.c 2136:notify plug in on phy[4]
drivers/scsi/mvsas/mv_sas.c 1224:port 4 attach dev info is 4
drivers/scsi/mvsas/mv_sas.c 1226:port 4 attach sas addr is 4
drivers/scsi/mvsas/mv_sas.c 378:phy 4 byte dmaded.
drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[4]:rc=3D=
 0
ata13: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
ata13: status=3D0x01 { Error }
ata13: error=3D0x04 { DriveStatusError }

I'm using the SuperMicro AOC-SASLP-MV8 to control 8 1TB disks, which
are never physically unplugged. Used kernel is 2.6.35.
Raid never breaks so no data loss occurs, but the samba copy
frequently breaks when the above error occurs, so copying always needs
a double check, which is quite annoying.

Best regards,

=46rederic Vanden Poel


On Fri, Aug 6, 2010 at 6:16 PM, David Milburn <dmilburn@redhat.com> wro=
te:
> mvs_lu_reset should not call mvs_release_task phy number of times,
> each phy is handled in mvs_release_task.
>
> Signed-off-by: David Milburn <dmilburn@redhat.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Srinivas <satyasrinivasp@hcl.in>
> Cc: Andy Yan <ayan@marvell.com>
> ---
> =A0drivers/scsi/mvsas/mv_sas.c | =A0 =A06 ++----
> =A01 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.=
c
> index adedaa9..013ab8d 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1551,7 +1551,7 @@ static int mvs_debug_I_T_nexus_reset(struct dom=
ain_device *dev)
> =A0int mvs_lu_reset(struct domain_device *dev, u8 *lun)
> =A0{
> =A0 =A0 =A0 =A0unsigned long flags;
> - =A0 =A0 =A0 int i, phyno[WIDE_PORT_MAX_PHY], num , rc =3D TMF_RESP_=
=46UNC_FAILED;
> + =A0 =A0 =A0 int rc =3D TMF_RESP_FUNC_FAILED;
> =A0 =A0 =A0 =A0struct mvs_tmf_task tmf_task;
> =A0 =A0 =A0 =A0struct mvs_device * mvi_dev =3D dev->lldd_dev;
> =A0 =A0 =A0 =A0struct mvs_info *mvi =3D mvi_dev->mvi_info;
> @@ -1560,10 +1560,8 @@ int mvs_lu_reset(struct domain_device *dev, u8=
 *lun)
> =A0 =A0 =A0 =A0mvi_dev->dev_status =3D MVS_DEV_EH;
> =A0 =A0 =A0 =A0rc =3D mvs_debug_issue_ssp_tmf(dev, lun, &tmf_task);
> =A0 =A0 =A0 =A0if (rc =3D=3D TMF_RESP_FUNC_COMPLETE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num =3D mvs_find_dev_phyno(dev, phyno);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irqsave(&mvi->lock, flags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < num; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, d=
ev);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mvs_release_task(mvi, dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&mvi->lock, fla=
gs);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/* If failed, fall-through I_T_Nexus reset */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
