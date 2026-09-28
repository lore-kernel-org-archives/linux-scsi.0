Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930674A2A5E
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618106; cv=none; b=FH9m3CZfdrzpkCzFLIDgOt8m9PQMKYsN6N5xOAMgQAbENT+gmQaYKRMvNgDxdZI71KQ39gNbbS0kk/XX9tK85Ed1bMmGTLope0CJvGIuWsXD53LQKfMWRAXJK3eHf3cWaMMRUVgW8IU2HBlDH0kOvPAd6BlEh/dqI7SkY972cP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618106; c=relaxed/simple;
	bh=22mIqSDlZQUq7KkYY9L+O13Rxah5dSBZ7ZvMss5f7uI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EogB3pDfyh9JsygCDSCmQYAyAURtyWDTspI2yuFRI2I6AsjOaLx+oiKH+eUS0r0c05IRTA0OmGs6GGXDOFeLq4GDBvZDQzoxEVVpVeOEOCNJVqlylnobanZBQViHxweOTYPVdwrxrB0EW/PaFha4dK6Iph36B9aQPKVTQczsrVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n7OqAijp; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n7OqAijp"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3410209aa6aso36693eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618104; x=1791222904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rHFNsG/h4lZzbRhf1FVfYb4O1tICsVNReFUcj5wWc4U=;
        b=n7OqAijpbww+OpVRwQpJIqb3iVp9qLJMyU8vf4EgBqrf6eixSfLwdwRDugKaKJV1nf
         qDvCP8SmIVwLjsLHkqtitt62diP9ZG7JPH8WrKf/jy45y1H9C7IbpiFiGm1+nZU87SQF
         xmJZ0hUcqWhgL+p+8VwcIqnBNuIMClfLnYcABd8byUynGanIcDarTBlzUqzjHjkXt4mt
         nXkcsyuW5AGKW7o840irP3+1ZfUtm/bF9weeJHVY7rIkCAUckCen3AJRqpE44SNGBXej
         t55fvSGzk8U9YIGj88fPFqE8f9oj9n2MWUNvOIXEwhBnDiCenmNMaaS/ETZdnZ6yCP9Y
         ppEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618104; x=1791222904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rHFNsG/h4lZzbRhf1FVfYb4O1tICsVNReFUcj5wWc4U=;
        b=eMMYKHrkc2kx7ZJRFhxWccA9sWp7g4JKQFkxT5lnTkTc21Y4QDHvr8bocEQRibQA17
         tS7np2tuDAp7Qqe4dlNkwW3yDUsNDWUulCLYZnYIZVg/6C//auU4j7gxCFho2tgrsdg7
         Sh4TCEYDkjY4pTHarr8QWsWYmoFSi7H+d2M9LaCrAZuHNlwGRqJZXBezJ0vpk7G2WSNr
         MjOlJi2JFvBaaMZcIqkkhI5wZwHGt9z37vBfzp3RfY/OuqOrG0TpnN8sybsrVj1FeIff
         XsXW0PeglGzipjViYdVLPVcjMIF1CLxGYE9Cwgtu3QqF1hISypOXjmC3sTPmsaRZZvXG
         9Qqw==
X-Gm-Message-State: AFq9FYL5qFxjGOZopoJTM5Yl6gyGdu12rlUrI0mnxK8golkLLTV4GjgK
	TWnrqNI8MMWl8hlk7jwBnsdB35ILFhtXwacuDjnv+UvbYRc8oSWkrzJFsQmBYv38
X-Gm-Gg: AYBFou1xM8fSneT6xYXSVdi6fJqFXGVOl54eMqdH8bVr11+ztKPqKWc7aJIHDbfnmsO
	12lX9+eDqQOpUA1CsiJfI6eIGH5jfgiqPPfyQWX5fxMQLgKT3h7qTmWyqnR7VgBer88JOAkKL9A
	95QrJcrhMGnC2Ctqc1iHWbXiM53z2vFpmYAEsygmAkqwXkohEofp3K2qag0Ow9oT0Sam3zA85SC
	XnEkbW1xNAQM8s+EPVtIdS1oQBvAouhxNNLgwO4VRwMRC+I9GuZfGGuiWQEwnmbps/OEhao17rn
	2bMkr26gxIAxNvWAvbuJ3Sq4vrUKR8hd7Qu8WuKb1ZKWl++TxU6GU/vjP6O0UbMz/Cti8oJ/m3Z
	S+5pEXFGBovzXSHAD890stiyH8EgDoC6he1QOOjZrADd04dqZJRZ0EJznEUttVMhS7JlDJg2bjD
	QfOj+ukQfk4O4b5rMJ3h3hd9ykfxsc6CW4LxJzIS3EKZrUOGqGhhItBVPn+5l8f9ooAb0YjKqa+
	ljmi9mdEXsVF2x+WfgJbV+AGDtSqhCJNPkICZRVfYgDx9Z02J4uSa5BcA==
X-Received: by 2002:a05:7300:a228:b0:332:946c:4778 with SMTP id 5a478bee46e88-34af83363c3mr128704eec.14.1790618103459;
        Mon, 28 Sep 2026 10:55:03 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.55.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:55:02 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 08/10] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
Date: Mon, 28 Sep 2026 11:17:55 -0700
Message-Id: <20260928181757.21959-9-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The lpfc_set_disctmo routine is not used for all cases when the driver
needs to restart discovery on the fc_disctmo timer.  Not doing so, makes
discovery timer actions invisible in some cases as they do not get logged.
This patch substitutes calls on fc_disctmo to use lpfc_set_disctmo in
lpfc_els_rcv_rscn.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index cd431c7bd9f0..1793d9c6d8b8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8171,7 +8171,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i, tmo;
+	int i;
 
 	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
@@ -8250,11 +8250,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb,
 				ndlp, NULL);
 			/* Restart disctmo if its already running */
-			if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-				tmo = ((phba->fc_ratov * 3) + 3);
-				mod_timer(&vport->fc_disctmo,
-					  jiffies + secs_to_jiffies(tmo));
-			}
+			if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+				lpfc_set_disctmo(vport);
 			return 0;
 		}
 	}
@@ -8285,11 +8282,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		set_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
 
 		/* Restart disctmo if its already running */
-		if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-			tmo = ((phba->fc_ratov * 3) + 3);
-			mod_timer(&vport->fc_disctmo,
-				  jiffies + secs_to_jiffies(tmo));
-		}
+		if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+			lpfc_set_disctmo(vport);
+
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag)) {
 			set_bit(FC_RSCN_MODE, &vport->fc_flag);
-- 
2.38.0

