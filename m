From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12222] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Mon, 15 Dec 2008 13:40:07 -0800 (PST)
Message-ID: <20081215214007.0C058108041@picon.linux-foundation.org>
References: <bug-12222-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbYLOVkJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 16:40:09 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBFLe7QB029303
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 13:40:08 -0800
In-Reply-To: <bug-12222-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12222





------- Comment #4 from grundler@parisc-linux.org  2008-12-15 13:40 -------
In 2.6.28-rc8 kernel, the BUG_ON is now at line 1276.
The BUG_ON is just indicating the IOMMU page table entry is already (or still)
in use.

My guess is either the IOMMU space allocator is buggy *OR* the unmap code isn't
clearing dma_pte_addr() (off by one?). Perhaps there needs to be a wmb() in
intel_unmap_sg() between dma_pte_clear_range() and the later __free_iova()
call.

intel_iommu=off means no IOMMU will be used. For normal workloads with modern
PCIe devices (which are all 64-bit, right?), there would be no perf impact. Not
until you wanted to get better isolation for virtual guest OSs or used a device
driver that only offers 32-bit DMA support, will it matter.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
