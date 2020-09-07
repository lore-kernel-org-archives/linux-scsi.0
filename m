Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A184C43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 22:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F294216C4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 22:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="lQp4+vVU";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="lQp4+vVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgIGW4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 18:56:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52572 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727119AbgIGW4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 18:56:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D50FF8EE0F8;
        Mon,  7 Sep 2020 15:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599519376;
        bh=9n8PcMdY4isC/3HPH7ahR+lZNenWAtgrW4/vixC+d5E=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=lQp4+vVUb+pLugovXC0P29SOBpt2VLAjxagXNtnH/V5FZ/hmiEOf5hf+plksbGsU+
         w0oOmKkHwq+dIe+OI+yygIIUYDuuo2Dokn38F/LJ6J7XZX+vsn5ooR7ROs49f6+R4w
         fkrrtxIVM6r5TsxF7r23Pcu1/7jP+etgZxW8/PoE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id x4gHYgMErJut; Mon,  7 Sep 2020 15:56:16 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 68BB28EE0E9;
        Mon,  7 Sep 2020 15:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1599519376;
        bh=9n8PcMdY4isC/3HPH7ahR+lZNenWAtgrW4/vixC+d5E=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=lQp4+vVUb+pLugovXC0P29SOBpt2VLAjxagXNtnH/V5FZ/hmiEOf5hf+plksbGsU+
         w0oOmKkHwq+dIe+OI+yygIIUYDuuo2Dokn38F/LJ6J7XZX+vsn5ooR7ROs49f6+R4w
         fkrrtxIVM6r5TsxF7r23Pcu1/7jP+etgZxW8/PoE=
Message-ID: <1599519374.4232.71.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: take module reference during async scan
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     dgilbert@interlog.com, Tomas Henzl <thenzl@redhat.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 07 Sep 2020 15:56:14 -0700
In-Reply-To: <a31b8640-307f-a14f-7cf8-7673fa8a4ff1@interlog.com>
References: <20200907154745.20145-1-thenzl@redhat.com>
         <1599500808.4232.19.camel@HansenPartnership.com>
         <a31b8640-307f-a14f-7cf8-7673fa8a4ff1@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-09-07 at 17:32 -0400, Douglas Gilbert wrote:
> On 2020-09-07 1:46 p.m., James Bottomley wrote:
> > On Mon, 2020-09-07 at 17:47 +0200, Tomas Henzl wrote:
> > > During an async scan the driver shost->hostt structures are used,
> > > that may cause issues when the driver is removed at that time.
> > > As protection take the module reference.
> > 
> > Can I just ask what issues?  Today, our module model is that
> > scsi_device_get() bumps the module refcount and therefore makes the
> > module ineligible to be removed.  scsi_host_get() doesn't do this
> > because the way the host model is supposed to be coded, we can call
> > remove at any time but the module won't get freed until the last
> > put of the host.  I can see we have a potential problem with
> > scsi_forget_host() racing with the async scan thread ... is that
> > what you see? What's supposed to happen is that scsi_device_get()
> > starts failing as soon as the module begins it's exit routine, so
> > if a scan is in progress, it can't add any new devices ... in
> > theory this means that the list is stable for scsi_forget_host(),
> > so knowing how that assumption is breaking would be useful.
> 
> James,
> If you think it is bullet-proof try using 

I'm not saying it's got no bugs, just that the above is the way it's
supposed to work.

> CONFIG_DEBUG_TEST_DRIVER_REMOVE=y .

The problem with this option is it basically gives you a thundering
herd of removal reinsertions ... trying to do it for a single driver
(or set of drivers) is likely a better way to get actionable debugging
information.

> John Garry reported that:
> 
>   # insmod scsi_debug.ko
> 
> Gave errors like this:
> 
> [  140.115244] debugfs: Directory 'sde' with parent 'block' already
> present!
> [  140.376426] debugfs: Directory 'sde' with parent 'block' already
> present!
> [  140.420613] sd 3:0:0:0: [sde] tag#40 access beyond end of device
> [  140.426655] blk_update_request: I/O error, dev sde, sector 15984
> op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 0
> [  140.437319] sd 3:0:0:0: [sde] tag#41 access beyond end of device
> [  140.443368] blk_update_request: I/O error, dev sde, sector 15984
> op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> ...
> 
> Which wasn't the scsi_debug driver directly as it doesn't use
> debugfs. So I suspect something is rotten in the mid-level.
> 
> When I tried to replicate John's config I couldn't even boot my
> Ubuntu 20.04 based system (with a MKP kernel). Seemed to fail/lockup
> before any kernel prints came out to the serial port (yes, still
> useful), perhaps in initrd. I'm guessing another, non-SCSI module
> caused the lockup. So I gave up and turned off that config setting.

If that can be distilled down to a better test case, I can look into
it.

James

