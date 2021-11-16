Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923F1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 16:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D742619E3
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 16:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhKPQLl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:11:41 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:44781 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbhKPQLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 11:11:23 -0500
Received: by mail-pf1-f181.google.com with SMTP id b68so18604389pfg.11
        for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2021 08:08:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2R/mJZ51+iGJFomcjs83lK5KRUlCZLsCewfHNLVX8w=;
        b=tsqFe7HXdz+Z04Fo23tGGV36mOagGeo64X3dBaFQTgHWs59h1sLhOS4Hm2hPmIfvHQ
         OLqCIJlwWlrFWmAhC+5iyrHNUAtAwUVh+/Wjm78WtMfwI/eAkwaCOQB4fzKAcmL5G+ky
         xUFWkhkZS0npjQ+NNNSeAHW7jdot2sf3ShKjPb5Ic0mGWcJdZmYqeF517pmwt8rABWH6
         7+D2LQOsyhE2GjKom4XwtlqFf8GzUfnBNOdWT0HuIMSOda/Hbbh2K0LujkmKkoXCxR92
         y4ibOfmtuxU1GnfBVowWqb2w3vpKwGO68hvHxIL/fmOK4yNZoXX6ZNoH0yFHjPbA8+AL
         8S4w==
X-Gm-Message-State: AOAM530icJgaZlEsYw1AryEwGjDBCiss9YrM1rfhXGYaxZyqqVOuzRLL
        eDCb6IemZj/H9Pt9CGytZuw=
X-Google-Smtp-Source: ABdhPJzEMTYO7F0bZmsN8Qu6K2xDVPQz79l5HhEDq9hQ12pYZUiHz9RH0RyqW5nwfi37nmzQalxlOg==
X-Received: by 2002:a63:fc12:: with SMTP id j18mr49358pgi.136.1637078905546;
        Tue, 16 Nov 2021 08:08:25 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x64sm2044835pfd.151.2021.11.16.08.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 08:08:24 -0800 (PST)
Subject: Re: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
To:     Peter Wang <peter.wang@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-9-bvanassche@acm.org>
 <b728d150-3271-c6b0-25dc-881141ef3630@mediatek.com>
 <1a196e1b-1412-90f3-e511-3f669572a619@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <87d8a036-087d-f1fa-19f4-f50c7279170a@acm.org>
Date:   Tue, 16 Nov 2021 08:08:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1a196e1b-1412-90f3-e511-3f669572a619@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 1:07 AM, Peter Wang wrote:
> Should we add unmap?

Hi Peter,

I will add DMA unmapping code in the abort handler.

Thanks,

Bart.
