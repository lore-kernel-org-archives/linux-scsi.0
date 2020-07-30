Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06982C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 11:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DACB22075F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 11:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGqPRCfw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgG3LNC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 07:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG3LNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 07:13:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BE9C061794;
        Thu, 30 Jul 2020 04:13:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g19so1205174plq.0;
        Thu, 30 Jul 2020 04:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1RXnzFUlUte9x0aeJ24tzi69Ln5Qow4Xgrtr1s2D2+Y=;
        b=bGqPRCfwJh32n0ixyAQlu/+W8RkMxXAMkLIbTqG7XWvHkybwKzU3zATxpYQpWS3q3t
         Jefpph3Mq216BB65Xyap1Uo9SWnnJVGSLledPKNBq4gdgB4bk5cpe7drQttmZc7+E3aI
         5Kq+D2cRfqbq9EKzL4tLMf5bBPtZrd4dqr9PeHOLlZxWCyyIldCF6REaXnTLH6Mk/7IA
         fIXqCKEAR88vDcTG7rgCa6FPHSVO5vsM4ohbC0sTX27JFHd+3hhYz28rmuO9ZN6tsDmT
         4q4osJT2gdkmu8XaYtbe7hCv5lxinWWlWTxcKvMl3e3g37zlhkZgMcQEQUJwkeNLSwO2
         YTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1RXnzFUlUte9x0aeJ24tzi69Ln5Qow4Xgrtr1s2D2+Y=;
        b=m6sWEMtN7cMt70xZ48RZp3EEujTtaqJLw2KNkMqAMYmlMRtxwrxhB+7N1GGk3SotaU
         GmBI/X+OB09UJu824fKex1Th3u+2xJpUfOKmjcHO1SHQ9CmOBZjGScC5bRyMvEeirlcw
         Cfrzjb+5vbnBaLAHcqGcUZ3mgRkoqAU7eHwuZ0kNbR239pvoSJNbZ97corSZzoExCCfh
         +v5aOCMZU0gXBEXOirRArD2/Uiqniku6qHyH03VCM8NzNe+4gg3oHZU9zMAQN+iuKbNx
         Hyb6AQWaK8w/hBEfBIYVt7zXQb+PsqjlA+I+x/NEn5pYjD8oAVTZun51v+Sr84Oba+kF
         MD2Q==
X-Gm-Message-State: AOAM531D+7oaGfbqqbpadC/Gal3QQuD4BAZKpQnjrFqiqX+hpXil9j2A
        oeSt9B4a51BXA14cuOWW5v0=
X-Google-Smtp-Source: ABdhPJw7ZezaIvMMg31YdupCrrfa8QNNWsgbqtE4ABRHJ28thJ5mdhBmLm8+vddePpaUrATms/nDjg==
X-Received: by 2002:aa7:9468:: with SMTP id t8mr1634918pfq.182.1596107580795;
        Thu, 30 Jul 2020 04:13:00 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id n25sm5812460pff.51.2020.07.30.04.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 04:13:00 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:41:19 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2] scsi: smartpqi: use generic power management
Message-ID: <20200730111119.GA664614@gmail.com>
References: <20200730070233.221488-1-vaibhavgupta40@gmail.com>
 <20200730110930.664486-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200730110930.664486-1-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is compile tested only.

Thanks
Vaibhav Gupta
