From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic7xxx build failure
Date: Tue, 05 Feb 2008 12:08:42 -0600
Message-ID: <1202234923.3133.47.camel@localhost.localdomain>
References: <20080205174024.GE505@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51701 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281AbYBESIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 13:08:49 -0500
In-Reply-To: <20080205174024.GE505@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2008-02-05 at 19:40 +0200, Adrian Bunk wrote:
> Commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb broke aic7xxx 
> compilation:
> 
> <--  snip  -->
> 
> $ make O=../out/x86-full
> ...
>   SHIPPED drivers/scsi/aic7xxx/aic79xx_seq.h
>   SHIPPED drivers/scsi/aic7xxx/aic79xx_reg.h
>   CC      drivers/scsi/aic7xxx/aic79xx_core.o
> gcc: drivers/scsi/aic7xxx/aic79xx_core.c: No such file or directory
> gcc: no input files
> make[4]: *** [drivers/scsi/aic7xxx/aic79xx_core.o] Error 1
> 
> <--  snip  -->
> 
> Next "make" run brings the same failure in 
> drivers/scsi/aic7xxx/aic7xxx_core.c.
> 
> With the third "make" it works.
> 
> It might compile for people with SMP systems using -j?

I'd just say "weird behaviour"  the file being complained about is
definitely part of the tree ... does it actually exist in your tree when
gcc claims it doesn't? if so, I suspect some type of make path screwup
here.  The commit in question is this:

commit 8891fec65ac5b5a74b50c705e31b66c92c3eddeb
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Feb 3 21:55:49 2008 +0100

    scsi: fix dependency bug in aic7 Makefile
    
    Building the aic7xxx driver includes the copy
    of an .h file from a _shipped file.
    
    In a highly parallel build Ingo saw that the
    build sometimes failed (included distcc usage).
    It was tracked down to a missing dependency from the .c
    source file to the generated .h file.
    We started to build the .c file before the
    copy (cat) operation of the .h file completed
    and we then only got half of the definitions
    from the copied .h file.
    
    Add an explicit dependency from the .c files to the
    generated .h files so make knows all dependencies and
    finsih the build of the .h files before it starts
    building the .o files.
    
    Ingo tested this fix and reported:
    good news: hundreds of successful kernel builds and no failures
    overnight.
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index e4f70c5..4c54954 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -44,13 +44,8 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 
 # Dependencies for generated files need to be listed explicitly
 
-$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_seq.h
-$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_reg.h
-$(obj)/aic79xx_core.o: $(obj)/aic79xx_seq.h
-$(obj)/aic79xx_core.o: $(obj)/aic79xx_reg.h
-
-$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h
-$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h
+$(addprefix $(src)/,$(aic7xxx-y:.o=.c)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
+$(addprefix $(src)/,$(aic79xx-y:.o=.c)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
 
 aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c

The last two additions look wrong:  they make source files depend on
headers, which isn't right: it's object files that depend on headers (we
don't know how to rebuild the .c files because they're not auto
generated).  However, the commit log indicates the cause might be
deeper.

James


