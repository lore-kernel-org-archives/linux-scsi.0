Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3895C2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 08:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9316120719
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 08:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604391993;
	bh=H2o46wRPnMfCNsMFuys7neQERbJwFfzabczNDkta3pM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JBnCqrGvrWrfH15MK7gFhG/uejXn23oWPL3h8I7imQz0kdyjdFGYtiMPYpT1hIvW6
	 bykWge6GkFX2XEshGYStp6IVbiI4yOUc68jubqGn+/WK5XMGteVB7UeJi5vzAyB7ws
	 Yb38k+uJroLtf/ogjjudV1PC1mT+hKcNiaK3MTfk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgKCI03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 03:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCI02 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 03:26:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36959206E3;
        Tue,  3 Nov 2020 08:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604391988;
        bh=H2o46wRPnMfCNsMFuys7neQERbJwFfzabczNDkta3pM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwdrDX82oG6KNy4uGMP56MKtqOyfCaei7QuxmihCi5nuY2BfUG3V3B/U+peBiTH0x
         3Xh5Ma0p/h+2O2fY8hFCxA8TmkFFZx04w4SbovqnHgOzqKc4E3JP8WKr0vc9X0o3Mf
         /1170kWuMXZW/zTII1J62AQ1umkoyP9q8v6fwJcY=
Date:   Tue, 3 Nov 2020 09:27:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     luojiaxing <luojiaxing@huawei.com>
Cc:     akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        andriy.shevchenko@linux.intel.com, linux-kernel@vger.kernel.org,
        martin.petersen@oracle.com, john.garry@huawei.com,
        himanshu.madhani@cavium.com, felipe.balbi@linux.intel.com,
        uma.shankar@intel.com, anshuman.gupta@intel.com,
        animesh.manna@intel.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH v2 0/5] Introduce a new helper marco
 DEFINE_SHOW_STORE_ATTRIBUTE at seq_file.c
Message-ID: <20201103082721.GA2510248@kroah.com>
References: <1604046722-15531-1-git-send-email-luojiaxing@huawei.com>
 <20201030084448.GA1625087@kroah.com>
 <d4852df0-d7e0-ee7e-352c-58eaf47c2c72@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4852df0-d7e0-ee7e-352c-58eaf47c2c72@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 03, 2020 at 04:19:09PM +0800, luojiaxing wrote:
> Hi
> 
> On 2020/10/30 16:44, Greg KH wrote:
> > On Fri, Oct 30, 2020 at 04:31:57PM +0800, Luo Jiaxing wrote:
> > > We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
> > > for read-only file, but we found many of drivers also want a helper marco for
> > > read-write file too.
> > > 
> > > So we try to add this macro to help decrease code duplication.
> > > 
> > > Luo Jiaxing (5):
> > >    seq_file: Introduce DEFINE_SHOW_STORE_ATTRIBUTE() helper macro
> > >    scsi: hisi_sas: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
> > >    scsi: qla2xxx: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
> > >    usb: dwc3: debugfs: Introduce DEFINE_SHOW_STORE_ATTRIBUTE
> > >    drm/i915/display: Introduce DEFINE_SHOW_STORE_ATTRIBUTE for debugfs
> > What changed from v1?
> 
> 
> Sorry, I should add a commit for the change.
> 
> 
> In v1, Andy pointed out that the old name of DEFINE_STORE_ATTRIBUTE was
> easily misunderstood as a write-only file rather than a read-write file.
> 
> Therefore, it is changed to DEFINE_SHOW_STORE_ATTRIBUTE according to his
> suggestion.

All of that needs to go in the patch, below the --- line, or in the
00/XX email here, like is documented.

Please fix that up and resend a v3 if you wish for people to look at
this series and know what is going on.

thanks,

greg k-h
