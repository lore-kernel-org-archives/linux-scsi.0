From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Sun, 24 Oct 2004 18:11:12 -0500
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <200410242311.i9ONBCKp019869@falcon10.austin.ibm.com>
References: <20041024100319.GA17183@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <20041024100319.GA17183@lst.de> 
To: Christoph Hellwig <hch@lst.de>
Cc: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 24 Oct 2004 12:03:19 +0200, Christoph Hellwig wrote:
>On Sat, Oct 23, 2004 at 07:55:36PM -0500, Doug Maxey wrote:
>> 
>> Name: inline ide_fix_driveid()
>> 
>> Rationale:
>> 	This is a fix for bugme.osdl 3819.
>
>bugme.osdl.org doesn't know of a bug #3819.

Uh Oh.  Should be 3618.  Have no idea where 3819 came from.

>
>> 	With any of the 2.6.9 release flavors (vanilla, mm1, ac3), one
>> 	cannot build the usb isd200 module due to the dependency on
>> 	ide_fix_driveid() being exported from ide-iops.
>> 
>> Description:
>> 	When building IDE modular, the current ide_fix_driveid() is
>> 	exported from ide-iops.c.  This patch makes the function an inline.
>
>Still doesn't make any sense. ide_fix_driveid is properly exported from
>ide-iops.c, so you use it from other modules.  The only case that
>doesn't work is modular ide and builtin usb-storage, and the BLK_DEV_IDE 
>depency should fix that one.
>
>If you think that depency is ugly (I do) just copy the routine to

What happened to common code that may have more uses than originally 
intended?  Do it right once in one place, and make it available.

>isd200.c, it's a) too large to inline but b) just a trivial byteswap
>that should need much changes over time.

Except for those few 32 and 64 bit quantities that need word (16 bit) swaps,
I agree completely.  

The points I was trying to make were that  
1) This is called in only a few places.
2) it is never on a fast path.
2) The sequence of the named elements was a little bit much.  Meaning of 
   the words change, and quite a few of the fields no longer have the 
   original meaning or definition.
3) Having a singular (even if somewhat large) inline handles all current (and 
   future) uses.

++doug

