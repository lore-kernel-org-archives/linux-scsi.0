From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Wed, 7 Nov 2007 04:49:29 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711070447280.25961@localhost.localdomain>
References: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain>
 <20071106153012.GG4113@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:56932 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXKGJv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 04:51:26 -0500
In-Reply-To: <20071106153012.GG4113@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 6 Nov 2007, Matthew Wilcox wrote:

> On Tue, Nov 06, 2007 at 10:20:46AM -0500, Robert P. J. Day wrote:
> > @@ -1656,7 +1657,7 @@ static inline int reconnect_target(struct NCR_ESP *esp, struct ESP_regs *eregs)
> >  	if(!(it & me))
> >  		return -1;
> >  	it &= ~me;
> > -	if(it & (it - 1))
> > +	if(!is_power_of_2(it))
> >  		return -1;
>
> Non-equivalent transform.  Probably a bug.
>
> >  		bits &= ~esp->scsi_id_mask;
> > -		if (!bits || (bits & (bits - 1)))
> > +		if (!is_power_of_2(bits))
> >  			goto do_reset;
>
> Non-equivalent transform.  Definitely a bug.
>
> >  		iscsi_set_param(cls_conn, param, buf, buflen);
> > -		if (session->max_r2t & (session->max_r2t - 1))
> > +		if (!is_power_of_2(session->max_r2t))
> >  			session->max_r2t = roundup_pow_of_two(session->max_r2t);
>
> Non-equivalent transform.  Not sure if it's a bug or not.
>
> >
> > -	if (cmds_max < 2 || (cmds_max & (cmds_max - 1)) ||
> > +	if (cmds_max < 2 || !is_power_of_2(cmds_max) ||
> >  	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {
>
> This one's OK.

so, of the above, which can safely be rewritten using
"[!]is_power_of_2"?  and, for now, let's leave out the ones that would
semantically make more sense to be testing for single-bitness -- i'll
try to sneak in a macro like that in the next merge window.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
