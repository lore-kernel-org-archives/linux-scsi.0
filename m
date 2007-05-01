From: James Smart <James.Smart@Emulex.Com>
Subject: [RFC] lpfc 8.2.0 : Refactoring and addition of NPIV support
Date: Mon, 30 Apr 2007 22:42:40 -0400
Message-ID: <1177987360.28585.32.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34148 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbXEACmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 22:42:47 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l412gjLU007643
	for <linux-scsi@vger.kernel.org>; Mon, 30 Apr 2007 19:42:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

All,

For the past several months, Emulex has been updating our driver to support
the N_Port ID Virtualization (NPIV).  We have reached a maturity point
where we would like to move the NPIV support into our upstream driver.
This is a request to review the modifications we have made for NPIV.

NPIV is a mechanism by which a FC port can acquire more than 1 Address
on a FC fabric. Using this mechanism, virtual FC ports can be instantiated
on the same physical Port. Each NPIV instance is a unique WWPN and
N_Port ID on the fabric. For all intents, it is another hba on the fabric.
Each instance has its own view of what is present on the fabric, each has
its own discovery engine, and each NPIV instances has a separate and unique
login context with each remote port.

In order to support NPIV, there were 3 major blocks of changes made to
the driver:
 - First, the driver is reorganized to separate the handling of the 
   adapter from the handling of the FC port. Adapter handling includes
   submissions of command requests, receiving responses, and managing
   adapter resources.  The FC port includes the discovery engine, login
   handling, and the mapping of a Scsi_Host on the "port".  Although
   not a large functional change, as it touches core structures and
   functions, resulting in a large text delta.

 - Second, NPIV support is only available via new adapter interface
   extensions, termed SLI-3. This interface changes some of the basic
   behaviors such as command and response ring element sizes and data
   structures, as well as a change in buffer posting.  Note: the new
   firmware extensions are found only on our mid-range and enterprise
   4Gig adapters - so NPIV support is available only on these newer
   adapters. The latest firmware can be downloaded from the Emulex
   support page. 

 - Lastly, NPIV support is added to the driver.  It utilizes the
   interfaces of the fc transport for the creation and deletion of
   vports. Within the driver, a new Scsi_Host is created for each
   NPIV instance, and is paired with a new instance of a FC port.
   This allows N FC Port elements to share a single Adapter.

Given that the patch sets are rather large, I have placed them on
our lpfc page on SourceForge. See:
https://sourceforge.net/project/showfiles.php?group_id=103050&package_id=188761&release_id=504988
We have also taken this opportunity to address some of the long-standing
methods that are suboptimal, but have been in the driver forever.

The patches are labeled and numbered per the descriptions above. They
apply on top of the recent 8.1.12 driver.  I have also included a
final tarball of the resulting driver, which we have renumbered to
8.2.0.

We appreciate any feedback on the patch sets.

-- james s



