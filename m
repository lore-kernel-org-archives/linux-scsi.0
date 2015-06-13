From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [BUG ?] pmcraid: condition with no effect
Date: Sat, 13 Jun 2015 12:39:25 +0200
Message-ID: <1434191965-5780-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:60771 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbbFMKsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2015 06:48:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>


scanning for trivial bug-patters with coccinelle spatches returned:
./drivers/scsi/pmcraid.c:1603
        WARNING: condition with no effect (if branch == else)

introduced in 'commit c20c426732a5 ("[SCSI] pmcraid: MSI-X support and other changes")'

drivers/scsi/pmcraid.c - line numbers from 4.1-rc7
1603         if (fw_version <= PMCRAID_FW_VERSION_1)
1604                 hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;
1605         else            
1606                 hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;

As "hidden_entry = (cfg_entry->unique_flags1 & 0x80) != 0;" is probing the
bit the if condition simply looks unnecessary - if this "fix" would do is
not clear though without knowing details of the driver.

thx!
hofrat
