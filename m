Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1250CC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 May 2022 02:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiE1Cib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 May 2022 22:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343827AbiE1Cia (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2022 22:38:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC725E751
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 19:38:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso5900228pjg.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 May 2022 19:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=QKfoIOgyZL/xb/1L1zYSEnG8584E1/HMwnAVrhZ2S90=;
        b=tH6+E+cGuT10WwPZrOtbguliVJw3nPEIIo/uPIghoZ8VrVVaGPhE4oGTYjtXil580O
         SMGg63x4IXfmFZ8VWCdUumkzN24l6LCh8z+IlJ3TleDDWN/UZ3dseGM6Yd9Y2vXrmhvE
         wAPABGmjXeGSOaobxzvHbNMbc+cxdkKD2+ngK46HedrQfDwgz/sglIQ0CAVlC/g0cKQc
         2BdfOUnDVKR5d4rwyo76Gs/0v08wH0e5JenWN0ejCsiX0bDS+BddQoeMoRmeVLGzZ92U
         UvFUbk5LLTrBeEzCTxzCrA1IZ70wgcvqjIx/oV38AA1OCAGvh+X26jXNW4vZIA92hN8m
         2dyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=QKfoIOgyZL/xb/1L1zYSEnG8584E1/HMwnAVrhZ2S90=;
        b=dv35AA37V7WJTVOeT5+OxELObvp713uXI6O7KFx/ZCgFNZbN/j9mFnCcjbbc05+NxA
         ZH4kF1+PYR/Kzzr/oa24i/FoMcezm+84wB03skkdLzU8Ovy7j8itTNKeKeh72buINO+M
         rJ++xKTqvqQhZ/Joo6qZHgKK/bZx5gLmR9Q3I7fzt8Gr2Bu4VdqJEsZSKhOjVVmuBjRx
         VGdRL7Gz03/tWh0qwOXlJj7UMqCXe4vSWhFaJOlXriBDQEh/tFOa4uc1lHuBOcHMfpzN
         EpaIgueda0ZeIeLG8L8N2FbEsoZ06Eo+qIma/EkEx3A9/1laQCDzkJZoHbGtrmaMZknj
         QG3A==
X-Gm-Message-State: AOAM533rKdk6yvwKKupCITbcdO1S06Q27r8vZjIPdNyF3CWfHb5PeTu2
        fTYtFJJtIzfBrgseSGiVg+lcnan5qfUvSg==
X-Google-Smtp-Source: ABdhPJzwqCNbh7NAKqkBulvD58E83zSeEol1PkLOrJgIZxpF2Fwj1W9WHtYjW3cxajUp9ll+eE+62Q==
X-Received: by 2002:a17:90b:4f43:b0:1dc:c1f1:59c9 with SMTP id pj3-20020a17090b4f4300b001dcc1f159c9mr11236684pjb.183.1653705509015;
        Fri, 27 May 2022 19:38:29 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e5ca00b001619cec6f95sm4394027plf.257.2022.05.27.19.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 19:38:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>, hare@suse.de
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org
In-Reply-To: <20220524055631.85480-1-hare@suse.de>
References: <20220524055631.85480-1-hare@suse.de>
Subject: Re: (subset) [PATCH 0/2] block,scsi: BLK_STS_AGAIN clarification
Message-Id: <165370550803.603787.9990337398772714237.b4-ty@kernel.dk>
Date:   Fri, 27 May 2022 20:38:28 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 24 May 2022 07:56:29 +0200, Hannes Reinecke wrote:
> BLK_STS_AGAIN should only be used under very specify circumstances,
> so we should better document that. And modify the SCSI midlayer to
> not return it, of course.
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (2):
>   block: document BLK_STS_AGAIN usage
>   scsi: return BLK_STS_TRANSPORT for ALUA transitioning
> 
> [...]

Applied, thanks!

[1/2] block: document BLK_STS_AGAIN usage
      commit: 98d40e76652e9aeb3aec4065f600d633ed335e94

Best regards,
-- 
Jens Axboe


