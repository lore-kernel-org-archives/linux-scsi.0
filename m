From: "John Stoffel" <john@stoffel.org>
Subject: Re: SCSI git trees
Date: Mon, 3 Aug 2009 13:52:29 -0400
Message-ID: <19063.9181.620137.814464@stoffel.org>
References: <1248887256.3900.78.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:57829 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZHCRwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 13:52:32 -0400
In-Reply-To: <1248887256.3900.78.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> It seems I got unsubscribed from linux-scsi last week while I was on
James> holiday and I've likely missed a slew of patches, it seems like an
James> appropriate time to remind everyone how the SCSI trees work.

James> ---

James> There are two git based scsi trees:

James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git

James> called the scsi-misc tree for patches being collected for the
James> next merge window.  And

I don't see my patch to block/Kconfig to make BLK_DEV_BSG be enabled
by default.  Is this going to be pushed for 2.6.32-rc1 when the merge
window opens up?  

I've attached the patch, just to make sure.  Let me know if I should
send it in properly.

Thanks!
John


Make Block Layer SG support v4 the default, since recent udev versions
depend on this to access serial numbers and other low level info
properly.

This should be backported to older kernels as well, since most distros
have
enabled this for a long time.

Signed-off-by: John Stoffel <john@stoffel.org>
---
 block/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index e7d1278..55bbefc 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -45,9 +45,9 @@ config LBD
          If unsure, say N.

 config BLK_DEV_BSG
-       bool "Block layer SG support v4 (EXPERIMENTAL)"
-       depends on EXPERIMENTAL
-       ---help---
+       bool "Block layer SG support v4"
+       default y
+       help
          Saying Y here will enable generic SG (SCSI generic) v4
	  support
          for any block device.

@@ -57,7 +57,10 @@ config BLK_DEV_BSG
          protocols (e.g. Task Management Functions and SMP in Serial
          Attached SCSI).

-         If unsure, say N.
+         This option is required by recent UDEV versions to properly
+         access device serial numbers, etc.
+
+         If unsure, say Y.

 config BLK_DEV_INTEGRITY
        bool "Block layer data integrity support"
-- 
