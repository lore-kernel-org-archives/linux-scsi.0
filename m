From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 02/10] dm-mpath, scsi_dh: request scsi_dh modules in
 scsi_dh, not dm-mpath
Date: Fri, 28 Aug 2015 12:53:17 -0700
Message-ID: <1440791597.2202.49.camel@HansenPartnership.com>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
	 <1440677823-11695-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56690 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbbH1TxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2015 15:53:18 -0400
In-Reply-To: <1440677823-11695-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:16 +0200, Hannes Reinecke wrote:
> @@ -158,7 +171,7 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
>  		/*
>  		 * Attach to a device handler
>  		 */
> -		if (!(scsi_dh = get_device_handler(buf)))
> +		if (!(scsi_dh = scsi_dh_lookup(buf)))

This one's a checkpatch error:

ERROR: do not use assignment in if condition
#71: FILE: drivers/scsi/device_handler/scsi_dh.c:174:
+               if (!(scsi_dh = scsi_dh_lookup(buf)))


For very good reason.  The meaning is obvious from the previous code, so
I fixed it up as

		scsi_dh = scsi_dh_lookup(buf);
		if (!scsi_dh)

But running the series through checkpatch and acting on at least the
errors would have been appreciated.

James


