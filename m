Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44561C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 21:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 263EC60F91
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 21:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhGZVSW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZVSV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 17:18:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91073C061757;
        Mon, 26 Jul 2021 14:58:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id da26so12613754edb.1;
        Mon, 26 Jul 2021 14:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=R5WzJafvHvQD5KbS6EJ/H8Ed9c7/eKNCV1X3I361Rt4=;
        b=ZEwS73pxLDfBefXs5tRE1bgXySW7xSJJYOWG71DrYkCED46tnTEgMoQmlbQBhEwkDC
         zTQPtuUngDjUWfM1qDfpMrIDdRagepy/CdJRHBDnxqxWgx1IQ/+D0RUPZ+GjdOD7cYDq
         WmHb3mhaQ49iHSjaGftPxNDYNA79cy0O1GGI6D/mr8e+lma+7WhyytNkSGDdg4XrnKpd
         NJYElDXk9Xz5R5J3I6SYGLbQi/PEVgOGfXP87PBKfCBOMkeQfnBmiWX0DqmRrTlZtJlf
         uI+ajhBp20WXRxOaNYwMJlCttXeUVgBqWh9/9LvDRN+SIx+Y/o+BcVxTk5TGZK96Qf/f
         +Zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R5WzJafvHvQD5KbS6EJ/H8Ed9c7/eKNCV1X3I361Rt4=;
        b=cJfh9qd2B0abj+R5akYUearw04rkGsXo0NYU+T+k6S4yFdCNmKtQ55kDIn8ASZX54z
         pSBWA1yN3Ro61iOxczGcBhW9X6REv6kHVNDPfy4LRFQopCWKBaUi5d+QRVSx6dBoLyYK
         /hNCKx0njof9DxGGzgl9E+sWdMXo2QDo1S0sbqEKDOJF66Rb6WcsnU3SrKllEPDTRxr7
         HtxKbYwbPtRriL+KLkq0xc6VA46lZQwAL1K3HJ4YWiOsw7rNjiWKU+UIynYB7a6mDS6v
         b6RiP456x6dYq6kRM5zvtvG5iHSD3FPcq0JY1/oNOZEWxgKy0WNFI9KROnlyCpdC0O1a
         0MWw==
X-Gm-Message-State: AOAM533nmzm3jWQyIqUrs/LuisInhT5Q/DdZbpgc3D1kuz7vEJi5kC+o
        gx/56R2UE9kR2pn3B9u+RWg=
X-Google-Smtp-Source: ABdhPJyDqo2D3LrCuH0aH1JxllWWvEzD2aTtCKIeOjfyqJ5ce3MHaHG1f8Xly2yHneMFTmQ3A6AYdA==
X-Received: by 2002:a05:6402:2074:: with SMTP id bd20mr18403209edb.123.1627336728208;
        Mon, 26 Jul 2021 14:58:48 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec25.dynamic.kabel-deutschland.de. [95.91.236.37])
        by smtp.googlemail.com with ESMTPSA id fw23sm266034ejb.66.2021.07.26.14.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 14:58:47 -0700 (PDT)
Message-ID: <602ee8bc56891f0f0429afe274d7174ec325172e.camel@gmail.com>
Subject: Re: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
From:   Bean Huo <huobean@gmail.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        'Krzysztof Kozlowski' <krzk@kernel.org>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     'Can Guo' <cang@codeaurora.org>,
        'Jaegeuk Kim' <jaegeuk@kernel.org>,
        'Kiwoong Kim' <kwmad.kim@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Adrian Hunter' <adrian.hunter@intel.com>,
        'Christoph Hellwig' <hch@infradead.org>,
        'Bart Van Assche' <bvanassche@acm.org>,
        'jongmin jeong' <jjmin.jeong@samsung.com>,
        'Gyunghoon Kwon' <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Mon, 26 Jul 2021 23:58:44 +0200
In-Reply-To: <000601d7820a$9aa11210$cfe33630$@samsung.com>
References: <20210714071131.101204-1-chanho61.park@samsung.com>
         <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
         <20210714071131.101204-15-chanho61.park@samsung.com>
         <2b4f4e6d76cdc517843fe8880312541c754d5352.camel@gmail.com>
         <000601d7820a$9aa11210$cfe33630$@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-07-26 at 19:40 +0900, Chanho Park wrote:
> > I don't understand here.  how many doorbell registers you have now?
> > and doesn VHs have a doorbell register also? and each doorbell
> > register
> > still supprts 32 tags?
> 
> 
> A PH has its own doorbell register and each VHs also has it as well.
> 
> The TASK_TAG[7:5] can be used to distinguish the origin of the
> request among VHs and remaining TASK_TAG[4:0] will be used for
> supporting 32 tags.
> 
> 
> 
> Best Regards,
> 
> Chanho Park

Thanks for your reply.

so you split the "Task Tag" filed byte3 in the UPIU header to two
parts, bit7~bit5 is for the VHs ID, and bit4~bit0 is for the task ID.
but this is not defined in the Spec 2.1. correct?

Kind regards,
Bean




