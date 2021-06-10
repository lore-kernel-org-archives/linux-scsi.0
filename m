Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C2DC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D587A613C1
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFJGJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 02:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229773AbhFJGJY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 02:09:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50627613B3;
        Thu, 10 Jun 2021 06:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623305248;
        bh=ygFYpVttYSWRyJGXwmZ+1NyXt4FbWlAO+T55CZ3VByA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Uw6k6y22ZIWs/LsAg49h9m9zK8HRxtUGhVuGbvx1oN9uCJfZnRa2uwNt0PbgV3gS
         Y0oqHpaSsHRK0RcazSP8LKvwZlszNLu3jvvnhDJvTnGee+3TpG4QpQhubRyyl2wHL6
         xZECE1nakDc7qFRj0sTATjoiTKEvmbbaSrKCLmAY=
Date:   Thu, 10 Jun 2021 08:07:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: Re: [PATCH v36 4/4] scsi: ufs: Add HPB 2.0 support
Message-ID: <YMGsHp0eLObOkvKL@kroah.com>
References: <20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p2>
 <CGME20210607041650epcms2p29002c9d072738bbf21fb4acf31847e8e@epcms2p7>
 <20210607041927epcms2p707781de1678af1e1d0f4d88782125f7b@epcms2p7>
 <25912c0a-7f52-8b04-2ac1-6686aee01f87@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25912c0a-7f52-8b04-2ac1-6686aee01f87@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 09, 2021 at 08:37:49PM -0700, Bart Van Assche wrote:
> On 6/6/21 9:19 PM, Daejun Park wrote:
> > -What:		/sys/class/scsi_device/*/device/hpb_sysfs/hit_cnt
> > +What:		/sys/class/scsi_device/*/device/hpb_stat_sysfs/hit_cnt
> >  Date:		June 2021
> >  Contact:	Daejun Park <daejun7.park@samsung.com>
> >  Description:	This entry shows the number of reads that changed to HPB read.
> >  
> >  		The file is read only.
> 
> Is it really useful to have a suffix "_sysfs" for a directory that
> occurs in sysfs? If not, please leave it out.

Ugh, missed that, yes it should be dropped, that's pointless :)

thanks,

greg k-h
