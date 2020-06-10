Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22DAC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8152072E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 09:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxaddMJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFJJ5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 05:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJJ5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 05:57:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19EEC03E96B;
        Wed, 10 Jun 2020 02:57:33 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r7so1558366wro.1;
        Wed, 10 Jun 2020 02:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lh+l8E/0G4HNv79DdjguIxQ8zfn9HQwltUTK0ls8AMw=;
        b=cxaddMJQ7+9pIVDnuPAGga3PYpBtHKiX8/+niQA7UyL43NDxIhvdVy+vIkDl/tgJKe
         ceOH+nEdmZmjb5mcvR1TwuvqRPxl0ps69fUsrFvfDgS9BwuhtQBdPZEutNwXQPyAQ+LR
         1A/lqROaSXo7wm+WqP14SdDQeLkx9nwRgb/b9kMFQV8CQ1gshQ7Z94l4fXKGgXLHAGiR
         tUtia2nYa93vwZqDICzcsN3JxLEGV06HqGet7qtdbF+xV+YkRzslbIdYYeKNzNhWXnFe
         xbxDW82lJ+eR81VT6kpinO2VFLed5nYn0jgurrKhoSnbNEIgjrtVUbFZI9QF98MKVXLa
         jFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lh+l8E/0G4HNv79DdjguIxQ8zfn9HQwltUTK0ls8AMw=;
        b=Y9000OQOQ6yjgWFAShf0E3kPT58JseFF2ctxdo+4OJMSz1FYuQBoV12M/79EiStdLH
         f8WIxeyzMBm8PdOCvYo8Y639gux6QrBG+2i/f4I7pcYrcs8D8QXO2rwIjx1Lh8rn0mqz
         tIU46QAi5RU6WoLi8N6KQTUtApMXwgvErLF84O2R9F2uIbuNyl7Uy1QIA2nos+ooBzez
         uCo7c2j6gMpkHxTJCsAinNgjK0uqiWG91ui2lPhnrJHcckw6P2LAxMIGutaL2JAVj4aT
         djM1dfSRxX5AekPBXWry0NaaX+EOt+V2BJtLkoW3/qWcZlEzT7YRYwjPOEauLP/ETUaf
         0Vfg==
X-Gm-Message-State: AOAM5324/EJh6ADJ8AqDjiPWOausJyxWcwzoJ04XlacZTW/TalceW1Ti
        EtRNSDVd5gR/tRfpWmWsQck=
X-Google-Smtp-Source: ABdhPJyCyDsmrLbYTjuWfgqAN/bpPpINTYytQIkZn9a1fqGBXl8aUWdYFiT0gWLL5v+Mkyf6rfWKug==
X-Received: by 2002:a5d:6944:: with SMTP id r4mr2679459wrw.169.1591783051512;
        Wed, 10 Jun 2020 02:57:31 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b90a:8f5:dd1:7313:78f9:539b])
        by smtp.googlemail.com with ESMTPSA id c70sm6018914wme.32.2020.06.10.02.57.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 02:57:31 -0700 (PDT)
Message-ID: <890c8bb717c0d5c1c7623b298d3f54a8e6594c73.camel@gmail.com>
Subject: Re: [RFC PATCH 3/5] scsi: ufs: Introduce HPB module
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, daejun7.park@samsung.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Wed, 10 Jun 2020 11:57:28 +0200
In-Reply-To: <76831c81-7879-8be7-54a4-ca6bfa68c30e@acm.org>
References: <336371513.41591320902369.JavaMail.epsvc@epcpadp1>
         <963815509.21591320301642.JavaMail.epsvc@epcpadp1>
         <231786897.01591320001492.JavaMail.epsvc@epcpadp1>
         <CGME20200605011604epcms2p8bec8ef6682583d7248dc7d9dc1bfc882@epcms2p8>
         <231786897.01591322101492.JavaMail.epsvc@epcpadp1>
         <76831c81-7879-8be7-54a4-ca6bfa68c30e@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-06-09 at 21:29 -0700, Bart Van Assche wrote:
> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> > new file mode 100644
> > index 000000000000..c6dd88e00849
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufshpb.h
> > @@ -0,0 +1,185 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Universal Flash Storage Host Performance Booster
> > + *
> > + * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
> > + *
> > + * Authors:
> > + *   Yongmyung Lee <ymhungry.lee@samsung.com>
> > + *   Jinyoung Choi <j-young.choi@samsung.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + * See the COPYING file in the top-level directory or visit
> > + * <http://www.gnu.org/licenses/gpl-2.0.html>
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * This program is provided "AS IS" and "WITH ALL FAULTS" and
> > + * without warranty of any kind. You are solely responsible for
> > + * determining the appropriateness of using and distributing
> > + * the program and assume all risks associated with your exercise
> > + * of rights with respect to the program, including but not
> > limited
> > + * to infringement of third party rights, the risks and costs of
> > + * program errors, damage to or loss of data, programs or
> > equipment,
> > + * and unavailability or interruption of operations. Under no
> > + * circumstances will the contributor of this Program be liable
> > for
> > + * any damages of any kind arising from your use or distribution
> > of
> > + * this program.
> > + *
> > + * The Linux Foundation chooses to take subject only to the GPLv2
> > + * license terms, and distributes only under these terms.
> > + */
> 
> Please use an SPDX declaration instead of the full GPLv2 text.
> 
> Thanks,
> 
> Bart.

agree with Bart,
also, should confirm SPDX-License-Identifier: GPL-2.0-only or  SPDX-
License-Identifier: GPL-2.0-later.

I just learnt this, based on your text, shoould be "SPDX-License-
Identifier: GPL-2.0-later"

Bean

