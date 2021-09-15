Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46240C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E74C61214
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 09:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbhIOJGk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 05:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhIOJGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 05:06:39 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E21C061574;
        Wed, 15 Sep 2021 02:05:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id h9so4626814ejs.4;
        Wed, 15 Sep 2021 02:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Iis3hUZBleMeHSyqqQwPSDaCQ/5tJDwKa10qnLYQLTY=;
        b=gQw4Pym82UXI2oxT1ys3emMSBqZsKAh4qnEqygjl914G3qc+SIQm9+PMqTK5QbhrWi
         hnruBdSmK6u/JoRG8iIeUDfPJIpDNFh0rpAPwrR13MG+YtuhVol5XgMdOaCQCCZYrgJz
         N2Kk7bEnPczRNCOZezcC6EO1fSlyefSvJvIx0N1tdXAl0qGNq0A0p/FJyl8Brb3+S1vX
         FFyGjkw9baMIxF6wwn22euwr1MP7YrmaW1qQS2ed/i9Z9s5Im+26HYAcN5MtaHJ4Fuf8
         DAY7GIdAUbUr9NN49IHA6x2zmbaj1A23jInCgXXhwhlXilvIPIlmSzuiCTHmTBahsTXK
         kKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Iis3hUZBleMeHSyqqQwPSDaCQ/5tJDwKa10qnLYQLTY=;
        b=zqAtzki8sDRZFi74vI9Wl7qCthGpM3ibR0ookkj89YNoRAdsRhHiVpdkvqvIvzw0lz
         c4JTjLPeOD8UwEW6xYml5dJGHwjNJ/h09OXNA0nDsduREiR4XWzCC1wjcDsqJPqBDUj4
         x9DPBx7/CS4vy/yboPmBxAxBJVrKghPr2JGq5G0rV5KAAb4FU6b8yHQZWNW2g0fXhtM1
         uKHW38R08ImJLN7gngAivtBbgxSnkpUtnF1ayQz3nIaht7yof4dJ+eD6YA0NcVOm0umx
         7uOX69VjFL8/p+DA8FzSv+sxyXk4WOjNI1yGS4V7dPQveTaotAABPj7Lsun3DcIgr3Vz
         pSsw==
X-Gm-Message-State: AOAM532MOnsq/0QHry+MXjj/duJFFbBxS9GQ7z2VRhlqljxiwKUfUz9/
        DyiTgMMi4GRFxPPBGUxNXaGTp592bC4=
X-Google-Smtp-Source: ABdhPJxe2nx60/GV6MnkGMZj/bVriRYC3KXrUoiiLfeeA3ZNvElfFf+Mfs+SynCGIXAVac1SUxtQsQ==
X-Received: by 2002:a17:906:1319:: with SMTP id w25mr24503538ejb.552.1631696719208;
        Wed, 15 Sep 2021 02:05:19 -0700 (PDT)
Received: from ubuntu-laptop ([165.225.203.49])
        by smtp.googlemail.com with ESMTPSA id w3sm6529702edc.42.2021.09.15.02.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 02:05:18 -0700 (PDT)
Message-ID: <7455519e5772c8a5c6e09d055a8fdbd138aef588.camel@gmail.com>
Subject: Re: [PATCH v7 2/2] scsi: ufs: Add temperature notification
 exception handling
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>
Date:   Wed, 15 Sep 2021 11:05:17 +0200
In-Reply-To: <20210915060407.40-3-avri.altman@wdc.com>
References: <20210915060407.40-1-avri.altman@wdc.com>
         <20210915060407.40-3-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-15 at 09:04 +0300, Avri Altman wrote:
> The device may notify the host of an extreme temperature by using the
> 
> exception event mechanism. The exception can be raised when the
> device’s
> 
> Tcase temperature is either too high or too low.
> 
> 
> 
> It is essentially up to the platform to decide what further actions
> need
> 
> to be taken. leave a placeholder for a designated vop for that.
> 
> 
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

