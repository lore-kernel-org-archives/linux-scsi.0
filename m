Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C534C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 791D82077D
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 18:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKP8yotI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgE3Sde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 14:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3Sde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 14:33:34 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61AAC03E969;
        Sat, 30 May 2020 11:33:33 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l1so3376694ede.11;
        Sat, 30 May 2020 11:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4YRgg4mVe6S4HVEN1nXvVtBG5wYMm2wu66O3xco6nK4=;
        b=JKP8yotI2lzkKDIIsMN7pn2Ki5qkpzzv5z4VvI3VIwk/h7VdUpS6AMQa4tonQ3P87d
         fJA0YW2pPZfwX77UzRSisHOtKDZ0pAdhoptxuYGB2VLtSL+6NSDnsS5KehE4L7y7qwqF
         xVfi8aXKMUaeKz5N3OJad/N139247jeuAO994Svnx5TaBGAwVYYpQifVNZiBFQO2y7WM
         EkvBPrHc/PUoVf3ZzNQiE7PVenuEHQolkGyvCrKPHMyu4d6HanUZ1OeoOaHcQFA0wzPx
         1DNgQQ94vi1qtH/AwIvQlxMRqk6ZiVLFbBD0Zy147rh10sYy1q4nttumLXkSIBLo4+N3
         dIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4YRgg4mVe6S4HVEN1nXvVtBG5wYMm2wu66O3xco6nK4=;
        b=iaCAZd4Af0lpE3I0OCfL/PJ5DEK9RgzrwSLRBurKcU5oUgMcjWGNDJnylo837/Wfyt
         46HeF+DZM2zQdqBmTxJpiHRpLDn6kzcR8hNavOTCrChaMMhpsmO8EUZLr1BC5PM8fHu3
         FqPIzRPlcELuPCVvj+6Tg6eEC1k1t/8jxkUAm0o4NdtsNogOESe3f2+bDYZFbs787q/f
         cHcnvJ7Cw1XUgB9L3pa81kK9Qc+mM5B9CFjuIINkowHEYgSgHZQj2PQtN3HrAXihbrxd
         WHEKnf5Z5v41+ztVQDESxme7Mt0GkQGSVzNL3ArSkMWiUyYswsWPOxCsTlnN4yUrQ28t
         ym4Q==
X-Gm-Message-State: AOAM532+gYurmq+RuTA+swGJcJtt/0R9m5QYWvExqxuRh9aYy/cmtDHi
        uzC2viZIHYlKUULBq8qx8p4=
X-Google-Smtp-Source: ABdhPJxoKcqPPeiHd1t2DQRM7qEB7RbRF9OkeLM71hCnW9k4lbASnFMpv6TOy6iPLqI4eyX4F5/Brw==
X-Received: by 2002:a05:6402:1ac1:: with SMTP id ba1mr524185edb.91.1590863612448;
        Sat, 30 May 2020 11:33:32 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.googlemail.com with ESMTPSA id dt7sm10440171ejb.33.2020.05.30.11.33.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 May 2020 11:33:31 -0700 (PDT)
Message-ID: <07b197a84394a20cf175e37d1a442d52535856ae.camel@gmail.com>
Subject: Re: [PATCH v4 4/4] scsi: ufs: add compatibility with 3.1 UFS unit
 descriptor length
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
Date:   Sat, 30 May 2020 20:33:30 +0200
In-Reply-To: <SN6PR04MB46404D5B77121B367C17AEA2FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200529164054.27552-1-huobean@gmail.com>
         <20200529164054.27552-5-huobean@gmail.com>
         <SN6PR04MB46404D5B77121B367C17AEA2FC8C0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avri,


On Sat, 2020-05-30 at 06:56 +0000, Avri Altman wrote:
>  
> > 
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > For UFS 3.1, the normal unit descriptor is 10 bytes larger
> > than the RPMB unit, however, both descriptors share the same
> > desc_idn, to cover both unit descriptors with one length, we
> > choose the normal unit descriptor length by desc_index.
> 
> This is not what your code is doing.
> For RPMB - desc size will not be 0x2d but remain 256.

sorry, I'm afraid I didn't quite get your point here.
would you go over it again in detail please?


> 
> Your strategy is still correct IMO - if you assign the larger size,
> The device will not reply with error, but with the proper buffer.
> 
> You can also rely that reading the rpmb unit descriptor will not
> happen before
> Reading regular luns, because this is happening in the first
> slave_alloc.
>  

On my side, I saw the Well-know LU descriptor is read before
regulaer/normal LU descritptor. see ufshcd_add_lus();

I did further debug to verify my patch, and the unit descriptor read
sequence:

1. read RPMB descriptor: desc_id 2, desc_index 0xc4
2. read LU 0 descriptor: desc_id 2, desc_index 0
3. read LU 0 descriptor: desc_id 2, desc_index 1
4. read LU 0 descriptor: desc_id 2, desc_index 2
5. read LU 0 descriptor: desc_id 2, desc_index 4
....

> Hence, I think you can drop the extra if, and just add the comment.
> 

so, this 'if' is still needed. otherwise, LU descriptor length will be
initialized as 0x23(RPMB descriptor length).

if I am wrong, please correct me.
thanks,

Bean



