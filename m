From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Thu, 27 Aug 2009 02:58:41 -0400
Message-ID: <yq1ab1l91zy.fsf@sermon.lab.mkp.net>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	<1251267481-24135-6-git-send-email-martin.petersen@oracle.com>
	<4A952D54.5010102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:44332 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZH0G6r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 02:58:47 -0400
In-Reply-To: <4A952D54.5010102@panasas.com> (Boaz Harrosh's message of "Wed,
	26 Aug 2009 15:40:52 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

>> + *lba = (u64)cmd[19] | (u64)cmd[18] << 8 |
>> + (u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
>> + (u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
>> + (u64)cmd[13] << 48 | (u64)cmd[12] << 56;

Boaz> get_unaligned_be64()

As you noticed further down in that patch I do generally use the
get_unaligned_* macros in "my own" code.

However, when I update somebody else's code I try to match the existing
style.  And in this case rest of get_data_transfer_info() is using
explicit shifts and to me it looks absolutely horrendous to mix the two.

I generally avoid mixing cleanups and new functionality.  I don't have a
problem with switching over to the macros, but in that case I think the
whole function should be updated.  And that should be an orthogonal
patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
