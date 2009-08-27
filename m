From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] SCSI: Add support for 32-byte CDBs
Date: Thu, 27 Aug 2009 02:38:20 -0400
Message-ID: <yq1iqg992xv.fsf@sermon.lab.mkp.net>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	<1251267481-24135-2-git-send-email-martin.petersen@oracle.com>
	<4A95279F.5090105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:46046 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZH0Gi1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2009 02:38:27 -0400
In-Reply-To: <4A95279F.5090105@panasas.com> (Boaz Harrosh's message of "Wed,
	26 Aug 2009 15:16:31 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org


>> + if (cmd->cmd_len == SCSI_EXT_CDB_SIZE)
>> + 	mempool_free(cmd->cmnd, cdb_pool);
>> +

Boaz> This will not work. The cmd->cmnd might happen to be form an upper
Boaz> layer through bsg or blk_execute_xxx and might just be
Boaz> SCSI_EXT_CDB_SIZE.

This patch has been kicking around in my tree for a while and it was a
huge, gnarly mess.  I trimmed it down a lot before sending it out
yesterday and forgot why I originally had an allocation flag in
scsi_cmnd.  I think I'll reinstate that just to play it safe.

-- 
Martin K. Petersen	Oracle Linux Engineering
