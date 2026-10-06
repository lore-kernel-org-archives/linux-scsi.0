Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A633D9665
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279281; cv=none; b=VKwHCMhd7fqqd43Lmw36pdnr4RtQVMS1oZ6J+sqlTfcX82HvI7naPIxo0wkN717R8+bEw2ZYLsj5MnMdVV5RVpMQJK6uMVxNCXUmA0KZcSYm+vnovNPnm8ab4yk7YRdKjzd34PtN/H3ZUGwFx6mSQYgGJaKvp54mjtBxvGsMc3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279281; c=relaxed/simple;
	bh=47mvSsNpNg+ZUpTtA1w32TuEcUfLQ7Pkxvdyz5/ll2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tuU1PNoHmQdfwrFYsrafZnc0FmFWgmXQjqoHGxLFsx1QYvG82iW4cjzfvUd3X4XBOlrPNk2o10zpDQBALsRfON1w5ypGj3yFDmV8jC+4/oY7W5sEv5Op6rlzvmIiJun8pKVqRzmoPSji0iSTiz/dJ7caP+iRkYCZIKKFIRaOp/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNjbQM3B; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNjbQM3B"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca12086c06eso206717a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279272; x=1791884072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qY0yv79M9ElE8fm/ELF5xq7iGxut3qQ2nfq4dYz2/7I=;
        b=nNjbQM3Bi3UXY1uqcUNZFy6k4XyHXltvZZzwPBDIP/D6Zp2GnwPZTELphKDLyYij1v
         GfxqZtOO0W9meXWURWr4QBtk+XkmloaMwm7gGI2saDeQUOjDZkW4z8nieb42ldxn+fBp
         ViaFASdCZTqEYFDpBb7PmlquyN9xVDOstAg28WGv/DbXmliS0E67ZB2/B+1/xf3S/Ox7
         jfMQpAT1k7Xzm+1iqp0AIjqhW0b9+IAR1pWp7xylU3yw1YC2Jm5W8/7+E2Esrxsgf54k
         ySdUcS0XgKV2jxlIAUds8Da/Y5BuVobCvIBjZEWBGxWvnnd79yWDeMM3JQvqa9e/1ra5
         ZS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279272; x=1791884072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qY0yv79M9ElE8fm/ELF5xq7iGxut3qQ2nfq4dYz2/7I=;
        b=nBSjQemFqjpqawqpb0TxFlyCPmD0GiqN6aOY4WCx4iwDR053x9jKb211IJn0qZxOBm
         6BJdm9JIanAr6UMMKkT9yq9EjYw/nqv3Wsd0Q7AwSJ3MbVeqfR4JNqx35XZC+R1/+4Qs
         EPj+BRmvOg3FTGWAyOdTN6QA9VylXAxK5gYazy8VwV6W/L+is6y+xjjsV6vmoppOumAc
         D5M8L/XYPNiOTtC2m4jnxcTqqwP/VAtllTcxlF3VyJhcivs/wEIeIXK1PE6Z27oyRYsK
         keqKtX0+jfMrBYe9XZDg2H09vtB9KRjrt9UV9q22NOJbWMajREYT4pJByta/Il3EafTS
         hxmQ==
X-Forwarded-Encrypted: i=1; AKwUvByuMesVxYALdrgFQhCslHIiIbBE1fVYb14/8s8jeJnXbunF2txJAxkPEBOsrhSgbThxZ+HENIwGSWzG@vger.kernel.org
X-Gm-Message-State: AFq9FYL14b00F4VGps9qXA7ZdjcAwzGHSAKxbxF+4tTV4lVytfBSnRcE
	Ibh28gCrEZlCil8s4+3ajkgR0i1TRNRGTpX06mDOrktPwdUMBWd2oBCA
X-Gm-Gg: AYBFou3ua9qsxDLQkz5EJ0yMRIGdk00h04pkm/c/FKcJOpdO/Go0nSokQIxyIywahh0
	r/wF8fM2PEIFE5WeT0hQ7wDWl9k8T37XWg12dO7r6f/2y0TFcvIhzCCtKFEOsXtuLveG7yjN8QS
	9jUW/B95fJ9b9TCKmP54JaPm6wwxh5CZ10fsUsQViFzHSE8ZNFHjHvXsA4D6/+4U7oTwCnkIqf0
	zmFV6pDYd0ySlGAQI5fBhQzWLVXi5BGMwf64GQ5zor52WmPdJQJxz8Rc667wc8+jsUq5sN2QOD4
	J0RRiw7RY6RShNTZVxLw58VhBdKuQKFw4WvLIyFQ3/MmljWgmvUj8a8+A6qJOrOrtbfHeS6+b9y
	2wn3aik3UjpzvZcnAEGqHPtys++z8ldnTBFBBymDYOhxw3eSqUKViihI/BvFzpfpXBgKj3bYl0f
	62nWI1SteZ0ipzYlRbZmjUY8I+2+ZmfadjprIcVnRmal1m4WfJF2437q/nyivF/G4pgdNhTQ==
X-Received: by 2002:a17:90b:4a0d:b0:39e:6ec6:f4d0 with SMTP id 98e67ed59e1d1-3a87267ea3cmr712031a91.8.1791279272186;
        Tue, 06 Oct 2026 02:34:32 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:31 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 3/8] scsi: target: reject a short SET TARGET PORT GROUPS list
Date: Tue,  6 Oct 2026 17:33:33 +0800
Message-Id: <20261006093338.27342-4-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261006093338.27342-1-physicalmtea@gmail.com>
References: <20261006093338.27342-1-physicalmtea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

target_emulate_set_target_port_groups() accepts any parameter list of
4 bytes or more. The walk then reads a 4-byte descriptor whenever any
byte remains. A 5-byte list reads ptr[0] and get_unaligned_be16(ptr + 2),
which is buf[6] and buf[7].

Explicit ALUA is enabled on a new target port group. Access state 0 is
Active/Optimized, so that read is reached. vhost-scsi keeps one sg
inside a page. Five bytes at page offset 4091 end on the page boundary,
and the port-group id is the next physical page.

A legal list is a 4-byte header plus 4-byte descriptors. Reject a
length that is not a multiple of 4 before any port-group state changes.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_set_target_port_groups+0x1dc/0x540 [target_core_mod]
  Read of size 2

  target_emulate_set_target_port_groups
  __target_execute_cmd
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd
  __target_submit
  target_queued_submit_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork
  ret_from_fork_asm

Fixes: 0d7f1299ca55 ("target: report too-small parameter lists everywhere")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c43..e2439f2e468a 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -283,9 +283,9 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 	int alua_access_state, primary = 0, valid_states;
 	u16 tg_pt_id, rtpi;
 
-	if (cmd->data_length < 4) {
+	if (cmd->data_length < 4 || (cmd->data_length & 3)) {
-		pr_warn("SET TARGET PORT GROUPS parameter list length %u too"
-			" small\n", cmd->data_length);
+		pr_warn("SET TARGET PORT GROUPS list length %u too small or not a multiple of 4\n",
+			cmd->data_length);
 		return TCM_INVALID_PARAMETER_LIST;
 	}
 
