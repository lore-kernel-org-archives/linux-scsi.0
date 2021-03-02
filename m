Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDDBC43381
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B9164F1E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835335AbhCBSwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350810AbhCBMue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 07:50:34 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DADC06178C;
        Tue,  2 Mar 2021 04:49:51 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w21so25019018edc.7;
        Tue, 02 Mar 2021 04:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QLU9bSmbJly6ESDXXMGZpe5ejk+FdLMiYAyttQ2v9vQ=;
        b=Jd7+gtNV675ZKYR0E2HjtgZkxCvAyvArpx74jdtbV/8lpnr8URroZayAKCS03MuZZx
         r1W3whOsl7kTqWCoYmTx8EBQNTBH2KzbAWsDRgXUmVUz8TnDOj547U4rspsWzZCNgoq/
         WMmNcAti1t/fbE717yG1RXxRt8CufkD9L7zwV/B7mXyn2TF2SwnhoN67FeyaTP8iTR1q
         CnVNlkUJtI0hfcX8/NSl7gw74evK4Wm2sPpSCR9bpwR0zRJ9sLK6sjgvnYxD8oXuYVCw
         b1Hp1aN7Q1Rdp/IqgJUhOylvKysl8kzVtFBLOAvM1yBO8qmKotPb7BsSDrj9dfdAAJVu
         6pOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLU9bSmbJly6ESDXXMGZpe5ejk+FdLMiYAyttQ2v9vQ=;
        b=lTlft1eiNSuAlOz2obRG+/wzyakpZy6J6nrr8ot4CkRJomJqsvuNf/mXn6Zu4DXK16
         jBvxQSdHx5i0KRnkbPtGzHI68cSCWDFgDq7H4lfeMrFXYWPwP+TW8u5LEajBTKMfp1Ki
         RRFqOIRxlXmwWKoGjCGdnQYC65Xw0Ywf0ZBeg2maEXCgnGK6MMnxF3vcdaO2zG2HrZD9
         tpxjisel1npJ8amxX1htF+Z/S8OMpgyWGJeYfe1/4sFungbIqFJZ97J4cW7G8gg5UYK9
         c9n+SH52bwjyuRpIZbHh9y3yIBhYZimk3wfo0MG3DW/DZbVSjseNXR8/FreVtJAGi9kI
         bEUg==
X-Gm-Message-State: AOAM532hFup/ZN/2PWNLd6ZjV3lfRjQGlYbNEHlo+XhX4qp/1n4V7IWa
        UV6P8TIsKXyW+MgtB49L147j14gRN0R+hA==
X-Google-Smtp-Source: ABdhPJwnNphDvpTn8ddSATgB8AtiOSrAkr4I4UwJ8o8LT8S1sOULdF9paDHAMZ2dJBxgJ7BtqcRJrw==
X-Received: by 2002:a05:6402:4d3:: with SMTP id n19mr20449431edw.2.1614689389814;
        Tue, 02 Mar 2021 04:49:49 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id a12sm5543437edx.91.2021.03.02.04.49.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Mar 2021 04:49:49 -0800 (PST)
Message-ID: <fb70bf48fab65474bf2f15a436852ccf9a3db026.camel@gmail.com>
Subject: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Tue, 02 Mar 2021 13:49:47 +0100
In-Reply-To: <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
References: <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
         <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p5>
         <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-26 at 16:35 +0900, Daejun Park wrote:
> +static void ufshpb_set_unmap_cmd(unsigned char *cdb, struct
> ufshpb_region *rgn)
> +{
> +       cdb[0] = UFSHPB_WRITE_BUFFER;
> +       cdb[1] = rgn ? UFSHPB_WRITE_BUFFER_INACT_SINGLE_ID :
> +                         UFSHPB_WRITE_BUFFER_INACT_ALL_ID;

Here is wrong, 
Valid HPB Region is (0 ~ (Ceiling( Region size calculated by
bHPBRegionSize )- 1) ). how do you know the region==0 is not 
a single normal region?

Bean


> +       if (rgn)
> +               put_unaligned_be16(rgn->rgn_idx, &cdb[2]);
> +       cdb[9] = 0x00;
> +}



