From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: boot hangs while LD is offline
Date: Wed, 16 Aug 2017 18:35:18 +0530
Message-ID: <b3be70b1e3e6a64e95b846b94830dbe2@mail.gmail.com>
References: <1502798355-59330-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36346 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdHPNFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 09:05:20 -0400
Received: by mail-oi0-f46.google.com with SMTP id g131so35026289oic.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Aug 2017 06:05:20 -0700 (PDT)
In-Reply-To: <1502798355-59330-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Tuesday, August 15, 2017 5:29 PM
>To: Martin K. Petersen
>Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; Kashyap Desai;
>megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; Hannes
>Reinecke; Hannes Reinecke
>Subject: [PATCH] megaraid_sas: boot hangs while LD is offline
>
>Offline Logical drives (LDs) should not allowed to be visible to the OS,
as the
>OS will hang trying to send commands to it.
>This patch skips offline LDs like it already does for non-system physical
drives
>(PDs).

Hi Hannes,

You have submitted this patch in past as it was part of SLES kernel but
missing in upstream and it was concluded to drop this patch then.
This issue was fixed in firmware 4 years back and many firmware versions
should be available with the fix so this fix is not required in
driver(upstream
as well SLES kernel). Do you see any functional issue without this patch ?
If not, I would request  to back out this patch from SLES kernel also.

Thanks,
Sumit

>
>Signed-off-by: Hannes Reinecke <hare@suse.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 5202c2f..39b08fc 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -1897,14 +1897,19 @@ static void
>megasas_set_static_target_properties(struct scsi_device *sdev,
>
> static int megasas_slave_configure(struct scsi_device *sdev)  {
>-	u16 pd_index = 0;
>+	u16 pd_index = 0, ld_index;
> 	struct megasas_instance *instance;
> 	int ret_target_prop = DCMD_FAILED;
> 	bool is_target_prop = false;
>
> 	instance = megasas_lookup_instance(sdev->host->host_no);
> 	if (instance->pd_list_not_supported) {
>-		if (!MEGASAS_IS_LOGICAL(sdev) && sdev->type ==
>TYPE_DISK) {
>+		if (MEGASAS_IS_LOGICAL(sdev)) {
>+			ld_index = ((sdev->channel -
>MEGASAS_MAX_PD_CHANNELS) *
>+				    MEGASAS_MAX_DEV_PER_CHANNEL) +
>sdev->id;
>+			if (instance->ld_ids[ld_index] == 0xff)
>+				return -ENXIO;
>+		} else if (sdev->type == TYPE_DISK) {
> 			pd_index = (sdev->channel *
>MEGASAS_MAX_DEV_PER_CHANNEL) +
> 				sdev->id;
> 			if (instance->pd_list[pd_index].driveState !=
>--
>1.8.5.6
