Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D56EC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 21:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F7561406
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 21:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhEMVMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 17:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbhEMVMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 17:12:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CB6C061574;
        Thu, 13 May 2021 14:10:49 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n2so41763607ejy.7;
        Thu, 13 May 2021 14:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=7UYaHIQgi80Po9Ce1GNSBB3/msApKtw49od1OnpSRLQ=;
        b=VXz8Kew7i2eGa5UHzAe1QVYj+AmbXsMnYMDQhXWHZJQSIgyjBshES+6miK3urq7OiZ
         3Q4JY3lhZRUqmRnB/6Iz2BJSIexrUyW1KelraUQ7JnU6xLr7HxMnKCflLkL2w2kBew0Q
         uYSzRudFJuoRroNyu9SQQ7g8JVaMGbAoHJaArIsd7K7wEcfFXtvHMPuBqBCdM4fQ+oRm
         /tsQd+lcJEoZgUKLN55BeAGHNtaNDfsAW80QXNrV+kDIJwGJzQ4sRIE4IBG929cSNBgs
         Z8/Tk0D6Gc3rN8ie6F8xQJmOdR1L3a4OMbj0B8HqGbKIK3PHf8DlDTzLUaIeM0b0GQe+
         TgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7UYaHIQgi80Po9Ce1GNSBB3/msApKtw49od1OnpSRLQ=;
        b=elCrjpk7UGc5w3sdaGXGDHWFVGmier3Ek0KErrFamTrNeAbgddnqikmRTiVC9ENGcd
         Sl9JteUilJwThjLN+Z6eA6+ZRsaOybRoq1DNiv7Y+pt9A+hUyYkL8MqAaKmrsK6h64Oq
         POatydwLrHYmvrmbc/SIKTErfyhJiQWjjgM0illyJYsz8wwV0c5bWsobeLNOLOHmRGhU
         qkVEQtLMzaLIjl6Ar3Nf7VFzttHo2p8QZYt1tJiRvIELeVB83PcHqHQpSaf2C/NbdQ1w
         RDq8DaTyaUWnXHpt135j+DHDek6N1Tj3DjFOCs/C2rS5p2/uxNVbyBA0JY8QWsi00mm7
         /J+Q==
X-Gm-Message-State: AOAM532IkOTs9ZITq0ytbo57JuQk+N+kdsVneqyS5AgYKnjZtqSLE6b8
        101i0f6EBXnWMTltsLPM3Iw=
X-Google-Smtp-Source: ABdhPJzlzbuNl/iYjUl+eN6U/N9N0HLEZ4ZUh0nZsLbeqB4aY46nRr7hl1DgDp9b/osKmBwDyIJ1vw==
X-Received: by 2002:a17:906:28d4:: with SMTP id p20mr45929283ejd.552.1620940248659;
        Thu, 13 May 2021 14:10:48 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id v12sm3125600edb.81.2021.05.13.14.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 14:10:48 -0700 (PDT)
Message-ID: <28226dc0f9c91e9bbbf9db830a3a63524d673b8a.camel@gmail.com>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Introduce hba performance monitor
 sysfs nodes
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 13 May 2021 23:10:45 +0200
In-Reply-To: <1619058521-35307-2-git-send-email-cang@codeaurora.org>
References: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
         <1619058521-35307-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-21 at 19:28 -0700, Can Guo wrote:
> Add a new sysfs group which has nodes to monitor data/request
> transfer
> 
> performance. This sysfs group has nodes showing total
> sectors/requests
> 
> transferred, total busy time spent and max/min/avg/sum latencies.
> This
> 
> group can be enhanced later to show more UFS driver layer performance
> 
> statistics data during runtime.
> 
> 
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
Acked-by: Bean Huo <beanhuo@micron.com>

