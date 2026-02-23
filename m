Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E9E37C0F7
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 22:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884196; cv=none; b=GAmqfX0dGsohDUpdwW80M1FyWv60RiGCWE1m+W+q5ZOUbQHvdFHkAtCZW+GPcxjxEND3YSwoW5uljpcQcJE+FLtUkOUMQoNVTcFgiOq1i7/MV9cj5m2ZCRQFR3GwfmOV+qgDlbXkCRxhFV+jBYQcQgKM/q7owuYdjIu3yfZuVVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884196; c=relaxed/simple;
	bh=FV/Zc0Nryt5cF3ZDo6ayXMMzxhax4Z+/sPPgWEAc9RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBOACHiENGDJ7gCvy422IyuHbapFI4LE0Pv1fR3IBN9lzOm/PHvxIg83gQeze/Bbp5ve3HJklAeVhUhJ22gSXBireqb1CYhHfhkaeBd7pFqiXjRBg3AcjHmJHXc+XhJd0FwUGiu5omIdDKpR6NXSAIhRsMjPCD1ziD/u2Hk1dz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=giFYeIPD; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="giFYeIPD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771884192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ro9rHEijIDt7itwr8DpFzXTmzaFSsQxHZ6tyzYu4xOY=;
	b=giFYeIPDC1hq3hCORMhLu86pqCbiRS3+50g5dsxsRlXjoq4aAp6eTVFzREzkBvvareBN30
	F1jYQE9LvzOKVvXie4De1qkHmhZWIKUyhsNx/RG2i9HWmqWyx/V184Q2n0+kAr9kqRO5Ai
	sdhIDSd0WPVyx9izDRDGTFXJJ0lzbtc=
From: Bart Van Assche <bart.vanassche@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH 30/62] megaraid: Protect more code with instance->reset_mutex
Date: Mon, 23 Feb 2026 14:00:30 -0800
Message-ID: <20260223220102.2158611-31-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-1-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bart Van Assche <bvanassche@acm.org>

megasas_get_device_list() and megasas_get_snapdump_properties() may
unlock instance->reset_mutex indirectly. Hence, hold reset_mutex while
calling these functions.

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ac71ea4898b2..ecd365d78ae3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6365,11 +6365,13 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	megasas_setup_jbod_map(instance);
 
-	if (megasas_get_device_list(instance) != SUCCESS) {
-		dev_err(&instance->pdev->dev,
-			"%s: megasas_get_device_list failed\n",
-			__func__);
-		goto fail_get_ld_pd_list;
+	scoped_guard(mutex, &instance->reset_mutex) {
+		if (megasas_get_device_list(instance) != SUCCESS) {
+			dev_err(&instance->pdev->dev,
+				"%s: megasas_get_device_list failed\n",
+				__func__);
+			goto fail_get_ld_pd_list;
+		}
 	}
 
 	/* stream detection initialization */
@@ -6468,7 +6470,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	}
 
 	if (instance->snapdump_wait_time) {
-		megasas_get_snapdump_properties(instance);
+		scoped_guard(mutex, &instance->reset_mutex)
+			megasas_get_snapdump_properties(instance);
 		dev_info(&instance->pdev->dev, "Snap dump wait time\t: %d\n",
 			 instance->snapdump_wait_time);
 	}
