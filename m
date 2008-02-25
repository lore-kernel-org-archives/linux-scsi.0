From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7246] 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 25 Feb 2008 11:54:03 -0800 (PST)
Message-ID: <20080225195403.0595D108094@picon.linux-foundation.org>
References: <bug-7246-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbYBYTyg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:54:36 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1PJs3lH011999
	for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2008 11:54:04 -0800
In-Reply-To: <bug-7246-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7246


aradford@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aradford@gmail.com




------- Comment #13 from aradford@gmail.com  2008-02-25 11:54 -------
Javier,

The final issue you are talking about (different from original issue in this
bugzilla entry):

The 3w-xxxx driver calling pci_map_sg() with sc_data_direction ==
DMA_BIDIRECTIONAL caused data corruption when going through swiotlb.c, on EM64T
with 4GB or higher of RAM.  AMD64 systems using IOMMU were never affected.

This problem doesn't exist in the 3w-xxxx driver in kernels 2.6.23 and higher.
The reason is the 'scsi data buffer accessors' patches removed most instances 
of scsi drivers calling pci_map_sg() and replaced them with scsi_dma_map().

This corrected the problem of the 3w-xxxx driver over-riding the default
sc_data_direction that was causing data corruption with EM64T systems with 
4GB+ RAM.

If you need a driver update for an older kernel to fix this issue, please go to
www.3ware.com, however no driver patch to 3w-xxxx needs to be sent to the
kernel tree to fix this issue.

Please close this BUG.

-Adam Radford


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
