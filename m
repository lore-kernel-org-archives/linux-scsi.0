Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE43C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 20:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDAE5603E5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 20:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhJ2UQK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 16:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhJ2UQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 16:16:10 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F1DC061570;
        Fri, 29 Oct 2021 13:13:41 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id bm16so10477592qkb.11;
        Fri, 29 Oct 2021 13:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iSxusJg9xqx7s92adJkHWGblr33lcnMh6/EvQ6ELrz0=;
        b=WGxJHcERQ0NNihPeE7E5FZ+9AfaGj0+pMqQgDp5E+LRAVJi0e53UAzOAYpZmKu/NcU
         oe/vP+6YXCf1jAUiptFrn5g6m7sxciVFWDnO4k1LqX8LWFZrviNXIZN9PeEnnfHR90Jz
         NvjW6IPk6v3JOjSvcwo0wci/If5qWkjwPRlsb3AB+D/8MuxPTXhqJ26ssOpufrI9wGUT
         odWytXIvEQsBLuf5jzYDa2mQUoMP9FXvJJGpnBwTc36AfDvK+7zX4h/9yFTBttLIxneG
         Sz5h30HLsxDG+Zs5z40PTTPPDnyNJI9IB8VrU5SouX6SttfME4y8W5gHtxblChURc9Qi
         nqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=iSxusJg9xqx7s92adJkHWGblr33lcnMh6/EvQ6ELrz0=;
        b=iSk3ofmuXzZlPZFA5hYF8nuP9qStB9Cl0+h667npsPCXn7wRmb7wgeEntYwLZjf90t
         lutu9CRANml0Ny/YK86AALThQmoJg9Wr8vdbSbMkXjwV7oEo3JiIBKgq4gcVKFJv5mLY
         vu4+Qy+G249wTAddffjiUQl8hbTl9m6H5M2UjWfJItei/oTd79GIQ/YLDA8Z8B93+bk5
         ryYdpSWdiX8m13WGVve27NaSNR6P6dyzgNexZmOQC2Vsv2Kc+cQVB7IU7S1b/ZjS1ypw
         ElA6I9/fZbI2Lq/USQLtCEYyXdrXregF/fKiPcSKdbBZ489q5QZmT90KqZG+MC54VD1Z
         pGUg==
X-Gm-Message-State: AOAM531G4jpgtkZIky55FX4y5oX+yJRqBGqZ36KKLPZXf1A24mMzd6mg
        G9B0yKm0eHec+lSUJcbHN7A=
X-Google-Smtp-Source: ABdhPJwENn5vZtIO/6w8KpYNJWdHoBsGQG8l+g5F9yigCbZXlQ/A0lMQM2gt5Ux8mgaJI4sgEbRX2g==
X-Received: by 2002:a37:a302:: with SMTP id m2mr11281309qke.522.1635538420257;
        Fri, 29 Oct 2021 13:13:40 -0700 (PDT)
Received: from ubuntu-mate-laptop.localnet ([132.170.15.255])
        by smtp.gmail.com with ESMTPSA id v12sm4950980qtw.57.2021.10.29.13.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:13:39 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
From:   Julian Braha <julianbraha@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        rdunlap@infradead.org, daejun7.park@samsung.com,
        fazilyildiran@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: fix unmet dependency on RESET_CONTROLLER for RESET_TI_SYSCON
Date:   Fri, 29 Oct 2021 16:13:39 -0400
Message-ID: <5179853.bjZVKorapy@ubuntu-mate-laptop>
In-Reply-To: <8288a615-1cca-9c24-f38c-549478ba55ad@acm.org>
References: <20211028203535.7771-1-julianbraha@gmail.com> <8288a615-1cca-9c24-f38c-549478ba55ad@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Please keep the indentation consistent.
> 
> Thanks,
> 
> Bart.
> 

Hi Bart,

I have adjusted my text editor, and will resubmit the patch.

- Julian Braha




