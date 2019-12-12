Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABBDC2D0CA
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 18:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21ED8227BF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 18:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="otNCU/9i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbfLLSYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 13:24:16 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34869 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbfLLSYQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 13:24:16 -0500
Received: by mail-pj1-f65.google.com with SMTP id w23so1384480pjd.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2019 10:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u1PHlHUdNRkLYDULqBTcDHsCK0nWR/67FBcfs8Oqumk=;
        b=otNCU/9in36hydlyZDESi7f5IA1iX06dCDae98JkQRLbariMr32467Lz6Qu0ScMrmh
         +u6NLSvFW3ESXgW94Yoqt9owpUcY+nONAyJSPGSHhakpPDvio0g9a1J89i3+UoSj4HY4
         JL+7ItCOIIw5A+C9qVwZotVcuXjeEt9cUAKQLegYiFfJB0az+qKIlOSXU0tkfyMShsxp
         G/ecVTMPFi3ptkxnOrcvywkbzwHyOqNs8xuwhLwbvLmpc68uLPD91znn31R8REPW5kV7
         U0tThNOx/pLhrE4E8ZdgMfNa0zbbdrMO8C1uPopM7FwK4cx5LpDUIHIS9WY8X0AXvgnb
         C3Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u1PHlHUdNRkLYDULqBTcDHsCK0nWR/67FBcfs8Oqumk=;
        b=Pd2bAZWfRQIJheAArYiwVTRPZpqRkAdL7658HInOokMdi3aq72Gd4AOLxdNfNqRV4w
         MaDRDTZTYHth83MO+imh+Xi10mwlFskK2MOjOjLlpoK16Y4yKc8zBvtpCTBFR0jFiOAA
         v2b8SZHgyBeMKsQ8/4Saq2KRKujfrnrVOMtO4+dY5sZZ0ce5UcjmRPgtzF4hKF1GATjs
         yW5Jv9gXz8tft4l23ET5w+vZOl+FfwuYdwfu7t4xu6dpj3d7Ymjs5JMOkNLdXJ7p2+7S
         /FxnYAK6cVKUZ5UxrK+dSBdHvCSqLeNc6T8VMViGzhZl+w6wxS/0AhXQS9Qsustb73FY
         Vhrw==
X-Gm-Message-State: APjAAAVHVA3sfuu2T1/G/za+fHzSYOqVYc/YqE5nv7R/HzR6bA5CTpm2
        1ZCxA+2vIgjAlBRvE8qeAk/wgQ==
X-Google-Smtp-Source: APXvYqysKkIuW1bkdC2A856WgquKQLYeFECzV0m5sJBtr9RxOmKEcCR0YAEPhVdRk8gZU0lveLD8Dw==
X-Received: by 2002:a17:902:8603:: with SMTP id f3mr10631884plo.198.1576175055155;
        Thu, 12 Dec 2019 10:24:15 -0800 (PST)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id d27sm7757087pgm.53.2019.12.12.10.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 10:24:14 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:24:11 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     cang@codeaurora.org
Cc:     Avri Altman <Avri.Altman@wdc.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
Message-ID: <20191212182411.GE415177@yoga>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <MN2PR04MB69919AA0C345E7D6620C3ADFFC550@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016efb07efac-32cf270a-68dd-455a-b037-9fac2f3834cd-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0101016efb07efac-32cf270a-68dd-455a-b037-9fac2f3834cd-000000@us-west-2.amazonses.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 12 Dec 08:53 PST 2019, cang@codeaurora.org wrote:

> On 2019-12-12 15:00, Avri Altman wrote:
> > > On Wed 11 Dec 22:01 PST 2019, cang@codeaurora.org wrote:
> > > > On 2019-12-12 12:53, Bjorn Andersson wrote:
> > > > > On Wed 11 Dec 00:49 PST 2019, Can Guo wrote:
[..]
> > > > And in real cases, as the UFS is the boot device, UFS driver will always
> > > > be probed during bootup.
> > > >
> > > 
> > > The UFS driver will load and probe because it's mentioned in the
> > > devicetree, but if either the ufs drivers or any of its dependencies
> > > (phy, resets, clocks, etc) are built as modules it might very well
> > > finish probing after lateinitcall.
> > > 
> > > So in the even that the bsg is =y and any of these drivers are =m,
> > > or if
> > > you're having bad luck with your timing, the list will be empty.
> > > 
> > > As described below, if bsg=m, then there's nothing that will load the
> > > module and the bsg will not probe...
> > Right.
> > bsg=y and ufshcd=m is a bad idea, and should be avoided.
> > 
> 
> Yeah, I will get it addressed in the next patchset.
> 

If you build this around platform_device_register_data() from ufshcd I
don't see a reason to add additional restrictions on this combination
(even though it might not make much sense for people to use this
combination).

Regards,
Bjorn
