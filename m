From: Aschwin Marsman <aschwin@marsman.org>
Subject: 2.4.23-pre5 BK: aic7xxx_reg.h: Permission Denied
Date: Sun, 21 Sep 2003 11:58:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309211135400.4110-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq2.home.nl ([213.51.128.197]:17587 "EHLO smtpq2.home.nl")
	by vger.kernel.org with ESMTP id S261974AbTIUKAB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Sep 2003 06:00:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com.br, linux-scsi@vger.kernel.org
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>

Hi,

During the compilation of 2.4.23-pre5 (latest from BK), I get the
following:

aicasm/aicasm -I. -r aic7xxx_reg.h -p aic7xxx_reg_print.c -i aic7xxx_osm.h -o aic7xxx_seq.h aic7xxx.seq
aic7xxx_reg.h: Permission denied
make[3]: *** [aic7xxx_seq.h] Error 73
make[3]: Leaving directory `/home/marsman/src/bk/linux-2.4/drivers/scsi/aic7xxx'
make[2]: *** [_modsubdir_aic7xxx] Error 2
make[2]: Leaving directory `/home/marsman/src/bk/linux-2.4/drivers/scsi'
make[1]: *** [_modsubdir_scsi] Error 2
make[1]: Leaving directory `/home/marsman/src/bk/linux-2.4/drivers'
make: *** [_mod_drivers] Error 2

The reason is that:
aic79xx_reg.h
aic79xx_reg_print.c
aic79xx_seq.h
aic7xxx_reg.h
aic7xxx_reg_print.c
aic7xxx_seq.h

are generated files, but they are under version control and therefor readonly, so they can't
be written. I see two options:
1) Do not put them under version control
2) Remove/make them writable before new versions are generated.

I would prefer option one, but you can argue that it is nice to be able to see the history
of the generated files.

The patch below removes the files before they are written.

--- drivers/scsi/aic7xxx/Makefile.org	Sun Sep 21 07:19:34 2003
+++ drivers/scsi/aic7xxx/Makefile	Sun Sep 21 11:46:29 2003
@@ -75,6 +75,7 @@
 		 -o aic7xxx_seq.h aic7xxx.seq
 endif
 $(aic7xxx_gen): aic7xxx.seq aic7xxx.reg aicasm/aicasm
+	$(RM) $(aic7xxx_gen)
 	$(aic7xxx_asm_cmd)
 endif
 
@@ -90,6 +91,7 @@
 		 -o aic79xx_seq.h aic79xx.seq
 endif
 $(aic79xx_gen): aic79xx.seq aic79xx.reg aicasm/aicasm
+	$(RM) $(aic79xx_gen)
 	$(aic79xx_asm_cmd)
 endif
 
Have a nice weekend,
 
Aschwin Marsman
 
--
aschwin@marsman.org              http://www.marsman.org

