From: Alex Williamson <alex.williamson@hp.com>
Subject: mptscsih.c: discarded in section `.exit.text' from
	drivers/built-in.o
Date: Thu, 05 Feb 2004 12:53:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076010797.3744.84.camel@patsy.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:6364 "EHLO atlrel6.hp.com")
	by vger.kernel.org with ESMTP id S266640AbUBETxY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 14:53:24 -0500
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org


   The MPT Fusion driver seems to have developed a linker problem on
ia64.  The latest linux-2.5 bk tree gives me the following:

  LD      .tmp_vmlinux1
local symbol 0: discarded in section `.exit.text' from drivers/built-in.o
make: *** [.tmp_vmlinux1] Error 1

Running the reference discard checking tool:

$ ~/reference_discarded.pl 
Finding objects, 858 objects, ignoring 0 module(s)
Finding conglomerates, ignoring 81 conglomerate(s)
Scanning objects
Error: ./drivers/message/fusion/mptscsih.o .init.text refers to 00000000000001e2 PCREL21B          .exit.text
Done

And, sure enough, if I remove the __exits from mptscsih_exit() I get a
linkable kernel.  Looks like the __exits ought to be removed.  Thanks,

	Alex

-- 
Alex Williamson                             HP Linux & Open Source Lab

