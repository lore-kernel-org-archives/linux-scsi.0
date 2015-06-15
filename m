From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] [RFC] block: Add blk_max_rw_sectors attribute
Date: Sun, 14 Jun 2015 20:28:32 -0400
Message-ID: <yq1oakhhl1r.fsf@sermon.lab.mkp.net>
References: <201506121612.t5CGCiTa004134@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26843 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbFOA3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2015 20:29:17 -0400
In-Reply-To: <201506121612.t5CGCiTa004134@d01av05.pok.ibm.com> (Brian King's
	message of "Fri, 12 Jun 2015 11:12:42 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, axboe@kernel.dk

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian,

Brian> As defined in the transfer limit table in the block limits VPD
Brian> page section of SBC4, this value is only supposed to apply to a
Brian> small subset of SCSI opcodes. However, we are using that value
Brian> for all SCSI commands.

Well, I guess the real issue here is that we use the same constraint for
FS and BLOCK_PC commands. It's not really the kernel's business to
enforce target device preferences on sg/bsg callers.

The main headache here is that max_sectors_kb in sysfs is widely used by
users that want to tweak their read/write I/O size. So we can't really
change the meaning of that knob, nor do I think it's necessarily a good
idea to introduce a max_rw_sectors_kb (which I agree would have been a
better name for the sysfs knob in the first place).

So I think my preference would be to have an internal max_rw_sectors
queue limit that sd can set based on the VPD. And use that as the limit
for REQ_TYPE_FS requests. I.e. max_sectors and max_sectors_kb need to be
constrained by min_not_zero(max_rw_sectors, max_hw_sectors).

max_hw_sectors would then only indicate the HBA hardware request size
limit which is what BLOCK_PC callers should be constrained by
exclusively.

That way you don't get into having to parse the CDB and other evils.

-- 
Martin K. Petersen	Oracle Linux Engineering
