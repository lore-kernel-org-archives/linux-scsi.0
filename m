Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07752D77E2
	for <linux-scsi@vger.kernel.org>; Tue,  4 Nov 2025 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762253131; cv=none; b=SUxihmXkP7fzIccp/j6D4uE64d9eAUOhGMuNGABOqrA6eAMBfKq+hpxtOi0EI5FxPkthvomYw0bHKs+UtItV6ZSrLeG+YdHAZiXyTZ8rWlXhCnxvh/DdIyQrXK2m9PCcofquvK6dxwYct5MwVnVJoTrCd0hbhw5reL3yOBPBnvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762253131; c=relaxed/simple;
	bh=VX0zLAsPBGlwcqvp/8KD3Z0nfnIEYq4KM2NgJGr5aXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ljsC3W5gmriOQ+ZqC8+J6+tNa5GydJWY1CaQjbDRxSt+ovLSZ3UR8y+NU9nIhEJx7hQmlcuAxSUxNueUFtD62gHHbeK9RhVw7NfKcX5CVp+RZ7yU3h/4bbnhYFXRKaFr2O3wNkTszRqwZLqeKbInFsOvSA2327GVIp59EsLPLL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PyGwY59m; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PyGwY59m"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so1922436a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Nov 2025 02:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762253127; x=1762857927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WYj8Ir61bhOOSEvOfRY0NgbszhSvxELkBx7OQsS3cOQ=;
        b=PyGwY59mWp3utUgAh2CmYtifE3gNPZiSf6GY7GwMAB+DkCf/1JXrIlq9TfMhdxE+YQ
         2B2ECfWUTtR/K0AeYQ0VVshxBM/SlRnewghaQcoee+U1+NL0w9hzckYfh/5tF/vQGIx1
         062ayTngKU2E1ojnOXupLDw1C180xE3yYuxJShOygafocJhwZZblIqthF0lj2rpFEBzN
         J0sPTxm5MpB2atG3SpzlEjttx96zpyJ5sj2eomN1bq9n+C1jmnvAwPmoTZGBC1a0hKIB
         YNgYP83Ttnih1+3vhaphHbMAx26a+kmIF+ABLmzJPtg7GM/omOBMqGeu+4l67r7l3oV0
         whpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762253127; x=1762857927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WYj8Ir61bhOOSEvOfRY0NgbszhSvxELkBx7OQsS3cOQ=;
        b=MvfffRwM5znX7WS4U/y8uy+lNIWlGBmkNWEoYmzwlnWJede9rw0yU8nU8aBjDiaGRy
         BZx4NKbL8G6dQYDnSxNJwdhCK08UaO/N3HT07KR5C583LqTd1VsRRqdoTrH4waA+MdeJ
         /nsUElMftQ5eCHBv23PwYTwdTULgHJ1jeMpsKG37aes4NAavqipkP2ybNINNSZbHhZZU
         I7G8B9HTK4VmCS8stxHNJWL4IWyzTR4g7y6bXgVk+u3BJ+StwIuuEgHs5sOkMHYI4e60
         FH6aSDDLvFpq5TpVVWUns5E33PBaHn4rHqodcRymPuyEJPMkfPOGmUSjLR9dfvdW4PW1
         xHAw==
X-Forwarded-Encrypted: i=1; AJvYcCXO1n+rBPs7TaCMcrkb5rjYB2LESaIuMUlD5uqrrkTfNnprgQ7FsLU4Uq0I3uf6jGMsKDDJ/jSulCWY@vger.kernel.org
X-Gm-Message-State: AOJu0YzTPeYXqgdx0rgRJ6ocCDXb7rGVa3eYs7BlGa11IeepO4Tchjhz
	X0eLt4WGWbUf5UaZHto+v1vChO8nuAsDz2AKBvu4xN2I0UuIzwYYvN8qcCk4nxULeTM=
X-Gm-Gg: ASbGncvlYxLVceIa4X5ih7b3yCgBZNr8JNGbb/kl55dPSkqEFY7OwoPvgh8hd1emY8+
	bSkYrh4I3AHLXbe5bEQnYWPwjZCAhREi0vzACh3fCxuzWY5Dj0Cjg3j/nJPTkbgSEokEyLR4KzM
	i1hB7EBmIVLR77nrmnO6iyjnvN7hsyVD5j4UYAzB9FHBjRCrVqFa9QWJuRPa1fEzBZQGgE2EGJS
	p/pYEPb/d6bUwHV9bZfPC1vIhNf3uNi0yq9a0I//d4VVJcbFwTnJlugRlasi2TRXgynnVpy+sue
	rg/kRENY2P00NzkyFG4tU86ysAdzm0L6N03o5avhw+PBp63vQOXedOwQ/YvbMMm70LvV16XZXZ8
	VjbRBaaAfCXkHd1E8NhPAFixZCRvfkhslNLVsnNNxoJ9fYIJcXprlS3PLiU8PrxNaQDA+ejh1zl
	u5GwJyG6pknmkoyw==
X-Google-Smtp-Source: AGHT+IEMA8UdWF6f+LHriDUDE/NjxHUOw+zfGpPihm2oIRRAOwA1BfGgSkWC9f9a8GPJW8x10c9pUQ==
X-Received: by 2002:a17:906:e0d6:b0:b70:7d5a:2111 with SMTP id a640c23a62f3a-b707d5a6021mr1065888366b.64.1762253127163;
        Tue, 04 Nov 2025 02:45:27 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723d3a3082sm177827666b.11.2025.11.04.02.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 02:45:26 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Chris Boot <bootc@bootc.net>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sbp-target: replace use of system_unbound_wq with system_dfl_wq
Date: Tue,  4 Nov 2025 11:45:18 +0100
Message-ID: <20251104104518.102130-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

system_dfl_wq should be the default workqueue so as not to enforce
locality constraints for random work whenever it's not required.

The old system_unbound_wq will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/target/sbp/sbp_target.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3b89b5a70331..b8457477cee9 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -730,7 +730,7 @@ static int tgt_agent_rw_orb_pointer(struct fw_card *card, int tcode, void *data,
 		pr_debug("tgt_agent ORB_POINTER write: 0x%llx\n",
 				agent->orb_pointer);
 
-		queue_work(system_unbound_wq, &agent->work);
+		queue_work(system_dfl_wq, &agent->work);
 
 		return RCODE_COMPLETE;
 
@@ -764,7 +764,7 @@ static int tgt_agent_rw_doorbell(struct fw_card *card, int tcode, void *data,
 
 		pr_debug("tgt_agent DOORBELL\n");
 
-		queue_work(system_unbound_wq, &agent->work);
+		queue_work(system_dfl_wq, &agent->work);
 
 		return RCODE_COMPLETE;
 
@@ -990,7 +990,7 @@ static void tgt_agent_fetch_work(struct work_struct *work)
 
 		if (tgt_agent_check_active(agent) && !doorbell) {
 			INIT_WORK(&req->work, tgt_agent_process_work);
-			queue_work(system_unbound_wq, &req->work);
+			queue_work(system_dfl_wq, &req->work);
 		} else {
 			/* don't process this request, just check next_ORB */
 			sbp_free_request(req);
@@ -1618,7 +1618,7 @@ static void sbp_mgt_agent_rw(struct fw_card *card,
 		agent->orb_offset = sbp2_pointer_to_addr(ptr);
 		agent->request = req;
 
-		queue_work(system_unbound_wq, &agent->work);
+		queue_work(system_dfl_wq, &agent->work);
 		rcode = RCODE_COMPLETE;
 	} else if (tcode == TCODE_READ_BLOCK_REQUEST) {
 		addr_to_sbp2_pointer(agent->orb_offset, ptr);
-- 
2.51.1

