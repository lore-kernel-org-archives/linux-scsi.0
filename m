From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: SCSI regression in 4.11
Date: Wed, 01 Mar 2017 10:57:00 -0800
Message-ID: <1488394620.2183.20.camel@linux.vnet.ibm.com>
References: <20170227152955.1362aabb@xeon-e3>
         <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
         <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
         <1488301573.3046.9.camel@linux.vnet.ibm.com>
         <20170228105741.6253bb8a@xeon-e3>
         <1488325732.11610.9.camel@linux.vnet.ibm.com>
         <20170228172532.280811ed@xeon-e3>
         <1488349258.20321.11.camel@linux.vnet.ibm.com>
         <20170301104800.00322bd4@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753190AbdCAS5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 13:57:21 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v21InOeB083502
        for <linux-scsi@vger.kernel.org>; Wed, 1 Mar 2017 13:57:10 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28wxrb914k-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 13:57:09 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 1 Mar 2017 11:57:09 -0700
In-Reply-To: <20170301104800.00322bd4@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Wed, 2017-03-01 at 10:48 -0800, Stephen Hemminger wrote:
> On Tue, 28 Feb 2017 22:20:58 -0800
> James Bottomley <jejb@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 2017-02-28 at 17:25 -0800, Stephen Hemminger wrote:
> > > [    1.346023] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0
> > > srb
> > > status 0x20 length 36
> > > [    1.352913] inquiry data: 00000000: 00 aa be f1 5c 98 ff ff f0
> > > 64
> > > 02 89 ff ff ff ff
> > > [    1.356543] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00
> > > 00
> > > 00 00 00 00 00 00
> > > [    1.359996] inquiry data: 00000020: 00 00 00 00
> > > [    1.361835] scsi host1: scsi scan: INQUIRY result too short
> > > (5),
> > > using 36
> > > [    1.361888] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0
> > > srb
> > > status 0x1 length 16
> > > [    1.362307] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0
> > > srb
> > > status 0x1 length 36
> > > [    1.362308] inquiry data: 00000000: 00 23 34 f1 5c 98 ff ff f0
> > > 64
> > > 02 89 ff ff ff ff
> > > [    1.362309] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00
> > > 00
> > > 00 00 00 00 00 00
> > > [    1.362309] inquiry data: 00000020: 00 00 00 00
> > > [    1.377423] scsi 1:0:0:1: Direct-Access                       
> > >     
> > >          PQ: 0 ANSI: 0  
> > 
> > Well, this pinpoints the fault to the block uncopy, I think.  The
> > Inquiry data is clearly correct in the page frame, so it's not
> > getting
> > copied to the scsi_execute() buffer for some reason.
> > 
> > James
> > 
> 
> Why do I see different sense data on good (4.10) versus bad (4.11)
> 
> Good 4.10 initial INQUIRY buffer
> [    1.012413] data: 00000000: 00 2e 64 71 db 97 ff ff f0 94 62 96 ff
> ff ff ff
> [    1.012413] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00
> [    1.012414] data: 00000020: 00 00 00 00
> 
> Bad 4.11 initial INQUIRY buffer  
> [    1.218159] data: 00000000: 00 00 05 02 1f 00 00 02 4d 73 66 74 20
> 20 20 20
> [    1.225654] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20
> 20 20 20
> [    1.242930] data: 00000020: 31 2e 30 20
> 
> Is the kmap_atomic looking at the right place?

Actually, the 4.11 data looks good.  You can tell from the string at
byte 8.  It's rubbish in the 4.10 one and 'Msft ' in the 4.11 one (I
assume you just reversed the cut and paste).

These should be the page physical addresses you sent down to the
hypervisor, so kmap should work.  Perhaps print out the physical page
address so we see what we're getting.

James
