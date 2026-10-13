Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FD23CF962
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849191; cv=none; b=TiR8xdliO2wc/4ykuMO9ZByw5qx9v31I7mgxL9/TT51I0zyqViWcNvyYS6UPDOtq3/Wjjwt+WpiI8R7wMsrqdOvTHZQ+EC4l9aS4DJXf26CN5fXx2ksEBBwi61TwVqj9dfo9IqgB9RBnBiQosw9VMuez3FGvscMbHMpMMHXuPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849191; c=relaxed/simple;
	bh=Gmz1E92+p57a0NcJeAHTnZ+kMfjy+CoeJqXGVtDBpCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iwxTk4si8I1DaefDYtUYJNcbp4z6yAmkO1pCho9gTZA/VcKC92msZQ7K99on3+tbEtylbG37M7yLvR7jJoubzCZ3v1ooxNng74Dz88RU8e9k1WID6Iv19K1l+Cxpfl+YzyokKBAt8igZVnQ/mjP9jSkiM53JefNJx61CSOQcnmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XFMearAc; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFMearAc"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3514e7cbbbaso6003340eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849189; x=1792453989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9WY6kwNjrMeoSQPZxbnoG8blBMcmJUfSqb5DFYGoD5c=;
        b=XFMearAcBR8wn+thP7VRvZ9GxREX3592STgzIzg9XpGeseDKwkcRYvQY8u92j/7OT7
         Fyv5FY+pwL8z+8SCRaEeFIZOYCnfFEFFA3KuepyGJ4sHE3lrdTi2E6pzUcFjoiH4NAb7
         9NNcQPbeARyLPgvSG5AUNIhvm5xRlKKhacttUsAxdkPVmadG73Z5CmOjZEvQeh2sc/cZ
         yM6ItbTbtlXTZfRXLaR5kksSDTr4F1vknzXsG07ng+ORgBDZ7b35E5g4dcd2UlXt4X1u
         X9I4/dO3BL0cMA8xh3kix+arRKi0FzN6smE5yMBoXgxXAlHPuiPlpSnOHmXyIwdiGlhN
         43FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849189; x=1792453989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9WY6kwNjrMeoSQPZxbnoG8blBMcmJUfSqb5DFYGoD5c=;
        b=h2Ahw05usdnPJxFkP3kFwzbJO8Ct2NkMrrxtyRCK5U1PL+7bd5nIyCwkh5qIu1adAT
         qHlac1xPQ8rOojDVf8JHi2RfbWZRaCww+DLKHI+tv1WED2VwK5cXUC8ITvHEgG3/nsjE
         Bbp7b4c0fKv82JMAD1AtHyhglVqFi0f+gqtBBdawLHqKGr+WlTmBukTxI/C4qyfXGIYI
         Vtmqg4XZ5t0Le5CMprBZgsMlwE4+OTqwE96n5AW7svvJUVtioXjuXN/7NX3BRkjwMX9n
         2esnHqbCrfldnS8SpGIYikaIvx3QROcbpk87EFWJ57yTe0dqQ+Pv/w0Ht57SKzBJELvw
         ac9A==
X-Gm-Message-State: AFq9FYLv/j4RrCUtuMjzX0dItiI5FNbxD90yEnrLTRpL3LMacRFtv2GS
	dMe7au4zo4BoeXvSqXJU1SaK6fbEl2lYHbgZEGyyWX55W8mDZmzxTXuL/kYXVGuy
X-Gm-Gg: AYBFou2m0+IBdIb660I8XaybYXEglocDise2d1lJpBbBuglSSanyC+WFfDj9M7TGVe4
	7IrXKiqDTaXxfnHoO341dtgsPi7+FSwMyKv9oHajkMQQOacNFvnoNmE1mi9biACQ52PLSxOudbI
	ghry5OiwIb2CZ7A3aogo7yp+RnKDusEfJiGGRFaL3T0xi39F2E0J4FfIzoJw14WVRZFw5fnNitq
	1RcqvWAVYpkTS+YublgyZGxTFgt8r9fdSJuUjij4G+byMo5Y59o1ZgEHurrk8xX5TihdFEYkx6A
	U4IrBNo3CBYzNecayWGrw7vXQYl5t2R9OJZmREvc6YP6WF5Ia45RHgegj09tJiguDYM7D091eO3
	jdbg8g0G5OwMoK1kxQCJuBEmNNNfqq1hMEHx4eK7YnYFqPmWgLpG1OF4Ykr2SX8kbeF5y2N8615
	G7WboXVLROtb39pcAB3+CSIoQWMgGSwvVMxS3hmlOD92T5PsDhqeXGjyeZjXhYiDorDfXD95Ywt
	sgJi3QsfkqhA63MK1K+pTWf8c09CO/E1VOMkQFEyO5PE33rkExUjA/qkg==
X-Received: by 2002:a05:7301:d194:b0:35b:c271:df19 with SMTP id 5a478bee46e88-35bc271e8c1mr2820799eec.32.1791849188905;
        Mon, 12 Oct 2026 16:53:08 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:08 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 3/8] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
Date: Mon, 12 Oct 2026 17:16:43 -0700
Message-Id: <20261013001648.62289-4-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A kernel oops at dma_unmap_sg_attrs may occur due to a race between an
aborted scsi I/O completion and a scsi error handler issued TUR using the
same repurposed scsi_cmnd structure.

The LPFC_DRIVER_ABORTED cmd_flag is set when inflight I/Os are aborted
via lpfc_sli_abort_taskmgmt, and this flag is not cleared until after
scsi_done is called.  The inflight I/O test is changed to check scsi I/O
for either LFPC_IO_ON_TXCMPLQ or LPFC_DRIVER_ABORTED.  If either cmd_flag
is set, then the I/O should still be counted.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>

---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cd285e87c278..b370a64e6b67 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12730,8 +12730,12 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 
 		if (!iocbq || iocbq->vport != vport)
 			continue;
-		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
+		/* Only count FCP i/o */
+		if (!(iocbq->cmd_flag & LPFC_IO_FCP))
+			continue;
+		/* Count i/o whilst LLDD retains an interest in the scsi_cmnd */
+		if (!(iocbq->cmd_flag &
+				(LPFC_IO_ON_TXCMPLQ | LPFC_DRIVER_ABORTED)))
 			continue;
 
 		/* Include counting outstanding aborts */
-- 
2.38.0

