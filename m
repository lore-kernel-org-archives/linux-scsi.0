Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C958C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 20:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28AA9610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 20:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhKKUbM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 15:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhKKUbM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 15:31:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB10AC061766
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 12:28:22 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r8so11751738wra.7
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 12:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HuabbeBzEDf2ZBG9JKU5gVqdm/phq570g2ukBC3Q7MU=;
        b=WSxp7flw0wgw7lCKdjxcMnEwMjtBUs2oqwhIl78mmbAf4QbR3OuTtUAQ+D7ambQSWq
         V7RekVifVCLFCjswFbbiODBIu4tzXhaN7F/s5ltfHU+9yUSbfJgRLsSjNki9sBfm3LU3
         lpbnfKED/NJtfwR9T67c8dMgTuZtuvJr9Zp8UcG6IdiVcS+uis597JGW6/3/ICkDYHSI
         4k+Y963McQ8xA5r5cWQpESp3ae3Bc59fveEJ3y7iov/+UVxUkYItLb7TVm/vdXZJcPSs
         irr5v/ZnFfr9YeZT4S9RhGcmW0SiFTbG/oH1M3LSqgeJN2R9Rr7+boaZtgAj+jIu4Wor
         4aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HuabbeBzEDf2ZBG9JKU5gVqdm/phq570g2ukBC3Q7MU=;
        b=kwOaIcdoNElflWFffCy5pUcexL7lUVk8ltZ9zw3g7oVy/qezvMUBbCeiqayGnaMERA
         vWFwHhSDYwhwZu6No4bvRcO5hTYx25q+TY15U2kAV+vIRMhFRC2ShHQCoQvNgBEG1W6V
         /EdXgfXOrSOCxq36MVdQE1HNNZ7S0R3sMY72We79HEupyUWce8MEWscZWTp68ccTauaA
         MxNaR0kzYK9mWSAgdYKNwolUwoNAvF6f0eh06GKED1KQ6oJpq84R8vexV9Oia/9S28T4
         nQM6ilGQUqZSGx/zA/o5T2/7rbjuO9cKVX7BS7Cn6BzJhiloKjGkxIuw4pw5R9wJ7CyU
         ss3A==
X-Gm-Message-State: AOAM531X9yK6SXWDtbFu/q+xaaEMWN44YIDfxWZwVmPEi5DsJ5T5XUnE
        Kyh/n02Je3eXRX0yxJqFJA==
X-Google-Smtp-Source: ABdhPJzf7WuPABWHuhNa2QsqyR2+VxDQMD0e2Q7NhpF5h1gxdRqNqkFajjY3t1Fb1zYyGwOmHDnU3w==
X-Received: by 2002:a5d:400e:: with SMTP id n14mr11712855wrp.368.1636662501332;
        Thu, 11 Nov 2021 12:28:21 -0800 (PST)
Received: from localhost.localdomain ([46.53.254.6])
        by smtp.gmail.com with ESMTPSA id t9sm4224619wrx.72.2021.11.11.12.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 12:28:20 -0800 (PST)
Date:   Thu, 11 Nov 2021 23:28:19 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org
Subject: Re: ufs: setting "hba" private pointer too late -- oops in
 ufshcd_devfreq_get_dev_status()
Message-ID: <YY184y876Ghm+7Ly@localhost.localdomain>
References: <YYvYGBuzZzAuNzxp@localhost.localdomain>
 <831b95a6-c097-9425-a6a8-cc599a14614c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <831b95a6-c097-9425-a6a8-cc599a14614c@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2021 at 10:18:15AM -0800, Bart Van Assche wrote:
> On 11/10/21 6:32 AM, Alexey Dobriyan wrote:
> > I've stumbled into a race while working on an earlier kernel,
> > but it looks like mainline is affected as well.
> > 
> >          err = ufshcd_init(hba, mmio_base, irq);
> > 		async_schedule(ufshcd_async_scan, hba);
> > 		ufshcd_add_lus(hba);
> > 		if (ufshcd_is_clkscaling_supported(hba)) {
> > 			[enable devfreq]
> > 
> >          platform_set_drvdata(pdev, hba);
> > 
> > Device's private pointer is set too late, as devfreq hook get HBA
> > pointer from private data and uses it:
> > 
> > 	static int ufshcd_devfreq_get_dev_status(struct device *dev, struct devfreq_dev_status *stat)
> > 	{
> > 	        struct ufs_hba *hba = dev_get_drvdata(dev);
> > 		if (!ufshcd_is_clkscaling_supported(hba))
> > 			return -EINVAL;
> > 
> > Unable to handle kernel NULL pointer dereference at virtual address ...0f10
> > pc :	ufshcd_devfreq_get_dev_status
> > lr :	devfreq_simple_ondemand_func
> > 	update_devfreq
> > 	devfreq_monitor
> > 
> > 
> > I reproduced it by turning async LU scan into sync, so it is easier to
> > trigger.
> 
> Hi Alexey,
> 
> Thanks for having reported this. Do you perhaps plan to post a patch to fix
> this?

Not really, my workaround is

	if (!hba) {
		return -EINVAL;
	}

But it is likely incorrect.
