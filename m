From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 02/15] target: Add protected fabric + unprotected device support
Date: Thu, 09 Apr 2015 17:45:14 -0400
Message-ID: <yq18ue1f02d.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-3-git-send-email-nab@daterainc.com>
	<yq1sicbh63q.fsf@sermon.lab.mkp.net>
	<1428478828.18203.109.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42271 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbbDIVpb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 17:45:31 -0400
In-Reply-To: <1428478828.18203.109.camel@haakon3.risingtidesystems.com>
	(Nicholas A. Bellinger's message of "Wed, 08 Apr 2015 00:40:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>

>>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:

>> How do you handle RDPROTECT/WRPROTECT values of 3 if the PI is not
>> persistent?

nab> AFAICT, this would result in cmd->prot_op = TARGET_PROT_*_PASS and
cmd-> prot_checks = 0 for RDPROTECT/WRPROTECT == 0x3 in
nab> sbc_set_prot_op_checks() code.

nab> Do DOUT_STRIP + DIN_INSERT need to be called if a protection buffer
nab> is present when RDPROTECT/WRPROTECT == 0x3 if fabric_prot was
nab> cleared..?  Or should the command be rejected when a protection
nab> buffer is present + RDPROTECT/WRPROTECT is non-zero if fabric_prot
nab> was cleared..?

Depends how compliant you want to be.

You can synthesize PI with RDPROTECT/WRPROTECT=1 as long as the
initiator doesn't rely on app tag escapes (we don't). Most non-HDD/SSD
targets work this way.

I would suggest that you return invalid field in CDB for
RDPROTECT/WRPROTECT=3 unless the PI can be made persistent, however.

-- 
Martin K. Petersen	Oracle Linux Engineering
