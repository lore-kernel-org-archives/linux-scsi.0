Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26D532B118
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618092; cv=none; b=TnNOmqnva2V5mfSIWENzaaTgCpgKe6UMwoLcyewIqA4NBq6godWRg66fggzk6cm22nrTxNyY5mdzhIwJzalaSeGS/sZBZLp5W5HcUQEx+wW2n6OxR+puqgAiJKuzkhmwc5F2xLk17MBwj6zDAYypni8ONE0adXlREEnnLs65Sv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618092; c=relaxed/simple;
	bh=ue3MImAfshTciV5CP2v5dyozlHFYNQmwC/uYJtRPG9k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J2vvK5YLAs6rcTD60yNJhyLrSqkYY+8zObl6xhqB+ylvtvP+oRA8uxZUNV4+7nde1GfvKDzPzK6U2fEpyjCrWRx+M+4GLCTpKRljW9ehqbGUGlDefGkxsbzMQllWG60hOgBwt+6lQ08OfHdC7Ch0g2qmA7YN/394i7cnXYHhUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FYadJ2n5; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYadJ2n5"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3413069aa25so2150636eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618090; x=1791222890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nb3k6qBFhPpU/4/zuAd7NfdOPBBAf8lJ1iTwp3vFBQM=;
        b=FYadJ2n5kzYlA+oku4Aj0STG0PMgN1kWt5tTZApHRT7A0ERamgqkqFg1YZKqFOR+W2
         LC1fZ1Ik+9vsDWrtXiuQ66CwHZfZ/m8BN/z0ZUPzoxvqpbVRk4CEwDKSLIic+EOm7fMV
         dfR4k80xeWsOf2lJHVjPkovrMFgfrSPK+XWyef+K+pkDJyYvfEx+fGgjP02agBHcmTd8
         SBMSX9WjsVXAiUDtjW/nX/gr0a6XTOAxzrmSKroUV2AuHcgtxidYupFboiKX7hlZYOL0
         Wnpz7SY5cQSQWcfL8yN8tnDiXCywJ5rc0kvRx2+QmC0vDn6Q39TI/Ct/i3QDBfwEsjII
         x31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618090; x=1791222890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nb3k6qBFhPpU/4/zuAd7NfdOPBBAf8lJ1iTwp3vFBQM=;
        b=SOH7o1RYNCW3lFFo2NySwTtXa/CKBYBKnhOi4i41wcSGkNMbQsJAwLH88EpLCCUMPO
         8QWnBX8OI9lyf/mMVCjqqbx6RZu5Qh4P1b8Y5YOqOZRNq6G2X/bfChwrVk3HLMzkhICD
         uGanNmrYd2IVT/k7AVsBJxU0fc0e8zb/L1Ub3gL9Qo5CLHJZoiB3faDB1/vUjm9IJOBi
         Wlv0eZfLNDe244w072GyEa/a4svW2Uv4UawqlT0JV5dBgamWhNJJ5wbpcJQyLltRhDZs
         z6G0pyyjj9CqabJ5fIBjGvOm0sj33pikfLvrRS2m5sZz9B1xKF3MIxG+LM+igS4SZk5N
         Y5+Q==
X-Gm-Message-State: AFq9FYItA27uKifcI3/1B1rW8waLZShbY2zsmmGj7cZ3euUkboq2nEMD
	Jlrn+Hl9zwTQUMPYU+JvUWEl4se/DKIGZrp2X25YqOYUaEBZyIEbQqWgKg5V7z8M
X-Gm-Gg: AYBFou1XdVP4u+W8IJh0uC8iLcWxlL3fBn5Gj0gdP8wl44ALK9LW2RD6T0AW6VwwPpF
	DD8Pe6ti/vJ4+V0BuM4beT0841L1cp4cvQRNxaYtIS64V88eedlC42UdjdlvtzdIJEzJPDWx7Ii
	6KVSkM11iYwQDGvx4sUTyKaDWnZDArvwJuKpT3MPSXkhuik8Rnt/Jj0+oTXf5Df2sHFZdLQghhS
	RoMTdzdL46T8XurqjYR53k+NC5QuHKDKj5Hpzf88lg9nt/X8op3k7r86AIs5arOYmH9sVPXC3gb
	KPPmdxmLhSUdL/OAa1Qx+5Cgx37JVgjNCtGh00BoeZ8EEHG79RNVJiWeCvNfs65UaOXpyAqMbrg
	1iR0bPEIn7oftbCUTSXUulVXc93uoXkdOncwO8/bQ2WX/w56NTtlvM0/ispN8YyP9FnVVYdRRJ/
	7mIQ+Gznv0k/GO5peN0cojh+7MmfLJKNEnScD0zbrzMSbx55gaujrYSusFzxA5UJhi/C8MLi4ze
	bmHyCALEJRA86omXrAaW2/xZ+bj4wkq2EswFXRr7UP+J2oc9lor8rw8Eg==
X-Received: by 2002:a05:693c:6215:b0:33b:afc9:caa9 with SMTP id 5a478bee46e88-34274332a13mr13449197eec.38.1790618089378;
        Mon, 28 Sep 2026 10:54:49 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.54.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:54:48 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 01/10] lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
Date: Mon, 28 Sep 2026 11:17:48 -0700
Message-Id: <20260928181757.21959-2-nkirkland2304@gmail.com>
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

In lpfc_cmpl_ct_cmd_vmid, there is an early call to lpfc_ct_free_iocb
when cmd is SLI_CTAS_DALLAPP_ID.  Within lpfc_ct_free_iocb the
cmdiocb->rsp_dmabuf will be freed.  This means any ctrsp ptr
dereference for SLI_CT_RESPONSE_FS_RJT or even ctrsp->ReasonCode and
ctrsp->Explanation when handling a CT LS_RJT response is a
use-after-free.

Remove the early lpfc_ct_free_iocb call for SLI_CTAS_DALLAPP_ID.
There already is a free_res label that calls lpfc_ct_free_iocb so
there doesn't need to be an early lpfc_ct_free_iocb at the start of
lpfc_cmpl_ct_cmd_vmid.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0734ab3be3e3..f709e5087577 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3576,8 +3576,6 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	int i;
 
 	cmd = be16_to_cpu(ctcmd->CommandResponse.bits.CmdRsp);
-	if (cmd == SLI_CTAS_DALLAPP_ID)
-		lpfc_ct_free_iocb(phba, cmdiocb);
 
 	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
 		if (cmd != SLI_CTAS_DALLAPP_ID)
-- 
2.38.0

