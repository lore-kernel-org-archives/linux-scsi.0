From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH 1/2] cxlflash: Verify problem state area is mapped before
 notifying shutdown
Date: Fri, 22 Jul 2016 13:26:40 +1000
Message-ID: <78e66b27-a98a-21b6-1d66-a06ab9c0bed4@au1.ibm.com>
References: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1469133844-8629-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46614 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbcGVD1R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 23:27:17 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6M3OVGi125111
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 23:27:16 -0400
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24akx7x9ap-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 23:27:16 -0400
Received: from localhost
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Fri, 22 Jul 2016 13:27:13 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 257173578057
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 13:27:12 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6M3RCZ222741242
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 13:27:12 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6M3RBg2026777
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2016 13:27:11 +1000
In-Reply-To: <1469133844-8629-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 22/07/16 06:44, Uma Krishnan wrote:
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

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited

