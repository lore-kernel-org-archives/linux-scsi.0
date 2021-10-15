Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169BDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 05:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE2E761181
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 05:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhJOFuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 01:50:54 -0400
Received: from email.unionmem.com ([221.4.138.186]:64434 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229706AbhJOFux (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 01:50:53 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 19F5mENA068304
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Oct 2021 13:48:14 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Fri, 15
 Oct 2021 13:48:14 +0800
Date:   Fri, 15 Oct 2021 05:48:14 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211015054814.56eb042a@songyl>
In-Reply-To: <9d9d2f95-7782-85a7-b79a-ce481292c451@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
        <20211012144906.790579d0@songyl>
        <6cd75c09-8374-7b9b-4ecc-3b3781cbe074@acm.org>
        <20211013065012.02b76336@songyl>
        <9d9d2f95-7782-85a7-b79a-ce481292c451@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS01.ramaxel.local (172.26.18.31) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 19F5mENA068304
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 15:00:07 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 10/12/21 11:50 PM, Yanling Song wrote:
> > On Tue, 12 Oct 2021 09:59:30 -0700
> > Bart Van Assche <bvanassche@acm.org> wrote:  
> >> Why is it that SG_IO is not sufficient? This is something that
> >> should have been explained in the patch description.  
> > 
> > There are two cases that there are no SG devices and SG_IO cannot
> > work. 1. To access raid controller:
> > a. Raid controller is a scsi host, not a scsi device, so there
> > is no SG device associated with it.
> > b. Even there is a scsi device for raid controller, SG_IO
> > cannot work when something wrong with IO queue and only admin queue
> > can work;
> > 2. To access the physical disks behinds raid controller:
> > raid controller only reports VDs to OS and only VDs have SG
> > devices. OS has no idea about physical disks behinds raid
> > controller and there is no SG devices associated with physical
> > disks.  
> 
> Please take a look at the bsg_setup_queue() call in ufs_bsg_probe(). 
> That call associates a BSG queue with the UFS host. That queue
> supports requests of type struct ufs_bsg_request. The Fibre Channel
> transport driver does something similar. I believe that this is a
> better solution than introducing entirely new ioctls.

I need some time to investigate it. will response later.

> 
> >>>> Additionally, mixing driver-internal and user space definitions
> >>>> in a single header file is not OK. Definitions of data
> >>>> structures and ioctls that are needed by user space software
> >>>> should occur in a header file in the directory
> >>>> include/uapi/scsi/.  
> >>>
> >>> Sounds reasonable. But after checking the directory
> >>> include/uapi/scsi/, there are only several files in it. It is
> >>> expected that there should be many files if developers follow the
> >>> rule. Do you know why?  
> >>
> >> If this rule is not followed, that will be a red flag for the SCSI
> >> maintainer and something that will probably delay upstream
> >> acceptance of this patch.  
> > 
> > Since there are not much examples in include/uapi/scsi/, what' your
> > suggestion on how to put the definitions into the folder? for
> > example, what's the file name? spraid_ioctrl.h?  
> 
> How about include/uapi/scsi/spraid.h, since I assume that that header 
> file will cover all user space interfaces for interaction with the 
> spraid driver?
> 
> Thanks,
> 
> Bart.
> 

