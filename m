Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC03AC4363D
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D4072395C
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 16:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="E3aQbiIv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgIXQiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXQiC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2020 12:38:02 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB41C0613CE
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 09:38:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id m15so9706pls.8
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2020 09:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m8yoJ4hRCbgftd/8ZIsjNh0LkJ7Nydkty+V1N9DwVzE=;
        b=E3aQbiIvW5ASzsIkkp4L5xe1VDQ/x6f7tmIU2Qumkwd44yFJSjejoix4OG0VDdLsvi
         8t+6AAJ74OW2TZn4hx4iETLmvTg7ipW2EEF9JYsPuiEeMJAug4MS3aWcaeRC4G7h/BXx
         YUJC6ryDk7Hexo2iNCQFVs/7TaXTt8OhJTows=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m8yoJ4hRCbgftd/8ZIsjNh0LkJ7Nydkty+V1N9DwVzE=;
        b=puHTGT1d81+XTawZptmMkvoURw4QMMG7UDRSMh/8IBQb+hA1u6NRePuSmIkqPAepQu
         zhdu2U3NseayKY+L7rIlFRfHcdElPNBNbKYjVLlnSKKMtz3R3vaOb6SCLejviDskvbqX
         eE2DxnIux4bXXcL+Ii9QN27SyUvOoSy1eUegbOyUB0otAlBWtYCYedrveea17zQEo//E
         i4i8nQVdDGB6SNlcPpCtnnVdnp9+KZ4thmFxUCl5BoXTjCwxwktfc2xi5E2VNuND+uxb
         KIpLm4tvmhv11kfgC2iK83m71uA05XgHj1C4MXrOQ3GQKaIbMPyiYgVuZBlSn6pIrlmg
         ykKA==
X-Gm-Message-State: AOAM530e+UCr8uNymr3sTcWyTzOUirI3rig6zpYWgLsPVpMp0NoUmbIT
        10jkQQqwRdOZUkU8Pknt02tifA==
X-Google-Smtp-Source: ABdhPJxVpIUmlg6QSO0uo7qVfI3GBTpCHy4KBpDLxb9AfL98zXDrzOu/BbfG6zdmg0N7jrHCSpOzDA==
X-Received: by 2002:a17:902:bb8c:b029:d2:2503:e458 with SMTP id m12-20020a170902bb8cb02900d22503e458mr70213pls.18.1600965482178;
        Thu, 24 Sep 2020 09:38:02 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id d7sm3528624pgg.1.2020.09.24.09.38.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 09:38:01 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.33\))
Subject: Re: [PATCH] scsi_dh_alua: avoid crash during alua_bus_detach()
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <2F7D7601-D9C2-4FFD-AA59-65A243F16AA9@purestorage.com>
Date:   Thu, 24 Sep 2020 09:38:00 -0700
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Ewan D . Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7C45D147-CF0B-4B7B-8EE2-F96977D000DD@purestorage.com>
References: <20200924104559.26753-1-hare@suse.de>
 <2F7D7601-D9C2-4FFD-AA59-65A243F16AA9@purestorage.com>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3654.0.3.2.33)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Yes. That looks good to me.

Thanks,
Brian

Brian Bunker
SW Eng
brian@purestorage.com

> On Sep 24, 2020, at 9:36 AM, Brian Bunker <brian@purestorage.com> wrote:
> 
> Yes. That looks good to me.
> 
> Thanks,
> Brian
> 
> Brian Bunker
> SW Eng
> brian@purestorage.com

