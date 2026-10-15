Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DC847A0DE
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049198; cv=none; b=KiXRby8btI3sxBBe0nns3ZAKKkWa8waRPwG2DHtVkHIST5XhTEix4/4n6At2RBEWVADO6l8Wlr5H1KYr2W/6n2MbRZLibzoSkSSddMTZCvFQuTYADNQ6jYrUHcmJMI3OvqOXYjmsOd9lo2TFd1zZanc4C3n6f9AQArfGLI83rvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049198; c=relaxed/simple;
	bh=cLnGrFj4fZ5QbMee1ofZJxYlwDb4ml+Hkm+YEE7tfAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwqOFA0rDMehDG2zeVQkjsKONsrhn2yRTjyaFujxjgPQ+s+5K+3j7Z0GhwH68m/AeQXIqsJrHj2r4OcX8QPxOpzhVmki3utlO21+vWCIqh0cD3vZSE+mAk9KRp6XJTO6nfPdQlOgfgZHHfXgBp179BEWLnpVbg4KdcyWOx+9k8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=j1VrVnfG; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="j1VrVnfG"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so3340156a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792049190; x=1792653990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HG1zhfPiMXRFUFNZwJgHDsR7OhzfKqj2uZPWv/pDLsM=;
        b=j1VrVnfGtPAF1eFkFt4AUMKxqOsuDqG6nCxFU7rct9BA7eCvr+LN2LW6i08BTjqBih
         22qP0iEGEldctit/2POBysC1/yMKqXF4sGVOa5WEjP9lDpaLVrupYfvEGUqIVDxvSLwA
         yxPYKupoOp/ctfAoF/uR1HuCx9Jz3dMkM/DY1IajJktUyNpgeg4UHEGj+1kT8bF27mtG
         d0V6cARL3NLeCJrlS0ryHmKigil1R0PZMBsC8GF51m+Nj7yb4VnNy3+DIf9O2F5q69NS
         pWSMLvASGEgzmxNafnI2cuIVwGpoY/7L4kiyKa3T5EfmmRZyX9jVFO92+kc65Agnjgtr
         13fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792049190; x=1792653990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HG1zhfPiMXRFUFNZwJgHDsR7OhzfKqj2uZPWv/pDLsM=;
        b=TLShRBmRX7JO157smQvna4wJ5zqMNxlXg2iW9uCpU+oY85mg/TE2AGFhgjZQY3cSvB
         gzFfNi+7OpSeh8onkMZPIqxPeKKveZ7xxVIwOMNI0//rYXyf08E+E9qjVXWG3o2RY8m/
         uLvj6KZqUlNADWszFF0C1DvMHDj3J5jvE4zIiNPPjeGSpVhkUbutdwYl486CwJYpuw7m
         gJl6DWGR0/b4qkENmISpOxI/GTjubFOq2pCUAuMvlHRtG8I/fblS1pioy6rUMb6oOn/P
         NAKXMWfIuvnFWDQ4NWF4jGlyf7S8zld1S/oxv0LQUd3OYxeoZQK9clCnvurr3S43aKeJ
         nV8Q==
X-Gm-Message-State: AFq9FYIpbjwaq/hmDrzgRgTZNnsP0NvHXxuOjMEwJeyVA2+6OsJsYceh
	qj+1WADmTZKa6ANA7mzNq/N/MdpM/4dvLF9dJFPWWi/d4DZy70NcjhSUNgrO7dPcV3I=
X-Gm-Gg: AYBFou3o+3G91l53BGrf32A3Im0OsBvPdpbU4y5fvgZnLL7Ho6QKUO2ESnYTsdZ7ud0
	zTLZG4zpyVaI68gB1fqvm6aQqmnCRbcPhwzan5HXLKjt5/y1/fK8EW9p0c/8YLVvTLMJ2pC6dOg
	BqwwHJ56h+Kil8KTVEadrH/e1Yj2HGC+yl4rgnlyCycmN+hYUYa8EHyfVcLj+7Nnv7s8jR0oIrp
	PtoFC5NkLXnkEeKYCND1qByts7/gmI32bRWgV5FoiCN/f7zndyXp0nkgHmFFgtUE2FhufHgVDRa
	aOuvhmA5n5vAdK8lqzLhhWQ6+pFvyT8cWxiP2SHtdKWpgteU+P8SmIpMIcxFHyQGCUBEXveH2pj
	iUuBsKuw+4kd6ME+GQEJvdNaUY6kcz3uFrQZ5dp7F9c8XOqQ/CFHldPCQ5o1uAWegMLrf0jR1Tg
	EpD60bCyEQD2J6NYrwRAG+22SU2mLdGQk+BELNa36jZUZq/k3K3kRt/NUa2gmDi3Wd2rTi7a7YY
	OAEj8A=
X-Received: by 2002:a17:90b:224c:b0:3a7:a3c8:8f4a with SMTP id 98e67ed59e1d1-3ab3a9a8dbbmr12756043a91.18.1792049189573;
        Thu, 15 Oct 2026 00:26:29 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac937c4e7asm1754279a91.3.2026.10.15.00.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:26:29 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 3/3] scsi: aic94xx: validate the EDB index in asd_get_tmf_resp_tasklet()
Date: Thu, 15 Oct 2026 16:26:12 +0900
Message-ID: <20261015072612.4144043-4-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

asd_get_tmf_resp_tasklet() extracts the empty data buffer index from the
done list status block exactly as asd_get_response_tasklet() does:

	int  edb_id = ((resp_sb->flags & 0x70) >> 4)-1;

and indexes seq->edb_arr[] with it unchecked:

	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
	ascb->tag = *(__be16 *)(edb->vaddr+4);

The field is three bits, so the value runs from -1 to 6, and the first
ESCB has edb_index 0, which makes seq->edb_arr[-1] reachable arithmetic.
asd_invalidate_edb() at the end of the function uses the same value
again.

Apply the same check as the preceding patch and return res, which is
TMF_RESP_FUNC_FAILED at that point, the way the lookup failure above it
already does.

The caveats are the ones on that patch: the sequencer is firmware loaded
with request_firmware() and nothing in the tree describes what it may put
in this field, so this is not a claim of a reachable out-of-bounds
access, and a response dropped here leaves its ESCB uninvalidated and
unreposted.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_tmf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 28ac92b041fe3..1ee6009d83051 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -282,6 +282,12 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb *ascb,
 		return res;
 	}
 
+	if (edb_id < 0 || edb_id >= ASD_EDBS_PER_SCB) {
+		ASD_DPRINTK("edb_id is %d! resp_sb->flags is 0x%x\n",
+			    edb_id, resp_sb->flags);
+		return res;
+	}
+
 	edb = asd_ha->seq.edb_arr[edb_id + escb->edb_index];
 	ascb->tag = *(__be16 *)(edb->vaddr+4);
 	fh = edb->vaddr + 16;
-- 
2.43.0

