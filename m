From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 16/24] scsi_dh_alua: Add new blacklist flag
	'BLIST_SYNC_ALUA'
Date: Mon, 18 Jan 2016 18:50:43 +0100
Message-ID: <20160118175043.GD24303@lst.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de> <1452672599-9820-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33482 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365AbcARRuo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 12:50:44 -0500
Content-Disposition: inline
In-Reply-To: <1452672599-9820-17-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

> @@ -335,6 +336,10 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>  	int rel_port = -1, group_id;
>  	struct alua_port_group *pg, *old_pg = NULL;
>  	bool pg_updated = false;
> +	unsigned int bflags = scsi_get_device_flags_keyed(sdev,
> +							  &sdev->inquiry[8],
> +							  &sdev->inquiry[16],
> +							  SCSI_DEVINFO_GLOBAL);

I see not reason to use scsi_get_device_flags_keyed over
scsi_get_device_flags here.  Also:

 - why can't we just set a flag in the sdev like for most other
   blacklist item (in the long run I plan to simply mirror all blist
   flags into the sdev anyway).
 - please add the affected arrays to scsi_static_device_list
