Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45EB3E92B7
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 03:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085300; cv=none; b=M3EQ5IREKwKzAHx/i/7ntWFddwQnWCm7tYz/kIe9GGnAJkVeU7yQWx6UxyCagSm0pfYU4wUQ0AldlWWoL4ktL4Rz8Xcp9dNoJMI/TTgbL0jxj6lx2c2iQZnh4QI6mj81cM+r32/hetIuqHow3fdQj7HjdwYlAGiR0Kq1Nkwl7K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085300; c=relaxed/simple;
	bh=fhR73NhC9+vNuwHlbmh1kyAcAjMvzf/ZTywGsRy2//0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chd952AVg0aR5v776J3P4qvYKitwhNbhpso4bF0ld28qFOkpn7TS3jw31XxduL1j1gFGyIjD/3Qrz4x+LujREN5M0JqShPHdJVoUFLSNKryE98l5mk3gwfK/bGz2quRO02VaXOidAcj3N9T+p2QpEYZXrHsqZU0F9jxNyTzr8uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=KC6jiuWX; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="KC6jiuWX"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-3396cec93b6so775568eec.3
        for <linux-scsi@vger.kernel.org>; Sat, 03 Oct 2026 20:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791085298; x=1791690098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MGayYLSpo+HONIxnPrP/qqWGzQP0aiWVlT8XEDLeFKY=;
        b=KC6jiuWXgXiS5S2eGib2N12itxKTHdUOO5tGuswvNC7ihtVdIogS6i6QJS928e2Rzh
         6Rekp/ODKvtHUrwhkqtvmrDuwTT2h+tVfq5rV7kgIcrVabfRoPiDSBO8UBzcxXFJfnSC
         awIfhMF3H7Mh5A4ZDUVa/EqAfDXCoUEbZqy/S55ui2dfPuabypo+FTpimM0OlKANlHl2
         yaE70YagJiiA8zOhj0AIlA5vZTUd8pWsLEXouJIvzzDxZSIm6M9PmnWFfycaaBVFHSiY
         oblCZ3rh+fWMvvPBZ2ixsQA8Hydoc0MjkPFKS2A9lUwJ3zbvdCtcT971ganyDHgW4RmU
         YdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791085298; x=1791690098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MGayYLSpo+HONIxnPrP/qqWGzQP0aiWVlT8XEDLeFKY=;
        b=ivNxHKWxboe5CuqTEH3LtxuusmOFojQ4sZfeToaXkv7SzqNHDgmkNO2esBnaL90DFA
         J2cG4la5rgUI4iX/A8/0AzwJQu8aVpcW8OoeXQt/TnnOTaN/OiJilUgfbZLu+QrcGUUz
         +7w/EGUCF0oGqRi9FYGYdcAD6gutkMxaXCm5Wr8axlxmBUPE0mraAF3xQlY0ULTxup23
         3RuysYDii9aCw57JO5nNhqdN4C1zKxC8zR4m+uuuKS4Az6AgfDFkCIduNdbKHuuAEBpI
         Ysgg2n6J8iPF+cvj91HuneQNAUjJuH5OlkqE4sBTp94g+Pvm3D2ZdEZchT0IgVuPjcc/
         vhZw==
X-Forwarded-Encrypted: i=1; AKwUvBzHnuI3gYN/f6zn/CEPOffoTw8TOnBMWPPRcX5b4lZbMOUEwB2uJu8bKFgPwXJVhZN5PLjN8fM0WiEr@vger.kernel.org
X-Gm-Message-State: AFq9FYLKP6/cOsiMf2XkHJNTZfalfsNUbGW6t5nyzWHjfzxbBJG6qHXl
	AtQZptRwq/eRCyjoAr+eS06NUkB++gXyAaM0u/ss6yNh9kvpdErd5HvaTnzXM3TO+dA=
X-Gm-Gg: AYBFou1JHhULX4vAfGcOddtTDVHd0VrQP+iSIuRMGbIGqgl6B1aeB6NAK7PKYei4bN8
	J2QdvD2CeHBNwSZT8+DayGKY9SHFC6YcAJlt67UqGsfFn+NcYR59qDxYz51uo88QM9vHH2YZp/4
	7mRD0cdK/0ataAu+pNkQfe2uPHqyWQXs+5xnInbInQOVQSuklNaU70UpOsnGtLOjOTQNG7gzraL
	RdF+jKj9ehc42V7K9Ucx/rGlVZg2Z31yc6DCRa6X/dYCfen07T/kenq3nemFbZ0/Fk7G+cSXzb5
	UneI7hEsjGv0cs4LARZLfjo6ShDePt9xfCIRfKyiLNR4CeKIiD6/4c3KBBrCiwNV8YtJxGTFumh
	I9ee7fEvxN+vefyAaw0Ji6hWL0qMeQRk79uzkJoJ1piFTFaCcMhpLE7fKEUIkQGt1WNsszsx4Vo
	Sj3HIHEKYo2eWyAR+cMEzbQVl/KpFyGQQptbbV8i/T9P19oamAUuw70SZvFnpmxkXrvLvgJH9ix
	8LbhdkBGOsiUedsP7Vz5BLhweDXi3MZ3TNLZnNWCNX7R1hv3SNcPYn2jlPAPmDKyjR78/U=
X-Received: by 2002:a05:7301:618d:10b0:34a:e7ba:863c with SMTP id 5a478bee46e88-34f150d227emr8378610eec.18.1791085297893;
        Sat, 03 Oct 2026 20:41:37 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:a817:e330:2fc8:fa47])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3512718a18esm1308920eec.17.2026.10.03.20.41.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 03 Oct 2026 20:41:37 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Smart <James.Smart@Emulex.Com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Dinaburg <artem@trailofbits.com>,
	stable@vger.kernel.org
Subject: [RFC PATCH 2/3] scsi: lpfc: Resolve synchronous mailbox wait ownership under hbalock
Date: Sat,  3 Oct 2026 23:41:35 -0400
Message-ID: <f6aba409fd4bf25e833d72bc943ca2788854985d.1790968549.git.artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790968549.git.artem@trailofbits.com>
References: <cover.1790968549.git.artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lpfc_sli_issue_mbox_wait() detaches the waiter under hbalock and, on
timeout, switches mbox_cmpl to lpfc_sli_def_mbox_cmpl() so that a late
completion frees the mailbox. The completion side does not make its
decision under the same lock. lpfc_sli_wake_mbox_wait() sets
LPFC_MBX_WAKE before taking hbalock, and the mailbox worker and the
flush path load mbox_cmpl without hbalock (lpfc_sli_handle_mb_event(),
lpfc_sli_mbox_sys_flush()). A completion that loaded the wake callback
before the waiter timed out then finds no waiter, wakes nobody and leaks
the mailbox. Because LPFC_MBX_WAKE is set before hbalock is taken, a
waiter that times out in that window also returns MBX_SUCCESS, and its
caller can free the mailbox before the wake handler reads it. This
affects every caller of lpfc_sli_issue_mbox_wait().

Decide ownership in lpfc_sli_wake_mbox_wait() under hbalock. If a waiter
is still attached, set LPFC_MBX_WAKE and complete it. Otherwise run
lpfc_sli_def_mbox_cmpl() after dropping the lock.

The wake callback now handles the detached case itself, so the timeout
path no longer switches mbox_cmpl, and the waiter no longer writes it
while the completion side may be reading it without the lock.

Fixes: 858c9f6c19c6 ("[SCSI] lpfc: bug fixes")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cfa437116..c2086f331 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2814,9 +2814,9 @@ lpfc_sli_chk_mbx_command(uint8_t mbxCommand)
  *
  * This is completion handler function for mailbox commands issued from
  * lpfc_sli_issue_mbox_wait function. This function is called by the
- * mailbox event handler function with no lock held. This function
- * will wake up thread waiting on the wait queue pointed by context1
- * of the mailbox.
+ * mailbox event handler function with no lock held. If the waiter is
+ * still attached, wake it; otherwise the caller timed out and the
+ * callback owns the mailbox resources.
  **/
 void
 lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
@@ -2824,17 +2824,18 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 	unsigned long drvr_flag;
 	struct completion *pmbox_done;
 
-	/*
-	 * If pmbox_done is empty, the driver thread gave up waiting and
-	 * continued running.
-	 */
-	pmboxq->mbox_flag |= LPFC_MBX_WAKE;
+	/* Decide who owns the mailbox under the same lock as waiter detach. */
 	spin_lock_irqsave(&phba->hbalock, drvr_flag);
 	pmbox_done = pmboxq->ctx_u.mbox_wait;
-	if (pmbox_done)
-		complete(pmbox_done);
+	if (!pmbox_done) {
+		spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
+		lpfc_sli_def_mbox_cmpl(phba, pmboxq);
+		return;
+	}
+
+	pmboxq->mbox_flag |= LPFC_MBX_WAKE;
+	complete(pmbox_done);
 	spin_unlock_irqrestore(&phba->hbalock, drvr_flag);
-	return;
 }
 
 /**
@@ -13313,15 +13314,11 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq,
 
 		spin_lock_irqsave(&phba->hbalock, flag);
 		pmboxq->ctx_u.mbox_wait = NULL;
-		/*
-		 * if LPFC_MBX_WAKE flag is set the mailbox is completed
-		 * else do not free the resources.
-		 */
+		/* The callback owns cleanup if it has not woken the waiter. */
 		if (pmboxq->mbox_flag & LPFC_MBX_WAKE) {
 			retval = MBX_SUCCESS;
 		} else {
 			retval = MBX_TIMEOUT;
-			pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flag);
 	}
-- 
2.43.0
