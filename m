Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB033C8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1C50205ED
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 12:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGyEvoSI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3Mpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726808AbgD3Mpo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 08:45:44 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4D7C035494;
        Thu, 30 Apr 2020 05:45:44 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id d15so6746233wrx.3;
        Thu, 30 Apr 2020 05:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nTelbWge7w+/UEuocO2uUnURIuxUwZKm7wDXXQqaeMw=;
        b=VGyEvoSILzN3pCvWFpscfa7jp4vFjoeWc0e5mpjAylmg+ja4ODabRLpT+LVrdVwYFT
         mguw/PEM+HKrxEphD38GAMxLu7CDAlaMEm92/091sxO+FMXzvEOPYjZdbYDsistHp7TK
         LlYgwzbwVRBZCDd9u5i2uIvuT/Gmp2Wlsmy3Mo77jCYNpJY1eJd/41X1tj1ypySGNlUE
         K7syk2kytKk39aJYWkcqIQE2gEK/97zKaId66vNJlpdq4STH6MEhV+P0kTAliHha0T0e
         4+V4vkitY2dVn6c8Oi9KxvLHgaiFHjziTDv8QCjo4YBBy6kEtglig+fGY7gZ1DbJ4dcj
         WDvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nTelbWge7w+/UEuocO2uUnURIuxUwZKm7wDXXQqaeMw=;
        b=DQr5uDwh/2fNtI/M/lDgn4YndjwgSuzJqQM0/aWNBSwVwqdWWDIMYnncivvEcOuRIw
         Kb9c4jCYDZV49tEZV4w8tQfohONzHmNOoQFFbylPXrPALDai593xMYYucs18rUtai+cG
         g6C3dCqxojO8LJpdagzjdwjsnGEe4myMISO385O7k3MShE+Z6at4MjQzAp5V/P/xzXrT
         +VgWI3QZ1J1p5UD+pP5nLJlFfhsIx3TyHWWVtwZR5GI1tJ4HwKg0JF8/+D8I4imUmi1p
         oE8cfdpdukvtL4yRqRPXJ8c+wJ9ryoqg0CIxjz0spOCshtdDiI3iHCgtSztW/VbEa14m
         DWxA==
X-Gm-Message-State: AGi0Puac1s5F/1X+hhTU06f+W9vbC06m3OLSDT1Dkjek+FR6xAGPPGSi
        XvLxLw415/etAdDppvNy4SS7Ce2SZxc=
X-Google-Smtp-Source: APiQypJGUJirvshsvajkCVQFbP0RO3lE77GpsE/ZwA8WZNBPaAZkiayWTQwQ+4mvYVLIQcvMCxESJA==
X-Received: by 2002:adf:9793:: with SMTP id s19mr3482561wrb.147.1588250743269;
        Thu, 30 Apr 2020 05:45:43 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id l16sm3700287wrp.91.2020.04.30.05.45.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Apr 2020 05:45:42 -0700 (PDT)
Message-ID: <79278fe0f4e0ce820484386a72bc6044d3c66822.camel@gmail.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 30 Apr 2020 14:45:40 +0200
In-Reply-To: <BYAPR04MB4629393BA60AF5E5898FB304FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
         <20200416203126.1210-6-beanhuo@micron.com>
         <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
         <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
         <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
         <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
         <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
         <SN6PR04MB464009AFAC8F7EFC04184826FCAC0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <15eca4dd2ec8a4ba210ce0844e9f5027251fa6f2.camel@gmail.com>
         <BYAPR04MB4629393BA60AF5E5898FB304FCAA0@BYAPR04MB4629.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-04-30 at 07:23 +0000, Avri Altman wrote:
> Hi Bean,
> 
> > > By now we've read the device HPB configuration, and we are
> > > ready  to
> > > attach a scsi device to our HPB luns.  A perfect timing might be
> > > while
> > > scsi is performing its .slave_alloc() or .slave_configure().
> > > 
> > 
> > hi, Avri
> > That means HPB memory allocation done in .scan_finished() ?
> 
> The specifics of this feature are yet to be determined.
> 
> Among those, yes - we need to discuss how to handle the memory
> allocation.
> Statically allocating the required cache for the entire max-active-
> subregions,
> Which may sum-up to a hundreds of MB, has its obvious downsize. 
> We need to discuss this further.
> 
> > and sd_init_command() needs to change as well, add a new request
> > type REQ_OP_HPB_READ?
> 
> Again, this is an implementation issue.
> We need to figure it out in the sequel.
> E.g. we might want to make use of the combination of a valid handler
> and blk_op_is_private.
> 
> I think it would be more constructive, if we can decide first on the
> module layout,
> And figure out the other details as we go?
> 
> Can you provide the pros and cons for the Samsung approach -
> implementing all HPB functionalities using a single LLD?
> 
> Thanks,
> Avri
> 
Hi Avri

Samsung approach is a flat design and the HPB functions are embedded in
the UFSHBA driver, looks ugly.  Each LU has its own HPB cache, which
statically allocated in HPB initialization stage.  If one LU runs out
of its HPB cache, it is impossbile to borrow HPB cache from its
neighbour LU. Also, HPB requests are enqueued to the scsi_device
request_queue and then fly back to SCSI layer. This unavoidably
lengthens the latency of HPB entry update. 
For the HPB host control mode, the predictability of HPB region
activation of this design is lower, since HPB driver doesn't know which
Region exactly should be activated in advance.

Regarding its pros, exactly I don't know, maybe it is relatively
simple, work, and there are already customers who are using it now.
also, we don't need to argue with SCSI layers and maintenance is
easier.

To me, hierarchical design sounds good, and move the implementation of
HPB manager module to SCSI layer is nice. but what is opinion of
others? and which way they prefer. or they want us to continue current
Samsung approach and solve its cons further.

thanks,

Bean

> > 
> > 
> > Bean
> > 
> 
> 

