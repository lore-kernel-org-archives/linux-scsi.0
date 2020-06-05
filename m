Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB318C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B6C206FA
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nwvDBXzX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgFETY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 15:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgFETY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 15:24:57 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82169C08C5C2;
        Fri,  5 Jun 2020 12:24:57 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k11so11310725ejr.9;
        Fri, 05 Jun 2020 12:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a6tAsRPhV3Cx+JvaoalRjPfpIYInNkIpjju6515gy3E=;
        b=nwvDBXzXQXCGh6DGfkXdRoIsbt39xNptx2pjRidLidGX/JA8vOIqatc4HwaLYLCuVo
         ASqFrkTKUYnbqRa6tLd7Gfn5yfPfA1vsNuPZzhk2dkSItmsGywOSVkIB6CcSJCLV667N
         2xq5s2acIQ6HzDWzWorLFwucUEe/ACHLW3vsRfDwi1tysg868Xte8th4Pdly44RevBLh
         213Hl105++NO/xLDxJUmx81gTI25e1lj/ATL33GdmTTAQbZ1B7mAjL64xSBVHeI1pwjg
         Wu80XcEmtBiuRCUmanwqYh9fmw3YiMXLpEiVvvs257Z6MfgLJ2ymFV5lHpMdJ9KxBffa
         dakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a6tAsRPhV3Cx+JvaoalRjPfpIYInNkIpjju6515gy3E=;
        b=bAn4BtSwPEW587XRihINNReiIWOwNgmnQ930TjInNYQfEYdSIJhX64YzaVj2T+StIg
         /WavoTeqD06WPVGd76M9omJEYGp3bi60DzgzemLHH1EjdYt+VE+9N520BFDJHoduVrxi
         DpVCRFkClPZrExpRn6CvNjRNqfAM+4pLy4qtGYt2dYJjsF7OWx2PFihEdmBoN7wVQjJr
         x3ZJ4u0aCB98nePBL9T4xCosN1PGtfc0AHF7TzpaXJdAP5o9W4gDn9D848ZVMWT9pa0D
         fMS3yxx2ftIB4VjTkgqRTduPf1JWD9p3nUmHkYMVfUoZFWZGFQALwXBc7RRXNe6P+fEJ
         TAXA==
X-Gm-Message-State: AOAM533+LC3dpSTr6bAcGQ/2RJAzm2zFWkcSfvMmWPhrJ5tFAY+zwvee
        aElwZVjuB3+ahup8UX+CEqk=
X-Google-Smtp-Source: ABdhPJy1tY37mS/faSNjI4DE2G1XJUeWE1rL0T+U5o6qRu6hAO2nTsANr2z3msOTMfP78BwR3rw41A==
X-Received: by 2002:a17:906:e0c:: with SMTP id l12mr9924037eji.435.1591385096146;
        Fri, 05 Jun 2020 12:24:56 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.googlemail.com with ESMTPSA id dn15sm5225170ejc.26.2020.06.05.12.24.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jun 2020 12:24:55 -0700 (PDT)
Message-ID: <2b4bb56b0a86c24ce96b6de178af16a0701aedc8.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
From:   Bean Huo <huobean@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 05 Jun 2020 21:24:54 +0200
In-Reply-To: <20200605191807.GJ1373@sol.localdomain>
References: <20200605191439.19313-1-huobean@gmail.com>
         <20200605191439.19313-2-huobean@gmail.com>
         <20200605191807.GJ1373@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-06-05 at 12:18 -0700, Eric Biggers wrote:
> > +/* SPDX-License-Identifier: GPL-2.0 */
> >   /*
> >    * Universal Flash Storage Host controller driver
> > - *
> > - * This code is based on drivers/scsi/ufs/ufs.h
> >    * Copyright (C) 2011-2013 Samsung India Software Operations
> >    *
> >    * Authors:
> >    *   Santosh Yaraganavi <santosh.sy@samsung.com>
> >    *   Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> 
> This actually says GPL v2 or later.  Not GPL v2 only.
> 
> - Eric

thanks, that shuold be "SPDX-License-Identifier: GPL-2.0-or-later".

ok, let me update it.

Bean

