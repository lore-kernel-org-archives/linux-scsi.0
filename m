Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C86306D50;
	Sat, 25 Oct 2025 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408967; cv=none; b=EZP3remUQ6mnkZ1KuH6rDPfMJotbbOjCjfr29x/52bsxTC7NgOZaObhlbNdY3GLSJ1PvOAuMe11XBbtIDfXUDNjbpAu/fGcmGCdkQxoUw6LH2Rx/pJahhWJ4IRP0u5ilnggbLeDhNwUFxsUQXkB5Ccu9RUT0E/85ESSBn5VJtds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408967; c=relaxed/simple;
	bh=lyJh3iMHKiH1eHeVXb+VzrOsb7MZtUAcEgdXBjvlnZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4RKqR4lNcpvs60Pup4detRHj8CeN+VSmHPlJc6+O0MDL5ZiylZtsDwngxorXW70N0l6uSOIUq5uuL9y967n+z1LUi9SBQqppuFzwb+gdV2WKIYc991lZnRVJIsQHU25reQIP7hOPWe+aHDajTdf0GL5madxHntbYcT4PyNLqt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3j1aXHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3j1aXHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2703C116B1;
	Sat, 25 Oct 2025 16:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408964;
	bh=lyJh3iMHKiH1eHeVXb+VzrOsb7MZtUAcEgdXBjvlnZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3j1aXHgf+dL4LbJI182kSSrNLDw5cizDOVSCsW0XPz+LudSb9ft6mARRDbJ6WyAa
	 Wz9qwUvLBdkvn/zaG47IYXL7SwCJI3o7R+Ol2V+P+TvwhK2sFscdCuVBNG1kJKXVev
	 9IW8hMgYH5ji0QxcIwFD+n8MbG4TUEAHnbhOdKcR62NZaulAt1+evYpBEW91+roIxV
	 Ai8YA9V4Ld8Moz7Z284epSt7DaBoF9XsfjomGaLSAZt+pr7xQ+n5vANnugNibsX5JL
	 tWADoYXctbW5TP8iyE5D0fwydEwT8ncOi+eQShuML3jJAYpq97S1EyWsEbGXyQdx7A
	 yE9aSAUp2YakQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] scsi: lpfc: Clean up allocated queues when queue setup mbox commands fail
Date: Sat, 25 Oct 2025 11:56:26 -0400
Message-ID: <20251025160905.3857885-155-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 803dfd83df33b7565f23aef597d5dd036adfa792 ]

lpfc_sli4_queue_setup() does not allocate memory and is used for
submitting CREATE_QUEUE mailbox commands.  Thus, if such mailbox
commands fail we should clean up by also freeing the memory allocated
for the queues with lpfc_sli4_queue_destroy().  Change the intended
clean up label for the lpfc_sli4_queue_setup() error case to
out_destroy_queue.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-4-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The failure path after `lpfc_sli4_queue_setup()` now jumps to
  `out_destroy_queue` (`drivers/scsi/lpfc/lpfc_sli.c:8820`),
  guaranteeing that any queues allocated by `lpfc_sli4_queue_create()`
  are torn down before we bail out.
- Those queues hold DMAable pages allocated in large batches
  (`drivers/scsi/lpfc/lpfc_init.c:10420`), so skipping
  `lpfc_sli4_queue_destroy()` leaked real memory whenever the mailbox
  CREATE_QUEUE commands failed—precisely the scenario this fix covers.
- `out_destroy_queue` already performs the paired cleanup
  (`drivers/scsi/lpfc/lpfc_sli.c:9104`), invoking
  `lpfc_sli4_queue_destroy()` which handles partial setups and releases
  every queue resource (`drivers/scsi/lpfc/lpfc_init.c:10862`); we
  simply make sure the queue-setup error uses the same, already-tested
  path.
- The change is tiny (one goto target), touches only the error path, and
  aligns this branch with other existing failures that already call
  `out_destroy_queue`, so regression risk is minimal while preventing a
  concrete resource leak on failed probe/recovery attempts.

 drivers/scsi/lpfc/lpfc_sli.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a8fbdf7119d88..d82ea9df098b8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8820,7 +8820,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	if (unlikely(rc)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"0381 Error %d during queue setup.\n", rc);
-		goto out_stop_timers;
+		goto out_destroy_queue;
 	}
 	/* Initialize the driver internal SLI layer lists. */
 	lpfc_sli4_setup(phba);
@@ -9103,7 +9103,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	lpfc_free_iocb_list(phba);
 out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
-out_stop_timers:
 	lpfc_stop_hba_timers(phba);
 out_free_mbox:
 	mempool_free(mboxq, phba->mbox_mem_pool);
-- 
2.51.0

