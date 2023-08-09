Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8422C001DE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 18:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbjHIS53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 14:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjHIS52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 14:57:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BB4E51
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 11:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691607398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EOeT56fYFXenbiTjEbqIlGNmaCm7sLXNGQKrx5ZWC5o=;
        b=iwLOc8Y9imXuuWImoEEUE1kjOJ3dR1dOTJtgADdkoGQXz9845qTA78sTwqM61tc+xINgzj
        Ez+9G6pBdgmzTAvnwlgyU79MKFhxPhqHX9RyecL07LPGN/gJpTiHwvfTaXa6L1/oy2OkNN
        TyQBtmApbSLrebAHu8cScrU5h48yFyk=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-vOWWBCw5OvWMfd7L_mGZpg-1; Wed, 09 Aug 2023 14:56:37 -0400
X-MC-Unique: vOWWBCw5OvWMfd7L_mGZpg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-585fb08172bso2725797b3.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Aug 2023 11:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691607396; x=1692212196;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOeT56fYFXenbiTjEbqIlGNmaCm7sLXNGQKrx5ZWC5o=;
        b=HXNgIfnErY5CEgu9TfQCK4Rn5rritrAGSV7JpdGn3/t1PWdmXvL4q/R77b1nCRFio3
         9TNDu8Y/dQ8H61f8/9q0FEVnslHXJhpXuiO8cvQueaIyL0XDIEy1c6qcPwdtV6KA6rBm
         4o1m6f0/VaxxUDrllSbi2vZdJqh05/ebbj2we2vMGVumJnIh0utGiMjZHSJ+kxnqR+G3
         JCO9cQMtbkaNF8u9/ZEK34InODNlxjq4exdw1TI83WO98dsEEwUuu1p20QCRc4dEslx9
         nBeUjGNxCu0wf1aGwh+29bwssrpG3WSAkLcpeFYZPSJhSPXhj4Ll1+HL2NryLjdeWA3M
         jriw==
X-Gm-Message-State: AOJu0YyoDcJTA04vdtNyphXhYWJHOvBdGwSp2Wvs/4CallqQnRzWMKzc
        5YHX/wsLtKi3jES2Y6IZYGDXkeOqY+fg1RxBbdb6vrBXVwN8v/egqEd6he8Vx3lTcooOJF0PW8Z
        amh7wRFXXd5sHnbzLD8Dd2g==
X-Received: by 2002:a81:4f91:0:b0:57a:9b2c:51f1 with SMTP id d139-20020a814f91000000b0057a9b2c51f1mr211519ywb.1.1691607396775;
        Wed, 09 Aug 2023 11:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeb8QRGb74j1vFryxurJ7SZstqb4N5IPmc6D8B1e4Q/O0UeGAeI1H9yFfnG7Vqoixf40LJ4Q==
X-Received: by 2002:a81:4f91:0:b0:57a:9b2c:51f1 with SMTP id d139-20020a814f91000000b0057a9b2c51f1mr211500ywb.1.1691607396536;
        Wed, 09 Aug 2023 11:56:36 -0700 (PDT)
Received: from brian-x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id e9-20020a81dd09000000b0058038e6609csm4101487ywn.74.2023.08.09.11.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 11:56:35 -0700 (PDT)
Date:   Wed, 9 Aug 2023 14:56:33 -0400
From:   Brian Masney <bmasney@redhat.com>
To:     Hugo Villeneuve <hugo@hugovil.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: ufs: core: convert to dev_err_probe() in
 hba_init
Message-ID: <ZNPhYRslrcwAHo3Y@brian-x1>
References: <20230808142650.1713432-1-bmasney@redhat.com>
 <20230808142650.1713432-2-bmasney@redhat.com>
 <20230808162929.a1b784ad42bd346cd87747b9@hugovil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808162929.a1b784ad42bd346cd87747b9@hugovil.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 08, 2023 at 04:29:29PM -0400, Hugo Villeneuve wrote:
> On Tue,  8 Aug 2023 10:26:49 -0400
> Brian Masney <bmasney@redhat.com> wrote:
> 
> > Convert ufshcd_variant_hba_init() over to use dev_err_probe() to avoid
> > log messages like the following on bootup:
> > 
> >     ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
> >         failed err -517
> > 
> > While changes are being made here, let's go ahead and clean up the rest
> > of that function.
> 
> Hi,
> you should not combine code cleanup and fixes/improvements in the same
> patch, split them.

This is a pretty simple patch as is, and split up the code clean up is
not very useful on its own. I'll just skip doing the code cleanup and
only post the dev_err_probe() change in v2.

Brian

