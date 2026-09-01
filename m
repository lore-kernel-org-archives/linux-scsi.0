Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85CB331EC0
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265463; cv=pass; b=k59Amb+48FDok6nHJ4p9X38kCS/A4lLNHXpATkU/UmOytcDltpi4oFpZg6wls+2nFQfIdmF5Ry7RoXEleAfTIwe4Wdi5m3K486/2YeskTFIYrGDSd7o1+9MuZvaS/yohVKAxLdW7Rn9b3Q2Bd/KSEqmZK3YriIHnSEdnOD6+Fjg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265463; c=relaxed/simple;
	bh=JN/t2FkFifvzscJ/Ssx2FsFd82QoZZqcQMljAzuGXQE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kqiwFmNMUEV/GjjHVIFXxt3uEi8hGgYM06vmWrs7ViJT0cY0GQmppVj1rKZqxpTmHD2ozhwiKm6I+Mrgauduz9pp3RUuoeZdVQCB088ySq0Im4qyFt0/BJRYEFqutUIvdxwtDOrr43gnEs1BBzw75hxN+hOkJ5omddhiKyJKEuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=al3u9SC+; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="al3u9SC+"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52fac937235so171511cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 05:24:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788265460; cv=none;
        d=google.com; s=arc-20260327;
        b=AOQIwjE9jLl60IMe8IivKvOHP3ahrMk46CfKoE/XrbbFFoBbcUcRkbznn8X4SMkq3M
         IKtlfm/pk5cLyejnSn0V6JwG6846Ttjg8uRWfdyDoAIBfPOQCGbXHoXDQDHydUcNRkTM
         VjyPqSm4mRP4oeVhkkdA+TW6fsBX6jiHjOyeGkRmmD0PyJEg/x2J5U6ulKpd5Nm9phZh
         T6CjbFkALQe6jVgijPA5t3jL7QCMAwyv62XpF116DuGczm7en8KtbnQFzPSMNuzseZ0c
         BCKXNnUuubiPpYeUK9RjzKnKP3SC8gM5cZj6RVubrl4vYdOr3ZDQg8XpiS56HzLcwqLz
         5ZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=d8In7MroUMENUyC3EqegCPVqWB6peac9BWZUcxLxuQE=;
        fh=Q9VRWQfo8dfblTCy+KKURTFMpRXrBUvp3ZJq6SLfQqY=;
        b=BP8TwUFM3tkzd6azJiMEtau4cYawYGP5bjpxQc2VJCir2INSd7Xe00OGiUe5TjltB6
         hB1K/uE4uZu9oIvt0Xg29qppkN3fELdzAd2noD+by/0pcTM69aeRBDnxf0rSEKM0UIGM
         fViYh1iUaPA1wVpQxyZmQe0xfe7YlhRuvllpZx77RE227oKqrTWlfkEWRbf3a+zvw78K
         LkdA0WBDHB/qhmiTq/k+uIGFdWTBs4VfMN0yRSIVk11JZ+W7WNx+eMyTd45icS4KpyBU
         W7/1t1+u1lfIF6GN4B4jP0Clk3XtvobZMvxP3B93Ru7BfOutWBr/0AjAARxhFVfBGa2z
         SFEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788265460; x=1788870260; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d8In7MroUMENUyC3EqegCPVqWB6peac9BWZUcxLxuQE=;
        b=al3u9SC+yuRQBfSNQSz01ezypQ5ADgSAfC57clea99WnxmJ4feIEdNexexeiBBRH/T
         QQ8/aNLEbQr6t/dczffCxIijBqWMm4yk/xoqhhHunKKDIE9WzzIyYn5aDiy3QGnI+doh
         JtDn+dP203VaKRCRDG/Ln4VbtpPWJGpo+wEDVlq2UXVgkBwgFGZtp6pnzeHCHQsAC8bq
         GHNBoJjJZCimCnrTW5LveUA3atjJ7CnK3r9DwFvMV8mALhdSD1YXY628R057bAPgllc5
         0VRowAf/gqF99GCTcGddbAtBGZHrlBg6av/6iwRmyHzWT6uyQkDVesBxfb0HeZ571Z50
         wl+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788265460; x=1788870260;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=d8In7MroUMENUyC3EqegCPVqWB6peac9BWZUcxLxuQE=;
        b=cL+bhlmz9dXO8OfgmikyWqbOUJoo2CXcPovqmKJtSaXYouapoRXtX1+NGGHXl+hX6R
         avHyYXzGqWLWi+fzYpPXw2ix7cDUDhRl9elsQl5muA/t5uwcDKL1zqjY+3zVswowknCe
         m56iL3yUf7BCBRC75oug4iqpNQYXR+yuD15Kzu2L62Tgdejel1qlZ7dG84NwCGg8HuLL
         Z3eY+eRgFHE5igQweenzxjK87MUOuNCOQvqArQKqsZE8pnlDu9izHNM0zc7p4l02pZXh
         ZD3wqc5nlk+GY88v73mRMbJYMF6K2nT1CuNDsT3s1oiAPDqixXu7SDYteEXx5UwfiQbT
         IeoA==
X-Forwarded-Encrypted: i=1; AHgh+RqeXzc5pmwu31gPLwtFl9NSRKXlj4zn+VYLto40LZVSPoTMJGGHMq+kMa1+bfx7YjIifAmahXyY2P05@vger.kernel.org
X-Gm-Message-State: AFuF++nSCSIM4ZUMr4RlR3Bj84SjJx+WuKuMT4wSbKwmnV+8h90Mfj4P
	On6DjmDeZIPA6iShgEZgJjZ5Jdp7JSK5M/3ikSdshX3051qnlI/UxkqmT9qHQptsBhlZPIlmrva
	JjI0/LwAzD3Nn9ZXf27Wav23vk/+7ZKA20ynlcvM6
X-Gm-Gg: AR+sD128Li8RTskPcI6rOkzK+pDfMPNdXtVJ/tpw7Diiverqbs+OR71Kss9tMSUHglx
	axf8/x+Z9EoDPZEC8ovOlCfapEKmLyLgTbY0+x4r1N7mN8W49VINQfZNUFLiMsV6u8qMe1gDSyU
	hlM96jcGN0nyKWWc2kwVsEbASP3wlWrlVPPgFzIQoexBMEtZGzZbKT4hEZGsDHO3psqXL6FPoBz
	yfw43L1SZSqBXempFuFonwGCe90r1ESDrDE77Vh9xUUFUxXc5tQuOVDpZmRayPqVFaIaBBv9SkF
	905Qby/Kwl/xKTa4UXEVz6EMhkOYKizTCTJwXn6BkhCI
X-Received: by 2002:a05:622a:1a8f:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-53024b7b7d5mr15608241cf.0.1788265459654; Tue, 01 Sep 2026
 05:24:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Stanley Jhu <stanleyjhu@google.com>
Date: Tue, 1 Sep 2026 20:23:43 +0800
X-Gm-Features: AcwNN1WE8g6tSRs53V9lxDRCC9ypyaxRDWe_obKQX3VLlFgTm5cLh0_k_iVI3WQ
Message-ID: <CAE14pdef2u=Eo7M9NGdABzsjy2o2SO=Z-U_BbRn9n45nJJR+wg@mail.gmail.com>
Subject: [PATCH] scsi: core: Set BLK_FEAT_SKIP_TAGSET_QUIESCE on pseudo SCSI devices
To: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, hare@suse.de, john.g.garry@oracle.com, hch@lst.de, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit d630fbf6fc8c ("scsi: core: Support allocating a pseudo SCSI
device") introduced pseudo SCSI devices to allocate and dispatch
internal SCSI commands (such as device management commands) via
scsi_get_internal_cmd(). Subsequently, commit 08b12cda6c44 ("scsi: ufs:
core: Switch to scsi_get_internal_cmd()") switched UFS internal commands
to use this mechanism.

However, pseudo SCSI devices share the host tagset (&shost->tag_set)
with regular LUNs. During error recovery or host reset, drivers
typically quiesce the host tagset via
blk_mq_quiesce_tagset(&shost->tag_set) to freeze user block I/O.
Because pseudo_sdev->request_queue belongs to shost->tag_set,
blk_mq_quiesce_tagset() marks it QUEUE_FLAG_QUIESCED as well.

When error handling then attempts to issue internal commands to recover
or verify the device (e.g. ufshcd_verify_dev_init() issuing a NOP OUT
UPIU), blk_execute_rq() inserts the request into the request_queue of
pseudo_sdev. Because the queue is quiesced, blk_mq_run_hw_queue() skips
running the queue, and blk_execute_rq() blocks indefinitely waiting for
completion. Since blk_mq_unquiesce_tagset() is only invoked after error
recovery finishes, this results in an unrecoverable circular wait
deadlock.

Resolve this by setting BLK_FEAT_SKIP_TAGSET_QUIESCE in struct
queue_limits when allocating a pseudo SCSI device in scsi_alloc_sdev().
Passing this feature directly into blk_mq_alloc_queue() conforms to the
Block Layer's atomic queue limits initialization model and mirrors
NVMe's canonical pattern for its internal connect_q in
drivers/nvme/host/core.c. This ensures that blk_mq_quiesce_tagset()
ignores the pseudo device's request queue, allowing internal commands to
be dispatched while user I/O remains quiesced.

Fixes: d630fbf6fc8c ("scsi: core: Support allocating a pseudo SCSI device")
Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/scsi/scsi_scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3b82e80e807a..eb48866ed0dc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -336,6 +336,8 @@ static struct scsi_device *scsi_alloc_sdev(struct
scsi_target *starget,
        sdev->sg_reserved_size = INT_MAX;

        scsi_init_limits(shost, &lim);
+       if (scsi_device_is_pseudo_dev(sdev))
+               lim.features |= BLK_FEAT_SKIP_TAGSET_QUIESCE;
        q = blk_mq_alloc_queue(&sdev->host->tag_set, &lim, sdev);
        if (IS_ERR(q)) {
                /* release fn is set up in scsi_sysfs_device_initialise, so
--
2.43.0
