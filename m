Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F7DC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 14:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234DE21655
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 14:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="te8jMgHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgEHO7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 10:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgEHO7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 10:59:36 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B832FC061A0C;
        Fri,  8 May 2020 07:59:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g14so1324646wme.1;
        Fri, 08 May 2020 07:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=omQwxYvN2PhlFDy4u3NMyWqkH9xoUSaMTqHy0o+Dg6E=;
        b=te8jMgHyHjutcwR0nqBmfBCAlv+oIqBu6mqcyCWkdAHZgPF0c+pKA5rvJDc4FYAvwL
         d4vKusWgiKMLhVI2b11kgrV5n8liiWS1qU5bjwUd9KxUU3Fkdh3NFlYUybHvnrSpC6nw
         QfIJSejye9uT7wWG0EsOwWXy8pWYkl6aQX1/txUQNRJfWCs23BHjWS4pRpI2Ba5Q59kq
         OM9sBBpzOy4LPe3A864fOuvrhzoF5GunNLZJta74bZitvh2hBxUqzyuEsorglqwl72Ww
         F48c/ZWMZVK7VyLM9przlpQcclP6/GdZVrsDiYxVP/xFAR+l/60itOJQuu0YhBYmerxb
         Wh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omQwxYvN2PhlFDy4u3NMyWqkH9xoUSaMTqHy0o+Dg6E=;
        b=l9N/pQQ8iO5yiQ07NhLJpt8NKBPt1kidZxGAISuL6/0b3gaQF1M5uAZMq5o2BJue28
         /vcHtBwI31ao4DBL9S6CRVPklACxQeAPDscDnWfTVp+iGotqtV9pvf1s3jY1zBuPEgEz
         od/0OoyVoPekH/WjNP266KkEA6rfojLAGwhHATuhz7t07ikMI3cRXNcKp0t/cMVgXXcz
         q774ZuAYROdniuJE4BbOWGkA9ZA81auJ/5fFs9RMlYcHemiGLEn2/AJD/+5nc780k+cY
         hEIZbd29vPelPak/LvvoHxapsWaADmByZyvI19ppYcCQPSnxKeol1oEtGpkdpYOGR8Xg
         TjLA==
X-Gm-Message-State: AGi0PuYh67HTax0nYYfnWkd/FJGiqTJbzKsa/bV6GCQ+ZjBQx4KwpgNU
        kSlJBTz0LA+HV5/wPYNjbQQ=
X-Google-Smtp-Source: APiQypLUYC24urSp23MfHJ5ukFDPaT+L4BGIZ2RhVIbOhstpCwEOPcUPo9rYl/7ZI0b3qvraFyBeDA==
X-Received: by 2002:a05:600c:441a:: with SMTP id u26mr17578215wmn.154.1588949974527;
        Fri, 08 May 2020 07:59:34 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id e17sm3204111wrr.32.2020.05.08.07.59.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 07:59:34 -0700 (PDT)
Message-ID: <94072fa2af155d69333b28331bf73073bddf856b.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
From:   Bean Huo <huobean@gmail.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        'Avri Altman' <Avri.Altman@wdc.com>, asutoshd@codeaurora.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        stanley.chu@mediatek.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org, seunguk.shin@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Date:   Fri, 08 May 2020 16:59:32 +0200
In-Reply-To: <000401d62544$ab93ead0$02bbc070$@samsung.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-6-beanhuo@micron.com>
         <CGME20200508113840epcas5p1cee545219dd59b64eeea287f17d34cde@epcas5p1.samsung.com>
         <BYAPR04MB462904DA704A8FD42436BA9FFCA20@BYAPR04MB4629.namprd04.prod.outlook.com>
         <000401d62544$ab93ead0$02bbc070$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-05-08 at 19:56 +0530, Alim Akhtar wrote:
> + seunguk.shin (who is one of the original author of the HPB, in case
> he has some more improvement inputs)
> 
> Hi Bean,
> I second Avri input on splitting this patch series into logical
> smaller patches, that will helps reviewers.
> Also if you can add support to build HPB as kernel module that will
> be useful. 
> I am looking into the HPB 1.0 spec, will review your patches soon.
> 
> Regards,
> Alim

Hi, Alim
that is great you added him, if he can give us more inputs,

For the HPB modulization, I did, also prefer it.
but I don't know how others think about it, since HPB is not a device
.also, I should export some properties from UFSHCD. let's see if there
are more supporters, let me try.


thanks,

Bean
 

