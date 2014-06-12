From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 10/14] block: Integrity checksum flag
Date: Wed, 11 Jun 2014 22:03:17 -0400
Message-ID: <yq18up2rije.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-11-git-send-email-martin.petersen@oracle.com>
	<20140611165228.GE9511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18587 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaFLCDt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 22:03:49 -0400
In-Reply-To: <20140611165228.GE9511@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:52:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> Make the choice of checksum a per-I/O property by introducing a flag
>> that can be inspected by the SCSI layer.

Christoph> Why?

First of all it's desirable to be able to use both IP and CRC checksums
without having to unload the HBA driver.

Also, there are some corner cases where you have to force the use of CRC
guard tag even when the HBA supports IP checksums. If you are doing
recovery and need to read a disk block with bad PI, for instance, you
must be able to tell the HBA to pass the CRC through verbatim instead of
attempting to convert it to IP checksum.

Another example is qualification tooling that needs to be able to write
a block with bad PI out to storage. In that case we also have to tell
the HBA to ignore checking the PI and that it shouldn't attempt a
checksum conversion.

-- 
Martin K. Petersen	Oracle Linux Engineering
