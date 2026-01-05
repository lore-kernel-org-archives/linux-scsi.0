Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E5310651
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 21:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648696; cv=none; b=Lmw5VNdk52Z7P+7VATFRNW3SS5JhZvZyF5d09+M1od0IZ4r8gq9tXwvO4aa5DPTG9sNGbmEiKEDp5CzZNQqAIt7Sr53HeWWb9hwNV3zjgkfml4nVtJcJvA6J1X/ZUOBShF8tXM/LhQZAsZx04rEgizN8Plr7NQf+FdDXXAegTN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648696; c=relaxed/simple;
	bh=yEYBuvLd/BthcXjgBviK2z+dPWoq/XyaCHn4ndnWrcg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=hws1iv7PEYQAkfIaFvNHdNPr8l9rBMkufLeCEFAwcExWgXL7Z0FMv5uaqAhP+9wXV+Q+YzfBgtF19isKY8E2HG8XGOaQPwL8KBbsX+l0KGQxfVJZIEWNBfT1Nw1+KbEdmuhIrUpByTCr8zMnw+VsneQ85gkCP5PytdnNrUl4V+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8LWrMD9; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8LWrMD9"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8be92e393f8so38183285a.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 13:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767648694; x=1768253494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XhBC7rXz1pRImrcbPp+woVkaMumJ5RxzSRmSj0UEHEQ=;
        b=g8LWrMD9FP27Styy1hoX7+OrA2RJACC88AxL5jwQPdBew+p1iycMOxfuJzPtYjO0wq
         kmTaQIMzpw6K9JSNLjJGxJfDjvWV+UlaaRyHstAdJ78zPaS5LVusrewPeroJYqo98R3A
         03MCOkbDsCzbldGPU2biIpvG0/p6e1D2y94sNeTteMJCTgl8AnTY93l7j4zGUpPJPeZg
         LBWlQexw40QjQPnKGa/SwaFWVaPJeNAgGdyI6OjcSYInZsO7en4nszpdDwyVABbDwqgh
         CbBFdm1N/GVNw7X19ZpTFH+A5m9efpTi56aPHytdpLlir6hUq2KnB0kL7dCLhPf1n/uA
         7Kqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767648694; x=1768253494;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XhBC7rXz1pRImrcbPp+woVkaMumJ5RxzSRmSj0UEHEQ=;
        b=AAyz0vxXFTKa2Hc18fTigRrkKpjlR5yu97or4qGwcFDObbAcRv/nm1HcZzIjp6/cjE
         b2e9daYj0FSj00ve8bvDpxDwNM3xKxAHfj4zaOCBNtA+9PuYOGKwAUmnI1c/YDV6CsQg
         BgnkPPVOxqaL6uA22/7iPz63PYYl1Q7HeaQNpOWLmiPaPPLjK51dBMIHXCXVLM7R85F7
         oz+iFX1Egh/kMjaOyYxX7HhViSljlxEvkfZLYmiI02Utkzm5FGojX6Ahbnnf0JXWN25X
         LhIiCT7kvsQYwrzprkWuec3QBXLnqVWuxzdVRMA4OtuCluk0WYjzVTLQknxbuKsRfXU2
         BE5w==
X-Forwarded-Encrypted: i=1; AJvYcCWvKnurzWqrXbceiEQ4D/FTNENlNiGwaJV6kVnN+jgSTGUZsMGVft2iikA3IRGD/dxrYhEmgN+5UA6Z@vger.kernel.org
X-Gm-Message-State: AOJu0YzohVgKzXHRVGT6GGJofxPA5c8czE+cJ/X4uZEfJzs/OO+4mYgE
	U8jiP872iX5Klxs6OeDdQ5/3TfUVUPBACS3nyeEEF1w80SurGAbu+WJU
X-Gm-Gg: AY/fxX64S9ytQJTBkNCiPuc1lwiOaeR4U1xypXTrJPdKuyApHd0802F1l0q+77ARqT2
	S+FZkZTDh37CSR+5NC4Ael5vIB0EAhX7qm0zskXlLQDtW8SbNWGk8rysHNrTuayruTwFw2PWj7D
	/ztJH76nu+YNpkwr4MQfrOY4Xa8v8dflNEj+s8+M9kBpLF510zll4pA3MljRn9tSFIkdiongUHZ
	VxuKSYU53F55NxwvAT7j8Erc41Yivw2yuejVtcZ+6K8uN6PgTJMz/ZR7rR/19CyLfNX21UlWrkI
	ofCDrhdUQJ3WwbH3MBEf31aVruZAQOvaV8uoWV4PYnKkNQuWhBZg4q5to6Q7CzHBdfHFh78oEY3
	txRz0JoJIaoJZWN3kE1SkkspFwwTqYryVDdvhNhXJPYgnIlTd55TD2VH1KvbQcRUxzfpVRrty33
	B4a1jdX6JSlu1X/d5ECzofGD7xzvdr3ElI
X-Google-Smtp-Source: AGHT+IGjGuVVtc4a9gZlmcnbYKV3HMs0PzUAQZ58Z3IxzCp1ryp/OyBq+hta8t2JtYK0yjLVBi/v5Q==
X-Received: by 2002:a05:620a:4508:b0:8b2:e3c1:24b7 with SMTP id af79cd13be357-8c37f535f19mr90357985a.29.1767648693845;
        Mon, 05 Jan 2026 13:31:33 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51d06fsm33450785a.32.2026.01.05.13.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:31:32 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Nilesh Javali <njavali@marvell.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	Saurav Kashyap <saurav.kashyap@qlogic.com>,
	Quinn Tran <quinn.tran@qlogic.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Remove redundant and conflicting initialization in qlt_alloc_qfull_cmd
Date: Mon,  5 Jan 2026 21:31:29 +0000
Message-Id: <20260105213129.46096-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove the unconditional initialization of cmd->q_full = 1 at the
beginning of qlt_alloc_qfull_cmd().

Perform initialization of the q_full and term_exchg flags exclusively
within the conditional branches based on the qfull input parameter.
This change eliminates the redundant assignment when qfull is true and
avoids the unnecessary overwrite of the flag when qfull is false.

Ensure that the command state accurately and explicitly reflects its
intended purpose—either a "Queue Full" event or an "Exchange Termination"
—without relying on a conflicting default value.

Fixes: 33e799775593 ("qla2xxx: Add support for QFull throttling and Term Exchange retry")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d772136984c9..560ff42ce3c7 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6682,7 +6682,6 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	cmd->tgt = vha->vha_tgt.qla_tgt;
 	cmd->vha = vha;
 	cmd->reset_count = ha->base_qpair->chip_reset;
-	cmd->q_full = 1;
 	cmd->qpair = ha->base_qpair;
 	cmd->cdb = &cmd->atio.u.isp24.fcp_cmnd.cdb[0];
 	cmd->cdb_len = 16;
@@ -6691,8 +6690,10 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 		cmd->q_full = 1;
 		/* NOTE: borrowing the state field to carry the status */
 		cmd->state = status;
-	} else
+	} else {
+		cmd->q_full = 0;
 		cmd->term_exchg = 1;
+	}
 
 	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
 	list_add_tail(&cmd->cmd_list, &vha->hw->tgt.q_full_list);
-- 
2.25.1

