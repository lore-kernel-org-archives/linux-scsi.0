From: "Denis Vlasenko" <vda.linux@googlemail.com>
Subject: [PATCH] debloat aic7xxx and aic79xx drivers by deinlining
Date: Tue, 31 Jul 2007 10:19:12 +0100
Message-ID: <1158166a0707310219t60c12ea9t484ce9f6a1dd9cb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:3474 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbXGaJTO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 05:19:14 -0400
Received: by nf-out-0910.google.com with SMTP id g13so207283nfb
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 02:19:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arjan@infradead.org, hare@suse.de, gibbs@scsiguy.com

Hi,

Attached patch deinlines and moves big functions from .h to .c files
in drivers/scsi/aic7xxx/*. I also had to add prototypes for ahc_lookup_scb
and ahd_lookup_scb to .h files.

No other code changes made.

Compile-tested on i386 and x86-64.
Total .text size reduction: ~60k in 64 bits, ~90k in 32 bits.

Per-object-file and whole-module size difference:
for x86-64:
   text    data     bss     dec     hex filename
 261433   50018    1172  312623   4c52f org/built-in.o
 199622   50018    1172  250812   3d3bc aic/built-in.o
  11680    7168       0   18848    49a0 org/aic7xxx_reg_print.o
  11680    7168       0   18848    49a0 aic/aic7xxx_reg_print.o
   3065       0       0    3065     bf9 org/aic7xxx_proc.o
   2849       0       0    2849     b21 aic/aic7xxx_proc.o
  16037    1984       0   18021    4665 org/aic7xxx_pci.o
  12896    1984       0   14880    3a20 aic/aic7xxx_pci.o
   1977    4768       0    6745    1a59 aic/aic7xxx_osm_pci.o
   1704    4768       0    6472    1948 org/aic7xxx_osm_pci.o
  15033     865     564   16462    404e org/aic7xxx_osm.o
  13752     865     564   15181    3b4d aic/aic7xxx_osm.o
  53228    7424       0   60652    ecec org/aic7xxx_core.o
  42925    7424       0   50349    c4ad aic/aic7xxx_core.o
   3193      72       0    3265     cc1 org/aic7xxx_93cx6.o
   1778      72       0    1850     73a aic/aic7xxx_93cx6.o
 103971   22321     564  126856   1ef88 org/aic7xxx.o
  87888   22321     564  110773   1b0b5 aic/aic7xxx.o
  25743   14016       0   39759    9b4f org/aic79xx_reg_print.o
  25743   14016       0   39759    9b4f aic/aic79xx_reg_print.o
   3312       0       0    3312     cf0 org/aic79xx_proc.o
   2764       0       0    2764     acc aic/aic79xx_proc.o
   9420     544      24    9988    2704 org/aic79xx_pci.o
   6539     544      24    7107    1bc3 aic/aic79xx_pci.o
   1805    6336       0    8141    1fcd org/aic79xx_osm_pci.o
   1791    6336       0    8127    1fbf aic/aic79xx_osm_pci.o
  18982    1189     564   20735    50ff org/aic79xx_osm.o
  17287    1189     564   19040    4a60 aic/aic79xx_osm.o
  98160    5600       0  103760   19550 org/aic79xx_core.o
  57572    5600       0   63172    f6c4 aic/aic79xx_core.o
 157435   27697     596  185728   2d580 org/aic79xx.o
 111708   27697     596  140001   222e1 aic/aic79xx.o

and for i386:
   text    data     bss     dec     hex filename
 280361   32633    1112  314106   4cafa org/built-in.o
 190406   32633    1112  224151   36b97 aic/built-in.o
  11697    3336       0   15033    3ab9 org/aic7xxx_reg_print.o
  11697    3336       0   15033    3ab9 aic/aic7xxx_reg_print.o
   2970       0       0    2970     b9a org/aic7xxx_proc.o
   2698       0       0    2698     a8a aic/aic7xxx_proc.o
  16700    1488       0   18188    470c org/aic7xxx_pci.o
  11984    1488       0   13472    34a0 aic/aic7xxx_pci.o
   1857    4044       0    5901    170d aic/aic7xxx_osm_pci.o
   1575    4044       0    5619    15f3 org/aic7xxx_osm_pci.o
  14876     561     548   15985    3e71 org/aic7xxx_osm.o
  12849     561     548   13958    3686 aic/aic7xxx_osm.o
  58959    5512       0   64471    fbd7 org/aic7xxx_core.o
  40907    5512       0   46419    b553 aic/aic7xxx_core.o
   3851      72       0    3923     f53 org/aic7xxx_93cx6.o
   1618      72       0    1690     69a aic/aic7xxx_93cx6.o
 110645   15013     548  126206   1ecfe org/aic7xxx.o
  83619   15013     548   99180   1836c aic/aic7xxx.o
  25762    6496       0   32258    7e02 org/aic79xx_reg_print.o
  25762    6496       0   32258    7e02 aic/aic79xx_reg_print.o
   3258       0       0    3258     cba org/aic79xx_proc.o
   2619       0       0    2619     a3b aic/aic79xx_proc.o
  10082     408      12   10502    2906 org/aic79xx_pci.o
   6145     408      12    6565    19a5 aic/aic79xx_pci.o
   1716    5416       0    7132    1bdc org/aic79xx_osm_pci.o
   1704    5416       0    7120    1bd0 aic/aic79xx_osm_pci.o
  18499     865     552   19916    4dcc org/aic79xx_osm.o
  16232     865     552   17649    44f1 aic/aic79xx_osm.o
 110391    4432       0  114823   1c087 org/aic79xx_core.o
  54314    4432       0   58746    e57a aic/aic79xx_core.o
 169715   17617     564  187896   2ddf8 org/aic79xx.o
 106784   17617     564  124965   1e825 aic/aic79xx.o

Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
