From: John Cherry <cherry@osdl.org>
Subject: Re: [TRIVIAL] fix parallel builds for aic7xxx]
Date: 24 Sep 2003 09:21:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064420472.2658.13.camel@cherrytest.pdx.osdl.net>
References: <20030924032922.BE68C2C21F@lists.samba.org>
	 <1064412654.2063.3.camel@mulgrave> <376620000.1064414362@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:41362 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261485AbTIXQWh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:22:37 -0400
In-Reply-To: <376620000.1064414362@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Rusty Trivial Russell <trivial@rustcorp.com.au>, Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

While any of the 3 patches (John's, Sam's, and Justin's) should work,
Justin has a case (below) for his patch.  

I have verified John's and Sam's patch, but I have not been able to
cleanly apply Justin's patch to 2.4 or 2.6 yet.  So please do not
forward this patch until we can verify it.

John


On Wed, 2003-09-24 at 07:39, Justin T. Gibbs wrote:
> > On Tue, 2003-09-23 at 21:56, Rusty Trivial Russell wrote:
> >> [ Sorry, did you guys end up with consensus on this?  Should I forward
> >>   or drop?  Thanks, Rusty ]
> > 
> > Justin, I think after some discussion you agreed this to be correct. 
> 
> Actually, no.  Here's the latest information on this issue that I
> sent to both Sam and John:
> 
> Date: Wed, 17 Sep 2003 16:09:58 -0600
> From: "Justin T. Gibbs" <gibbs@scsiguy.com>
> Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
> To: John Cherry <cherry@osdl.org>, Sam Ravnborg <sam@ravnborg.org>
> Subject: Re: [TRIVIAL][PATCH] fix parallel builds for aic7xxx]
> Message-ID: <34280000.1063836597@aslan.btc.adaptec.com>
> In-Reply-To: <1063129389.1512.39.camel@cherrypit.pdx.osdl.net>
> 
> > Justin,
> > 
> > I assume you are the scsi guy (I can take a clue).  Is Sam's patch for
> > the aic7xxx Makefiles more acceptable to you?  How do we move this
> > forward?
> 
> There are still problems with both patches.
> 
> Option 1 looks like this:
> 
> $(aic7xxx-gen-y): $(src)/aic7xxx.seq 
> 
> $(src)/aic7xxx.seq: $(obj)/aicasm/aicasm $(src)/aic7xxx.reg
> 	run assembler...
> 
> The .seq file is not a generated file, so unless you touch it,
> this rule will always be invoked so long as the .seq file
> is older than the .reg file.  This also means that if the .seq
> file is newer than the reg file and aicasm, the assembler will
> not run.
> 
> Option 2 looks like this:
> 
> $(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg
> $(aic7xxx-gen-y): doaic7xasm
> 
> .PHONY: doaic7xasm
> $(aic7xxx-gen-y): doaic7xasm
> 
> doaic7xasm: $(obj)/aicasm/aicasm
> 	run assembler ...
> 
> In this case, the assembler will aways be run since a phony
> target that is a prerequisite to a real target will always
> be executed (the make manual explicitly warns about this).
> Running the assembler guarantees a recompile of the entire
> driver.  Even if this were not the case, the generated files
> would not be rebuilt if only the assembler changed.  This
> strategy also seems to confuse make into attempting to pull
> the generated files out of RCS/SCCS if, for example, you
> have a BK tree.
> 
> What we really want is an order only pre-requisite, but not
> all Linux installations have a make new enough to support this.
> (This is the pipe prerequisite syntax).  Baring that, I plan
> to just chain the generated files as a dependency which still
> causes the assembler to be run multiple times if any generated
> file is out of date, but at least the assembler will not be run
> concurrently.  This also avoids having the files rebuilt on
> each build.
> 
> It would be really nice if gnu make would grow a .ORDER target
> like bmake so that you can selectively disable parallelism
> on certain targets.
> 
> --
> Justin
> 
> ==== //depot/linux-aic79xx-2.4.0/drivers/scsi/aic7xxx/Makefile#15 - /home/gibbs/bk/linux-2.4/drivers/scsi/aic7xxx/Makefile ====
> --- /tmp/tmp.12649.0	2003-09-17 16:03:52.000000000 -0600
> +++ /home/gibbs/bk/linux-2.4/drivers/scsi/aic7xxx/Makefile	2003-09-17 15:49:06.000000000 -0600
> @@ -64,8 +64,13 @@
>  	$(LD) $(LD_RFLAG) -r -o $@ $(obj-aic79xx)
>  
>  ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
> +# Create a dependency chain in generated files
> +# to avoid concurrent invocations of the single
> +# rule that builds them all.
> +aic7xxx_seq.h: aic7xxx_reg.h
>  aic7xxx_gen = aic7xxx_seq.h aic7xxx_reg.h
>  ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
> +aic7xxx_reg.h: aic7xxx_reg_print.c
>  aic7xxx_gen += aic7xxx_reg_print.c
>  aic7xxx_asm_cmd = aicasm/aicasm -I. -r aic7xxx_reg.h		\
>  		 -p aic7xxx_reg_print.c -i aic7xxx_osm.h	\
> @@ -79,8 +84,13 @@
>  endif
>  
>  ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
> +# Create a dependency chain in generated files
> +# to avoid concurrent invocations of the single
> +# rule that builds them all.
> +aic79xx_seq.h: aic79xx_reg.h
>  aic79xx_gen = aic79xx_seq.h aic79xx_reg.h
>  ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
> +aic79xx_reg.h: aic79xx_reg_print.c
>  aic79xx_gen += aic79xx_reg_print.c
>  aic79xx_asm_cmd = aicasm/aicasm -I. -r aic79xx_reg.h		\
>  		 -p aic79xx_reg_print.c -i aic79xx_osm.h	\
> ==== //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aicasm/Makefile#14 - /home/gibbs/bk/linux-2.4/drivers/scsi/aic7xxx/aicasm/Makefile
> ====
> --- /tmp/tmp.12649.7	2003-09-17 16:03:52.000000000 -0600
> +++ /home/gibbs/bk/linux-2.4/drivers/scsi/aic7xxx/aicasm/Makefile	2003-09-17 15:49:09.000000000 -0600
> @@ -49,11 +49,19 @@
>  clean:
>  	rm -f $(clean-files)
>  
> +# Create a dependency chain in generated files
> +# to avoid concurrent invocations of the single
> +# rule that builds them all.
> +aicasm_gram.c: aicasm_gram.h
>  aicasm_gram.c aicasm_gram.h: aicasm_gram.y
>  	$(YACC) $(YFLAGS) -b $(<:.y=) $<
>  	mv $(<:.y=).tab.c $(<:.y=.c)
>  	mv $(<:.y=).tab.h $(<:.y=.h)
>  
> +# Create a dependency chain in generated files
> +# to avoid concurrent invocations of the single
> +# rule that builds them all.
> +aicasm_macro_gram.c: aicasm_macro_gram.h
>  aicasm_macro_gram.c aicasm_macro_gram.h: aicasm_macro_gram.y
>  	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
>  	mv $(<:.y=).tab.c $(<:.y=.c)
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

