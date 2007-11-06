From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: Use is_power_of_2() macro for simplicity.
Date: Tue, 6 Nov 2007 09:22:28 -0700
Message-ID: <20071106162227.GH4113@parisc-linux.org>
References: <Pine.LNX.4.64.0711061019450.9041@localhost.localdomain> <20071106153012.GG4113@parisc-linux.org> <Pine.LNX.4.64.0711061107480.21836@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41885 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbXKFQW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 11:22:29 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711061107480.21836@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 06, 2007 at 11:09:51AM -0500, Robert P. J. Day wrote:
> > >  		bits &= ~esp->scsi_id_mask;
> > > -		if (!bits || (bits & (bits - 1)))
> > > +		if (!is_power_of_2(bits))
> > >  			goto do_reset;
> >
> > Non-equivalent transform.  Definitely a bug.
> 
> ok, that one i'm curious about.  how is that not an equivalent
> transform?  am i missing something painfully obvious?

Apologies, I got my boolean algebra wrong.  It is equivalent:

bool is_power_of_2(unsigned long n)
        return (n != 0 && ((n & (n - 1)) == 0));

substitute it in:

		if (!is_power_of_2(bits))

		if (!(bits != 0 && ((bits & (bits - 1)) == 0)))

push the ! inside brackets:

		if (bits == 0 || ((bits & (bits - 1)) != 0))

> > > -		if (!bits || (bits & (bits - 1)))

Clearly the same thing.  Still ... I don't like it because we're not
really looking for 'is this a power of two', we want to know 'is there
exactly one bit set'.  Which, after a bit of thinking, is the same
thing, but it's a bad name for this usage.  Perhaps we could add

#define exactly_one_bit_set is_power_of_2

to the header file.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
