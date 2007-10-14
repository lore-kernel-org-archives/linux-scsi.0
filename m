From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Sun, 14 Oct 2007 15:58:26 +0100
Message-ID: <200710141558.27156.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:46945 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbXJNO6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 10:58:40 -0400
Received: by ug-out-1314.google.com with SMTP id z38so778365ugc
        for <linux-scsi@vger.kernel.org>; Sun, 14 Oct 2007 07:58:38 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

Following patches debloat drivers/scsi/aic7xxx/*.
I also had to add prototypes for ahc_lookup_scb
and ahd_lookup_scb to .h files.

1-debloat.patch
Deinlines and moves big functions from .h to .c files.
Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.

2-addstatic.patch
Adds statics, #ifdefs out huge amount of unused code, adds consts

3-addconst.patch
Adds more consts

Driver code/data size reductions:

Build with debugging on (CONFIG_AIC7XXX_DEBUG_ENABLE=y):
   text    data     bss     dec     hex filename
 310865   49922    1204  361991   58607 linux-2.6.23.t/drivers/scsi/aic7xxx/built-in.o
 221987    2754    1204  225945   37299 linux-2.6.23-aic-3-addconst.t/drivers/scsi/aic7xxx/built-in.o

With debugging off:
   text    data     bss     dec     hex filename
 298896   42754    1172  342822   53b26 linux-2.6.23.tt/drivers/scsi/aic7xxx/built-in.o
 216068    2754    1172  219994   35b5a linux-2.6.23-aic-3-addconst.tt/drivers/scsi/aic7xxx/built-in.o

make namespacecheck goes from 400+ functions to:
  drivers/scsi/aic7xxx/aic79xx_core.o
    ahd_inq
    ahd_inw
    ahd_outq
    ahd_outw
  drivers/scsi/aic7xxx/aic79xx_osm.o
    ahd_insb
  drivers/scsi/aic7xxx/aic7xxx_core.o
    ahc_inq
    ahc_outq
  drivers/scsi/aic7xxx/aic7xxx_osm.o
    ahc_insb

None of these patches touch any logic, code changes are pretty minimal.

Compile tested and applies cleanly to 2.6.23.
I don't have this hardware anymore and cannot run test these patches.

Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
