Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECC5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 01:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53EF761994
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 01:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351003AbhJABF6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 21:05:58 -0400
Received: from email.unionmem.com ([221.4.138.186]:54972 "EHLO
        VLXDG1SPAM1.ramaxel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1350887AbhJABF6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 21:05:58 -0400
Received: from V12DG1MBS03.ramaxel.local (v12dg1mbs03.ramaxel.local [172.26.18.33])
        by VLXDG1SPAM1.ramaxel.com with ESMTPS id 19113lKR072180
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Oct 2021 09:03:47 +0800 (GMT-8)
        (envelope-from songyl@ramaxel.com)
Received: from songyl (10.64.10.54) by V12DG1MBS03.ramaxel.local
 (172.26.18.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1531.3; Fri, 1 Oct
 2021 09:03:46 +0800
Date:   Fri, 1 Oct 2021 01:03:46 +0000
From:   Yanling Song <songyl@ramaxel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <20211001010346.2478a8af@songyl>
In-Reply-To: <481d8f10-f755-29f0-58f3-9838890b0dc6@infradead.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
 <481d8f10-f755-29f0-58f3-9838890b0dc6@infradead.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.10.54]
X-ClientProxiedBy: V12DG1MBS03.ramaxel.local (172.26.18.33) To
 V12DG1MBS03.ramaxel.local (172.26.18.33)
X-DNSRBL: 
X-MAIL: VLXDG1SPAM1.ramaxel.com 19113lKR072180
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Randy,
Thanks for your comments. 
It is National Holiday since today and I'm on a 7-day vacation. My
response may be delayed, Sorry.
 


On Wed, 29 Sep 2021 22:36:14 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:
> Hi,
> 
> On 9/29/21 8:47 PM, Yanling Song wrote:
> > This initial commit contains Ramaxel's spraid module.
> >   
> 
> Does "spraid" mean anything?  <something>  RAID ?

yes, it means Super RAID.

> 
> > Signed-off-by: Yanling Song <songyl@ramaxel.com>
> > ---
> >   Documentation/scsi/spraid.rst                 |   28 +
> >   .../userspace-api/ioctl/ioctl-number.rst      |    2 +
> >   MAINTAINERS                                   |    7 +
> >   drivers/scsi/Kconfig                          |    1 +
> >   drivers/scsi/Makefile                         |    1 +
> >   drivers/scsi/spraid/Kconfig                   |   11 +
> >   drivers/scsi/spraid/Makefile                  |    7 +
> >   drivers/scsi/spraid/spraid.h                  |  656 +++
> >   drivers/scsi/spraid/spraid_main.c             | 3617
> > +++++++++++++++++ 9 files changed, 4330 insertions(+)
> >   create mode 100644 Documentation/scsi/spraid.rst
> >   create mode 100644 drivers/scsi/spraid/Kconfig
> >   create mode 100644 drivers/scsi/spraid/Makefile
> >   create mode 100644 drivers/scsi/spraid/spraid.h
> >   create mode 100644 drivers/scsi/spraid/spraid_main.c
> >   
> 
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > b/Documentation/userspace-api/ioctl/ioctl-number.rst index
> > 2e8134059c87..d93dbb680b16 100644 ---
> > a/Documentation/userspace-api/ioctl/ioctl-number.rst +++
> > b/Documentation/userspace-api/ioctl/ioctl-number.rst @@ -169,6
> > +169,8 @@ Code  Seq#    Include
> > File                                           Comments 'M'
> > 00-0F  drivers/video/fsl-diu-fb.h
> > conflict! 'N'   00-1F  drivers/usb/scanner.h 'N'   40-7F
> > drivers/block/nvme.c +'N'   41-42
> > drivers/scsi/spraid_main.c
> > conflict! +'N'   80     drivers/scsi/spraid_main.c 'O'   00-06
> > mtd/ubi-user.h                                          UBI 'P'
> > all    linux/soundcard.h
> > conflict! 'P'   60-6F
> > sound/sscape_ioctl.h                                    conflict!  
> 
> It looks like the above won't apply cleanly: the surrounding lines
> should not be indented any.

Will be fixed in the next version. 

> 
> > diff --git a/drivers/scsi/spraid/Kconfig
> > b/drivers/scsi/spraid/Kconfig new file mode 100644
> > index 000000000000..83962efaab07
> > --- /dev/null
> > +++ b/drivers/scsi/spraid/Kconfig
> > @@ -0,0 +1,11 @@
> > +#
> > +# Ramaxel driver configuration
> > +#
> > +
> > +config RAMAXEL_SPRAID
> > +	tristate "Ramaxel spraid Adapter"
> > +	depends on PCI && SCSI
> > +	depends on ARM64 || X86_64
> > +	default m  
> 
> Not "default m" unless it is needed to boot a system.

This line will be deleted in next version.

> 
> > +	help
> > +	  This driver supports Ramaxel spraid driver.  
> 
> 
> thanks.

