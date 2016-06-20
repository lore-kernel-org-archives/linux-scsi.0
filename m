From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] cxlflash: Fix to drain operations from previous reset
Date: Mon, 20 Jun 2016 08:47:09 -0500
Message-ID: <E601E96F-4C2F-48EF-BDFF-689114A05285@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1466034560-17864-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13597 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288AbcFTNrl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 09:47:41 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5KDi9sE020408
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2016 09:47:16 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23n1kum0ft-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2016 09:47:16 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 20 Jun 2016 07:47:15 -0600
In-Reply-To: <1466034560-17864-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 15, 2016, at 6:49 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
> 
> While running 'sg_reset -H' in a loop with a user-space application active,
> hit the following exception:
> 
> cpu 0x2: Vector: 300 (Data Access)
>    pc: : afu_attach+0x50/0x240 [cxlflash]
>    lr: : cxlflash_afu_recover+0x3dc/0x7d0 [cxlflash]
>    pid   = 20365, comm = run_block_fvt
> 
> Linux version 4.5.0-491-26f710d+
> 
> cxlflash_afu_recover+0x3dc/0x7d0 [cxlflash]
> cxlflash_ioctl+0x5a8/0x6f0 [cxlflash]
> scsi_ioctl+0x3b0/0x4c0
> sd_ioctl+0x110/0x190
> blkdev_ioctl+0x28c/0xc20
> block_ioctl+0xa4/0xd0
> do_vfs_ioctl+0xd8/0x8c0
> SyS_ioctl+0xd4/0xf0
> system_call+0x38/0xb4
> 
> The problem here is that the problem space area is unmapped while the
> application issues the DK_CXLFLASH_RECOVER_AFU ioctl.
> 
> This is the order I observe:
> 
> proc1				proc2
> 1) sg_reset
> 				2) ioctl(DK_CXLFLASH_RECOVER_AFU)
> 3) sg_reset again
>   causing a PSA unmap
> 				4) continues RECOVER_AFU processing
> 
> The resolution to this problem is to have the reset handler drain all
> outstanding user space initiated ioctls before proceeding.  It is safe
> to drain after the state has been changed to STATE_RESET. Also since
> drain_ioctls() was static, it had to be moved up a bit to be before
> cxlflash_eh_host_reset_handler().
> 
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

