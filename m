From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] cxlflash: Simplify PCI registration
Date: Mon, 7 Mar 2016 12:30:01 -0600
Message-ID: <00C55C63-2A27-4F3D-AECB-B5D677BE90B5@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:40129 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbcCGSaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 13:30:16 -0500
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 7 Mar 2016 11:30:15 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id EBA5DC40003
	for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2016 11:18:21 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u27IUC4523199860
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2016 11:30:12 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u27IU5Tk029039
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2016 11:30:11 -0700
In-Reply-To: <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Mar 4, 2016, at 3:55 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
> 
> The calls to pci_request_regions(), pci_resource_start(),
> pci_set_dma_mask(), pci_set_master() and pci_save_state() are all
> unnecessary for the IBM CXL flash adapter since data buffers
> are not required to be mapped to the device's memory.
> 
> The use of services such as pci_set_dma_mask() are problematic on
> hypervisor managed systems as the IBM CXL flash adapter is operating
> under a virtual PCI Host Bridge (virtual PHB) which does not support
> these services.
> 
> cxlflash 0001:00:00.0: init_pci: Failed to set PCI DMA mask rc=-5
> 
> The resolution is to simplify init_pci(), to a point where it does the
> bare minimum (pci_enable_device). Similarly, remove the call the
> pci_release_regions() from cxlflash_remove().
> 
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

