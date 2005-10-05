From: Andi Kleen <ak@suse.de>
Subject: Removing BROKEN scsi drivers
Date: Wed, 5 Oct 2005 13:14:32 +0200
Message-ID: <200510051314.33411.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:15302 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932605AbVJELOP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 07:14:15 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 2A7861CC32
	for <linux-scsi@vger.kernel.org>; Wed,  5 Oct 2005 13:14:14 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In 2.6.14rc3:

linux/drivers/scsi> grep -c BROKEN Kconfig
11

There are a lot of SCSI drivers who have been marked BROKEN forever. Or at 
least for all of 2.6 and one would expect if there are users left they would 
have fixed them by now. Would it make sense to remove them?

In particular:

SCSI_ADVANSYS - vendor went out of market afaik. Probably not many left.
SCSI_CPQFCTS - suboption of another driver, incredibly ugly code defying all 
coding standards.
SCSI_EATA_PIO - really old ISA cards. Probably all left over cards are way 
over their MTBF by now.
SCSI_SEAGATE - extremly scary code, i doubt there is any such card left
SCSI_MCA_53C9X - BROKEN_ON_SMP only. Ok I guess there are no SMP
Micro Channel systems.
SCSI_QLOGIC_ISP - afaik there is a newer driver for this
SCSI_AMIGA7XX - no maintainer, broken forever
ATARI_SCSI - no maintainer, broken forever
MVME16x_SCSI - no maintainer, broken forever
BVME6000_SCSI - same
SUN3_SCSI - sun3 never worked in mainline anyways

I think they could all go except perhaps the MCA driver. Or at least added
to Documentation/feature-removal-schedule.txt and then removed in a few 
months.

-Andi 
