From: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Subject: Magical ansi scsi revision (was Re: [linux-usb-devel] Re: What is
 SCSI command 0xa0 ?)
Date: Thu, 17 Feb 2005 22:18:03 +0100
Message-ID: <20050217221803.091fd840@hebus>
References: <20050214230645.22eb3b3c@hebus>
	<Pine.LNX.4.44L0.0502161133350.6418-100000@ida.rowland.org>
	<20050217165940.23cd9521@hebus>
Reply-To: Samuel Colin <Samuel.Colin3@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from smtp6.wanadoo.fr ([193.252.22.25]:40672 "EHLO smtp6.wanadoo.fr")
	by vger.kernel.org with ESMTP id S261165AbVBQVSB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 16:18:01 -0500
In-Reply-To: <20050217165940.23cd9521@hebus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Samuel Colin <Samuel.Colin3@wanadoo.fr>

The Thu, 17 Feb 2005 16:59:40 +0100
Samuel Colin <Samuel.Colin3@wanadoo.fr> wrote:

> > I don't know why.  Do you want to turn on usb-storage verbose debugging
> > in the 2.6.8 kernel, and run it on that other machine?
> > [...]
> > It's hard to say, since there are so many things being changed all the
> > time.  But if the REPORT_LUNS command worked under 2.6.8 and failed
> > under 2.6.11, it would be worthwhile to know why.
> > 
> OK, I will do and send the debug logs asap.
> 
> linux-usb-devel and linux-scsi (as they might be interested in the test
> results for the 2.6.8 kernel) in Cc:
> 
OK, I put the logs here : 
http://sjdcolin.free.fr/tmp/scsi-problem.tgz
Actually the different logs are inclusive (I did not erase the previous log
informations :-/ ). I made the test with 2.6.8-test (thus the 2.6.8 with
debugging on) and 2.6.10-test. These kernels are Debian ones, but I don't
think there are patches that would parasite the results. 
The results surprised me, thus I did a test with 2.6.8 on the openbrick, and
actually lacie1 (the disk that caused problems). Thus I guess that my
machine hanged back then because both disks were usb and debugging was
turned on. Hence, any "big" test (a big copy) could cause problems related
to overloading of the disk where the root mount point was located.

Anyway, I have interesting results for the scsi devel list : 


Feb 17 21:19:09 gnondpom kernel: scsi0 : SCSI emulation for USB Mass Storage
devices 
Feb 17 21:19:09 gnondpom kernel:   Vendor: WDC WD25  Model:
00JB-00FUA0       Rev: 15.0 
Feb 17 21:19:09 gnondpom kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 02


Feb 17 21:26:10 gnondpom kernel: scsi0 : SCSI emulation for USB Mass Storage
devices 
Feb 17 21:26:15 gnondpom kernel:   Vendor: WDC WD25  Model:
00JB-00FUA0       Rev: 15.0 
Feb 17 21:26:15 gnondpom kernel:   Type:  
Direct-Access                      ANSI SCSI revision: 04

It means that for a 2.6.8 kernel, the revision is 02 (then no report_luns
causing problems), while for a 2.6.10, the revision is 04. As I don't think
the firmware of the disk upgrades itself magically depending on the running
kernel, does anyone have an idea why the numbers reported are different ?

I only put scsi-dev in Cc:, as nothing is really of concern for the
usb-devel list (I guess).

Regards,
Samuel Colin

