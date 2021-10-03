Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0CEC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A7DD61374
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJCVQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 17:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbhJCVQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 17:16:49 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03D3C0613EC
        for <linux-scsi@vger.kernel.org>; Sun,  3 Oct 2021 14:15:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d6so26710147wrc.11
        for <linux-scsi@vger.kernel.org>; Sun, 03 Oct 2021 14:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nLZeG/rHCZNsUKCyVIV87JB8czi5Q7gs0JSXX17l1zE=;
        b=Zzd223oIy0FUDGCJU5X1NvLuZRQCVrAiRYEUJ/qXn8h7Ew0H1hYEHNgY7NLhstlRWQ
         5f/RfmmPN6VUZBGbQAXpsqkryfVZ0D/M1wkS2YLbWdQiTSoESKC4vuM1zlUfg3pztpK2
         9tiWZJbHavuxR3VwxTnJFNDek+ReeCv/pypQ94GOSqlFr0WGrgS9VfLFxpGjV3ixxSPO
         1tpP2DHfaWhgeo0xMAwjmtyNriproWnw/J+MAl4OjYSOiFUZxwpHI7lmpyuK+dAwS+0K
         3S5i+/yWS2Z8ke6Kj5tx7M17hduDjDKkymJMywp2+/pNiP7hd60Sb0E8U03QUnvVyfHY
         77Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nLZeG/rHCZNsUKCyVIV87JB8czi5Q7gs0JSXX17l1zE=;
        b=S4SrFgsQ3sLX0f62rLthqJtCgtPBqDzLAD9Dk+aHSGRNHLkyVFJU9oZpb1GrOSyv+u
         EYtFpt6NYbJm7p2zVXuHqyZLz2HRCMT/fVtOiCrHYeqYtHfIMVMdizBEk1z/wCd4PSxA
         npKuubbSe7+TyOEJ3sUEH5ajU2GhmCbqYmGD97tppXLY/pag620fxIdjmGAEbcbyCGHg
         sP3KasM5YVVo8Yd8jJ0I9u91xY8bI6YXQX9liBcWItco0hQ7IwrvCUwZOVReigazdag2
         uJfvtabA/WZhgqlcTiT5tS1K9I9DmrfvDrMiqqvWOGxc2HKuNBu9eDW+Vf1Zi7hMudpY
         VtfQ==
X-Gm-Message-State: AOAM532WvVIjvNLfFU4eNtM9StokpFo/1yAyv5RawsxOVuVClNaqirVH
        GRSO2mRtKw21vsfz8M+KEBY=
X-Google-Smtp-Source: ABdhPJxMlTdyObd7v+T5KXY823phleLqGKRZ4PNXitCeI67A4PDJ7kJ4Y4je5gs5tE3ZJxJvPBB0dw==
X-Received: by 2002:adf:8bca:: with SMTP id w10mr595681wra.43.1633295700088;
        Sun, 03 Oct 2021 14:15:00 -0700 (PDT)
Received: from p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de (p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de. [2003:e9:4717:cf64:8712:b27b:14e4:a39f])
        by smtp.googlemail.com with ESMTPSA id d12sm4359478wru.8.2021.10.03.14.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 14:14:59 -0700 (PDT)
Message-ID: <de85685697ac3281bca6a49c04837b26de62eef9.camel@gmail.com>
Subject: Re: [PATCH v2 84/84] scsi: core: Call scsi_done directly
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Date:   Sun, 03 Oct 2021 23:14:59 +0200
In-Reply-To: <20210929221138.3511208-5-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
         <20210929221138.3511208-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-29 at 15:11 -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> 
> scsi_done() directly. Since this patch removes the last user of the
> 
> scsi_done member, also remove that data structure member.
> 
> 
> 
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

