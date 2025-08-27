Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105932EAB6D;
	Wed, 27 Aug 2025 21:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756331155; cv=none; b=VAa6a0fddY8OE5vkrbLZ/pIijo9JJPhX0E28jxHuHNXug1e9xueDL+jquirSgvANKRj/gmG+KjhHLvKfM60WjMaOViorJdu1zKmfbOFt796uPSiMVgqffXevglhTi5wITPWUV7dmGvqHVqKj+C09Z6cPrMIdN6QMbodl3KS+ajg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756331155; c=relaxed/simple;
	bh=lW+KKbGwe58r6KqnEQZQdWWOb/U79mT0k10tLt6KMF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ong796FOJQdXhrlwhvfbtOau8dJeIUsC92I4m/Dp51+9V8inRq1bAcA9TLutN3Q27OkM5HuaMMpSbo25/+ZenzJneRYxhQI0w08cG6d6C4pNNPvsSqwbxfGlH7y6+Kr6HIxHm/avqUr83Fa01cdmktykzCI/wXsRrZVdIwvTing=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LjCp83OS; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LjCp83OS"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-30cceb3be82so293402fac.2;
        Wed, 27 Aug 2025 14:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756331153; x=1756935953; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LUrauvtwu2W119rfRMW5e2S4jfehzM8m9wXYieQYqSo=;
        b=LjCp83OSea3/LfQsBu8kiwIx0j0paZagFIjwjFHQCAYkjQRBUAd7uXxwv06qV3VFVU
         i1ThMcWgDJaSeUWxLnCmTm2QaQhU0F+2LNqHgQ4fRcJ6KpUjbKajh8k5Bw8DuLNUTw6T
         +xOZ9Hv2kiuPOEQfgZVOU9FatG6ShSqry9ecMX9oM9SHrJw5qYAJdYnMgE2Tn35j+1ez
         cW2hoszA2GoJydkyffRTUcXLivuUpWJMrkv6eTmSBRMkSbRtoIrQam9P9YXV1gHJjmcc
         NhRjafohfyk4OWGbX9qVpYSTi7Sbi0vwqGZP6rk8KXlo8u2zZfGZvlzo3gOwPl8edcuG
         d/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756331153; x=1756935953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LUrauvtwu2W119rfRMW5e2S4jfehzM8m9wXYieQYqSo=;
        b=GjkGHHTRKbB+QaA4UZeaKzNcT8stqJlIBeFzVJnI+LBv2lIlskxIow3FIB0e5zgOCc
         uyI3hfse+DB7Jsd7Qbv06xfmG55T0QRhoKeicsJpG1/i96Dfndl+Nw3Ao25pd+e5pNHP
         Ks1NCfq/6rSeLOm+dogsSrqdGs8ZtwstujQYtN2fgnIC3JjYKVspkdFfVCGh8CFkvrEr
         JCEo7lTS6G1l2ryk9IJ2JR/mnM+SnhJ9WrpQvEWjNfJoxk6OEAX/foiKpR11430Dnc0c
         C1V+JfUN7Q0kntdNtxhvrdEkDhLMAV5lDAQ69/BymiqrwJfvgnHgR/pIxLM5R1vQXd5b
         ImyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBizLxaPXdXrSFix9C/UUnD2ptqFP43k9aNT96td+KzNMa3/NHmM/EfVsP0wQYobrqap1C7W9Uf0uogA==@vger.kernel.org, AJvYcCURZYp5vzGpvLvLwMpV1O2WYZ0TsBxO6o5T25A7k9/Sy0Rsg0Y6umNDEDr+/CBej+gggGsM3tFsQj+z1ZY=@vger.kernel.org, AJvYcCV5E/IY379sKOeXcFIjS8A3yWwnKdo6ofHIjSKakVYz8CHiUZZB47Z7wXofnhw/I6Gssjy82JoR@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Ghkxs/GF3lnm+Bn+JpmFOiDvYVt8+rCLES0EW3m3Vkv3vGXz
	JsdZRlsxScW5UYYY1EmU9zEgu5QAc+SxBMAUsVIwC5hFuvJQsruX1T81tEWi9eKsRDVEQOswC3D
	2py0JeGAV1gl7Fjdhly5V4CWfHpplIbIm4Lo8
X-Gm-Gg: ASbGncvGvNBA1LbfLgxG6ayIB81HgvQ8oamDC2Jak8xyFfhv/ylJvTMgpVjirCo8GRQ
	zfDJifHnfGeR7o468D8DTj/ginFNHwosJn9sT8JabxzrvU2TicJDEj3W7sSSKBeq0/2m4Xz/sjb
	kXYYYbUVHePZy9VT2pxSTVMhpKX7rbKAMvjMVs2ai3y6uFj/wkl+5jlBgGiilhKfWy1oYYM2uyd
	gpVrhKl9gqMO2EnYbo=
X-Google-Smtp-Source: AGHT+IHSW7spTIH9AFthG4zHmAsL6v/aQYPQ1pjUfKWPLeIfYjBzm0dV/Mg2kJB60nI6RAYzGPNT0kKbj3HrPkw2Da0=
X-Received: by 2002:a05:690c:e0d:b0:71e:759c:f7bc with SMTP id
 00721157ae682-71fdc43724cmr247244277b3.36.1756330788260; Wed, 27 Aug 2025
 14:39:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250826195645.720-1-evans1210144@gmail.com> <CABPRKS_bKK-6ph1ETQ1pLsY_KPPQBnCyBsqfd9V2JrOQXHQT7Q@mail.gmail.com>
 <CA+KyXhKX1n6fsjfRE_ocu5rKsP3Yp4UoEGVyq_=TZwftnWLdkw@mail.gmail.com>
In-Reply-To: <CA+KyXhKX1n6fsjfRE_ocu5rKsP3Yp4UoEGVyq_=TZwftnWLdkw@mail.gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Wed, 27 Aug 2025 14:39:25 -0700
X-Gm-Features: Ac12FXzXuHU8HLBelj2Jx1McWTtlvi_S5_UeoTFZWxLoKoZQo9y3T6ZY7KpvyIg
Message-ID: <CABPRKS-DZ9hY99QfVKuHNEt3m3AF2iLb7TP8j6+gPsGMux+Xdg@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix buffer free/clear order in deferred
 receive path
To: John Evans <evans1210144@gmail.com>
Cc: james.smart@broadcom.com, Justin Tee <justin.tee@broadcom.com>, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi John,

Ah okay, then how about moving where we take the ctxp->ctxlock?

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index fba2e62027b7..3d8ab456ced5 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1243,7 +1243,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_target_port *tgtport,
        struct lpfc_nvmet_tgtport *tgtp;
        struct lpfc_async_xchg_ctx *ctxp =
                container_of(rsp, struct lpfc_async_xchg_ctx, hdlrctx.fcp_req);
-       struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
+       struct rqb_dmabuf *nvmebuf;
        struct lpfc_hba *phba = ctxp->phba;
        unsigned long iflag;

@@ -1251,11 +1251,14 @@ lpfc_nvmet_defer_rcv(struct
nvmet_fc_target_port *tgtport,
        lpfc_nvmeio_data(phba, "NVMET DEFERRCV: xri x%x sz %d CPU %02x\n",
                         ctxp->oxid, ctxp->size, raw_smp_processor_id());

+       spin_lock_irqsave(&ctxp->ctxlock, iflag);
+       nvmebuf = ctxp->rqb_buffer;
        if (!nvmebuf) {
                lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
                                "6425 Defer rcv: no buffer oxid x%x: "
                                "flg %x ste %x\n",
                                ctxp->oxid, ctxp->flag, ctxp->state);
+               spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
                return;
        }

@@ -1264,10 +1267,9 @@ lpfc_nvmet_defer_rcv(struct
nvmet_fc_target_port *tgtport,
                atomic_inc(&tgtp->rcv_fcp_cmd_defer);

        /* Free the nvmebuf since a new buffer already replaced it */
-       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
-       spin_lock_irqsave(&ctxp->ctxlock, iflag);
        ctxp->rqb_buffer = NULL;
        spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
+       nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
 }

Regards,
Justin
