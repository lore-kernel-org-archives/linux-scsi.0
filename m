Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC32C71156
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 11:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2AE2225D
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 11:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgLCLpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 06:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgLCLpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 06:45:46 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D9DC061A4D;
        Thu,  3 Dec 2020 03:45:05 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id n26so2999581eju.6;
        Thu, 03 Dec 2020 03:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MfxZi61CCL1kARU1/n7nH9whoSlX/OiuqfTorhvl0nE=;
        b=fk8rUNOdcRGdBxKLOp4tc8VQOF4t8uAWrNXy838Qp80NxsPFnnXhX+j1zHa/9AxiyS
         pa7uyz/pW4zrLFmrzzxKa+aQ5YGqrDJEGA5r54UhfFUh6rKmy7co0ZSgmQ5s0SOgPcoe
         koJuDOB4qKsWR0WrQyRixgcO7tQMAcPsilWWbTXK5T4kp33sVopqheANa/voqUfFL1Hl
         xHNhJxGbs74GbZzCxTSlUYcwiVnSZe3d2/SxFRiBDlHDKyGXRd88D+4W3oPX2cEJOSVd
         9ABWiU2MX393XVcSr2ePPX9DZFmfod9gvCREby6NnDbjnslR3h39BY+kTDjHhDymOHQm
         xIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MfxZi61CCL1kARU1/n7nH9whoSlX/OiuqfTorhvl0nE=;
        b=IhWlkl/RIj+r8LJQZt+dh9D18D/5IZr//nTVb33L6HjPUGubOvdLUoDUoTi52r1n5e
         ptbAR6e4iMc1yCnCmq+wJNSSsFc95spXeU2p97zu+FDT/k7H+5XZaesKiAviqKN8eICt
         W9CF91/B8l5m/AfuTXvnXu0rHbKe1Grfdh/suWkEpchmlyQI3kqdJIlSdcEZ0/d/sgiM
         DXkEBZ8mK0MNEVrTnyYCD5RnDKRIafaVO+k8cXEnaJt9HMyFh8/OV90Wtt1h8zPOZd6o
         wqlISfSUZ0GsXnWrwHFjAXkM5sDBDkGN0mwKJ2586+Iw2UKPjcazeIH6zC3+B4X38U8Z
         KTVw==
X-Gm-Message-State: AOAM531umOAofcTK4AExP6zaasnN8YYsU75peMylodjuYyI8TIdeAg3a
        mHRnAes9b8A587tLZT/cxm8=
X-Google-Smtp-Source: ABdhPJxWfZD1DiNyoLIA2IQFbnTuTzw2F+I6PbMw2FWMlzr+CgNuDf9YRvJLV5fo3gN1YZWm80UWOg==
X-Received: by 2002:a17:906:edc4:: with SMTP id sb4mr2086206ejb.21.1606995904139;
        Thu, 03 Dec 2020 03:45:04 -0800 (PST)
Received: from ubuntu-laptop ([2a01:598:b905:79de:6c3d:3b27:f281:55d5])
        by smtp.googlemail.com with ESMTPSA id bo5sm980673edb.44.2020.12.03.03.45.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Dec 2020 03:45:03 -0800 (PST)
Message-ID: <2578a5fa2323f46b29dc8808b948ed5eaea6fbca.camel@gmail.com>
Subject: Re: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
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
Date:   Thu, 03 Dec 2020 12:45:00 +0100
In-Reply-To: <DM6PR04MB657551290696C7EBD8339328FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
         <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
         <2dafb87ff450776c0406311bb7e235e9816f6ecf.camel@gmail.com>
         <DM6PR04MB657551290696C7EBD8339328FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-03 at 10:46 +0000, Avri Altman wrote:
> > > > From: Bean Huo <beanhuo@micron.com>
> > > > 
> > > > Keep device power mode as active power mode and VCC supply only
> > > > if
> > > > fWriteBoosterBufferFlushDuringHibernate setting 1 is
> > > > successful.
> > 
> > Hi Avri
> > Thanks so much taking time reiew.
> > 
> > > Why would it fail?
> > 
> > During the reliability testing in harsh environments, such as:
> > EMS testing, in the high/low-temperature environment. The system
> > would
> > reboot itself, there will be programming failure very likely.
> > If we assume failure will never hit, why we capture its result
> > following with dev_err(). If you keep using your phone in a harsh
> > environment, you will see this print message.
> > 
> > Of course, in a normal environment, the chance of failure likes you
> > to
> > win a lottery, but the possibility still exists.
> 
> Exactly.

so, you agree the possiblity of failure  exists.

> Hence we need-not any extra logic protecting device management
> command failures.

what extra logic? 

> 
> if reading the configuration pass correctly, and UFSHCD_CAP_WB_EN is
> set,


UFSHCD_CAP_WB_EN set is DRAM level. still in the cache.

> one should expect that any other functionality would work.
> 
No,  The programming will consume more power than reading, the
later setting will more possbile fail than reading.

> Otherwise, any non-standard behavior should be added with a quirk.
> 

NO, this is not what is standard or non-standard. This is independent
of UFS device/controller. It is a software design. IMO, we didn't deal
with programming status that is a potential bug. If having to impose to
a component, do you think should be controller or device? Instead of
addin a quirk, I prefer dropping this patch.




> Thanks,
> Avri
> > 
> > 
> > > Since UFSHCD_CAP_WB_EN is toggled off on ufshcd_wb_probe If the
> > > device doesn't support wb,
> > > The check ufshcd_is_wb_allowed should suffice, isn't it?
> > > 
> > 
> > No, UFSHCD_CAP_WB_EN only tells us if the platform supports WB,
> > doesn't tell us fWriteBoosterBufferFlushDuringHibernate status.
> > 
> > Thanks,
> > Bean

