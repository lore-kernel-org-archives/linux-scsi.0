From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 15:06:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A4046.6040007@pobox.com>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patlinux.iomegacorp.com> <20040823154648.GB2301@suse.de> <412A15EC.8040903@pobox.com> <412A3BE5.4090203@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:18652 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267433AbUHWTHA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 15:07:00 -0400
In-Reply-To: <412A3BE5.4090203@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jens Axboe <axboe@suse.de>, Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
>> I would like to see support for CDBs larger than 16 bytes in struct 
>> request.
>>
>> Problem:  Would like to support SCSI's variable length CDBs, and support
>>   non-{ATA,SCSI} RAID CDBs which are often larger than 16 bytes, such as
>> Promise's SX8 (formerly known as carmel).
>>
>> Suggested solution:  Probably this involves adding a flag and a pointer,
>> rather than increasing the actual CDB buffer size in struct request.
> 
> 
> Not sure that you need a flag.
> Op. code 0x7F implies (cdb->acdb != 0 && cdb[7] > 0), else bug.


At the struct request level a flag is needed.  A "CDB" may be a SCSI 
CDB, an ATA taskfile, an I2O command, etc.  The block layer must treat 
any cdb buffer as an anonymous blob that gets passed through to a lower 
layer.

	Jeff


