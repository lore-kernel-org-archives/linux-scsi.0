From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH/RFC] allow userspace to modify scsi command filter on per device basis
Date: Sat, 14 Jun 2008 22:26:12 +0200
Message-ID: <20080614202612.GG20851@kernel.dk>
References: <6cf6b73e0806131233i53942756j24a00ba18abebb47@mail.gmail.com> <20080613195448.GA30405@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:29508 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbYFNU0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jun 2008 16:26:16 -0400
Content-Disposition: inline
In-Reply-To: <20080613195448.GA30405@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Adel Gadllah <adel.gadllah@gmail.com>, linux-scsi@vger.kernel.org, pjones@redhat.com

On Fri, Jun 13 2008, Matthew Wilcox wrote:
> On Fri, Jun 13, 2008 at 09:33:27PM +0200, Adel Gadllah wrote:
> > -		if (blk_verify_command(rq->cmd, has_write_perm))
> > +		if (blk_cmd_filter_verify_command(bd->cmd_filter, rq->cmd, bd->f_mode))
> 
> Could you wrap to 80 columns?
> 
> > +static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
> > +			      const char *page, size_t count, int rw)
> > +{
> > +	ssize_t ret = 0;
> > +	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
> > +	int cmd, status, len;
> > +	substring_t ss;
> > +
> > +	memset(&okbits, 0, sizeof (okbits));
> > +
> > +	for (len = strlen(page); len > 0; len -= 3) {
> > +		if (len < 2)
> > +			break;
> > +		ss.from = (char *) page + ret;
> > +		ss.to = (char *) page + ret + 2;
> > +		ret+=3;
> > +		status = match_hex(&ss, &cmd);
> > +		/* either of these cases means invalid input, so do nothing. */
> > +		if (status || cmd >= BLK_SCSI_MAX_CMDS)
> > +			return -EINVAL;
> > +
> > +		set_bit(cmd, okbits);
> 
> set_bit is atomic.  locked ops can be quite painful on some processors.
> Since okbits is local, the atomicity isn't necessary and you can simply
> use __set_bit.

Which that is strictly true, this is only invoked when someone sets a
new filter for the device. So probably once in the life time of that
kernel boot, hardly performance critical...

-- 
Jens Axboe

