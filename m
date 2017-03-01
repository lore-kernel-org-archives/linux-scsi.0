From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 07:54:12 -0800
Message-ID: <20170301075412.2e5f1e98@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:33099 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752198AbdCAPyZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 10:54:25 -0500
Received: by mail-pg0-f43.google.com with SMTP id 25so21654121pgy.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 07:54:19 -0800 (PST)
In-Reply-To: <20170301155057.GA13167@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Wed, 1 Mar 2017 16:50:57 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Feb 28, 2017 at 10:48:45PM -0800, Stephen Hemminger wrote:
> > Let me know, I can run another test and dump more data.  
> 
> Could it be that we keep the old sense buffer values around because
> my commit change the way how sense buffers are handled.  A while ago
> I suggested this patch to fix it, so maybe you can try it:
> 
> 	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4

It appears that is already in the code I am testing in linux-next...

bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
			  struct scsi_sense_hdr *sshdr)
{
	memset(sshdr, 0, sizeof(struct scsi_sense_hdr));

	if (!sense_buffer || !sb_len)
		return false;

	sshdr->response_code = (sense_buffer[0] & 0x7f);

	if (!scsi_sense_valid(sshdr))
