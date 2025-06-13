Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975C2472B0
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 03:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784133; cv=none; b=KCLNcdVwRgUp11ctv16QriRxK0PGnOVhRgbQ8kGoefkf2D2RLWZ9vQa3YHjbxP+YsYgNtgBPIRwndT1gxeEkPROKleBS0tDFdZ0VKnG0cf+smhmHIYXn2sXjLj/T1Cj1t9HzSoERgtYuhvqjvwN501aOcHpyxbZMzK+5loCcrTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784133; c=relaxed/simple;
	bh=te63zQbWCSo0mXXkreplZyT4a26l+JieKkfYEFKB3+c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=jPVqsUjhJA2o/MhWpXM2hp6a6XjlfZ3I9y2b27GkuoQwRyMexk8+YsFo1JPJZqU8TfW3PSzOJEYRlS9LhKmBsULcLDmXFye4HsdKxhxvJTI2AncDJTnOGhlyi3XW5r5tZJnBvnV90/OVMD20o+ClpDwbYiQocG+w/ZXmP76pxPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NCsljuLa; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NCsljuLa"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so21107975e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 20:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749784130; x=1750388930; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NIxP3iombi8+uVGSIAyip6bKiFBuxxY9Jf5Cqzou2E4=;
        b=NCsljuLad6pswBA+CO7qyQrDDLL7vJpoC4pRfCGvatFZ8tbhi03AMHjVEu97l2Qael
         h5nX8nWN948hwzKzRyYYj60Ph80cEFWzu+lncA67IgbEs8x79lti5p4w+kXDPBQdIk7k
         B0Hyc5FtFzgvh5BWrC+Ogg0+JZS9KjY5MN9RMeS/zGesPdNuJfPUe8dc1y5Gl7v6kcRM
         g+jSCO2NM9iwduEjZdEpDg2o1qpQqZY+PwlOnR7Tu1QQvGqEwP83/QG99WDmfmQUZSVi
         LxAxXlmDdHOvHWFwEwH+HWSukWrfg2h0AQ7Mq7JeoPA865J4WIQ6dD+OLa8XRymm3UT/
         UA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749784130; x=1750388930;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NIxP3iombi8+uVGSIAyip6bKiFBuxxY9Jf5Cqzou2E4=;
        b=iWnT8RvsgtPLZiBFCH1xp8IpTtrzj2OAueTUe2QQYWT+9CLH01PGbqR7yyDOgShkPJ
         Ku0/LIlfxkVWapLijUFH/CmIvJ/kUsUpQ4yC0Q2DG2qEl4qwjcsuNmVMRYARzhgGustW
         ZpEkDINUiJWDL61YkAVUDdBaJlofoYkhTRtoQXzgfA/A60weIb7qkLbH31bEwwGociht
         uClxpcmQaOBYOQ24Qvev3Azf9nQPmPe3t+nxC98ZCmueNUNxEJtb2QhkO6DAp7lBoKNC
         VWhj1ABNgKrJAdpsStICivg8HsfmzbGl+G9OetLe3kXdJznJWp5NwuwBYbs2L9xFvOqu
         aIDA==
X-Gm-Message-State: AOJu0Yy8AeiK1npoGxr9TNPm6EO3cOiU3l22nSDAcqOSjERtDTTvgKWJ
	XFGyJ4XNa2WECyOr1+6+2G4f9luVUJ380ldSTqZmSsADzt2pKU6f1f3BBYaDy8D9+FHfB0Iim0o
	w9JnfK8NQoPrisqgHSJ7T0Kd8/oXbdMUYC2UhJh4=
X-Gm-Gg: ASbGncs7D8PeM6Eu6HPCd3vt7XjkG3VYjeZypSGTOHAvwEEEtGyUfc+0RD26M4WiMfy
	AkF7TmRmEGsW43+SMp64EghWR/4i5vMmXzH8SFy10Bg6SoxLvQ0uSJRshtJfjznZFOLj/Zx1RTi
	yDf3gifNNOebCx1JZzzziURweELlRb2T+c+mXsSmhYcKY=
X-Google-Smtp-Source: AGHT+IEjZ3Oe2Sn02M0OJ061yy4mKBw25sOfyCwwrO1bvsxx0xZIXaBAdVK2xX+RiP81nZcalBuGlGmFNa9nrR0QGHs=
X-Received: by 2002:a05:600c:4f49:b0:43c:ee3f:2c3 with SMTP id
 5b1f17b1804b1-45334ab7ebdmr9256075e9.7.1749784130001; Thu, 12 Jun 2025
 20:08:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?5YiY5oCd5rSL?= <theforsaken641@gmail.com>
Date: Fri, 13 Jun 2025 11:08:38 +0800
X-Gm-Features: AX0GCFsYRp2JDw_TIVDP8_XauID5zyCD5EFT-WSQA23XYsNU3lnw9QZMWLAEdIk
Message-ID: <CAOocBacoLFg5sz+Y4UL86h2gvmzZBUk2uJw2ocUgvk7tMVqB3g@mail.gmail.com>
Subject: memory leak vulnerability found in drivers/scsi/qedf
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I found a memory leak vulnerability in
linux/drivers/scsi/qedf/qedf_main.c , qedf_prepare_sb Function Due to
Missing Resource Cleanup in Error Path.

The qedf_prepare_sb function allocates resources in a loop for
multiple queues. If an allocation fails mid-loop (e.g., kcalloc for
fp->sb_info or qedf_alloc_and_init_sb fails), the error path (goto
err) returns without freeing resources allocated in previous
iterations



static int qedf_prepare_sb(struct qedf_ctx *qedf)
{
    int id;
    struct qedf_fastpath *fp;
    int ret;

    qedf->fp_array =
        kcalloc(qedf->num_queues, sizeof(struct qedf_fastpath),
        GFP_KERNEL);

    if (!qedf->fp_array) {
        QEDF_ERR(&(qedf->dbg_ctx), "fastpath array allocation "
              "failed.\n");
        return -ENOMEM;
    }

    for (id = 0; id < qedf->num_queues; id++) {
        fp = &(qedf->fp_array[id]);
        fp->sb_id = QEDF_SB_ID_NULL;
        fp->sb_info = kcalloc(1, sizeof(*fp->sb_info), GFP_KERNEL);
        if (!fp->sb_info) {
            QEDF_ERR(&(qedf->dbg_ctx), "SB info struct "
                  "allocation failed.\n");
            goto err;
        }
        ret = qedf_alloc_and_init_sb(qedf, fp->sb_info, id);
        if (ret) {
            QEDF_ERR(&(qedf->dbg_ctx), "SB allocation and "
                  "initialization failed.\n");
            goto err;
        }
        fp->sb_id = id;
        fp->qedf = qedf;
        fp->cq_num_entries =
            qedf->global_queues[id]->cq_mem_size /
            sizeof(struct fcoe_cqe);
    }
err:
    return 0;

}



vulnerability can be fixed by cleanup allocated resources on error:
err:
    // return 0;
    /* Cleanup allocated resources on error */
    for (int i = 0; i < id; i++) {
        fp = &qedf->fp_array[i];
        if (fp->sb_info) {
            qedf_free_sb(qedf, fp->sb_info);
            kfree(fp->sb_info);
            fp->sb_info = NULL;
        }
    }
    kfree(qedf->fp_array);
    qedf->fp_array = NULL;
    return -ENOMEM;



Looking forward to your reply
