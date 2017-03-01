From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 22:48:45 -0800
Message-ID: <20170228224845.1da358ee@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34462 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdCAGuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 01:50:13 -0500
Received: by mail-pf0-f174.google.com with SMTP id b5so1012399pfa.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 22:48:53 -0800 (PST)
In-Reply-To: <1488349258.20321.11.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Tue, 28 Feb 2017 22:20:58 -0800
James Bottomley <jejb@linux.vnet.ibm.com> wrote:

> On Tue, 2017-02-28 at 17:25 -0800, Stephen Hemminger wrote:
> > [    1.346023] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb
> > status 0x20 length 36
> > [    1.352913] inquiry data: 00000000: 00 aa be f1 5c 98 ff ff f0 64
> > 02 89 ff ff ff ff
> > [    1.356543] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [    1.359996] inquiry data: 00000020: 00 00 00 00
> > [    1.361835] scsi host1: scsi scan: INQUIRY result too short (5),
> > using 36
> > [    1.361888] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb
> > status 0x1 length 16
> > [    1.362307] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb
> > status 0x1 length 36
> > [    1.362308] inquiry data: 00000000: 00 23 34 f1 5c 98 ff ff f0 64
> > 02 89 ff ff ff ff
> > [    1.362309] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [    1.362309] inquiry data: 00000020: 00 00 00 00
> > [    1.377423] scsi 1:0:0:1: Direct-Access                           
> >          PQ: 0 ANSI: 0  
> 
> Well, this pinpoints the fault to the block uncopy, I think.  The
> Inquiry data is clearly correct in the page frame, so it's not getting
> copied to the scsi_execute() buffer for some reason.
> 
> James
> 

Let me know, I can run another test and dump more data.
