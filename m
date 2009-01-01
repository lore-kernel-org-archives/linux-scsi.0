From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi: Add VPD helper
Date: Thu, 1 Jan 2009 06:38:18 -0700
Message-ID: <20090101133818.GM2002@parisc-linux.org>
References: <1230747167-31677-1-git-send-email-matthew@wil.cx> <495C8AA5.9010008@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56828 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZAANiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2009 08:38:20 -0500
Content-Disposition: inline
In-Reply-To: <495C8AA5.9010008@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Thu, Jan 01, 2009 at 11:19:33AM +0200, Boaz Harrosh wrote:
> +	buffer[1] = -1;
> see below
> > +	/*
> > +	 * I'm not convinced we need to try quite this hard to get VPD, but
> > +	 * all the existing users tried this hard.
> > +	 */
> > +	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
> > +				  len + 4, NULL, 30 * HZ, 3, NULL);
> > +	if (result)
> > +		return result;
> > +
> > +	/* Sanity check that we got the page back that we asked for */
> > +	if (buffer[1] != page)
> > +		return -EIO;
> 
> Maybe it's just me but, if you are going to if() on a buffer byte, then you need
> to make sure its initial value. Or at least document the need for a -1 at
> buffer[1]

buffer[] is an array of unsigned char, so -1 is 255.  We could be asking
for page 0xff, so your initialisation doesn't help reject bogus data.

Your concern here, presumably, is that the device might transfer less than
two bytes, and not return an error.  I think this is quite unlikely --
and in any case, such a misbehaving device is really no different from a
device which transfers complete garbage.

I suppose we could pass a 'resid' to scsi_execute_req and check that at
least four bytes was transferred.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
