From: Denis Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/4] aic7xxx: remove excessive inlining
Date: Sun, 13 Aug 2006 14:57:21 +0200
Message-ID: <200608131457.21951.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:59046 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751162AbWHMM5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Aug 2006 08:57:31 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1425254nfc
        for <linux-scsi@vger.kernel.org>; Sun, 13 Aug 2006 05:57:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

This is a resend. I had these patches run-tested
at the time of first submission. Now I have no hardware
to test them. I think that they are still fine, though.

Basically, patches deinline some functions, mainly those
which perform port I/O. They shave off ~55k on AMD64:

# x86_64-pc-linux-gnu-size linux-2.6.17.8_64*/vmlinux
   text    data     bss     dec     hex filename
4632627 1222698  468392 6323717  607e05 linux-2.6.17.8_64/vmlinux
4571327 1223274  468392 6262993  5f90d1 linux-2.6.17.8_64aic/vmlinux

# x86_64-pc-linux-gnu-size linux-2.6.17.8_64*/drivers/scsi/aic7xxx/aic7*xx.o
   text    data     bss     dec     hex filename
 135543   13521     628  149692   248bc linux-2.6.17.8_64/drivers/scsi/aic7xxx/aic79xx.o
 103291   22289     560  126140   1ecbc linux-2.6.17.8_64/drivers/scsi/aic7xxx/aic7xxx.o
  90083   13521     628  104232   19728 linux-2.6.17.8_64aic/drivers/scsi/aic7xxx/aic79xx.o
  87231   22289     560  110080   1ae00 linux-2.6.17.8_64aic/drivers/scsi/aic7xxx/aic7xxx.o
--
vda
