Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FB2EAD0;
	Fri, 20 Sep 2024 20:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726863794; cv=none; b=G0elUyQAhYMaFcXC5/pzbTdvfSeZ7eUyHMMVX86z4i1JAFaTKzTXkFNgK7ccLibh2Ge86HyuSujNoCd1O7yEEqsAnYSWyb9frwipNKF3Wr/JgcrRv6MDyyeuMTYT+h/pUkVf9LHoXpCU2jwXrf9cJ3T/Ay8mY/4ZcxzsHyy36zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726863794; c=relaxed/simple;
	bh=ib+A9S5I9CMvHt4v2Ct35wVZBQs6+SYKbHCDlgeiVaI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZJWSv/7hbU8SVE8esFw7Mk7pexulNUBUGn50QDNs1h6bu26ONqZ8U520uOT3vKbtYpQfS8eIDFcqiIcZazHzZG4GdUFl12i5yJHZiAfTMu4fH2CI7wfvedPOHZQ/1P0JTNndzYkBRZVG2S28iVTeKT/7fwviQrbcsZZQbT6xQkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=BQ5Ar9o5; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="BQ5Ar9o5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=Sf/FAwdE+OOEoqBoch5OH47McASgFoKuaA8Cys6NfL4=; b=BQ5Ar9o5IHpvMkSQ
	UU9L5RA1z1um4I1Sd46C+HioIQgggopUPJpPFyZnGSBT0qT8l9cc9zVzmBomeUs8XXuE9gPd/Ciib
	MoN5hU3wVkf9jcJ4pbyZ8149sNytglrML9nYufO7mIUitvdDRyJa2un/6pmuGRR0e0JXoj/nFdvsh
	9sHHldIVgEdehX/+BUVW0EIq0pyhhvmfzHRXsEGy1sbiyRSZ820kKiSXE2F9skg2gRDsDQUXc5eK8
	iEEuMAhuA32xORZiJrNcUbWj8KBtfnWe1cjtW91uszw+i9j62Vo19BVQd580IM+HJeilOLERSIqco
	nyn+To2ZxIoG5OuBOA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1srk9h-006b9Z-18;
	Fri, 20 Sep 2024 20:23:05 +0000
From: linux@treblig.org
To: aacraid@microsemi.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: aacraid: Remove unused aac_check_health
Date: Fri, 20 Sep 2024 21:23:04 +0100
Message-ID: <20240920202304.333108-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

aac_check_health has been unused since commit
  9473ddb2b037 ("scsi: aacraid: Use correct function to get ctrl health")

Remove it.

(I don't have the hardware to test this, build and booted only)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/aacraid/aacraid.h |   1 -
 drivers/scsi/aacraid/commsup.c | 121 ---------------------------------
 2 files changed, 122 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 1d09d3ac6aa4..8c384c25dca1 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2736,7 +2736,6 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 Index,
 			int isAif, int isFastResponse,
 			struct hw_fib *aif_fib);
 int aac_reset_adapter(struct aac_dev *dev, int forced, u8 reset_type);
-int aac_check_health(struct aac_dev * dev);
 int aac_command_thread(void *data);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
 int aac_fib_adapter_complete(struct fib * fibptr, unsigned short size);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 47287559c768..ffef61c4aa01 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1698,127 +1698,6 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	return retval;
 }
 
-int aac_check_health(struct aac_dev * aac)
-{
-	int BlinkLED;
-	unsigned long time_now, flagv = 0;
-	struct list_head * entry;
-
-	/* Extending the scope of fib_lock slightly to protect aac->in_reset */
-	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
-		return 0;
-
-	if (aac->in_reset || !(BlinkLED = aac_adapter_check_health(aac))) {
-		spin_unlock_irqrestore(&aac->fib_lock, flagv);
-		return 0; /* OK */
-	}
-
-	aac->in_reset = 1;
-
-	/* Fake up an AIF:
-	 *	aac_aifcmd.command = AifCmdEventNotify = 1
-	 *	aac_aifcmd.seqnum = 0xFFFFFFFF
-	 *	aac_aifcmd.data[0] = AifEnExpEvent = 23
-	 *	aac_aifcmd.data[1] = AifExeFirmwarePanic = 3
-	 *	aac.aifcmd.data[2] = AifHighPriority = 3
-	 *	aac.aifcmd.data[3] = BlinkLED
-	 */
-
-	time_now = jiffies/HZ;
-	entry = aac->fib_list.next;
-
-	/*
-	 * For each Context that is on the
-	 * fibctxList, make a copy of the
-	 * fib, and then set the event to wake up the
-	 * thread that is waiting for it.
-	 */
-	while (entry != &aac->fib_list) {
-		/*
-		 * Extract the fibctx
-		 */
-		struct aac_fib_context *fibctx = list_entry(entry, struct aac_fib_context, next);
-		struct hw_fib * hw_fib;
-		struct fib * fib;
-		/*
-		 * Check if the queue is getting
-		 * backlogged
-		 */
-		if (fibctx->count > 20) {
-			/*
-			 * It's *not* jiffies folks,
-			 * but jiffies / HZ, so do not
-			 * panic ...
-			 */
-			u32 time_last = fibctx->jiffies;
-			/*
-			 * Has it been > 2 minutes
-			 * since the last read off
-			 * the queue?
-			 */
-			if ((time_now - time_last) > aif_timeout) {
-				entry = entry->next;
-				aac_close_fib_context(aac, fibctx);
-				continue;
-			}
-		}
-		/*
-		 * Warning: no sleep allowed while
-		 * holding spinlock
-		 */
-		hw_fib = kzalloc(sizeof(struct hw_fib), GFP_ATOMIC);
-		fib = kzalloc(sizeof(struct fib), GFP_ATOMIC);
-		if (fib && hw_fib) {
-			struct aac_aifcmd * aif;
-
-			fib->hw_fib_va = hw_fib;
-			fib->dev = aac;
-			aac_fib_init(fib);
-			fib->type = FSAFS_NTC_FIB_CONTEXT;
-			fib->size = sizeof (struct fib);
-			fib->data = hw_fib->data;
-			aif = (struct aac_aifcmd *)hw_fib->data;
-			aif->command = cpu_to_le32(AifCmdEventNotify);
-			aif->seqnum = cpu_to_le32(0xFFFFFFFF);
-			((__le32 *)aif->data)[0] = cpu_to_le32(AifEnExpEvent);
-			((__le32 *)aif->data)[1] = cpu_to_le32(AifExeFirmwarePanic);
-			((__le32 *)aif->data)[2] = cpu_to_le32(AifHighPriority);
-			((__le32 *)aif->data)[3] = cpu_to_le32(BlinkLED);
-
-			/*
-			 * Put the FIB onto the
-			 * fibctx's fibs
-			 */
-			list_add_tail(&fib->fiblink, &fibctx->fib_list);
-			fibctx->count++;
-			/*
-			 * Set the event to wake up the
-			 * thread that will waiting.
-			 */
-			complete(&fibctx->completion);
-		} else {
-			printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
-			kfree(fib);
-			kfree(hw_fib);
-		}
-		entry = entry->next;
-	}
-
-	spin_unlock_irqrestore(&aac->fib_lock, flagv);
-
-	if (BlinkLED < 0) {
-		printk(KERN_ERR "%s: Host adapter is dead (or got a PCI error) %d\n",
-				aac->name, BlinkLED);
-		goto out;
-	}
-
-	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
-
-out:
-	aac->in_reset = 0;
-	return BlinkLED;
-}
-
 static inline int is_safw_raid_volume(struct aac_dev *aac, int bus, int target)
 {
 	return bus == CONTAINER_CHANNEL && target < aac->maximum_num_containers;
-- 
2.46.1

