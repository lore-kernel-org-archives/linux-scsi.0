From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 2/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 14 Apr 2008 20:47:40 +0200
Message-ID: <200804142047.40426.vda.linux@googlemail.com>
References: <200803230440.40685.vda.linux@googlemail.com> <47FB8713.3030208@suse.de> <200804081708.06787.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:53691 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965205AbYDNSry (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2008 14:47:54 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1664549fgb.17
        for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2008 11:47:52 -0700 (PDT)
In-Reply-To: <200804081708.06787.vda.linux@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Tuesday 08 April 2008 17:08, Denys Vlasenko wrote:
> > > Please let me know how to regenerate these _shipped files,
> > > and I will fix it "correctly" by modifying aicasm/* files.
> >
> > CONFIG_PREVENT_FIRMWARE_BUILD is the trick.
> > Once it's enable there's a config option which allows you to
> > build the aic7xxx firmware files from scratch.
> 
> Well, I already tried it, and I mentioned it in my previous email.
> Relevant part of make output:
> 
>   LD      kernel/built-in.o
> make -C drivers/scsi/aic7xxx/aicasm
> bison -d -b aicasm_gram aicasm_gram.y
> aicasm_gram.y: warning: 1 useless nonterminal and 6 useless rules
> aicasm_gram.y:217.46-54: warning: useless nonterminal: f4_opcode
> aicasm_gram.y:1315.9-37: warning: useless rule: f4_opcode: T_OR16
> aicasm_gram.y:1316.9-38: warning: useless rule: f4_opcode: T_AND16
> aicasm_gram.y:1317.9-38: warning: useless rule: f4_opcode: T_XOR16
> aicasm_gram.y:1318.9-38: warning: useless rule: f4_opcode: T_ADD16
> aicasm_gram.y:1319.9-38: warning: useless rule: f4_opcode: T_ADC16
> aicasm_gram.y:1320.9-38: warning: useless rule: f4_opcode: T_MVI16
> mv aicasm_gram.tab.c aicasm_gram.c
> mv aicasm_gram.tab.h aicasm_gram.h
> bison -d -b aicasm_macro_gram -p mm aicasm_macro_gram.y
> mv aicasm_macro_gram.tab.c aicasm_macro_gram.c
> mv aicasm_macro_gram.tab.h aicasm_macro_gram.h
> flex  -oaicasm_scan.c aicasm_scan.l
> flex  -Pmm -oaicasm_macro_scan.c aicasm_macro_scan.l
> gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
> drivers/scsi/aic7xxx/aicasm/aicasm -Idrivers/scsi/aic7xxx -r drivers/scsi/aic7xxx/aic79xx_reg.h \
>                       -p drivers/scsi/aic7xxx/aic79xx_reg_print.c -i aic79xx_osm.h -o drivers/scsi/aic7xxx/aic79xx_seq.h \
>                       drivers/scsi/aic7xxx/aic79xx.seq
> drivers/scsi/aic7xxx/aicasm/aicasm: 826 instructions used
>   CC      drivers/scsi/aic7xxx/aic79xx_core.o
>   CC      drivers/scsi/aic7xxx/aic79xx_pci.o
>   CC      drivers/scsi/aic7xxx/aic79xx_reg_print.o
>   CC      drivers/scsi/aic7xxx/aic79xx_osm.o
>   CC      drivers/scsi/aic7xxx/aic79xx_proc.o
>   CC      drivers/scsi/aic7xxx/aic79xx_osm_pci.o
> drivers/scsi/aic7xxx/aicasm/aicasm -Idrivers/scsi/aic7xxx -r drivers/scsi/aic7xxx/aic7xxx_reg.h \
>                       -p drivers/scsi/aic7xxx/aic7xxx_reg_print.c -i aic7xxx_osm.h -o drivers/scsi/aic7xxx/aic7xxx_seq.h \
>                       drivers/scsi/aic7xxx/aic7xxx.seq
> drivers/scsi/aic7xxx/aicasm/aicasm: 880 instructions used
>   CC      drivers/scsi/aic7xxx/aic7xxx_core.o
> 
> > But you need my patch I just posted to linux-scsi, otherwise
> > aicasm will complain and not build anything.
> 
> Indeed, I found out that _shipped files are not updated
> after above.
> 
> Can you send this patch to me? I'm not subscribed to linux-scsi...

Ping here as well.
--
vda
