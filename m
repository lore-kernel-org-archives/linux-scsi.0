Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B754C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 12:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E77208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 12:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vdy5gWLv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgEHMQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 08:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbgEHMQD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 08:16:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EDAC05BD43;
        Fri,  8 May 2020 05:16:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j5so1604839wrq.2;
        Fri, 08 May 2020 05:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p022wi7eOZ/mGn1ToBo+V56FcvhDPdcFh/MpymQ6w34=;
        b=vdy5gWLvmv4WW60B+MSjZYY0aEofZ1J9SFJ2Zl3QjbUu0gGnVQyJ31nDFWiM9PPRtQ
         MlSTkL2AZ0qfIZEolIG6QsQwfKPm2k5CnCs+WvwzBmI+3W4NE2PKX0NtZw15J7rB5bjo
         dXmUh7EW1n7vTefA/bv+SKmac0NXb96aZ3fu0jD8ciE+xUuyFGZdnkOyoxX59evb6Eax
         boX9OhA/WzJ0UuJsPdAegkG4JzL6nBmxmlRK2D99p32UpZNUzbE+E3Xp+9PmN4p//agV
         lTUuTrcvTAFeemOZtQ4FkuTZ4iDSCoNJs3EcOkkGc+Umd24P6LfPz0CRFkYhR/Cmbc5Y
         Nj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p022wi7eOZ/mGn1ToBo+V56FcvhDPdcFh/MpymQ6w34=;
        b=Lg6Gpbpq8krDdP5FRJWJGY1DH3JJMrSCGA79epMfEb/VHGBdbvbdGKiYRUa0bNfFle
         lqZkiFTBonJTaQVi83qmAFl/sW077VeMclcdXtngcRaHn0Jqg9qoG9/Z54lSQiSvJHap
         8uZXUKg/KF+UVGhjc0dcmeeoksqzan8ycxzPoVWaHVuuORrhxtwzkZaUP1pZ90V2hUaP
         zfH5EdsmYTQ1deKAPspc3EOruPSPZKJeL9buw8+ytRgklNWl1OjIwK/QK9/afWgJYAJ+
         Ncl+qobwxd8gdvDFZgAlWj/aGmpAWpJb62DbzMDpeWyKN8OfsXB/KZuxBuFvai+0fHME
         44QQ==
X-Gm-Message-State: AGi0PuanU6IE1dr3ZZdPOtEs63pICSfXmo/aUNqvX9ZbQvY4njm5TYl7
        Fj50hjVDU0CJroJyZIoF7loPWLxXhZ8=
X-Google-Smtp-Source: APiQypKQU3XDMt2+QtR6u6sPyGZk8FmmD0FXgCIHUio+Q83GS6nn6Uuz7ZrQwJsUcKFtfiGStoCvIA==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr2647798wrr.222.1588940160456;
        Fri, 08 May 2020 05:16:00 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id r20sm12168431wmh.26.2020.05.08.05.15.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 05:16:00 -0700 (PDT)
Message-ID: <12cf335dc86f6eafa1f090dc0b150796532da3e1.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
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
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Date:   Fri, 08 May 2020 14:15:58 +0200
In-Reply-To: <BYAPR04MB462904DA704A8FD42436BA9FFCA20@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-6-beanhuo@micron.com>
         <BYAPR04MB462904DA704A8FD42436BA9FFCA20@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-05-08 at 11:38 +0000, Avri Altman wrote:
> Hi Bean,
> This patch is ~3,000 lines long.
> Is it possible to divide it into a series of a smaller, more
> reviewable patches?
> E.g. it can be something like:
> 1) Init part I - Read HPB config
> 2) Init part II - prepare for L2P cache management (introduce here
> all the new data structures, memory allocation, etc.)
> 3) L2P cache management - activation / inactivation / eviction
> handlers
> 4) Add response API
> 5) Add prep_fn handler - the flows that contruct HPB-READ command.
> Or any other division that makes sense to you.
> 
> Also, Is there a way to avoid all those #ifdefs everywhere?
> 
> Thanks,
> Avri
> 

Hi, Avri

Thanks. I will split it in the next version based on each different
funcitonality.

thanks,

Bean



