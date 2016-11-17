From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/14] cxlflash: Fix crash in cxlflash_restore_luntable()
Date: Thu, 17 Nov 2016 13:20:41 -0600
Message-ID: <6591CF80-8879-406F-8F9A-D7182553AE04@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1479251642-22744-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.1 \(3251\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754311AbcKQTUt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 14:20:49 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAHJIwTf063854
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 14:20:49 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26sernmrtr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2016 14:20:48 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 17 Nov 2016 12:20:47 -0700
In-Reply-To: <1479251642-22744-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

> On Nov 15, 2016, at 5:14 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> During test, the following crash was observed:
> 
> [34538.981505] Faulting instruction address: 0xd000000007c9c870
> cpu 0x9: Vector: 300 (Data Access) at [c0000007f1e8f590]
>    pc: d000000007c9c870: cxlflash_restore_luntable+0x70/0x1d0 [cxlflash]
>    lr: d000000007c9c84c: cxlflash_restore_luntable+0x4c/0x1d0 [cxlflash]
>    sp: c0000007f1e8f810
>   msr: 9000000100009033
>   dar: c00000171d637438
> dsisr: 40000000
>  current = 0xc0000007f1e43f90
>  paca    = 0xc000000007b25100   softe: 0        irq_happened: 0x01
>    pid   = 493, comm = eehd
> enter ? for help
> [c0000007f1e8f8a0] d000000007c940b0 init_afu+0xd60/0x1200 [cxlflash]
> [c0000007f1e8f9a0] d000000007c945a8 cxlflash_pci_slot_reset+0x58/0xe0 [cxlflash]
> [c0000007f1e8fa20] d00000000715f790 cxl_pci_slot_reset+0x230/0x340 [cxl]
> [c0000007f1e8fae0] c000000000040dd4 eeh_report_reset+0x144/0x180
> [c0000007f1e8fb20] c00000000003f708 eeh_pe_dev_traverse+0x98/0x170
> [c0000007f1e8fbb0] c000000000041618 eeh_handle_normal_event+0x328/0x410
> [c0000007f1e8fc30] c000000000041db8 eeh_handle_event+0x178/0x330
> [c0000007f1e8fce0] c000000000042118 eeh_event_handler+0x1a8/0x1b0
> [c0000007f1e8fd80] c00000000011420c kthread+0xec/0x100
> [c0000007f1e8fe30] c00000000000a47c ret_from_kernel_thread+0x5c/0xe0
> 
> When superpipe mode is disabled for a LUN, the references for the
> local lun are deleted but the LUN is still identified as being present
> in the LUN table. This mismatched state can result in the above crash
> when the LUN table is restored during an error recovery operation.
> 
> To fix this issue, the local LUN information structure is updated to
> reflect the LUN is no longer in the LUN table once all references to
> the LUN are gone.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

