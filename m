Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32165C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 14:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C46D6103D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 14:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhJLOvd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 10:51:33 -0400
Received: from email.unionmem.com ([221.4.138.186]:10158 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230195AbhJLOvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 10:51:32 -0400
Received: from V12DG1MBS01.ramaxel.local (v12dg1mbs01.ramaxel.local [172.26.18.31])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 19CEn7Ek001766
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Oct 2021 22:49:07 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS01.ramaxel.local
 (172.26.18.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Oct 2021 22:49:06 +0800
Date:   Tue, 12 Oct 2021 14:49:06 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <songyl@ramaxel.com>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211012144906.790579d0@songyl>
In-Reply-To: <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
        <cfe5b692-6642-e317-39a7-f38c1460097c@acm.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS01.ramaxel.local (172.26.18.31)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 19CEn7Ek001766
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 11 Oct 2021 12:54:20 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 9/29/21 20:47, Yanling Song wrote:
> > +#define SPRAID_IOCTL_RESET_CMD _IOWR('N', 0x80, struct
> > spraid_passthru_common_cmd) +#define SPRAID_IOCTL_ADMIN_CMD
> > _IOWR('N', 0x41, struct spraid_passthru_common_cmd)  
> 
> Do these new ioctls provide any functionality that is not yet
> provided by SG_IO + SG_SCSI_RESET_BUS?

These new ioctls are developed to manage our raid controller by our
private tools, which has no sg device. so SG_IO cannot work for our
case.

> 
> Additionally, mixing driver-internal and user space definitions in a 
> single header file is not OK. Definitions of data structures and
> ioctls that are needed by user space software should occur in a
> header file in the directory include/uapi/scsi/.

Sounds reasonable. But after checking the directory include/uapi/scsi/,
there are only several files in it. It is expected that there should be
many files if developers follow the rule. Do you know why? 

> 
> > +#define SPRAID_IOCTL_IOQ_CMD _IOWR('N', 0x42, struct
> > spraid_ioq_passthru_cmd)  
> 
> What functionality does this ioctl provide that is not yet provided
> by SG_IO?

See the above.

> 
> > +#define SPRAID_DRV_VERSION	"1.0.0.0"  
> 
> Although many Linux kernel drivers include a version number, a
> version number is only useful in an out-of-tree driver and not in an
> upstream driver. The Linux kernel itself already has a version number.

In practice, There are several branch/versions of the driver for
different purposes, upstream version is one of them. a version number
can easily tell us where it comes from and what's the relationship
between different versions. I think that's the reason why many Linux
kernel drivers have a version number.

> 
> > +MODULE_AUTHOR("Ramaxel Memory Technology");  
> 
> My understanding is that the MODULE_AUTHOR argument should mention
> the name of a person. From include/linux/module.h:
> 
> /*
>   * Author(s), use "Name <email>" or just "Name", for multiple
>   * authors use multiple MODULE_AUTHOR() statements/lines.
>   */
> #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

ok. Will use the name of developer in the next version.

> 
> Thanks,
> 
> Bart.

