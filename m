From: "goggin, edward" <egoggin@emc.com>
Subject: Should multipath detect changed path UIDs?
Date: Wed, 26 Jan 2005 16:49:07 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A71B@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:28026 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S262466AbVAZVtL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2005 16:49:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'dm-devel@redhat.com', "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'christophe varoqui' <christophe.varoqui@free.fr>

Simply pulling two FC cables from a host and re-cabling incorrectly
(think a switch of two HBA cables) or a surprise reconfiguration of a
storage system target could lead to a situation where the potential for
data corruption is ripe.  While it may not be reasonably possible to
prevent data corruption in this scenario (think I/O already queued to
target devices underneath the multipath target driver), the prudent
course of action may be to try to prevent data corruption whenever
the potential is discovered using reasonable means.

Besides such pilot error as described above, the pre-requisites for
the cable switch scenario include at least (1) having the cable disconnect
and subsequent re-connect events occur while no user or path checker
initiated I/O occurs to paths using the switched cables and (2) the
target-side connectivity for the two cables is asymmetrical.

Possible solutions could involve (1) detecting fiber channel disconnect
hotplug events and acting upon them or (2) modifying multipath checker
functions to verify a path's UID remains consistent in addition to verifying
path connectivity.

EMC's multipathing product PowerPath uses the latter approach for
testing paths to SCSI logical units on both Symmetrix and CLARiion
storage systems.  Although using a single I/O for path testing may not
be possible for many storage systems, the PowerPath checker function
for both Symmetrix and CLARiion storage determines the UID for the
SCSI logical unit from reply (or sense) information returned by a single
test I/O and fails a path if the UID is not consistent.
