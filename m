From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: disable automatic target scan
Date: Mon, 14 Mar 2016 19:57:02 -0400
Message-ID: <yq1y49kfwa9.fsf@sermon.lab.mkp.net>
References: <1457710420-37769-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18754 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbcCNX5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 19:57:15 -0400
In-Reply-To: <1457710420-37769-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 11 Mar 2016 16:33:40 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 97074c9..929204b 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -96,10 +96,11 @@ MODULE_PARM_DESC(max_luns,
>  #define SCSI_SCAN_TYPE_DEFAULT "sync"
>  #endif
>  
> -char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
> +char scsi_scan_type[9] = SCSI_SCAN_TYPE_DEFAULT;
>  
> -module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
> -MODULE_PARM_DESC(scan, "sync, async or none");
> +module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type),
> +		    S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(scan, "sync, async, disabled, or none");

So "disabled" is "sometimes enabled" and "none" is "really disabled"?
 
>  static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
>  
> @@ -1604,7 +1605,9 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
>   * @channel:	channel to scan
>   * @id:		target id to scan
>   * @lun:	Specific LUN to scan or SCAN_WILD_CARD
> - * @rescan:	passed to LUN scanning routines
> + * @rescan:	passed to LUN scanning routines; 0 for no rescan, 1 to rescan
> + *              existing LUNs, and 2 to override any 'scan_disabled' setting
> + *              from the host.

enum SCSI_SCAN_FOO_BAR instead of magic values, please.

What's this "scan_disabled" setting from the host?

-- 
Martin K. Petersen	Oracle Linux Engineering
