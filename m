From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
Date: Sun, 12 Jan 2014 07:43:38 -0500
Message-ID: <yq138ktpdz9.fsf@sermon.lab.mkp.net>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	<1389212157-14540-10-git-send-email-nab@daterainc.com>
	<yq161prr1p8.fsf@sermon.lab.mkp.net>
	<52D28807.2000004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34500 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaALMnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 07:43:55 -0500
In-Reply-To: <52D28807.2000004@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Sun, 12 Jan 2014 14:18:15 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

>> The IP checksum is only supported by DIX between OS and initiator,
>> not by the target. I guess we could signal to the initiator via a
>> vendor-private VPD that IP checksum is supported directly. But now
>> what we have hardware-accelerated T10 CRC I don't think it's a big
>> deal.

Sagi> shouldn't it stick around if it is not deprecated yet, the
Sagi> transport is required to support ip-csum->CRC conversion anyhow.

SBC mandates that the guard tag on the wire and on the target device be
the T10 CRC. The IP checksum is a DIX-optimization for application-HBA
exchanges. The only place you should support the IP checksum is in the
initiator.

Note that you could conceivably do a T10 CRC to IP checksum conversion
on writes received by the target and store the IP checksum on disk. And
then convert back to T10 CRC when the data is eventually read. But it
makes no sense to do that given that you will have to do the T10 CRC
calculation regardless. Even if the backing store is DIX-capable and
supports the IP checksum.

-- 
Martin K. Petersen	Oracle Linux Engineering
