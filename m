From: Daniel Drake <dsd@gentoo.org>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs   disabled
 - dmesg filled with warnings
Date: Sat, 16 Feb 2008 23:36:44 +0000
Message-ID: <47B7738C.9050107@gentoo.org>
References: <47ADC74B.9080009@control.aau.dk>	 <1202580076.4254.24.camel@localhost.localdomain>	 <20080209193518.GC11299@hoblitt.com>	 <1202586219.4254.35.camel@localhost.localdomain>	 <20080212205345.GB7640@hoblitt.com> <20080212222109.GC7640@hoblitt.com>	 <1202855436.3137.153.camel@localhost.localdomain>	 <20080215205657.GB23625@hoblitt.com>	 <1203112643.3058.48.camel@localhost.localdomain>	 <1203113047.3058.50.camel@localhost.localdomain>	 <47B6CDDB.8000605@gentoo.org> <1203173535.3182.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serenity.mcc.ac.uk ([130.88.200.93]:58971 "EHLO
	serenity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYBPXfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2008 18:35:04 -0500
In-Reply-To: <1203173535.3182.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joshua Hoblitt <josh@hoblitt.com>, Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, j_gentoo@hoblitt.com, nick.cheng@areca.com.tw

James Bottomley wrote:
> On Sat, 2008-02-16 at 11:49 +0000, Daniel Drake wrote:
>> I assume you're aware that this patch is just a subset of commit 
>> 76d78300a6eb8 which you've already pushed up to Linus. Adding Nick Cheng 
>> (commit author) to CC so that he can go over the feedback.
> 
> Well, in case it's not obvious by now:  The way to get bad code upstream
> is to send a patch that combines many changes (the more the better) so
> that any potential reviewer has no idea which change is meant by which
> hunk and then to make sure Andrew picks it up so he'll hound the
> subsystem Maintainer until it's applied.  Best of all, mention that it
> fixes a bug and you're made.

Sorry, I didn't mean to sound that as a criticism. I'm sure you have a 
lot of patches flowing by you at any one time.

Here is a patch to address your comments.
Joshua, would you mind testing this before I submit it properly? It will 
apply cleanly to 2.6.24 on top of the previous patch you tested. I have 
compile-tested it.

> The odd thing is, it should have triggered a might_sleep() warning under
> testing ... do you know why it didn't?

No, and I can see that scsi_dispatch_command does invoke ->queuecommand 
under a spinlock so it must be atomic context...
I'm not sure which might_sleep() codepath you are looking at though. At 
a guess it depends on SLUB vs SLAB?

Daniel
