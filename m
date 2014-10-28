From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Tue, 28 Oct 2014 18:44:01 +0100
Message-ID: <544FD5E1.8030603@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de> <1414153627-2863-28-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B4029593375F6@G9W0745.americas.hpqcorp.net> <20141028173328.GA10966@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060800010103050306000908"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaJ1Ro0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2014 13:44:26 -0400
In-Reply-To: <20141028173328.GA10966@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060800010103050306000908
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 10/28/2014 06:33 PM, Christoph Hellwig wrote:
> On Fri, Oct 24, 2014 at 09:00:15PM +0000, Elliott, Robert (Server Storage) wrote:
>> With MLQUEUE level 0 and MLCOMPLETE level 0, v8 runs those prints, 
>> and they work as expected:
>> * the value in the ratelimit message matches the block layer (82)
>> * the number of print_result/print_sense/print_command matches 
>>   the number of block layer prints (10)
>> * the SCSI prints end up interleaved, but that's for the next 
>>   patch series to fix
>>
>> Assuming the MLQUEUE -> MLCOMPLETE fix is put back in,
>> you may add:
>> Tested-by: Robert Elliott <elliott@hp.com>
>> Reviewed-by: Robert Elliott <elliott@hp.com> 
> 
> Hannes, can you send me a quick incremental fix for this issue?
> 
Of course.

Here it is.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------060800010103050306000908
Content-Type: text/x-patch;
 name="0001-scsi-fixup-SCSI_LOG_MLCOMPLETE-instead-of-SCSI_LOG_M.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi-fixup-SCSI_LOG_MLCOMPLETE-instead-of-SCSI_LOG_M.pa";
 filename*1="tch"

>From 7da8db4d39ae71b065e0167339a6e4107f1243b8 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 28 Oct 2014 18:42:15 +0100
Subject: [PATCH] scsi: fixup SCSI_LOG_MLCOMPLETE instead of SCSI_LOG_MLQUEUE

Robert Elliott pointed out that we need to use SCSI_LOG_MLCOMPLETE
in scsi_io_completion() instead of SCSI_LOG_MLQUEUE.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4572991..7711dbd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1045,8 +1045,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 					DEFAULT_RATELIMIT_BURST);
 
 			if (unlikely(scsi_logging_level))
-				level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
-						       SCSI_LOG_MLQUEUE_BITS);
+				level = SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
+						       SCSI_LOG_MLCOMPLETE_BITS);
 
 			/*
 			 * if logging is enabled the failure will be printed
-- 
1.8.4.5


--------------060800010103050306000908--
