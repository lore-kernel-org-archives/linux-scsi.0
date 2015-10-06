From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v5 33/34] cxlflash: Fix to avoid leaving dangling interrupt
 resources
Date: Tue, 06 Oct 2015 14:43:01 +1100
Message-ID: <56134345.5070202@au1.ibm.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443715127-25776-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38647 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbJFDnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2015 23:43:40 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Tue, 6 Oct 2015 13:43:36 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 3C6882BB004D
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2015 14:43:33 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t963hQ4W25952268
	for <linux-scsi@vger.kernel.org>; Tue, 6 Oct 2015 14:43:34 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t963gxQj017894
	for <linux-scsi@vger.kernel.org>; Tue, 6 Oct 2015 14:43:01 +1100
In-Reply-To: <1443715127-25776-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org

On 02/10/15 01:58, Matthew R. Ochs wrote:
> When running with an unsupported AFU, the cxlflash driver fails
> the probe. When the driver is removed, the following Oops is
> encountered on a show_interrupts() thread:
>
> Call Trace:
> [c000001fba5a7a10] [0000000000000003] 0x3 (unreliable)
> [c000001fba5a7a60] [c00000000053dcf4] vsnprintf+0x204/0x4c0
> [c000001fba5a7ae0] [c00000000030045c] seq_vprintf+0x5c/0xd0
> [c000001fba5a7b20] [c00000000030051c] seq_printf+0x4c/0x60
> [c000001fba5a7b50] [c00000000013e140] show_interrupts+0x370/0x4f0
> [c000001fba5a7c10] [c0000000002ff898] seq_read+0xe8/0x530
> [c000001fba5a7ca0] [c00000000035d5c0] proc_reg_read+0xb0/0x110
> [c000001fba5a7cf0] [c0000000002ca74c] __vfs_read+0x6c/0x180
> [c000001fba5a7d90] [c0000000002cb464] vfs_read+0xa4/0x1c0
> [c000001fba5a7de0] [c0000000002cc51c] SyS_read+0x6c/0x110
> [c000001fba5a7e30] [c000000000009204] system_call+0x38/0xb4
>
> The Oops is due to not cleaning up correctly on the unsupported
> AFU error path, leaving various allocated and registered resources.
> In this case, interrupts are in a semi-allocated/registered state,
> which the show_interrupts() thread attempts to use.
>
> To fix, the cleanup logic in init_afu() is consolidated to error
> gates at the bottom of the function and the appropriate goto is
> added to each error path. As a mini side fix while refactoring
> in this routine, the else statement following the AFU version
> evaluation is eliminated as it is not needed.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

