From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 22:20:58 -0800
Message-ID: <1488349258.20321.11.camel@linux.vnet.ibm.com>
References: <20170227152955.1362aabb@xeon-e3>
         <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
         <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
         <1488301573.3046.9.camel@linux.vnet.ibm.com>
         <20170228105741.6253bb8a@xeon-e3>
         <1488325732.11610.9.camel@linux.vnet.ibm.com>
         <20170228172532.280811ed@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57935 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750703AbdCAGYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 01:24:06 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v216JBdp144709
        for <linux-scsi@vger.kernel.org>; Wed, 1 Mar 2017 01:24:05 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28wrw7rk7g-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 01:24:05 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 28 Feb 2017 23:21:06 -0700
In-Reply-To: <20170228172532.280811ed@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Tue, 2017-02-28 at 17:25 -0800, Stephen Hemminger wrote:
> [    1.346023] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb
> status 0x20 length 36
> [    1.352913] inquiry data: 00000000: 00 aa be f1 5c 98 ff ff f0 64
> 02 89 ff ff ff ff
> [    1.356543] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    1.359996] inquiry data: 00000020: 00 00 00 00
> [    1.361835] scsi host1: scsi scan: INQUIRY result too short (5),
> using 36
> [    1.361888] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb
> status 0x1 length 16
> [    1.362307] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb
> status 0x1 length 36
> [    1.362308] inquiry data: 00000000: 00 23 34 f1 5c 98 ff ff f0 64
> 02 89 ff ff ff ff
> [    1.362309] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    1.362309] inquiry data: 00000020: 00 00 00 00
> [    1.377423] scsi 1:0:0:1: Direct-Access                           
>          PQ: 0 ANSI: 0

Well, this pinpoints the fault to the block uncopy, I think.  The
Inquiry data is clearly correct in the page frame, so it's not getting
copied to the scsi_execute() buffer for some reason.

James
