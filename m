From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] Make scsi_transfer_length take a scsi_data_buffer argument
Date: Wed, 06 Aug 2014 11:49:47 -0400
Message-ID: <yq161i5d3dw.fsf@sermon.lab.mkp.net>
References: <20140713113715.GA26031@infradead.org>
	<1406318419-7273-1-git-send-email-martin.petersen@oracle.com>
	<53E21BA7.5000703@dev.mellanox.co.il>
	<53E228FA.6060901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34990 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaHFPuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 11:50:19 -0400
In-Reply-To: <53E228FA.6060901@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Wed, 06 Aug 2014 16:09:14 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@infradead.org>

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi> On second thought, since the transfer length is always the command
Sagi> scsi data buffer length, why not keep it as is and if at any point
Sagi> in the future DIF will co-exist with bidi, we can add
Sagi> scsi_bidi_transfer_length which will calculate the bidi in length.

Sagi> In this case, an iSCSI bidi transaction will do:

Sagi>	hdr-> data_length = scsi_transfer_legnth(sg);
Sagi>	rlen_ahdr-> read_length = scsi_bidi_transfer_length(sc);

I agree that the distinction between in and out buffers is unnecessary
and a bit of a burden. Unless it's a bidi command there is only one
buffer. I don't think there's an inherent win in having multiple names
for it depending on I/O direction.

-- 
Martin K. Petersen	Oracle Linux Engineering
