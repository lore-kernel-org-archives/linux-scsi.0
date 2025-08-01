Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16441C72
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 13:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754054335; cv=none; b=moIU0dW5AADw6VttH69Kh0vgHQ82PRTzjg/98KLvdlFuH5B+zo3tQCuOGypQFNPQdtonNVhctH9Q4nyVeZS4D+WafVFLAuXTyickpk+PrK6KMTgTLQSBa+EKQinywPiNDs2GRdkSDdTONSeR96Z0CbdZ1EpoZ3ZOGaKJs+AhfJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754054335; c=relaxed/simple;
	bh=ldyXQ4UTZpyjoQQwxsSwfMxG5yVfCnV5SP2ogvHbQS4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=T50bCrFr2XS235wxney3hKXIezgoQW12/sw9PLG1/fJLIZeZCHvY5Spu5QqhTOWo3yLs+y9UCZAYpDtm52KTA7Z0CgC/tBjBycQJTN+GHxCJBplhf4Yr04TEphnda4zpHfVE5En4D95sfOh18RxV1aviOYJQSHRyYcZOdS/GG+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PPeV+oGM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PPeV+oGM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-458b49c98a7so318165e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Aug 2025 06:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754054332; x=1754659132; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aCwOQzZcZp/Xl1H7lLeksF7ToOJINQRXKmshGvKKt6E=;
        b=PPeV+oGMuPB7zbR6NB7xGE6cIi5gB6dHvT9dTRsHLgcokdGh70R8bXHR2kmtmW2sv5
         mfuX43TB3CDn6utPtIfTwB2d8LB6nj9tV53SY9yr+5joBIKWBJBmIfJ15lkDPapPjCfE
         ND22XstNv7oOzqgNg6IdnBU0StUCHtWQDas35cwSjTkB9Z3rd3NpWz3oAq4eV57DwZ9h
         UdWLWwjqllNSJ2K5Cb0BlRYpat34KdSZ4KYbYTmvwFof+MUb/npV11myPPUMafj9uw6X
         LpsqIhbe7j1qh4JSauMMeHNq2+zgww8iyUJphJVdhOctnyEPcdhqxu1GgW4HAH5Dc4iB
         sdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754054332; x=1754659132;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aCwOQzZcZp/Xl1H7lLeksF7ToOJINQRXKmshGvKKt6E=;
        b=LxChah5t4EM8grgiQAOZBNwjLltsH6VvyABPyghthUI+lEnk1dhoKt/7W4UhymCUtz
         icLQ5zDkpuhy7W80IvvEmyCP3oWeqqaLMfFBRIt16oNz5YDqnuxF8+75DdDCCq82cRYt
         f00YaaN0WGioQl5ZXwiOBOUiAgBBsmP9Tc/I6X2hwyNDR2wpbir4o6avLCzYmYFXJKhU
         2L+0HofIgk1sXjT3cSl4pxRAGgOTtrcEbJyatP6CefGTmOK8f+vIunOCQU0CBkNphbP4
         J49N098PALe0qs9H2BeRYUqUbseA9DM4WcAyGnFOPm29oV1GTo9a5W4Cyy+vUBJqQX5j
         MAzA==
X-Gm-Message-State: AOJu0YxPmFovuo3/eNF8tsAqKQhblN5vfDYC5j93Ukma3+hNWeXzSuYz
	XIuFbHhyGFlw2HgcEUF5he3J0MRX5DNd9YYNIu++DoiWg04ilY/kIeeVB8Qw4hf9yfo=
X-Gm-Gg: ASbGncsI18EKAxM6mSI1pnkHokeu+/m2fJjDZBzBbHqNT82ZsF9XN2rXsbhHtlUxUcG
	X0mfn61mRXdIOQkBh4jSWAUBne0UAQ88blxtrYQTk1Y6E3rZrmWxuiI8I9/Ji172vlXUAUUeJo5
	OMRMvaTYEKvo2DZ6Nz4r0myBA48USXMMSI6xC2OJYicBz34ZJBO+rb0L80bdeqvmdNIlG9eMhum
	Xp68moB8I3BDk5KVpt3P9Jhk7FK3gDtuY4dRXcOHLk/IkiMSHQTw5B+4TKYkMQwQXFAzxCFb9Ic
	j/sxC6jJC+AzEk2F4kAYppNkKbjN0V8ztt/V+qtcA8y8N1r0VSgJOV06txjGXCn+6KOq9ziaMP2
	WmPBiywh8KkVEK1zrfHE0S36n80U=
X-Google-Smtp-Source: AGHT+IGL+p19TEPnElONLr5QZS+wXmAxM9ezIq06esequDkgY/lXWnvPQSz+MHavSQeoEuRJjBR93w==
X-Received: by 2002:a05:600c:4927:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-458aef01e97mr14488965e9.26.1754054332293;
        Fri, 01 Aug 2025 06:18:52 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c4a6f6fsm6120989f8f.74.2025.08.01.06.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 06:18:51 -0700 (PDT)
Date: Fri, 1 Aug 2025 16:18:47 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Peter Wang <peter.wang@mediatek.com>
Cc: linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: [bug report] scsi: ufs: host: mediatek: Set IRQ affinity policy for
 MCQ mode
Message-ID: <aIy-t8rS0b8vhfmL@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Peter Wang,

Commit 66e26a4b8a77 ("scsi: ufs: host: mediatek: Set IRQ affinity
policy for MCQ mode") from Jul 22, 2025 (linux-next), leads to the
following *UNPUBLISHED* Smatch static checker warning:

	drivers/ufs/host/ufs-mediatek.c:827 ufs_mtk_mcq_get_irq()
	warn: array off by one? 'host->mcq_intr_info[q_index]'

drivers/ufs/host/ufs-mediatek.c
    812 static u32 ufs_mtk_mcq_get_irq(struct ufs_hba *hba, unsigned int cpu)
    813 {
    814         struct ufs_mtk_host *host = ufshcd_get_variant(hba);
    815         struct blk_mq_tag_set *tag_set = &hba->host->tag_set;
    816         struct blk_mq_queue_map        *map = &tag_set->map[HCTX_TYPE_DEFAULT];
    817         unsigned int nr = map->nr_queues;
    818         unsigned int q_index;
    819 
    820         q_index = map->mq_map[cpu];
    821         if (q_index > nr) {

This really looks like it should be ">= nr" instead of "> nr" but I'm not
certain enough to send a patch for it.  Could you take a look?

    822                 dev_err(hba->dev, "hwq index %d exceed %d\n",
    823                         q_index, nr);
    824                 return MTK_MCQ_INVALID_IRQ;
    825         }
    826 
--> 827         return host->mcq_intr_info[q_index].irq;
    828 }

regards,
dan carpenter
