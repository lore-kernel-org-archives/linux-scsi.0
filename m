From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 08:43:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204161443.g3GEhh990519@aslan.scsiguy.com>
References: <200204161403.g3GE33B01706@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Tue, 16 Apr 2002 09:03:03 CDT."
             <200204161403.g3GE33B01706@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

>We can't go on adding these band aid fixes to the scsi subsystem with
>the justification that it's currently broken in a lot of cases so we
>don't need to consider them.  All that does is cause the subsystem to
>diverge further and make the eventual fix even more difficult and daunting.

In my opinion, the only way to really fix the Linux SCSI layer is
to rip it out and start over using prior art from systems with functional
I/O subsystems as a guide to building something enterprise worthy.  As
soon as the community becomes serious about such an endevor, so will I. 8-)

>What is wrong with:
>
>	    if (scsi_sense_valid(SCpnt)) {	/* Sense data is valid */
>		/* FIXME: this probably won't work for deferred errors
>
>That way you've used the supplied function and noted the potential problem 
>case.

If you insist on doing this, lets at least preserve the current behavior:

	/*
	 * FIXME: this driver treats deferred errors are fatal for
	 * 	  the command that reports the error.  The error is
	 *	  actually for a previous command, so the current
	 *	  command should be retried.  In general, deferred
	 *	  errors are hard to cope with as the data written
	 *	  may not be available to be written again.  This
	 *	  is one of the many reasons that write-back caching
	 *	  should not be enabled for general purpose applications.
	 *	  The user should at lease enable "auto write reallocation"
	 *	  and verify that the spare table for the device is not
	 *	  full.
	 */
	if (scsi_sense_valid(SCpnt)
	 && scsi_sense_key(SCpnt) == SKEY_CURRENT_ERROR) {

	}

I don't believe there are definitions to support the second part of
the if clause, but there could be.

--
Justin
