Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9182C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 15:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1682084C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 15:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SJNdWEva"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404098AbgE1PEd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 11:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404087AbgE1PEb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 11:04:31 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9524AC08C5C6;
        Thu, 28 May 2020 08:04:30 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f5so3549740wmh.2;
        Thu, 28 May 2020 08:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pbNGWADWmH1o8ITeUzV43LxllSVUiopM5tVSH/bNMRg=;
        b=SJNdWEvaGf6UTpJrouuPKlz9AH0H1iZIiMfvjxZpnPCMWSJlNcDSULrTvaUSkQNXwy
         Oju3hYuWRZv61ZCE/vLBEamB1sdZcYIA9QjrFlz3rqt0gLeh34cGUAaeqRAJlljO6HGk
         IId3QflGNPUsDMit8cAd3mB+Eas2ol893rFTuDI3ubFA6HCu5UsrW1IO1AyUgfAoD7bl
         YqLEpaYq5G5XcKoAIqAPVp92Ssd4OU7lMnQYkydXhhZuT1G+qqq02K5p2jWUa2ADj0+h
         LmdnkgTeCUgSDMTp93mG661A0/GrrL4cs1RT7IfXdBKzY/hDLbQdPCsB9jzTEAr7wZQ8
         vwiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pbNGWADWmH1o8ITeUzV43LxllSVUiopM5tVSH/bNMRg=;
        b=Qr7Kiuk6wmOvYjBf27a3up5VP+jdjPOFZUFvj3wZKFy0lXQFT77e2ioHiCXhzqTRbA
         E/jVF14TqQtg7Ko3gL608vkMfBQouDgEstDvDeJudZSnXcmNgE/Ld05Sq1hM5zBDVPzy
         kWoqIghNPG/4fC/6Azqq5afESjp2Rgeh3BL3/Ny4crw6sDSTwY4sYIPWE9UtxmPbtpWQ
         2JaDezDxNnDj9zXGj6xsdD3rqVJ10urq27rHMF1F7KKC34kUhjQbkFgHR4XtCqLBZV5L
         qYXyURYky9V78mL3hTmxSHC5HUTSq1WufnI4t00gAJG340PcPzA4jOYLmRbrLf0oOKG4
         qcUQ==
X-Gm-Message-State: AOAM532f7BfD9xXx0nYX8KI00A2l1QCHoP564QwAdBE2wYHhHUZAM8uE
        O5tu4Op465GyAl88Mou/gzU=
X-Google-Smtp-Source: ABdhPJydVOUwJbECYU0CBurknPofc9eHfqgEwvqe4vovuv5arUlN3AJO7U3Wa4IqNkrH5e+hb7b65Q==
X-Received: by 2002:a1c:dc02:: with SMTP id t2mr3794313wmg.8.1590678269375;
        Thu, 28 May 2020 08:04:29 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id v2sm6291880wrn.21.2020.05.28.08.04.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 08:04:28 -0700 (PDT)
Message-ID: <82e8faa7d6a0c5f04832519740230f9f520347cb.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 28 May 2020 17:04:17 +0200
In-Reply-To: <85bbc91f-7b91-46fc-acff-3bcc2288c4ae@acm.org>
References: <20200528115616.9949-1-huobean@gmail.com>
         <20200528115616.9949-2-huobean@gmail.com>
         <85bbc91f-7b91-46fc-acff-3bcc2288c4ae@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-28 at 07:56 -0700, Bart Van Assche wrote:
> > -     buff_len = max_t(size_t, hba->desc_size.dev_desc,
> > -                      QUERY_DESC_MAX_SIZE + 1);
> > +     buff_len = QUERY_DESC_MAX_SIZE + 1;
> >        desc_buf = kmalloc(buff_len, GFP_KERNEL);
> >        if (!desc_buf) {
> >                err = -ENOMEM;
> 
> Since the buff_len variable is not changed after its initial
> assignment,
> please remove it entirely.
> 
> Thanks,
> 
> Bart.

hi, Bart

Thanks.

do you mean  like this: buff_len = hba->desc_size[id]?

Bean


