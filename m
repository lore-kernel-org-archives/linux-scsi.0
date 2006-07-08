From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: aic94xx status
Date: Sat, 08 Jul 2006 11:27:47 -0500
Message-ID: <1152376067.12020.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:46245 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964888AbWGHQ1t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 12:27:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

The current status is this:

The biggest problem I've been pursuing all week was the hangs and
softlockups on driver insertion.  This actually turns out to be all
caused by the generic timer code and have nothing to do with the actual
aic94xx (the pitfalls of working in Linus' git head, I'm afraid).

The only two remaining serious issues I can now find that need to be
fixed before it can go into scsi-misc are:

1) SATA support.  We at least need this stubbed out so seeing a SATA
device won't cause nasty things to happen (IBM is working on this).
Ideally, we need to integrate this driver with Brian King's SATA/SAS
code, but no-one who has this board has a sata device and vice versa.

2) Error handling.  I seem to have a somewhat flakey connection on my
SAS cage that seems to cause intermittent transport errors.  The current
behaviour is for this driver to find the transport problem, clear the
nexus and then complete the command (i.e. fail it).  So if this happens
at boot time in the initial INQUIRY (and it does for me about 25% of the
time) it never brings up my root disk, so the box panics.  The error
handler needs to be taught to retry the commands for transport failures.
(I can look into doing this unless there are ready volunteers).

3) The wide port formation and deformation issues, which I've described
in a separate email.

Other than this, most of the remaining work is code refactoring, which I
think can be done in-tree, unless anyone else has critical issues to add
to the list.

James


