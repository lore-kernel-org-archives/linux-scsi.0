From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 01/08] scsi: remove unused bounce-buffer
	release path
Date: Tue, 22 Mar 2005 22:07:26 -0600
Message-ID: <1111550846.5520.90.camel@mulgrave>
References: <20050323021335.960F95F8@htj.dyndns.org>
	 <20050323021335.F07B64D9@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:4839 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262758AbVCWEHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 23:07:44 -0500
In-Reply-To: <20050323021335.F07B64D9@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-03-23 at 11:14 +0900, Tejun Heo wrote:
> 01_scsi_remove_scsi_release_buffers.patch
> 
> 	Buffer bouncing hasn't been done inside the scsi midlayer for
> 	quite sometime now, but bounce-buffer release paths are still
> 	around.  This patch removes these unused paths.

Yes, but scsi_release_buffers isn't referring to bounce buffers anymore,
it's simply releasing the sg buffers.

[...]
> -	else if (cmd->buffer != req->buffer) {
> -		if (rq_data_dir(req) == READ) {
> -			unsigned long flags;
> -			char *to = bio_kmap_irq(req->bio, &flags);
> -			memcpy(to, cmd->buffer, cmd->bufflen);
> -			bio_kunmap_irq(to, &flags);
> -		}
> -		kfree(cmd->buffer);
> -	}

I'll defer to Jens here, but I don't thing you can just remove this ...
sg_io with a misaligned buffer will fail without this.

That rather nasty code freeing cmd->buffer needs to be in there as
well ... so it does make sense to keep this API

James


