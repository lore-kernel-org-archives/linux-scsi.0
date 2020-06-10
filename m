Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE358C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA532072E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmeS4bAO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFJJa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 05:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgFJJa3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 05:30:29 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D96C03E96B;
        Wed, 10 Jun 2020 02:30:28 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p5so1424961wrw.9;
        Wed, 10 Jun 2020 02:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tE3iyyCz/PdyCa0nE9kvJXdIlcRexy3wAEhGGbRHY3M=;
        b=kmeS4bAOh8UL2XgnryhJMJxl9yuwYo3tgzMOe7YbJ78H9S6HsTmKtBqkzkpYo93hVi
         9O3gudvJoo4cLWvTaHTBqAg/qxVJ5ZXShnYiixRZy4PBBlC/Gb2iFfSVU6O+SYIZQ4dy
         LNc5zVRRRZCatbT7QTQqrGEbtx4x5KEG22c9Sso2pIl/IpanZOj/7wQGrI88fdWG5xa+
         SIpEFs0bZkATo5A7sRVVVD1ieOaQ+qXwCdkUG6yucCyjYYckQRduFoq8Z8Am9vnVm11l
         7D77xdMfyiRvECc7xM3qmoFSmM1kMLRjrnMVVtNPKIjvsPoJ+7aMGNqQbL4aHLZTdglJ
         A8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tE3iyyCz/PdyCa0nE9kvJXdIlcRexy3wAEhGGbRHY3M=;
        b=g4ij4BWA5Zve3VTYiNyFmcR9F2sdulMZQCjboRLx36K3B4QZj80QBVDRES3zBCYd24
         nUg3DJEkyYsuU1ICu0yBGOKiQuksXHe5/uQM3TOQXwHZD0v8LLf8OomtIlwXysR9RalU
         m2OPKRa4sphP2A/7xaUt8xxA+F+iRaawoEV12QPR2vBCasrpXyokZnv6LBfkFh6+dqTE
         8SVqt7t9eyRK9c1QsjFF3ukoKkTXVOIhA7Tvarc5D21hur4UBmb9gdz8K/1EIn+WJxo+
         uubFdBURwksStT2dGX6cKMkbHp6x1NzUUaOOU9mV/hxKfvY+/q3UHpc4C3ABJf+qCh8y
         Hlqg==
X-Gm-Message-State: AOAM533TXEcRKd2z+ZuLDz9+SGBRameoruoEUDmj0R0JeiK7iXeLrwoM
        jKwKNJsO/HOYcNsV61restk=
X-Google-Smtp-Source: ABdhPJzw+1OtEFcActDe7N+ms6FWkTZIU0etNdQvLFLKOGOPvMskleR1h3MbUV1kNbLSjtBh3sh4uw==
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr2550500wrx.215.1591781427050;
        Wed, 10 Jun 2020 02:30:27 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b90a:8f5:dd1:7313:78f9:539b])
        by smtp.googlemail.com with ESMTPSA id t129sm6699900wmf.41.2020.06.10.02.30.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 02:30:26 -0700 (PDT)
Message-ID: <4b12ed3a47f6bb444f58ad480d584f3cf4c47819.camel@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
From:   Bean Huo <huobean@gmail.com>
To:     "Winkler, Tomas" <tomas.winkler@intel.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 10 Jun 2020 11:30:22 +0200
In-Reply-To: <b9f2970c5061433b8acc16a10885e5b4@intel.com>
References: <20200605200520.20831-1-huobean@gmail.com>
         <20200605200520.20831-2-huobean@gmail.com>
         <b9f2970c5061433b8acc16a10885e5b4@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-06-06 at 23:20 +0000, Winkler, Tomas wrote:
> > 
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Add SPDX GPL-2.0 to UFS driver files that specified the GPL version
> > 2 license,
> > remove the full boilerplate text.
> > 
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> 
> LGTM.
> Thanks
> Tomas

Hi Tomas

would you please add your viewed or acked tag for this patch?
thanks, 

Bean


> 
> > ---
> >  drivers/scsi/ufs/ufs.h           | 27 +--------------------------
> >  drivers/scsi/ufs/ufshcd-pci.c    | 25 +------------------------
> >  drivers/scsi/ufs/ufshcd-pltfrm.c | 27 +--------------------------
> >  drivers/scsi/ufs/ufshcd.c        | 30 +---------------------------
> > --
> >  drivers/scsi/ufs/ufshcd.h        | 27 +--------------------------
> >  drivers/scsi/ufs/ufshci.h        | 27 +--------------------------
> >  6 files changed, 6 insertions(+), 157 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h index
> > c70845d41449..7df4bdc813d6 100644
> > --- a/drivers/scsi/ufs/ufs.h
> > +++ b/drivers/scsi/ufs/ufs.h
> > @@ -1,36 +1,11 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >  /*
> >   * Universal Flash Storage Host controller driver
> > - *
> > - * This code is based on drivers/scsi/ufs/ufs.h
> >   * Copyright (C) 2011-2013 Samsung India Software Operations
> >   *
> >   * Authors:
> >   *	Santosh Yaraganavi <santosh.sy@samsung.com>
> >   *	Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > - * without warranty of any kind. You are solely responsible for
> > - * determining the appropriateness of using and distributing
> > - * the program and assume all risks associated with your exercise
> > - * of rights with respect to the program, including but not
> > limited
> > - * to infringement of third party rights, the risks and costs of
> > - * program errors, damage to or loss of data, programs or
> > equipment,
> > - * and unavailability or interruption of operations. Under no
> > - * circumstances will the contributor of this Program be liable
> > for
> > - * any damages of any kind arising from your use or distribution
> > of
> > - * this program.
> >   */
> > 
> >  #ifndef _UFS_H
> > diff --git a/drivers/scsi/ufs/ufshcd-pci.c
> > b/drivers/scsi/ufs/ufshcd-pci.c index
> > 8f78a8151499..f407b13883ac 100644
> > --- a/drivers/scsi/ufs/ufshcd-pci.c
> > +++ b/drivers/scsi/ufs/ufshcd-pci.c
> > @@ -1,3 +1,4 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> >  /*
> >   * Universal Flash Storage Host controller PCI glue driver
> >   *
> > @@ -7,30 +8,6 @@
> >   * Authors:
> >   *	Santosh Yaraganavi <santosh.sy@samsung.com>
> >   *	Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > - * without warranty of any kind. You are solely responsible for
> > - * determining the appropriateness of using and distributing
> > - * the program and assume all risks associated with your exercise
> > - * of rights with respect to the program, including but not
> > limited
> > - * to infringement of third party rights, the risks and costs of
> > - * program errors, damage to or loss of data, programs or
> > equipment,
> > - * and unavailability or interruption of operations. Under no
> > - * circumstances will the contributor of this Program be liable
> > for
> > - * any damages of any kind arising from your use or distribution
> > of
> > - * this program.
> >   */
> > 
> >  #include "ufshcd.h"
> > diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c
> > b/drivers/scsi/ufs/ufshcd-pltfrm.c
> > index 76f9be71c31b..3db0af66c71c 100644
> > --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> > +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> > @@ -1,36 +1,11 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> >  /*
> >   * Universal Flash Storage Host controller Platform bus based glue
> > driver
> > - *
> > - * This code is based on drivers/scsi/ufs/ufshcd-pltfrm.c
> >   * Copyright (C) 2011-2013 Samsung India Software Operations
> >   *
> >   * Authors:
> >   *	Santosh Yaraganavi <santosh.sy@samsung.com>
> >   *	Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > - * without warranty of any kind. You are solely responsible for
> > - * determining the appropriateness of using and distributing
> > - * the program and assume all risks associated with your exercise
> > - * of rights with respect to the program, including but not
> > limited
> > - * to infringement of third party rights, the risks and costs of
> > - * program errors, damage to or loss of data, programs or
> > equipment,
> > - * and unavailability or interruption of operations. Under no
> > - * circumstances will the contributor of this Program be liable
> > for
> > - * any damages of any kind arising from your use or distribution
> > of
> > - * this program.
> >   */
> > 
> >  #include <linux/platform_device.h>
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index
> > ad4fc829cbb2..ec4f55211648 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1,40 +1,12 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> >  /*
> >   * Universal Flash Storage Host controller driver Core
> > - *
> > - * This code is based on drivers/scsi/ufs/ufshcd.c
> >   * Copyright (C) 2011-2013 Samsung India Software Operations
> >   * Copyright (c) 2013-2016, The Linux Foundation. All rights
> > reserved.
> >   *
> >   * Authors:
> >   *	Santosh Yaraganavi <santosh.sy@samsung.com>
> >   *	Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > - * without warranty of any kind. You are solely responsible for
> > - * determining the appropriateness of using and distributing
> > - * the program and assume all risks associated with your exercise
> > - * of rights with respect to the program, including but not
> > limited
> > - * to infringement of third party rights, the risks and costs of
> > - * program errors, damage to or loss of data, programs or
> > equipment,
> > - * and unavailability or interruption of operations. Under no
> > - * circumstances will the contributor of this Program be liable
> > for
> > - * any damages of any kind arising from your use or distribution
> > of
> > - * this program.
> > - *
> > - * The Linux Foundation chooses to take subject only to the GPLv2
> > - * license terms, and distributes only under these terms.
> >   */
> > 
> >  #include <linux/async.h>
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index
> > bf97d616e597..ef92c4a9e378 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -1,37 +1,12 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >  /*
> >   * Universal Flash Storage Host controller driver
> > - *
> > - * This code is based on drivers/scsi/ufs/ufshcd.h
> >   * Copyright (C) 2011-2013 Samsung India Software Operations
> >   * Copyright (c) 2013-2016, The Linux Foundation. All rights
> > reserved.
> >   *
> >   * Authors:
> >   *	Santosh Yaraganavi <santosh.sy@samsung.com>
> >   *	Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > - * without warranty of any kind. You are solely responsible for
> > - * determining the appropriateness of using and distributing
> > - * the program and assume all risks associated with your exercise
> > - * of rights with respect to the program, including but not
> > limited
> > - * to infringement of third party rights, the risks and costs of
> > - * program errors, damage to or loss of data, programs or
> > equipment,
> > - * and unavailability or interruption of operations. Under no
> > - * circumstances will the contributor of this Program be liable
> > for
> > - * any damages of any kind arising from your use or distribution
> > of
> > - * this program.
> >   */
> > 
> >  #ifndef _UFSHCD_H
> > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> > index
> > c2961d37cc1c..2c1c7a277430 100644
> > --- a/drivers/scsi/ufs/ufshci.h
> > +++ b/drivers/scsi/ufs/ufshci.h
> > @@ -1,36 +1,11 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> >  /*
> >   * Universal Flash Storage Host controller driver
> > - *
> > - * This code is based on drivers/scsi/ufs/ufshci.h
> >   * Copyright (C) 2011-2013 Samsung India Software Operations
> >   *
> >   * Authors:
> >   *	Santosh Yaraganavi <santosh.sy@samsung.com>
> >   *	Vinayak Holikatti <h.vinayak@samsung.com>
> > - *
> > - * This program is free software; you can redistribute it and/or
> > - * modify it under the terms of the GNU General Public License
> > - * as published by the Free Software Foundation; either version 2
> > - * of the License, or (at your option) any later version.
> > - * See the COPYING file in the top-level directory or visit
> > - * <http://www.gnu.org/licenses/gpl-2.0.html>
> > - *
> > - * This program is distributed in the hope that it will be useful,
> > - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - * GNU General Public License for more details.
> > - *
> > - * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > - * without warranty of any kind. You are solely responsible for
> > - * determining the appropriateness of using and distributing
> > - * the program and assume all risks associated with your exercise
> > - * of rights with respect to the program, including but not
> > limited
> > - * to infringement of third party rights, the risks and costs of
> > - * program errors, damage to or loss of data, programs or
> > equipment,
> > - * and unavailability or interruption of operations. Under no
> > - * circumstances will the contributor of this Program be liable
> > for
> > - * any damages of any kind arising from your use or distribution
> > of
> > - * this program.
> >   */
> > 
> >  #ifndef _UFSHCI_H
> > --
> > 2.17.1
> 
> 

