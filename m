From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] cxlflash: Resolve oops in wait_port_offline
Date: Thu, 17 Dec 2015 16:30:23 -0600
Message-ID: <5673377F.5060304@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1449788074-23208-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42478 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933340AbbLQWaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2015 17:30:16 -0500
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 17 Dec 2015 15:30:15 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 2AE5A19D8051
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 15:18:16 -0700 (MST)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBHMUBpQ28901604
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 15:30:11 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBHMUAEx005799
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 15:30:11 -0700
In-Reply-To: <1449788074-23208-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

On 12/10/2015 4:54 PM, Uma Krishnan wrote:
> From: Manoj Kumar <manoj@linux.vnet.ibm.com>
>
> If an async error interrupt is generated, and the error requires the FC
> link to be reset, it cannot be performed in the interrupt context. So
> a work element is scheduled to complete the link reset in a process
> context. If either an EEH event or an escalation occurs in between
> when the interrupt is generated and the scheduled work is started, the
> MMIO space may no longer be available. This will cause an oops in the
> worker thread.
>
> [  606.806583] NIP kthread_data+0x28/0x40
> [  606.806633] LR wq_worker_sleeping+0x30/0x100
> [  606.806694] Call Trace:
> [  606.806721] 0x50 (unreliable)
> [  606.806796] wq_worker_sleeping+0x30/0x100
> [  606.806884] __schedule+0x69c/0x8a0
> [  606.806959] schedule+0x44/0xc0
> [  606.807034] do_exit+0x770/0xb90
> [  606.807109] die+0x300/0x460
> [  606.807185] bad_page_fault+0xd8/0x150
> [  606.807259] handle_page_fault+0x2c/0x30
> [  606.807338] wait_port_offline.constprop.12+0x60/0x130 [cxlflash]
>
> To prevent the problem space area from being unmapped, when there is
> pending work, a mapcount (using the kref mechanism) is held.  The mapcount
> is released only when the work is completed.  The last reference release
> is tied to the unmapping service.
>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> ---

Reviewed-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

