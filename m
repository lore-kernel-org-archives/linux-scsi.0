Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2827A34FF79
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 02:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788314483; cv=pass; b=tEKB4y53/3lAW0JptX3GkFRH0ZQQ/vn9iJcF5bY06QUu0NlYpuW6AMnB7aEXkbZRAPpOsN/MPZQT+a7JFn4EKGodn8X+xhjPvZaD2BsMsxyGjTnb8cx2mxxf7EkWznbR+S7ZnozKRsPo1tkmMT6t8By/5bfZeUvvLw+M4gKttl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788314483; c=relaxed/simple;
	bh=U3aa/uX2QJ6x8/cys5PY/EmIY6wqHCxmh0up08kwOCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hH1nSp0CiCYSrZvTCy5go4bXUMqxQaAIwFrTC5Kvq3C1FrspLOKKq47g5HCJznqxQchj13tfGlYF7PX8ggSGzoHNEt4SenBbQmdD8dyca20RY7zwK0FGEGkkmN05+Zdi8lDND3fYwJZY+kmnDAqXx5n7R6OeOONO0Nao89v3Gys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hIGjMTBm; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hIGjMTBm"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-52faa58bff5so140941cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2026 19:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788314473; cv=none;
        d=google.com; s=arc-20260327;
        b=qEkTvEF3b1N6T1f6VcYS3txWGFlxQCmucJnf+xw8K7i41XW95/CEj2cDEoLJ6n7jpe
         ArwpnPzK7zgcX4wHXG64xEeyLVO6qsTUE3wdOSdh/5voEfjmc5StIdTPI+WihN+jxINv
         EEycaKOglKBSBEDIB5rU9op8gwpwWzphP/RikdgWetw/HCQEyP3jHFDc7Db2r3XgmGTp
         n6bKI0rOoE7xCqAcVGoOebV9GGzhQ7QhoUpELoDbZljbyqiAhWXiCfEbPP19CbC7Y4lq
         10QShMyrZ6EAi+pqqfj71GO7Hl8D1ymQ5AGhf/w1s7gEfEqs3OgL5Pb1rVPhND+2X/LB
         raMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mCiyEAo5wxMzkcXu7vU1R6+a/fDtwqnpSwvfpXQcP5o=;
        fh=x5j3fNUSNGNt9ugVx8qJfM9FRQzqTmWAbN+GJ+M7I4Y=;
        b=ShDxfYKcnNtilV4No07GLLbLpX9Ie2q4vIsp/UnqcHB2X6oD44+9jm4DxziwludtYW
         1voFymS3TX5a0RBP1fBq6c8mHZVy4t6wjqup8I4Jul8T0G1tnY9yCsnHzIawpD4l6Jkx
         G7jf9GI2UgEJm+9mMjUAHYj/snoEMg7sarKF4osAfAk2PnmwwmFhK9P51Wx0aRV4esbu
         Sqdqp5xd2jJwSZFEgpIu3d371Ebzj/5BprCVoIy1aEuw1yUi7WOgiW9IlH+TrF8VpXWq
         /QhRkcioQNqxFfCUgKrYYPCptKFgD0f9imdoA5T5jxqszYaObma5RFN9YkpFEQ/YAfew
         hnMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788314473; x=1788919273; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mCiyEAo5wxMzkcXu7vU1R6+a/fDtwqnpSwvfpXQcP5o=;
        b=hIGjMTBmM3Oj1b0BTXO2ogWByJcQEr0YgZ5EDJQnklj7mkITqmbuTDB3pRAZEOBeLx
         sdFqQN94oERcWYCMTCs7whPrflUW4dA/5RpE8233FovbO4exrjwGe/3UamUcjarYFTH5
         /U5b17OMQzyHsq+UtGXjOoCDOqYaAuXwr/0V5HB37ekIx6QWt0UVQFAmqpZ5JzSX+TbQ
         ExHy/wEx5+pyjk/9qAoPUIJ6qgbrkK9iiNYn2eGHkWbf73ywm5cee9VJ8OwRI04JbQ3o
         zszOFwDfqAl4NmwO4XfNBT/N/yZLHljK09J6JFrDA57QLWoiylrIHmwHxiue7QbyBSTO
         X/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788314473; x=1788919273;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=mCiyEAo5wxMzkcXu7vU1R6+a/fDtwqnpSwvfpXQcP5o=;
        b=WuulDpfDFImzUgtcpa9PrjVkVsHv9v4l/tikJAjm3itlHxmji+nRpQeuu5biArYD2t
         PXu6qu40CyqXFjO4bQ4yr3rIVGR8/BV1OeAZyYFaCvgj04lHKZm+Bvl2JWKaw3D4FHQf
         U8vLx/8PnkDNSkvifMiPqTG604+uHDv90OIqZzcfYeQpwC5FuK9t51ocleJEZy9fpbBg
         FMgL+D9+lf1z75ICsjh9xMYi3O9u2ypqxY3amt9cT3QftA70HR+0BcHbnQIcL1dN5Wao
         zbPbK9qPaV+H84GXaeXAB2OcRe/Hnm0CGqbeiq9R9UbaNYVZ2vBh+UqY8EQX4Sy8xLMh
         6ZSQ==
X-Forwarded-Encrypted: i=1; AHgh+RqS/7HqVJ1kFSA4INyXEEr5S2CNCIhxLaaXGgLzUtjmncURAH0KlhOsPhXh273BJhhrgd6TBN7s11bO@vger.kernel.org
X-Gm-Message-State: AFuF++m3CsIHFGyBpFBrZhh9lWx8M54db9SBUvOr8QdjHbBhjcajzGyQ
	O+Gz8i17wFPabRqSRFaSY1mTHtFPmg2EjZMgwres1l46wsVzC275xGPqu1PMcObhT8PwMGmIVvy
	9Sws7K8/yg8Xx7hEicthHXKL4SMVYTZERYv0vtdwp
X-Gm-Gg: AR+sD12VWpd1VclIZ4iaXfjjJNpnER0HLJlYItKFFnMNW+XOiODmqGd7DCoKjxXnlM1
	HmURMbznniV5Wo+3VDl78ejcefCgBb5H57nplKSJ16R/QKGCZUQhSCSTIaYhQKhgyw9HNu144un
	hrIzd7yh0/jp+O3dqPAu+k47dVnDAEy115pvRLyL51I3YRcxDQxMGFmlOm5c+t6pK4yL5MJ9vNf
	qwYrgGxXF91YUrv8vACHQ/uqZgyJFpAJoM0cyUQM7cakVtGp/l8ukfWEoFUc033BZ+uh0884W+E
	o9sJijw7v7gWL1A/yNdlo0XOwLhINXiAMix3Dlj8U3KRky6+uvTzXE53xHoYHMcLIRWyvp5PrY1
	S
X-Received: by 2002:a05:622a:1b1c:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-53035b0244fmr4577611cf.7.1788314472279; Tue, 01 Sep 2026
 19:01:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAE14pdef2u=Eo7M9NGdABzsjy2o2SO=Z-U_BbRn9n45nJJR+wg@mail.gmail.com>
 <6f78c4bd-a70b-402d-abfd-599091b67674@acm.org>
In-Reply-To: <6f78c4bd-a70b-402d-abfd-599091b67674@acm.org>
From: Stanley Jhu <stanleyjhu@google.com>
Date: Wed, 2 Sep 2026 10:00:33 +0800
X-Gm-Features: AcwNN1UiOHbd-lkyUlqZ5G0VRdeSeGP_sY6ZABq_Mgd0A-kN0QJuBUaEk2kVvBk
Message-ID: <CAE14pdcnmcvPZv4_pKOnH57OZmJBqe8DTwRnmrMTwOnBm+iOOg@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: Set BLK_FEAT_SKIP_TAGSET_QUIESCE on pseudo
 SCSI devices
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: hare@suse.de, john.g.garry@oracle.com, hch@lst.de, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Sep 2026, Bart Van Assche wrote:
> Does setting BLK_FEAT_SKIP_TAGSET_QUIESCE on pseudo_sdev break frequency
> scaling? ufshcd_pause_command_processing() also calls blk_mq_quiesce_tagset().
>
> Why not replace blk_mq_quiesce_tagset() in ufshcd_err_handling_prepare()
> with blk_mq_wait_quiesce_done() and drop blk_mq_unquiesce_tagset() in
> ufshcd_err_handling_unprepare()?

Hi Bart,

Looking at the three call sites of blk_mq_quiesce_tagset() in ufshcd.c, they
have distinct requirements regarding pseudo_sdev:

1. Clock scaling (ufshcd_clock_scaling_prepare):
   Requires freezing all queues (including pseudo_sdev) while clock
   frequencies change.
2. Command pause (ufshcd_pause_command_processing):
   Requires freezing all queues while TX equalization retraining runs.
3. Error handling (ufshcd_err_handling_prepare):
   Requires quiescing attached logical units to avoid HOST_BUSY retry
   storms during host reset, but must keep pseudo_sdev open so internal
   recovery commands (e.g. NOP OUT in ufshcd_verify_dev_init) can proceed.

Setting BLK_FEAT_SKIP_TAGSET_QUIESCE on pseudo_sdev in SCSI core breaks (1)
and (2). Conversely, replacing blk_mq_quiesce_tagset() with
blk_mq_wait_quiesce_done() in (3) leaves logical units unquiesced, causing
incoming I/O to storm the recovering controller with HOST_BUSY retries.

Would it be cleaner to keep blk_mq_quiesce_tagset() for (1) and (2), and
handle (3) locally in UFS error handling by quiescing only logical units?

    static void ufshcd_quiesce_all_sdevs(struct ufs_hba *hba)
    {
        struct scsi_device *sdev;

        shost_for_each_device(sdev, hba->host)
            blk_mq_quiesce_queue_nowait(sdev->request_queue);
        blk_mq_wait_quiesce_done(&hba->host->tag_set);
    }

    static void ufshcd_unquiesce_all_sdevs(struct ufs_hba *hba)
    {
        struct scsi_device *sdev;

        shost_for_each_device(sdev, hba->host)
            blk_mq_unquiesce_queue(sdev->request_queue);
    }

Because shost_for_each_device() explicitly skips pseudo SCSI devices
(via scsi_device_is_pseudo_dev() in __scsi_iterate_devices()), logical units
are quiesced while pseudo_sdev remains unquiesced for recovery commands.

What do you think about this approach? If this looks reasonable to you,
I will withdraw the SCSI core patch and submit the UFS-local fix.

Thanks,
Stanley Jhu
