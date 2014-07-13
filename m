From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
 requests
Date: Sun, 13 Jul 2014 10:52:53 -0400
Message-ID: <53C29D45.8000301@interlog.com>
References: <1404048881-19526-1-git-send-email-hch@lst.de>	<1404048881-19526-7-git-send-email-hch@lst.de> <yq14myl1g3q.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58290 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaGMOxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2014 10:53:03 -0400
In-Reply-To: <yq14myl1g3q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 14-07-13 10:35 AM, Martin K. Petersen wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
>
> Christoph> Simplify handling of discard requests by setting up the
> Christoph> command directly instead of initializing request fields and
> Christoph> then calling scsi_setup_blk_pc_cmnd to propagate the
> Christoph> information into the command.
>
> Would be nice to add a comment similar to the WRITE SAME one. Something
> like:
>
> /*
>   * Initially __data_len is set to the amount of data that needs to be
>   * transferred to the target. This amount depends on whether WRITE SAME
>   * or UNMAP is being used. After the scatterlist has been mapped by
>   * scsi_init_io() we set __data_len to the size of the area to be
>   * discarded on disk. This allows us to report completion on the full
>   * amount of blocks described by the request.
>   */
>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

To make things clearer when referring to the WRITE SAME command
I would suggest "WRITE SAME(unmap)" for the case when its UNMAP
field is 1 (as I assume it is in this case).

Doug Gilbert


