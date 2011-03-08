From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Integrity errors should not cause failover
Date: Tue, 8 Mar 2011 10:14:31 -0500
Message-ID: <20110308151430.GB4669@redhat.com>
References: <yq1aah6drw7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab1CHPOm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2011 10:14:42 -0500
Content-Disposition: inline
In-Reply-To: <yq1aah6drw7.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Mar 08 2011 at  1:54am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> Integrity errors need to be passed to the owner of the integrity
> metadata for processing. Consequently EILSEQ should be passed up the
> stack.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks Martin.  But James has already staged a few patches associated
with IO error differentation for 2.6.39.  Your dm-mpath patch will need
to be rebased on that work; best to feed it to James too.

(we were gambling that there wouldn't be additional DM or block changes
related to this work and figured it safe to have James carry all the
SCSI, block and DM changes... ;)

Problem is I'm not seeing a 2.6.39 branch in James' scsi-2.6-misc.git
(even though I know the changes are staged there ;)

See:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=79775567e0439ca47eb9f501e52c4b713d44cf89
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=751b2a7d623ead9e55f751a6087efeab454b5659
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=63583cca745f440167bf27877182dc13e19d4bcf

James,
Any easy way to get Martin your 2.6.39 tree?  Do you have a branch (just
the tag isn't exposed)?

Mike

> ---
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index f336c69..57f7dd3 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1215,7 +1215,7 @@ static int do_end_io(struct multipath *m, struct request *clone,
>  	if (!error && !clone->errors)
>  		return 0;	/* I/O complete */
>  
> -	if (error == -EOPNOTSUPP)
> +	if (error == -EOPNOTSUPP || error == -EILSEQ)
>  		return error;
>  
>  	if (mpio->pgpath)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
