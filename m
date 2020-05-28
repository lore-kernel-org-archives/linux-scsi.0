Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA7EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCED20888
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lgozBsJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390568AbgE1Nry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 09:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390486AbgE1Nrt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 09:47:49 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42407C05BD1E;
        Thu, 28 May 2020 06:47:49 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id r15so3221730wmh.5;
        Thu, 28 May 2020 06:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=59q2X1dLv7LPdt/5T9ul9rltygoE3RH2ulsqgC35EVc=;
        b=lgozBsJ8tJHeBiS/JAatgliagvgIkF+FzYXDS93183YNcN2cJ9rOl4GltXhIpHgBCs
         ll7ovbzZGz/MS22oBYPswPs8bNi+StQNyL9pkeuDv6avjBlI3OCCCRx7VVI+riKW0Kds
         F68RTb4A1LkKVN2QMYjLSAtwvOFBmcp/Gb3WytBo4Hm1Gfa1Xr12II5ky/Ncoaf5+H92
         52DXlmtRZyYf+nIwM2bsnP/Oa+pJIbHi5S3l/OAiKiLexVzk37jrFpVGGzc2VljuxPGv
         4d3o7WRVx0tdItFvB2Ksv+Yg58R5giz9gD+sn7eId8ik+rTQS9mMX9jT8jSYUgwNfTgA
         3Oqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=59q2X1dLv7LPdt/5T9ul9rltygoE3RH2ulsqgC35EVc=;
        b=UZ8bKHvu+lf0vKqeO/2yzdBZFCh43brqPpcHQhIn1t6DPb6p3TOUpmTgycPJJAf938
         Bu6pWick0qcAnPt4jGVlOzzdAcVvQqVY5adbaEPqv7C8nkzkXEYEM104zQqYBNmMSPjJ
         Z2l7rK6VIUHGQtzXbSMInpeP2IHM1E/QOChSI+116J7qz/nyDfjHgW2Y5YE5mDP2+ZCe
         pnYM58xksB50mX0rhZhFol4Oh0oTDlhg18g/xfVw0cNyngVI911yr3nrmbVCFH/fK548
         EIN87VAfvrLCh2baxOU5f2CB+q1ObZnEgoK0RUl0htheKl3TSsqd/v07EhyNTtD4swXf
         6v5w==
X-Gm-Message-State: AOAM5303lCJOZc9nGZGgMQXMgdPkF3NvITjDvHDdWfEVO683/dgyu84O
        OmWGfSDkreddmekH7tslXb4=
X-Google-Smtp-Source: ABdhPJw9cr+ACK5navy4UlzHCkUCBi+3k6g+FtYRJDIScuWXiz8RB4LTo5bEtSRITpK1jhdNWw5LVg==
X-Received: by 2002:a1c:44c3:: with SMTP id r186mr3432227wma.67.1590673667877;
        Thu, 28 May 2020 06:47:47 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id q128sm6146821wma.38.2020.05.28.06.47.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 06:47:47 -0700 (PDT)
Message-ID: <9a317a138c61c7937b655dbd73ffcb40985d61c8.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] scsi: ufs: remove max_t in ufs_get_device_desc
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 28 May 2020 15:47:36 +0200
In-Reply-To: <SN6PR04MB46402C75D4CBDA85A3628BB5FC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200528115616.9949-1-huobean@gmail.com>
         <20200528115616.9949-2-huobean@gmail.com>
         <SN6PR04MB46402C75D4CBDA85A3628BB5FC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-28 at 13:41 +0000, Avri Altman wrote:
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6881,8 +6881,7 @@ static int ufs_get_device_desc(struct ufs_hba
> > *hba)
> >          u8 *desc_buf;
> >          struct ufs_dev_info *dev_info = &hba->dev_info;
> > 
> > -       buff_len = max_t(size_t, hba->desc_size.dev_desc,
> > -                        QUERY_DESC_MAX_SIZE + 1);
> > +       buff_len = QUERY_DESC_MAX_SIZE + 1;
> 
> So why the +1?
> Originally it was used for the '\0' terminator, which is not needed
> anymore.

you are correct, now not need +1, I will change it.

thanks,

Bean

