Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890B9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 06:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F7E60F11
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 06:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhJMGwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:52:39 -0400
Received: from email.ramaxel.com ([221.4.138.186]:15497 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231495AbhJMGwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 02:52:38 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 19D6oDDN085676
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 Oct 2021 14:50:13 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 13
 Oct 2021 14:50:12 +0800
Date:   Wed, 13 Oct 2021 06:50:12 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211013065012.02b76336@songyl>
In-Reply-To: <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
        <20211012144906.790579d0@songyl>
        <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 19D6oDDN085676
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Oct 2021 09:59:30 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 10/12/21 7:49 AM, Yanling Song wrote:
> > On Mon, 11 Oct 2021 12:54:20 -0700
> > Bart Van Assche <bvanassche@acm.org> wrote:
> >   
> >> On 9/29/21 20:47, Yanling Song wrote:  
> >>> +#define SPRAID_IOCTL_RESET_CMD _IOWR('N', 0x80, struct
> >>> spraid_passthru_common_cmd) +#define SPRAID_IOCTL_ADMIN_CMD
> >>> _IOWR('N', 0x41, struct spraid_passthru_common_cmd)  
> >>
> >> Do these new ioctls provide any functionality that is not yet
> >> provided by SG_IO + SG_SCSI_RESET_BUS?  
> > 
> > These new ioctls are developed to manage our raid controller by our
> > private tools, which has no sg device. so SG_IO cannot work for our
> > case.  
> 
> Why won't an SG device be associated with spraid device nodes? My 
> understanding is that an SG device is associated with every SCSI
> device if CONFIG_CHR_DEV_SG is enabled and also that a bsg device is
> associated with every SCSI device if CONFIG_BLK_DEV_BSG is enabled.
> 
> Why is it that SG_IO is not sufficient? This is something that should 
> have been explained in the patch description.

There are two cases that there are no SG devices and SG_IO cannot work.
1. To access raid controller: 
a. Raid controller is a scsi host, not a scsi device, so there
is no SG device associated with it. 
b. Even there is a scsi device for raid controller, SG_IO
cannot work when something wrong with IO queue and only admin queue can
work;
2. To access the physical disks behinds raid controller: 
raid controller only reports VDs to OS and only VDs have SG devices. OS
has no idea about physical disks behinds raid controller and there is no
SG devices associated with physical disks.  

> 
> >> Additionally, mixing driver-internal and user space definitions in
> >> a single header file is not OK. Definitions of data structures and
> >> ioctls that are needed by user space software should occur in a
> >> header file in the directory include/uapi/scsi/.  
> > 
> > Sounds reasonable. But after checking the directory
> > include/uapi/scsi/, there are only several files in it. It is
> > expected that there should be many files if developers follow the
> > rule. Do you know why?  
> 
> If this rule is not followed, that will be a red flag for the SCSI 
> maintainer and something that will probably delay upstream acceptance
> of this patch.

Since there are not much examples in include/uapi/scsi/, what' your
suggestion on how to put the definitions into the folder? for example,
what's the file name? spraid_ioctrl.h?

> 
> Bart.

