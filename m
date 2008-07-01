From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/3] aic7xxx: debloat
Date: Tue, 1 Jul 2008 18:48:22 +0200
Message-ID: <200807011848.22599.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:55522 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYGAOsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 10:48:09 -0400
Received: by gv-out-0910.google.com with SMTP id e6so261807gvc.37
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jul 2008 07:48:06 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Hi Hannes,

aic7xxx still contains ~30kb of dead code if pretty printing of registers
is requested. These patches deal with it.

I did not get any feedback from you whether the approach of adding
"dont_generate_debug_code" marker would be acceptable despite
asking twice. I decided that it's a "Yes".

The patches are compile tested on linux-2.6.26-rc8 and apply cleanly to
current scsi-misc.

Size differences:

   text    data     bss     dec     hex filename
DEBUG_ENABLE+PRETTY_PRINT:
 234697    2362    1188  238247   3a2a7 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 205092    2362    1188  208642   32f02 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
NO_DEBUG_ENABLE+PRETTY_PRINT:
 227272    2362    1172  230806   38596 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 197671    2362    1172  201205   311f5 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
DEBUG_ENABLE+NO_PRETTY_PRINT:
 192457    2362    1188  196007   2fda7 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 192457    2362    1188  196007   2fda7 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
NO_DEBUG_ENABLE+NO_PRETTY_PRINT:
 185040    2362    1172  188574   2e09e linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 185040    2362    1172  188574   2e09e linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o

Please apply to scsi-misc.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
