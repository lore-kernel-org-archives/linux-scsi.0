Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415D5C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 23:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D7660F91
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 23:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhH0X5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 19:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhH0X5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 19:57:43 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B4EC0613D9
        for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2021 16:56:53 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h13so12832538wrp.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Aug 2021 16:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vdRipuubuK9k4VSlR48gnSkRAwX4nTj4QCElmWNUYFs=;
        b=cRES/bV/Le3R8TnjrrSnhwq2Ex215AKVhKJpz3Rr+CUNcEVx+KEt1r54r3XbiTETTZ
         fU3de3avrDNt4dN+v0vXvdC1bpZYgOhzadcr+uYwaKJc4/PUoyILXsE1D7OJHPgH1sjp
         0L//MQh+Cga+0DZDIM+o3hr5KltpcP2vq7AcBwiUkjlhaiWVoRdBGPvRsTrYy77X+MjL
         X7Ac8hAbuAXl2Z6AKPcEpF+PNz1x0hsAsGdm90/4DPoafm00dWBDEOy7ju8l7Z4HjeeH
         N6TGQnatgzEiKpmGUFvFNJPMYrzP2XnqR1hFFy8NsVo9wYvq7uuQscXkemGuALKsSygS
         Zzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vdRipuubuK9k4VSlR48gnSkRAwX4nTj4QCElmWNUYFs=;
        b=LibQ/f7wKnlmOeX7VwWf11lk7d8oOGh25PbfSaE+e9DatvoJ2VM/QcWSQkvT7PQtH4
         MoYp/opK6UxWEF8iIWWJky4/GTdBzJnipeJEq8PwrRMlckukXSeHzX8naIii5S4oPT4Q
         Rh8ANHTs8ZpOlOV6xm+KNVd5Wio3tXPoOdIVhoN4iMOQgItlLqXyTla4U94u3mPDZugb
         T+NaZX8tfR3Q7JUERwodc7zenLBZcMeHLGRz+lRAMkvEbTeAwwDZZUKeyhQ+3+A/tgY+
         AG9TIju/+D33rPNjBNdaW3wagLvHJaijhWFzZAmjUPsHnShs3z/a2s7XTl6MfqCxtdFG
         HhQA==
X-Gm-Message-State: AOAM533X/UarGxofifnBq4BFYpDEjdMi57ZqC+lo+V8+MUIfqkmeaJq6
        mSoFpvKT+4PNDTq6TlDxQPdLEA==
X-Google-Smtp-Source: ABdhPJzbm8dwCTJMOz4D+Nzp2K9d1BlAGf48eCcs2LNSxg6YB1BNYmzafekryPF1fB1zKsIA2CFwmg==
X-Received: by 2002:a05:6000:1627:: with SMTP id v7mr13197531wrb.54.1630108611900;
        Fri, 27 Aug 2021 16:56:51 -0700 (PDT)
Received: from localhost.localdomain (3.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16::3])
        by smtp.gmail.com with ESMTPSA id k14sm7612175wri.46.2021.08.27.16.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 16:56:51 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>
Subject: RE: Wanted: CDROM maintainer
Date:   Sat, 28 Aug 2021 00:56:23 +0100
Message-Id: <20210827235623.1344-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <22d59432-1b8e-0125-96e9-51b041fe3536@kernel.dk>
References: <22d59432-1b8e-0125-96e9-51b041fe3536@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Jens,

Thought I'd reply publicly given the spirit of the mailing lists, hope this
is OK.

Whilst I haven't worked on this area of the kernel, I would certainly like
to register my interest. Many thanks.

Regards,
Phil Potter
