Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8D48FF9F
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682254; cv=none; b=dFZz4glhT9JHhOnFNE8H6lu7zOPilu8divBa/IKN+vn20MGv7ChF3t6NbQmyHvr5b+y75H5EaNoN2IpvHvkMIN1lZUSd95ReYTwbZpT3PJORas1psYUa2V4x6hqSL4Q9BPOHUslnU1p5Sg8NJFfgXhFZjtI5CvePYi9+uWbP160=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682254; c=relaxed/simple;
	bh=8BmigP9OEyKyx4lqN2CgQWec9pprrETphDLdlyw6Pes=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f4RXwm085UaaISIK2QhylBeA1Uxe72drxk2PjXnnDLUvnlNHflJVx3Nmofh6pBSxeo3/JtDao1cag8NobPZ61HgL2iSUxugIBUmBTKiQwCPS5giiyq3m/SukH8zVGXB/OXzKGy32yZy1CZEuZ/pi0uaIsr4isnyUzP6fK0fm5aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rWuuNKN3; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rWuuNKN3"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so109869a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682251; x=1790287051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NjtCSAxRw9b79rhyms8Yi2+SOwHyCbnju7LQAL5xcTA=;
        b=rWuuNKN3HBTPVit+MUQa86ZSPJjjKLkKY7yUHS5pPHt0xNSQITpnT85CpvpweQFZUE
         +r97rGwpt7V6bY28z2r7LjSy10Of0rJKxWA4d9euFxjEolF34TQ1QbRmZdS8xc9BRC1w
         sXgrsu4zrHFcD8ixDmDHa0Hb8yRnJt2Q4TmAIBLWEUatOHkmymEPorUSjPGvrmp7qaDA
         ZDpAARMetSDlRJxTK1ACTpltgPKfIlfKF4Gj5awvcTKgok/lX0A9GpEctCqS8EKLsxuH
         Sb2TieZpx6z1yTOvqlz+ZUP+tQYpIlh4cIqBgBcfTb3tNYgbTZN0yak9fJ8wPnavcltQ
         4c5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682251; x=1790287051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjtCSAxRw9b79rhyms8Yi2+SOwHyCbnju7LQAL5xcTA=;
        b=v87Q2e8/PSi3E4FB9YBs7kv8A0jXZ8e+9tNRDDZ6yZjGpTGYLkQ1kxC1X44Lj48u1F
         biU3IygmZIYwjhkXUCia5I5HhMYg4Dmw9MBmaXb9npA1q4AZUEFLPeIVXOidlQIREPOd
         muR8FbGE1xPa+x49OQmavc1vpoU0MS7rnPb83RTwZfu2sarvfqSSgv4U8eV0vMLIOYEe
         Ksz0aSGc6165aha2YrvEjxl9SJvSfP6wueC3Z807AwD6Ov9sVOkfXeJ/s6ff0r/lNaHL
         RThN/MQh1VBZO3pBDG4spDRF2TpsrXbvnSa9grwGRTlBIpQ7Flfwd5bREJUgCnBVAuoZ
         04lA==
X-Gm-Message-State: AFuF++lzWz+XuwlzFzZNP48nuJYu6niws8OEjQv7Wn4lcBDMotoMhXVx
	PnmEosdp2gRHc0NFBh5f341nlr+8EoZ95cJXmAYH1etbu3WJI1OfpuZUOgKyLQ==
X-Gm-Gg: AYBFou21yhhMCjbkAb6Y+GwCTiRilfehLxU3hhz6ONsLUaTU7FghCD6/fDFge6wrTZf
	4VE7uxhl+GvpN8b1G8DvLZI6Oezwbh3ChvXU/g7//FTmeQGtekX+5tAv/AhMgcpl/NgFC3NxZvp
	gZ2ojwO46BT/B52nG1EXRWCMhzv2HnuPsBOyBy/Z+1CEQU+1i8tMobsbRBsoGexPjYq9PJcD8lM
	8IX7ORWjq1O4onhr0cffikJtKi/Yki1bPhAPd4uTAASXHNIgsIMI0BOz/dQnWJT/aAF0zr5ATic
	pWUlPn5H6hI54IkX7uSkDmtsABT7TpKNj3S6CA+nZqHJSGBPD4FkR7Ul1zvhUW+zJuS2rssZKOt
	0voPy1DYvOB7TkX3vhgHPYRjSBV01kaC0qsEBsfPR+OClitXY0T8zS/3k0dNF7Wc/TWLDiWGX0+
	J5tLOX4LHWYeO+dAjedJi6dSbiAyzzXSGwp+zrFN5+BBFa9tzaui3cwRYHW8n2jwn0rbuqV4UHm
	p7a5qAuRYBx32I8GoJ3nEB/zP2NYjWs28KgZTzWNtZcg27pWDVAFqSJAxo=
X-Received: by 2002:a17:90b:17cb:b0:38e:57a3:f218 with SMTP id 98e67ed59e1d1-39e54d13343mr984087a91.13.1789682251200;
        Thu, 17 Sep 2026 14:57:31 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:30 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 01/14] lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
Date: Thu, 17 Sep 2026 15:20:02 -0700
Message-Id: <20260917222015.61053-2-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In lpfc_cmpl_ct_cmd_vmid, there is an early call to lpfc_ct_free_iocb when
cmd is SLI_CTAS_DALLAPP_ID.  Within lpfc_ct_free_iocb the
cmdiocb->rsp_dmabuf will be freed.  This means any ctrsp ptr dereference
for SLI_CT_RESPONSE_FS_RJT or even ctrsp->ReasonCode and ctrsp->Explanation
when handling a CT LS_RJT response is a use-after-free.

Remove the early lpfc_ct_free_iocb call for SLI_CTAS_DALLAPP_ID.  There
already is a free_res label that calls lpfc_ct_free_iocb so there doesn't
need to be an early lpfc_ct_free_iocb at the start of
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

