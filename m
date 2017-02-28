From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 09:06:13 -0800
Message-ID: <1488301573.3046.9.camel@linux.vnet.ibm.com>
References: <20170227152955.1362aabb@xeon-e3>
         <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
         <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35467 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751135AbdB1RHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 12:07:17 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1SH4ALD008138
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 12:06:22 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28wc4rkj24-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 12:06:22 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 28 Feb 2017 10:06:21 -0700
In-Reply-To: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Stephen Hemminger <stephen@networkplumber.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On Tue, 2017-02-28 at 08:32 -0700, Jens Axboe wrote:
> On 02/28/2017 07:08 AM, Christoph Hellwig wrote:
> > On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:
> > > Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each
> > > I/O")
> > > 
> > > but that is already in linux-next.
> > > 
> > > Noticed another place where memset(of the data was being done not
> > > the extra bits.
> > > Tried this, but didn't fix it either...
> > 
> > Are you using blk-mq or the legacy request code?
> 
> Stephen doesn't have MQ set in the config he posted, I'm assuming he 
> didn't boot with scsi_mod.use_blk_mq=true. In a previous email, I 
> asked if turning on MQ makes a difference.

OK, since we're not making much progress, Stephen, could you insert
some debugging into the storvsc driver?  The trace clearly shows we're
getting zeros back in the buffer when we should have data from the
initial scan.  Firstly, does the vmbus think it's transferring any data
for the INQUIRY and READ_CAPACITY commands (looks like
storvsc_command_completion() data_transfer_length)?  If it does,
there's probably an issue initialising the sg list.  If it doesn't,
we're probably sending bogus commands.

James
