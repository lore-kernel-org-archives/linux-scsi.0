Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77D3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B657E20756
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 14:43:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eacYIhJJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLOm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 10:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgHLOms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 10:42:48 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD95C061383;
        Wed, 12 Aug 2020 07:42:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id bo3so2517846ejb.11;
        Wed, 12 Aug 2020 07:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9OQv4e9NX7HX1bkO4ou+vTmkM5NleqGKG5z6kX3PyeQ=;
        b=eacYIhJJXQkfMWSRFwYtMoSaOsoGksinGKdnca/KHMExhRSqCT0Xw3mNBwCTtNMQWr
         K9OzZJeWsQtQJg2mEuRqSgpigM7TiF4CNRrKcCRqgpIMDljIpQUYh9DIu1L/YbPoYwcx
         bZPJQJUjeT6DjXP/ts9Pdc4DHjAT/VwuTjJ1n7iCQHTbRAMTzxxfef1apG+e0Tw4/UCT
         jNSlFZ35djFbUssdn8O2hdi54m3cBNGnRWfJxfX7rgz4EQWvTZPj7JfhzcFU99sz1Igk
         uu2axHpXMGvVhJmMC6rHfRmVipJ2ujB4QI5A6NY5n+XGnv4O1qi1nzOio5XB88r6iGpW
         q/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9OQv4e9NX7HX1bkO4ou+vTmkM5NleqGKG5z6kX3PyeQ=;
        b=XnUSJre4425vhmxT1cUV9wCqGou/pyM4YloyR34Wcp7zQ4Krx+ioBjDfGEcnW/WWGh
         ucRGGx/VZ0dIwlTMpcsGObcunS9JYNEN0s2a+Sfep++oj1AQ19+lxe4pTdUMtfmMxCfE
         PLagG/MzuyNKtstGGZF+qijJ6UKHvQYBuHNeXVIeUfOG7gCiKzoAMR8UcfRdWL/KKtOt
         dvBppbcXMeVU3+XMT+x2iNJAru7s1TidxBvQa/j2kldZFgVUrosJWf4VtY4CLF6wKuTv
         kzKBnmOxOSJ0zERkCIX4CjxFuhlZvDV+tQ3I+gPXmgcz+UEObYJ0/LEgmCnjc0vySgs/
         eNjA==
X-Gm-Message-State: AOAM530uc7mSF/+84AYpo597bUf0S3exqzXnW87tQChnLCJJ9SeKRYyX
        E9Zh6ZZbSjOSxxeih+UdpUg=
X-Google-Smtp-Source: ABdhPJwGWDqneDCYXgcdcVEsEM/xykXWlgadYriKMelN8TFZtF6EaeoY+ojV7y5DzTV49HgLQxnicA==
X-Received: by 2002:a17:906:b2d0:: with SMTP id cf16mr107348ejb.514.1597243367238;
        Wed, 12 Aug 2020 07:42:47 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b90f:8e5c:44c:d55b:5f94:2fc4])
        by smtp.googlemail.com with ESMTPSA id w9sm1741488ejk.62.2020.08.12.07.42.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Aug 2020 07:42:46 -0700 (PDT)
Message-ID: <4da0c324952861608bca14df77720e805be881e5.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Cleanup completed request without
 interrupt notification
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, avri.altman@wdc.com
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
        bvanassche@acm.org, tomas.winkler@intel.com, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 12 Aug 2020 16:42:39 +0200
In-Reply-To: <1597236472.26065.9.camel@mtkswgap22>
References: <20200811141859.27399-1-huobean@gmail.com>
         <20200811141859.27399-2-huobean@gmail.com>
         <1597236472.26065.9.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-08-12 at 20:47 +0800, Stanley Chu wrote:
> Hi Avri, Bean,
> 
> On Tue, 2020-08-11 at 16:18 +0200, Bean Huo wrote:
> > From: Stanley Chu <stanley.chu@mediatek.com>
> > 
> > If somehow no interrupt notification is raised for a completed
> > request
> > and its doorbell bit is cleared by host, UFS driver needs to
> > cleanup
> > its outstanding bit in ufshcd_abort(). Otherwise, system may behave
> > abnormally by below flow:
> > 
> > After ufshcd_abort() returns, this request will be requeued by SCSI
> > layer with its outstanding bit set. Any future completed request
> > will trigger ufshcd_transfer_req_compl() to handle all "completed
> > outstanding bits". In this time, the "abnormal outstanding bit"
> > will be detected and the "requeued request" will be chosen to
> > execute
> > request post-processing flow. This is wrong because this request is
> > still "alive".
> > 
> > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> > Reviewed-by: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> 
> Thanks Bean's patch integration.
> 
> Like Avri's comment in https://patchwork.kernel.org/patch/11683381/
> I think you could add Acked-by tag from Avri.
> 

Hi Avri
do I need to re-send the patchset to add your Acked-by tag?
or you will sign your acked-by statement and append this patch?

Thanks,
Bean

> 
> 
> Hi Avri,
> 
> Please correct above description if required.
> Thanks for your review! : )
> 
> 
> Thanks,
> 
> Stanley Chu
> 

