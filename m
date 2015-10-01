From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/36] scsi_dh_alua: return standard SCSI return codes in
 submit_rtpg
Date: Thu, 1 Oct 2015 16:58:47 -0700
Message-ID: <560DC8B7.8020800@sandisk.com>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
 <1443523658-87622-9-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0100.outbound.protection.outlook.com ([65.55.169.100]:26950
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750762AbbJAX6x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 19:58:53 -0400
In-Reply-To: <1443523658-87622-9-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
> +	blk_execute_rq(rq->q, NULL, rq, 1);
> +	if (rq->errors)
> +		err = rq->errors;

Not all code in the block layer uses the SCSI error codes. Do we need
code to convert negative error codes into a SCSI error code here ? An
example:

void blk_mq_abort_requeue_list(struct request_queue *q)
{
        [ ... ]
		rq->errors = -EIO;
        [ ... ]
}
EXPORT_SYMBOL(blk_mq_abort_requeue_list);

Bart.
