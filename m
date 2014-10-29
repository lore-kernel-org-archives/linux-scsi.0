From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 26/27] scsi: correct return values for .eh_abort_handler
 implementations
Date: Wed, 29 Oct 2014 08:39:35 +0100
Message-ID: <545099B7.9090501@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de> <1414153627-2863-27-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B4029593470E7@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090909070206080207080705"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593470E7@G9W0745.americas.hpqcorp.net>
Sender: stable-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090909070206080207080705
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 10/29/2014 12:49 AM, Elliott, Robert (Server Storage) wrote:
> 
> 
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Friday, 24 October, 2014 7:27 AM
>> To: James Bottomley
>> Cc: Christoph Hellwig; Elliott, Robert (Server Storage); linux-
>> scsi@vger.kernel.org; Hannes Reinecke; stable@vger.kernel.org
>> Subject: [PATCH 26/27] scsi: correct return values for
>> .eh_abort_handler implementations
>>
>> The .eh_abort_handler needs to return SUCCESS, FAILED, or
>> FAST_IO_FAIL. So fixup all callers to adhere to this requirement.
>>
>> Cc: Robert Elliott <elliott@hp.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/NCR5380.c            | 2 +-
>>  drivers/scsi/aha1740.c            | 2 +-
>>  drivers/scsi/esas2r/esas2r_main.c | 2 +-
>>  drivers/scsi/megaraid.c           | 8 ++++----
>>  4 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
>> index 50873bb..e2c9e73 100644
>> --- a/drivers/scsi/NCR5380.c
>> +++ b/drivers/scsi/NCR5380.c
>> @@ -2703,7 +2703,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
>>   * aborted flag and get back into our main loop.
>>   */
>>
>> -		return 0;
>> +		return SUCCESS;
>>  	}
>>  #endif
> 
> The comment above this function still says:
> * Returns : 0 - success, -1 on failure.
> 
> The same comment problem also exists in
> atari_NCR5380.c and sun3_NCR5380.c, which have
> functions with this same name.
> 
Yeah, but for those it's just the comment which is
at fault; the code actually does the correct thing ...

> With all those comments also updated...
> Reviewed-by: Robert Elliott <elliott@hp.com>
> 
Okay, updated patch attached.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------090909070206080207080705
Content-Type: text/x-patch;
 name="0026-scsi-correct-return-values-for-.eh_abort_handler-imp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0026-scsi-correct-return-values-for-.eh_abort_handler-imp.pa";
 filename*1="tch"

>From 687d52fbc9475e539f443e66234f13408cd3fc1a Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 6 Oct 2014 09:59:14 +0200
Subject: [PATCH 26/27] scsi: correct return values for .eh_abort_handler
 implementations

The .eh_abort_handler needs to return SUCCESS, FAILED, or
FAST_IO_FAIL. So fixup all callers to adhere to this requirement.

Reviewed-by: Robert Elliott <elliott@hp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/NCR5380.c            | 12 ++++++------
 drivers/scsi/aha1740.c            |  2 +-
 drivers/scsi/atari_NCR5380.c      |  2 +-
 drivers/scsi/esas2r/esas2r_main.c |  2 +-
 drivers/scsi/megaraid.c           |  8 ++++----
 drivers/scsi/sun3_NCR5380.c       | 10 +++++-----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 50873bb..296c6f5 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2647,14 +2647,14 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the 
- *      host byte of the result field to, if zero DID_ABORTED is 
+ * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the
+ *      host byte of the result field to, if zero DID_ABORTED is
  *      used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
- *	XXX - there is no way to abort the command that is currently 
- *	connected, you have to wait for it to complete.  If this is 
+ *	XXX - there is no way to abort the command that is currently
+ *	connected, you have to wait for it to complete.  If this is
  *	a problem, we could implement longjmp() / setjmp(), setjmp()
  *	called where the loop started in NCR5380_main().
  *
@@ -2703,7 +2703,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  * aborted flag and get back into our main loop.
  */
 
-		return 0;
+		return SUCCESS;
 	}
 #endif
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5f31017..31ace4b 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -531,7 +531,7 @@ static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
  * quiet as possible...
  */
 
-	return 0;
+	return SUCCESS;
 }
 
 static struct scsi_host_template aha1740_template = {
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 229c61b..11e9302 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2607,7 +2607,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
  *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
  * XXX - there is no way to abort the command that is currently
  *	 connected, you have to wait for it to complete.  If this is
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 6504a19..45aa684 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1057,7 +1057,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		cmd->scsi_done(cmd);
 
-		return 0;
+		return SUCCESS;
 	}
 
 	spin_lock_irqsave(&a->queue_lock, flags);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ac5d94c..2485255 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1945,7 +1945,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	     cmd->device->id, (u32)cmd->device->lun);
 
 	if(list_empty(&adapter->pending_list))
-		return FALSE;
+		return FAILED;
 
 	list_for_each_safe(pos, next, &adapter->pending_list) {
 
@@ -1968,7 +1968,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
 
-				return FALSE;
+				return FAILED;
 			}
 			else {
 
@@ -1993,12 +1993,12 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 				list_add_tail(SCSI_LIST(cmd),
 						&adapter->completed_list);
 
-				return TRUE;
+				return SUCCESS;
 			}
 		}
 	}
 
-	return FALSE;
+	return FAILED;
 }
 
 static inline int
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 3abd796..835bd8d 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2590,15 +2590,15 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
  * Purpose : abort a command
  *
  * Inputs : cmd - the struct scsi_cmnd to abort, code - code to set the
- * 	host byte of the result field to, if zero DID_ABORTED is 
+ *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
- * XXX - there is no way to abort the command that is currently 
- * 	 connected, you have to wait for it to complete.  If this is 
+ * XXX - there is no way to abort the command that is currently
+ *	 connected, you have to wait for it to complete.  If this is
  *	 a problem, we could implement longjmp() / setjmp(), setjmp()
- * 	 called where the loop started in NCR5380_main().
+ *	 called where the loop started in NCR5380_main().
  */
 
 static int NCR5380_abort(struct scsi_cmnd *cmd)
-- 
1.8.5.2


--------------090909070206080207080705--
