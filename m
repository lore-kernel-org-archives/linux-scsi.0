From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc 8.2.1 : Refactoring and addition of NPIV support
Date: Tue, 05 Jun 2007 15:21:42 -0400
Message-ID: <1181071302.23368.4.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53619 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760242AbXFETVU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2007 15:21:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@steeleye.com, hch@infradead.org

All,

For the past several months, Emulex has been updating our driver to support
the N_Port ID Virtualization (NPIV).  We have reached a maturity point
where we would like to move the NPIV support into our upstream driver.
The patches, as an RFC, were posted 5/1 for review:
    http://marc.info/?l=linux-scsi&m=117798737903334&w=2
This post formally requests inclusion of the NPIV modifications.

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

Beyond the original 3 patches above, posted in the RFC, this patch set
includes the following:

 - A rather large set of miscellaneous bug fixes found during further
   testing and qualification.

 - A patch to include support for the data buffer accessors. This is
   a rework of the original patch by Fujita Tomonori:
      http://marc.info/?l=linux-scsi&m=117896446832171&w=2

 - A patch to up the revision to 8.2.1

There are 6 patches in total.

Given that the patch sets are rather large, I have placed them on
our lpfc page on SourceForge. See:
https://sourceforge.net/project/showfiles.php?group_id=103050&package_id=188761&release_id=513811

The patches are labeled and numbered per the descriptions above. They
apply on top of the current lpfc driver in scsi-misc-2.6 (the 8.1.12 driver).
SourceForge also includes a final tarball of the resulting driver.

Thank You

-- james s




