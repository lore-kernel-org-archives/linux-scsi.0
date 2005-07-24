From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 4929] New: problem with aic7xxx driver on
	2.6.x
Date: Sun, 24 Jul 2005 08:50:31 -0400
Message-ID: <1122209431.5128.9.camel@mulgrave>
References: <20050723100522.3c308cfe.akpm@osdl.org>
	 <20050723185104.GA7934@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29153 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261214AbVGXMur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2005 08:50:47 -0400
In-Reply-To: <20050723185104.GA7934@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mbligh@aracnet.com

On Sat, 2005-07-23 at 19:51 +0100, Christoph Hellwig wrote:
> This message is totally useless.  If you want to forward bugzilla reports
> please include all relevant information.

OK, let me try.

The format I'd like is for the text of the bug report to go over the
list with a cc to the bugzilla so that it captures any email
conversation about it.  Martin has already set this up, I just can't
figure out what the bugzilla email address is for this report.

Anyway, this is what looks to be the issue in the trace

>  target2:0:1: Ending Domain Validation
> SCSI device sdc: 2788016128 512-byte hdwr sectors (1427464 MB)
> (scsi2:A:1:0): Handled Residual of 4 bytes
> SCSI device sdc: drive cache: write back
> SCSI device sdc: 2788016128 512-byte hdwr sectors (1427464 MB)
> (scsi2:A:1:0): Handled Residual of 4 bytes
> SCSI device sdc: drive cache: write back
>  sdc: sdc1 sdc2 sdc3 sdc4
> Attached scsi disk sdc at scsi2, channel 0, id 1, lun 0
> (scsi2:A:1:0): Handled Residual of 3960 bytes
> scsi: host 2 channel 0 id 1 lun 0x00000200080c0400 has a LUN larger than
> currently supported.
> scsi: host 2 channel 0 id 1 lun 0xff010000ffffffff has a LUN larger than
> currently supported.
> scsi: host 2 channel 0 id 1 lun 0x0002202020202020 has a LUN larger than
> currently supported.
> scsi: host 2 channel 0 id 1 lun808529923 has a LUN larger than allowed by the
> host adapter
> (scsi2:A:1:4): Handled Residual of 4 bytes
> (scsi2:A:1:5): Handled Residual of 4 bytes
> scsi: host 2 channel 0 id 1 lun3078 has a LUN larger than allowed by the host
> adapter

So I think it's not an aic7xxx error (it seems the new DV actually works
whereas the old DV failed).  It seems to be a bug in REPORT LUNS.
Either in the device or in the kernel code.

The curious thing is why after the report luns failure, we apparently
jump to sequential LUN scanning, but choose to begin at LUN 4.

I think as a work around, a simple

echo scsi add-single-device 2 0 1 1 > /proc/scsi/scsi

should bring the missing LUN back again

James


