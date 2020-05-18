Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABCBC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 00:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1768207BB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 00:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgERAfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 May 2020 20:35:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:57991 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgERAfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 May 2020 20:35:41 -0400
IronPort-SDR: GUNjLEvbktaBOcgsW3shhbdbt27my5hD9hhFL1tSHDgSpEwCsP7g6oGOjZFFv/G31VX04KckN5
 haMdhfYegl0w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2020 17:35:41 -0700
IronPort-SDR: NOguugL+eLy+5DTJF5CAdWogARdgcPfmnpRPmLq5S2lKx1qlqZhXbmYI8MNAx5Uhz0TrIi5Xyc
 zqlC6c4b9XWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,405,1583222400"; 
   d="scan'208";a="373226041"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.159.39])
  by fmsmga001.fm.intel.com with ESMTP; 17 May 2020 17:35:38 -0700
Date:   Mon, 18 May 2020 08:34:17 +0800
From:   Philip Li <philip.li@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kbuild test robot <lkp@intel.com>, Michal Simek <monstr@monstr.eu>,
        kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Stefan Asserhall <stefan.asserhall@xilinx.com>,
        linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [kbuild-all] Re: drivers/scsi/ncr53c8xx.c:5306:9: sparse:
 sparse: cast truncates bits from constant value (58f becomes 8f)
Message-ID: <20200518003417.GA4344@intel.com>
References: <202005160227.h6Ieqnmz%lkp@intel.com>
 <20200515190026.GI16070@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515190026.GI16070@bombadil.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 15, 2020 at 12:00:26PM -0700, Matthew Wilcox wrote:
> On Sat, May 16, 2020 at 02:20:38AM +0800, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   051e6b7e34b9bd24f46725f74994a4d3a653966e
> > commit: 06e85c7e9a1c1356038936566fc23f7c0d363b96 asm-generic: fix unistd_32.h generation format
> > date:   5 weeks ago
> 
> I don't see how that commit in any way reflects this error message.
> 
> > reproduce:
> >         # apt-get install sparse
> >         # sparse version: v0.6.1-193-gb8fad4bc-dirty
> >         git checkout 06e85c7e9a1c1356038936566fc23f7c0d363b96
> >         make ARCH=x86_64 allmodconfig
> 
> I can't even see a way to build the ncr53c8xx module with this config.
> Unless somebody reenabled EISA on x86, the only way I can see to
> still build this driver is on PA-RISC with the ZALON code.
sorry, the reproduce steps here is wrong, it is not for x86_64. We will
fix this.

> 
> >         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > 
> > sparse warnings: (new ones prefixed by >>)
> > 
> > >> drivers/scsi/ncr53c8xx.c:5306:9: sparse: sparse: cast truncates bits from constant value (58f becomes 8f)
> > 
> > ^1da177e4c3f41 Linus Torvalds 2005-04-16 @5306  	OUTW (nc_sien , STO|HTH|MA|SGE|UDC|RST|PAR);
> 
> This seems entirely intentional.
> 
> Something like this should do the job (whitespace damaged):
> 
> +++ b/drivers/scsi/ncr53c8xx.h
> @@ -407,7 +407,7 @@
>  
>  #ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
>  /* Only 8 or 32 bit transfers allowed */
> -#define OUTW_OFF(o, val)       do { writeb((char)((val) >> 8), (char __iomem *)np->reg + ncr_offw(o)); writeb((char)(val), (char __iomem *)np->reg + ncr_offw(o) + 1); } while (0)
> +#define OUTW_OFF(o, val)       do { writeb((char)((val) >> 8), (char __iomem *)np->reg + ncr_offw(o)); writeb((char)((val) & 0xff), (char __iomem *)np->reg + ncr_offw(o) + 1); } while (0)
>  #else
>  #define OUTW_OFF(o, val)       writew_raw((val), (char __iomem *)np->reg + ncr_offw(o))
>  #endif
> 
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org
