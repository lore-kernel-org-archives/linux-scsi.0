From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 12:57:47 -0400
Message-ID: <446A048B.6040703@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1147797507.3505.52.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2006-05-16 at 12:12 -0400, Jeff Garzik wrote:
>> Its an API-which-only-libata-uses that we're discussing.  And because 
>> its moving to the block layer, its also a 
>> temporary-API-which-only-libata-uses.
> 
> OK ... this may be the root of the problem.  I really would like libata
> to migrate to being block only ... especially as PATA looks to be trying
> to follow you into the SCSI subsystem.  However, this has been the
> statement for the past two years (at least), and really, few
> enhancements have been made to block that you need to make good on this.
> I think one of the things we'll try to find time to do at the storage
> summit is to take a hard look at block to see exactly what has to be
> added to make libata solely dependent upon it.

100% agreed...

The general list, off the top of my head:

* objects: storage message, storage device, storage host, and the 
requisite interconnections
* queuecommand-style API
* EH thread(s)
* timers, for command timeouts
* SCSI-style MLqueue and state stuff, i.e. ability to return "device 
busy", "host busy", "retry this command", ...

And once libata is happy at the block layer, move SCSI to using this 
stuff too :)

FWIW, as ATAPI continues to align ever more closely with SCSI MMC, I 
strongly feel that libata should continue to use the "SCSI MMC device 
class driver" (i.e. sr), and other applicable SCSI device class drivers 
(st, ...).

Like modern SAS controllers, which support plugging SATA drives, libata 
must mix SCSI and non-SCSI.  Thus, most of the above infrastructure 
basically _must_ live outside the SCSI layer, if we are going to 
properly support modern controllers in a modular fashion.


> However, the bottom line is that if you want to modify the *SCSI* API
> then you follow the same process as everyone else  (i.e. demonstrate
> justification and utility and worry about long lived maintainability of
> the API).

Well...
* ->eh_strategy_handler() API was unusable before libata (evidence: all 
the bugs we've fixed)
* there were zero users before libata (evidence: grep past 2.4.0)
* there is only one user today, libata (evidence: grep)

So you'll pardon my skepticism when newly elevated standards for this 
API suddenly appear.  libata is just trying to Do What Needs To Be Done, 
And Nothing More.

	Jeff


