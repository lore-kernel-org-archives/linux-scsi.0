From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ses: Fix SAS device detection in enclosure
Date: Mon, 16 Jan 2017 16:02:24 -0500
Message-ID: <yq1ziiqk9b3.fsf@oracle.com>
References: <1483997616-18900-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:41022 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdAPVDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2017 16:03:51 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0GL3Yqq032659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2017 21:03:34 GMT
In-Reply-To: <1483997616-18900-1-git-send-email-emilne@redhat.com> (Ewan
        D. Milne's message of "Mon, 9 Jan 2017 16:33:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan> The call to scsi_is_sas_rphy() needs to be made on the SAS
Ewan> end_device, not on the SCSI device.

Ewan> Fixes: 835831c57e9b ("ses: use scsi_is_sas_rphy instead of
Ewan> is_sas_attached") Reviewed-by: Johannes Thumshirn
Ewan> <jthumshirn@suse.de> Signed-off-by: Ewan D. Milne
Ewan> <emilne@redhat.com> ---
Ewan>  drivers/scsi/ses.c | 2 +- 1 file changed, 1 insertion(+), 1
Ewan>  deletion(-)

Ewan> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index
Ewan> 8c9a35c..50adabb 100644
Ewan> --- a/drivers/scsi/ses.c
Ewan> +++ b/drivers/scsi/ses.c
Ewan> @@ -587,7 +587,7 @@ static void ses_match_to_enclosure(struct
Ewan> enclosure_device *edev,
 
Ewan>  	ses_enclosure_data_process(edev,
Ewan>  	to_scsi_device(edev->edev.parent), 0);
 
Ewan> - if (scsi_is_sas_rphy(&sdev->sdev_gendev))
Ewan> + if (scsi_is_sas_rphy(sdev->sdev_target->dev.parent))
Ewan>  		efd.addr = sas_get_address(sdev);
 
Ewan>  	if (efd.addr) {
Ewan> -- 1.8.3.1

James?

-- 
Martin K. Petersen	Oracle Linux Engineering
