From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Always retry internal target error
Date: Tue, 17 Oct 2017 22:58:00 -0400
Message-ID: <yq18tg9upqf.fsf@oracle.com>
References: <1508224263-130302-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29348 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758033AbdJRC6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 22:58:11 -0400
In-Reply-To: <1508224263-130302-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 17 Oct 2017 09:11:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> +		if (!strncmp(scmd->device->vendor, "EMC", 3) &&
> +		    !strncmp(scmd->device->model, "SYMMETRIX", 9) &&
> +		    (sshdr.asc == 0x44) && (sshdr.ascq == 0x0)) {
> +			/*
> +			 * EMC Symmetrix returns 'Internal target failure'
> +			 * for a variety of internal issues, all of which
> +			 * can be recovered by retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		}

It's decidedly awful to have vendor/model-specific triggers in
scsi_error.

What are the drawbacks of just always refiring on AC/0x44/ITF?

-- 
Martin K. Petersen	Oracle Linux Engineering
