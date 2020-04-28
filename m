Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7AFC83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 09:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE3620757
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 09:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKIrYxCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgD1JMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 05:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726462AbgD1JMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 05:12:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5E2C03C1A9;
        Tue, 28 Apr 2020 02:12:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s10so23763208wrr.0;
        Tue, 28 Apr 2020 02:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1oDTbvwHgrD9ZLQPoK5BGfLkEAfVqa/XbZPM5vd3Q8M=;
        b=mKIrYxCLJGvLcaKAR7v0QOQ0y9M4srcwbTFsCmuZvgrQyJRkaXvANAdmTtNkD0ku7j
         y9rPVeA2X8Pd/j7SZSeTZmeATo47du3gf1PYTB/HhXxfBMBxkVtvKOU2GhTTsea7vSJF
         HyQ0zXX4gyATDmoUnH/MThJP6jkNE8v8XsD4C2WAPoBmZK0dIKLr4e1i2BFjl+u/eq7X
         W0CtS7RKxmFIxFIYpe72A78Ifx6PsyPWf0CKvt8lbVjYgUp0vA7DSl+AaY5gNlJ19jI/
         K0jGjDsCeQulIS+VF9S8xiPREnmqif60Uk/hJYfK3nlG6qK4ghrcLlemsKahtKN3VmqI
         PaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1oDTbvwHgrD9ZLQPoK5BGfLkEAfVqa/XbZPM5vd3Q8M=;
        b=FX3vVA/rlj1m5t5krIcsE3nKkCC78cw74H468RhlQXVDR1R14PzxKVAFfgeDIZFQFs
         izIRb+0FkX8R78aCUXY/sSxx0278iSQnf8ao3oxP1X7KLQplU7DNVLhkqnJf+jEXjf9i
         RyUfE+U8vIfqNDqlyN5Ns5N72cVrWDz5+X1etibg70Oz8JRnA4ZxtqkXRjSgYLkkv2IL
         SdY8ndXgRbED6OfBfUoLfFE9ESfIqJ9AuwZXWEZ1XiB/yKK19tVniq5RJEygMvOPUGnn
         J+6ymQvMXksecDfq8ewRQ/jNJBJJEAt8Dc1UHLrg6qw2dHN8q2iY1qR8BU2uham1WS5m
         FyiA==
X-Gm-Message-State: AGi0PubVilxOaEbFXh8p86eNsDnO2Rvb7i6wcVO1trcO+QJyCX5HuZUv
        C2su12b5lcan1JFkK3iVnL4=
X-Google-Smtp-Source: APiQypJAWt32dlGrt2LtTHrQxFplAS8Y/IJS/ek3mWd5g/SljrZNxJd4yzL7aRQge7JgtKbLer+nmg==
X-Received: by 2002:a5d:498d:: with SMTP id r13mr33376413wrq.374.1588065158164;
        Tue, 28 Apr 2020 02:12:38 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id j17sm27352474wrb.46.2020.04.28.02.12.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2020 02:12:37 -0700 (PDT)
Message-ID: <d75ec0cd8bdc4da05a11d57bdc33399a8ebbc3d7.camel@gmail.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
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
Date:   Tue, 28 Apr 2020 11:12:33 +0200
In-Reply-To: <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
References: <20200416203126.1210-1-beanhuo@micron.com>
         <20200416203126.1210-6-beanhuo@micron.com>
         <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
         <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
         <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
         <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
         <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-04-27 at 20:36 -0700, Bart Van Assche wrote:
> On 2020-04-26 23:13, Avri Altman wrote:
> > > On 2020-04-25 01:59, Avri Altman wrote:
> > 
> > HPB support is comprised of 4 main duties:
> > 1) Read the device HPB configuration
> > 2) Attend the device's recommendations that are embedded in the
> > sense buffer
> > 3) L2P cache management - This entails sending 2 new scsi commands
> > (opcodes were taken from the vendor pool):
> > 	a. HPB-READ-BUFFER - read L2P physical addresses for a
> > subregion
> > 	b. HPB-WRITE-BUFFER - notify the device that a region is
> > inactive (in host-managed mode)
> > 4) Use HPB-READ: a 3rd new scsi command (again - uses the vendor
> > pool) to perform read operation instead of READ10.  HPB-READ
> > carries both the logical and the physical addresses.
> > 
> > I will let Bean defend the Samsung approach of using a single LLD
> > to attend all 4 duties.
> > 
> > Another approach might be to split those duties between 2 modules:
> >  - A LLD that will perform the first 2 - those can be done only
> > using ufs privet stuff, and 
> >  - another module in scsi mid-layer that will be responsible of L2P
> > cache management,
> >   and HPB-READ command setup.
> > A framework to host the scsi mid-layer module can be the scsi
> > device handler.
> > 
> > The scsi-device-handler infrastructure was added to the kernel
> > mainly to facilitate multiple paths for storage devices.
> > The HPB framework, although far from the original intention of the
> > authors, might as well fit in.
> > In that sense, using READs and HPB_READs intermittently, can be
> > perceived as a multi-path.
> > 
> > Scsi device handlers are also attached to a specific scsi_device
> > (lun).
> > This can serve as the glue linking between the ufs LLD and the
> > device handler which resides in the scsi level.
> > 
> > Device handlers comes with a rich and handy set of APIs & ops,
> > which we can use to support HPB.
> > Specifically we can use it to attach & activate the device handler,
> > only after the ufs driver verified that HPB is supported by both
> > the platform and the device. 
> > 
> > The 2 modules can communicate using the handler_data opaque
> > pointer,
> > and the handler’s set_params op-mode: which is an open protocol
> > essentially,
> > and we can use it to pass the sense buffer in its full or just a
> > parsed version.
> > 
> > Being a scsi mid-layer module, it will not break anything while
> > sending
> > HPB-READ-BUFFER and HPB-WRITE-BUFFER as part of the L2P cache
> > management duties.
> > 
> > Last but not least, the device handler is already hooked in the
> > scsi command setup flow - scsi_setup_fs_cmnd(),
> > So we get the hook into HPB-READ prep_fn for free.   
> >  
> > Later on, we might want to export the L2P cache management logic to
> > user-space.
> > Locating the L2P cache management in scsi mid-layer will enable us
> > to do so, using the scsi-netlink or some other means.
> 
> 
> - Will preparing a SCSI command involve executing a SCSI command? If
> so,
>   how will it be prevented that execution of that internally
> submitted
>   SCSI command triggers a deadlock due to tag exhaustion?
> 
> Thanks,
> 

No, as for the HPB READ, it will replace SCSI READ in SCSI request
executing path in case L2P entry hit in HPB cache. so it still uses the
previously assigned tag.

As for the HPB BUFFER READ and HPB BUFFER WRITE, should beg for a new
tag from hba->cmd_queue.

Bean

