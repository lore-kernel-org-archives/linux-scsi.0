Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA6FC43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 19:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A59D23119
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 19:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600458060;
	bh=IwIR6aotZiZz6If768azZzVDumAWo05x1JcIldWd4Bg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=a2khYU6AJ7MQsAZIwvus1rHqQBytaR0Wo/65vNLKdqTrDxLTXS8tetTfKkvY2pgZD
	 vJqSV6UValLahBHoxtRXvGTkYVmi/+171pMeT3f1949AXFVX4KTc0hTpLjc0+CYJwp
	 hs8rXOY9+JqTBilytg6Ju6IqB+hV4AEOBc7DVFTI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgIRTk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 15:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgIRTk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 15:40:59 -0400
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A7D206A2;
        Fri, 18 Sep 2020 19:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600458058;
        bh=IwIR6aotZiZz6If768azZzVDumAWo05x1JcIldWd4Bg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hTB6MaJ8vlmyVCvLqDBkbU8PBPOgkTv2XnpdEREalwm0Del+ztISIfApVnQiZ+n0i
         /gmvpgIHh8RnIf1PGE4Cgfm7QGlcSWS7qeR1pQU5hMFU06jjMXhHhgKRjkBJKgQiIJ
         A8fgE/ddk2LfXs6XsMYUijB9nGsNKI4dMVxsX80Y=
Date:   Fri, 18 Sep 2020 12:40:56 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv3 1/4] block: add zone specific block statuses
Message-ID: <20200918194056.GB4030837@dhcp-10-100-145-180.wdl.wdc.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
 <20200917231841.4029747-2-kbusch@kernel.org>
 <SN4PR0401MB35983DBC8B0B97A4083CDF8B9B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35983DBC8B0B97A4083CDF8B9B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 18, 2020 at 01:31:44PM +0000, Johannes Thumshirn wrote:
> On 18/09/2020 01:18, Keith Busch wrote:
> > diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
> > index f261a5c84170..2638d3446b79 100644
> > --- a/Documentation/block/queue-sysfs.rst
> > +++ b/Documentation/block/queue-sysfs.rst
> > @@ -124,6 +124,10 @@ For zoned block devices (zoned attribute indicating "host-managed" or
> >  EXPLICIT OPEN, IMPLICIT OPEN or CLOSED, is limited by this value.
> >  If this value is 0, there is no limit.
> >  
> > +If the host attempts to exceed this limit, the driver should report this error
> > +with BLK_STS_ZONE_ACTIVE_RESOURCE, which user space may see as the EOVERFLOW
> > +errno.
> > +
> >  max_open_zones (RO)
> >  -------------------
> >  For zoned block devices (zoned attribute indicating "host-managed" or
> > @@ -131,6 +135,10 @@ For zoned block devices (zoned attribute indicating "host-managed" or
> >  EXPLICIT OPEN or IMPLICIT OPEN, is limited by this value.
> >  If this value is 0, there is no limit.
> >  
> > +If the host attempts to exceed this limit, the driver should report this error
> > +with BLK_STS_ZONE_OPEN_RESOURCE, which user space may see as the ETOOMANYREFS
> > +errno.
> 
> Don't we also need to update some man pages in section 2?

Yes, good point. Those updates need to come from this repo

  https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

right? If so, I can send updates there once it looks like this is the
form that will be committed.
