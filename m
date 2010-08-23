From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/6] libata: Report supported TRIM payload size
Date: Mon, 23 Aug 2010 14:56:54 -0400
Message-ID: <yq1d3t9tax5.fsf@sermon.lab.mkp.net>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-3-git-send-email-martin.petersen@oracle.com>
	<20100823135024.GA22554@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:39274 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab0HWS5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 14:57:15 -0400
In-Reply-To: <20100823135024.GA22554@lst.de> (Christoph Hellwig's message of
	"Mon, 23 Aug 2010 15:50:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> On Thu, Aug 19, 2010 at 11:48:57AM -0400, Martin K. Petersen wrote:
>> ATA IDENTIFY DEVICE word 105 contains the number of 512-byte blocks
>> of TRIM payload information the device can accept in one command.
>> Use this value to enable payloads > 512 bytes.

Christoph> Currently ata_scsi_write_same_xlat passes uses a constant 512
Christoph> for the payload all over the place, so the larger payloads
Christoph> won't actually work yet.

Christoph> I don't think advertising a larger size than we actually
Christoph> support is a good idea.

I was on crack when I included this in the series last week.  It came
from my discard coalescing tree where things are quite different.

In any case we're also limited by the range of WRITE SAME as long as
we're relying on SAT.  So under all circumstances we're dead in the
water with a payload > 1KB.

Let's just drop this one for now.

-- 
Martin K. Petersen	Oracle Linux Engineering
