From: Larry Keegan <lk@pfw.demon.co.uk>
Subject: mpt2sas and HP Ultrium 1840 SAS LTO4 sporadic EBUSY
Date: Wed, 19 Feb 2014 20:43:46 +0000
Message-ID: <20140219204346.0de63d05@cs3.al.itld>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfw.demon.co.uk ([62.49.22.168]:60952 "EHLO pfw.demon.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaBSUxL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Feb 2014 15:53:11 -0500
Received: from fs6.al.itld (fs6.al.itld [10.1.1.175])
	by pfw.demon.co.uk (Postfix) with ESMTP id E83E84F
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2014 20:43:47 +0000 (UTC)
Received: from cs3.al.itld (cs3.al.itld [10.1.1.139])
	by fs6.al.itld (Postfix) with ESMTP id E5693230
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2014 20:43:46 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear fellow SASers,

I wonder if I might pick your brains. I have an HP Storageworks
Ultrium 1840 SAS tape drive and an LSI SAS9211-4i PCI Express SAS HBA
which are behaving temperamentally. The SAS card uses the mpt2sas
driver. There are no other devices connected to the SAS controller.

After power-on the drive works swimmingly with dd, happily writing
several GB of data before unpredictably aborting the write with EBUSY.
All subsequent writes with dd return EBUSY yet mt operates just fine.
Re-loading the tape or resetting the SAS bus with LSI's SAS2Flash
utility make no difference.

Rebooting clears the fault. The fault may clear itself if I wait
anything from a few seconds to many minutes. Bizarrely sometimes it
clears if I 'echo some_value > /proc/sys/dev/scsi/logging_level',
although this only works a dozen or so times before it becomes
ineffective.

I'm using a plain-vanilla 3.10.28 kernel and the latest versions of the
SAS card's BIOS (7.35.00.00) and firmware (18.00.00.00). I note that
in 2010 HP claimed the tape drive won't work with many Linux SAS HBAs
because their drivers were not reliable:

http://h20566.www2.hp.com/portal/site/hpsc/template.PAGE/public/psi/advisoriesDisplay/?javax.portlet.begCacheTok=com.vignette.cachetoken&javax.portlet.endCacheTok=com.vignette.cachetoken&javax.portlet.prp_efb5c0793523e51970c8fa22b053ce01=wsrp-navigationalState%3DdocId%253Demr_na-c02236321-1%257CdocLocale%253Den_US&javax.portlet.tpst=efb5c0793523e51970c8fa22b053ce01&sp4ts.oid=4227371&ac.admitted=1391170950929.876444892.199480143

but I figure things have changed since then. Does anyone have any
suggestions for debugging this problem?

Yours,

Larry.
