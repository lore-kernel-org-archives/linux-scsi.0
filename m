From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/7] cxlflash: Reorder user context initialization
Date: Mon, 7 Mar 2016 12:37:10 -0600
Message-ID: <E45FF842-056A-4FE3-864B-9BB1FD246F56@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1457128520-53056-5-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:48902 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbcCGShY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 13:37:24 -0500
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 7 Mar 2016 11:37:23 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id EC23319D8053
	for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2016 11:25:15 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u27IbKvj24838372
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2016 11:37:20 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u27IbGA2017494
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2016 11:37:19 -0700
In-Reply-To: <1457128520-53056-5-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

> On Mar 4, 2016, at 3:55 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> In order to support cxlflash in the PowerVM environment, underlying
> hypervisor APIs have imposed a kernel API ordering change.
> 
> For the superpipe access to LUN, user applications need a context.
> The cxlflash module creates this context by making a sequence of
> cxl calls. In the current code, a context is initialized via
> cxl_dev_context_init() followed by cxl_process_element(), a function
> that obtains the process element id. Finally, cxl_start_work()
> is called to attach the process element.
> 
> In the PowerVM environment, a process element id cannot be obtained
> from the hypervisor until the process element is attached. The
> cxlflash module is unable to create contexts without a valid
> process element id.
> 
> To fix this problem, cxl_start_work() is called before obtaining
> the process element id.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

