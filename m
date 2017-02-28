From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 11:10:31 -0800
Message-ID: <1488309031.3046.29.camel@linux.vnet.ibm.com>
References: <20170227152955.1362aabb@xeon-e3>
         <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
         <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
         <1488301573.3046.9.camel@linux.vnet.ibm.com>
         <20170228104135.50f62736@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44425 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751186AbdCACar (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 21:30:47 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1SIwoCx043179
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 14:10:42 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28wdxxkpp1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 14:10:42 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 28 Feb 2017 12:10:41 -0700
In-Reply-To: <20170228104135.50f62736@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On Tue, 2017-02-28 at 10:41 -0800, Stephen Hemminger wrote:
> [    1.652279] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb
> status 0x20 length 36
> [    1.652297] scsi host1: scsi scan: INQUIRY result too short (5),
> using 36

This is definitive.  We sent the Inquiry command, we got 36 bytes of
payload from hyperv (correct size), but when we tried to get the length
from the data buffer of the command, we found zeros where it should
have been (the length is the byte at offset 4 plus 5).  Wherever the
inquiry data went it wasn't into the command buffer ... it's like we
have some type of sg list setup error, but I can't find it.

James
