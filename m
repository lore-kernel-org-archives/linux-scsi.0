Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20BCC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 11:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 503A92083E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 11:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mLvG7P2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgKYLya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 06:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKYLya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 06:54:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A55C0613D4;
        Wed, 25 Nov 2020 03:54:29 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id k27so2585287ejs.10;
        Wed, 25 Nov 2020 03:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXMWiO/nEgseQJ61zPcw7m8Ch8R9S9P35c2iOp2Qd5w=;
        b=mLvG7P2Mj8TjNFSVleSDlAq0KXuIfNqRw2cNWsq3kdLASmS1XD2UMD4hck9cDuT+V+
         bMeNHEofsL5IyX9RU3Ja+3Ai2lEFUXy+Rn6TU8fmVWW+BDeL1m1p4qVu9b9H/vwOv+au
         MpaLi+Euod+ZF8pNMfo4YLMnQes6FRF7n68YIX5OXj+2fKv4Vp3cdbIbU8pt5MsCTFN2
         7A5p46KpxsqJPVod3qXKd7B/YQekKXwAO2tcHj/fni/XEv1NAwauB9xOdgHIA86wG2cr
         XDFMI5lR+Khz8iKPqDPwV3nxY+G8fq5lgR/+XMZEauPhTkcm0QTNd0aAz489G/VDBBU9
         S1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXMWiO/nEgseQJ61zPcw7m8Ch8R9S9P35c2iOp2Qd5w=;
        b=mVAwxDnjB3dQdh1zBpanEzK5yMORS0eE+OcjaguzO0XZxkhdegLmxdfNvWghde1aaf
         hi9WiFbNm4Ko+DbsX/L9xznoIBQqOiPg53I+yCpTmaNRpUzjKtggRG38ay7NM2S/jsCC
         EBhX4fS7fNHSPAzD1++fkVd/JLjb2FS4gT+FkwSkVHr2KgblVhgySCLFKmpL7JqDqH6B
         9t4LjLxgz+T/WGUOu4ewjG+EyJIjVo5wfUiqL9NduWV722OVcQIwWn3KWXViiPNmnDIs
         uqbTew2+h0yvNEyOB58qhZt/90H396VgSjybNupMFqV3WQjaloUEDhGdrcQUzHEjcG/J
         3asA==
X-Gm-Message-State: AOAM533zMea3YERrq9sYNkgpM4vYB/ulHYI9ozQzhU6kyLpsQqJ30RDp
        /0hGr0ey3ZX1MxTz07HvYGQ=
X-Google-Smtp-Source: ABdhPJxvE9NZQVCbYriE8I+PhN6gwTtCU5dYOye7RCXdPwxpmCZTJEkbKgKdMZiYuGLcfgIv4cls7w==
X-Received: by 2002:a17:906:a448:: with SMTP id cb8mr414518ejb.365.1606305268260;
        Wed, 25 Nov 2020 03:54:28 -0800 (PST)
Received: from ubuntu-laptop ([2a01:598:b885:70fc:e10d:51e4:644:a1be])
        by smtp.googlemail.com with ESMTPSA id j34sm612091edd.57.2020.11.25.03.54.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Nov 2020 03:54:27 -0800 (PST)
Message-ID: <0b0c545d80f9a0e8106a634063c23a8f0ba895fc.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 25 Nov 2020 12:54:19 +0100
In-Reply-To: <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
         <1606202906-14485-2-git-send-email-cang@codeaurora.org>
         <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
         <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-25 at 08:53 +0800, Can Guo wrote:
> > > +       bool always_on_while_link_active;
> > 
> > Can,
> > using a sentence as a parameter name looks a little bit clumsy to
> > me.
> > The meaning has been explained in the comments section. How about
> > simplify it and in line with other parameters in the structure?
> > 
> 
> Do you have a better name in mind?
> 
no specail input in mind, maybe just "bool eternal_on"

> Thanks,
> 
> Can Guo.

