From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 09:03:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204161403.g3GE33B01706@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Mon, 15 Apr 2002 15:13:37 MDT." <200204152113.g3FLDb982996@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

gibbs@scsiguy.com said:
> Well, if we really wanted to fix it correctly:
[...]
> The check against 0xF0 is currently "correct" because the code in
> sd.c's rw_intr doesn't know how to deal with anything other than a
> current error (0x70 + valid bit). 

I'm not advocating that you fix it correctly.  However, if you use the 
provided scsi_sense_valid() function it will show up in an easy to recognise 
form for someone who later does all of this fixing.  We can't go on adding 
these band aid fixes to the scsi subsystem with the justification that it's 
currently broken in a lot of cases so we don't need to consider them.  All 
that does is cause the subsystem to diverge further and make the eventual fix 
even more difficult and daunting.

What is wrong with:

	    if (scsi_sense_valid(SCpnt)) {	/* Sense data is valid */
		/* FIXME: this probably won't work for deferred errors

That way you've used the supplied function and noted the potential problem 
case.

James



