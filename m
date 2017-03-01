From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 11:39:26 -0800
Message-ID: <20170301113926.250b5df7@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170301104800.00322bd4@xeon-e3>
        <1488394620.2183.20.camel@linux.vnet.ibm.com>
        <1488396022.2183.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36215 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdCATjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 14:39:41 -0500
Received: by mail-pg0-f43.google.com with SMTP id s67so23406308pgb.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 11:39:34 -0800 (PST)
In-Reply-To: <1488396022.2183.26.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Wed, 01 Mar 2017 11:20:22 -0800
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2017-03-01 at 10:57 -0800, James Bottomley wrote:
> > On Wed, 2017-03-01 at 10:48 -0800, Stephen Hemminger wrote:  
> > > On Tue, 28 Feb 2017 22:20:58 -0800
> > > James Bottomley <jejb@linux.vnet.ibm.com> wrote:
> > >   
> > > > On Tue, 2017-02-28 at 17:25 -0800, Stephen Hemminger wrote:  
> > > > > [    1.346023] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0
> > > > > srb
> > > > > status 0x20 length 36
> > > > > [    1.352913] inquiry data: 00000000: 00 aa be f1 5c 98 ff ff
> > > > > f0
> > > > > 64
> > > > > 02 89 ff ff ff ff
> > > > > [    1.356543] inquiry data: 00000010: 00 00 00 00 00 00 00 00
> > > > > 00
> > > > > 00
> > > > > 00 00 00 00 00 00
> > > > > [    1.359996] inquiry data: 00000020: 00 00 00 00
> > > > > [    1.361835] scsi host1: scsi scan: INQUIRY result too short
> > > > > (5),
> > > > > using 36
> > > > > [    1.361888] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0
> > > > > srb
> > > > > status 0x1 length 16
> > > > > [    1.362307] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0
> > > > > srb
> > > > > status 0x1 length 36
> > > > > [    1.362308] inquiry data: 00000000: 00 23 34 f1 5c 98 ff ff
> > > > > f0
> > > > > 64
> > > > > 02 89 ff ff ff ff
> > > > > [    1.362309] inquiry data: 00000010: 00 00 00 00 00 00 00 00
> > > > > 00
> > > > > 00
> > > > > 00 00 00 00 00 00
> > > > > [    1.362309] inquiry data: 00000020: 00 00 00 00
> > > > > [    1.377423] scsi 1:0:0:1: Direct-Access                     
> > > > >   
> > > > >     
> > > > >          PQ: 0 ANSI: 0    
> > > > 
> > > > Well, this pinpoints the fault to the block uncopy, I think.  The
> > > > Inquiry data is clearly correct in the page frame, so it's not
> > > > getting
> > > > copied to the scsi_execute() buffer for some reason.
> > > > 
> > > > James
> > > >   
> > > 
> > > Why do I see different sense data on good (4.10) versus bad (4.11)
> > > 
> > > Good 4.10 initial INQUIRY buffer
> > > [    1.012413] data: 00000000: 00 2e 64 71 db 97 ff ff f0 94 62 96
> > > ff
> > > ff ff ff
> > > [    1.012413] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00
> > > 00
> > > 00 00 00
> > > [    1.012414] data: 00000020: 00 00 00 00
> > > 
> > > Bad 4.11 initial INQUIRY buffer  
> > > [    1.218159] data: 00000000: 00 00 05 02 1f 00 00 02 4d 73 66 74
> > > 20
> > > 20 20 20
> > > [    1.225654] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b
> > > 20
> > > 20 20 20
> > > [    1.242930] data: 00000020: 31 2e 30 20
> > > 
> > > Is the kmap_atomic looking at the right place?  
> > 
> > Actually, the 4.11 data looks good.  You can tell from the string at
> > byte 8.  It's rubbish in the 4.10 one and 'Msft ' in the 4.11 one (I
> > assume you just reversed the cut and paste).
> > 
> > These should be the page physical addresses you sent down to the
> > hypervisor, so kmap should work.  Perhaps print out the physical page
> > address so we see what we're getting.  
> 
> Another possible explanation is non zero sg->offset, in which case you
> might not see the INQUIRY data because you start at the beginning of
> the page.  This shouldn't happen because you specify no alignment
> override in the driver, so we should start the INQUIRY buffer on a new
> page and copy the data back to the real buffer, but perhaps that's what
> changed.

Dumping more data from 4.9, 4.10 and 4.11
