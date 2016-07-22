From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cxlflash: Verify problem state area is mapped before notifying shutdown
Date: Fri, 22 Jul 2016 10:36:18 -0500
Message-ID: <4981EA58-75C0-4757-9B4E-E63F0476A31A@linux.vnet.ibm.com>
References: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1469133844-8629-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47383 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbcGVPg1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2016 11:36:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6MFYGaH017376
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 11:36:26 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24bhv2a9fb-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 11:36:26 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 22 Jul 2016 11:36:25 -0400
In-Reply-To: <1469133844-8629-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jul 21, 2016, at 3:44 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> If an EEH or some other hard error occurs while the
> adapter instance was being initialized, on the subsequent
> shutdown of the device, the system could crash with:
> 
> [c000000f1da03b60] c0000000005eccfc pci_device_shutdown+0x6c/0x100
> [c000000f1da03ba0] c0000000006d67d4 device_shutdown+0x1b4/0x2c0
> [c000000f1da03c40] c0000000000ea30c kernel_restart_prepare+0x5c/0x80
> [c000000f1da03c70] c0000000000ea48c kernel_restart+0x2c/0xc0
> [c000000f1da03ce0] c0000000000ea970 SyS_reboot+0x1c0/0x2d0
> [c000000f1da03e30] c000000000009204 system_call+0x38/0xb4
> 
> This crash is due to the AFU not being mapped when the shutdown
> notification routine is called and is a regression that was inserted
> recently with Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support
> for CXL Flash cards").
> 
> As a fix, shutdown notification should only occur when the AFU is mapped.
> 
> Fixes: 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL Flash cards")
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

