From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Fri, 12 Sep 2014 14:09:50 -0400
Message-ID: <yq17g184snl.fsf@sermon.lab.mkp.net>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
	<1409254292-2540-15-git-send-email-martin.petersen@oracle.com>
	<540390FF.2040703@dev.mellanox.co.il>
	<yq1bnqn9fzg.fsf@sermon.lab.mkp.net>
	<54114AA3.2090806@dev.mellanox.co.il>
	<yq1k3594o4p.fsf@sermon.lab.mkp.net>
	<5412F313.4030005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24417 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaILSKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2014 14:10:04 -0400
In-Reply-To: <5412F313.4030005@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Fri, 12 Sep 2014 16:20:19 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, axboe@fb.com, hch@lst.de, sagig@mellanox.com

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

Sagi,

Sagi> I see, It's just confusing to see flags such as
Sagi> REF_INCREMENT/GUARD_CHECK/REF_CHECK associated with a set of prot
Sagi> operations, but I guess it's just me.  Do you really need the mask
Sagi> anyway? seems like just an extra precaution against wrong
Sagi> flagging.

I did it this way to avoid having several additional special cases in
the hot path. Instead I apply a mask at the end to filter out any flags
that would be invalid for that particular protection operation. It
simplified the protection prep code significantly.

I was also afraid of drivers blindly using the flags to fill out IOCB
fields. I was guilty of that myself in the ones I converted and it
tripped firmware errors in several cases during qualification runs. So I
decided to be on the defensive side about the flags I send down to the
LLD. I'd also rather have that filtering encapsulated in single location
instead of every driver having to figure out whether it's being
presented with a valid combination of flags or not.

Sagi> Nice, I posted "RDMA signature feature update" preparing iSER DIF
Sagi> code to complement this change - all that is left now is a
Sagi> straight-forward conversion.

Great!

-- 
Martin K. Petersen	Oracle Linux Engineering
