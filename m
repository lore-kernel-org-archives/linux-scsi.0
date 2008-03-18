From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Tue, 18 Mar 2008 19:19:05 +0200
Message-ID: <47DFF989.80903@panasas.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com> <47DFE9E4.6070301@sgi.com> <47DFEBBD.7080702@panasas.com> <47DFF369.90805@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8491 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753525AbYCSTxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:53:47 -0400
In-Reply-To: <47DFF369.90805@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 18 2008 at 18:52 +0200, Michael Reed <mdr@sgi.com> wrote:
> 
> Boaz Harrosh wrote:
>> On Tue, Mar 18 2008 at 18:12 +0200, Michael Reed <mdr@sgi.com> wrote:
>>> Michael Reed wrote:
>>>> Boaz Harrosh wrote:
>>>> <snip>
>>>>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>>>>> untested.
>>>>>> I can try this out and see what happens.
>>>>>>
>>>>>>
>>>>> Will not compile here is a cleaner one
>>>> Still in my queue.  Hopefully I'll get to poke at this today.
>>> Patch compiles cleanly and appears to have no effect on the misc.
>>> sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.
>>>
>>> Mike
>>>
>>>> Mike
>>>>
>> <patch sniped>
>>
>> If you remove the original fix to sg.c
>> ([PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device causes infinite loop in 2.6.24)
>>
>> and apply this patch, does it solve your original infinite loop?
> 
> Unfortunately, the infinite loop only occurred at 2.6.24.  I'll see if
> I can break the current rc by removing some known fixes.
> 
> Care to gen a patch for 2.6.24?
> 
> Mike
> 
>> Thanks
>> Boaz
>>

here is the same principle on Linux 2.6.24
---
[PATCH] scsi: Always complete BLOCK_PC commands

Current code, in some IO combinations could wrongly retry
a BLOCK_PC command in chunks. This was never intended.
Fix it that BLOCK_PC will always complete atomically

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
git-diff --stat -p
 drivers/scsi/scsi_lib.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a9ac5b1..ae32012 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -966,7 +966,16 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
+		good_bytes = req->data_len;
 		req->data_len = cmd->resid;
+retry_end_req:
+		if (scsi_end_request(cmd, 1, good_bytes, 0) != NULL) {
+			WARN_ON(1);
+			good_bytes = req->data_len;
+			goto retry_end_req;
+		}
+		
+		return;
 	}
 
 	/*
