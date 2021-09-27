Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D32C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 21:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6CC861074
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 21:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbhI0VBo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:01:44 -0400
Received: from tartarus.angband.pl ([51.83.246.204]:57380 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhI0VBn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 17:01:43 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1mUxj3-00GSTs-6L; Mon, 27 Sep 2021 22:59:49 +0200
Date:   Mon, 27 Sep 2021 22:59:49 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: aic7xxx: fix building with -Werror (missing
 include)
Message-ID: <YVIwxV7HyJ0Le2zh@angband.pl>
References: <20210912213212.12169-1-kilobyte@angband.pl>
 <3e8ba5d8400969270e040d886a1b65c81974ff14.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8ba5d8400969270e040d886a1b65c81974ff14.camel@linux.ibm.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Sep 12, 2021 at 03:09:58PM -0700, James Bottomley wrote:
> On Sun, 2021-09-12 at 23:32 +0200, Adam Borowski wrote:
> > This is an userland helper tool to generate data rather than
> > something compiled into the kernel, thus it wants regular POSIX
> > functions.

> > --- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> > +++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> > @@ -45,6 +45,7 @@
> >  #include <sys/types.h>
> >  
> >  #include "aicdb.h"
> > +#include <ctype.h>
> 
> I'm really dubious about trying to get aicasm to compile with -Werror
> ... the driver is dying and we have prebuilt firmware headers in the
> tree so it's not like it's required.

To be honest, I don't care much about this driver, but when it fails here,
it stops build tests.

> I'm also curious: if you compiled with -Werror how did you get around
> the missing function declarations induced by the -p mm in the bison
> command line?

The Makefile passes -Werror from external flags to some but not other
invocations of the compiler; those spew warnings but don't cause the build
to fail.

Obviously, if we wanted to polish the driver it'd be nice to fix those
warnings, but as I mentioned above that's currently not my itch to scratch.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ According to recent spams, "all my email accounts are owned
⢿⡄⠘⠷⠚⠋⠀ by a hacker".  So what's the problem?
⠈⠳⣄⠀⠀⠀⠀
