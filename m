From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 15:08:15 -0400
Message-ID: <433D8D1F.1030005@adaptec.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965072AbVI3TIU@vger.kernel.org>
In-Reply-To: <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, jgarzik@pobox.com, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On 09/30/05 14:50, Kyle Moffett wrote:
> On Sep 30, 2005, at 14:34:42, Luben Tuikov wrote:
> 
>>This is how we have the SPI-centric EH methods in the scsi host  
>>template right now:
>>    int (* eh_abort_handler)(struct scsi_cmnd *);
>>    int (* eh_device_reset_handler)(struct scsi_cmnd *);
>>    int (* eh_bus_reset_handler)(struct scsi_cmnd *);
>>    int (* eh_host_reset_handler)(struct scsi_cmnd *);
> 
> 
> So submit patches to fix it!  You clearly understand what is wrong,  
> so why not help change it?

Because
  - I do not want to give heart attack to all existing LLDDs
  - Some LLDD would never be able to be changed
  - Some LLDD work on very _scarce_ hardware which we cannot test.
  - plus such radical changes are neither warranted nor necessary.

It is better to keep legacy around, until all you'll have on
your new serverboard is a SAS/SATA storage chip such as
AIC-94xx or say BCM8603.  Then you can compile out most
of the legacy stuff.

>>But we should _not_ break legacy drivers and backward support,
> 
> WRONG.  This is not the way Linux works.  We break internal APIs all  
> the time.  If you need to change one _thats_OK_.  Userspace ABI is  

Well, I can never have it right.  Some people say you shouldn't break
it, others say let's break the whole thing and give heart attack
to all LLDDs, other say it is impossible to change all LLDD since
the hardware is not around, etc, etc.

I think not breaking anything (for now at least) would be the
_easiest_ and most painless way to transition.

>>The way we do this is we slowly, without disruption to older  
>>drivers introduce, in parallel, emerge a new, simpler, slimmer,  
>>faster SCSI Core, whereby we accommodate new infrastructures, yet,  
>>have 100% backward compatibility, via the current older SCSI Core.   
>>After all, both would be a bunch of functions in a bunch of files.
> 
> 
> Except this introduces bloat and multiplies maintainer load.  Fix the  
> existing one.  If it breaks other in-core drivers, fix those to  

Well, not necessarily.  It would be more painful and more maintainer
load if we did what you suggest.  The overhead would be enormous.

>>Section 4: Politics
>>-------------------
> 
> 
> s/Politics.*//g;  I hate politics.  Keep it off this list.

Me too, but we are idealists.  Politics is an integral part of
life.

Long time ago, in a galaxy far, far away...
I literally sat in a meeting whereby technical staff of _several_
companies agreed that Pi=3.0.

	Luben
