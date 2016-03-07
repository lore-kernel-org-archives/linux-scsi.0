From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/7] cxlflash: Fix to avoid unnecessary scan with internal LUNs
Date: Mon, 7 Mar 2016 12:45:04 -0600
Message-ID: <94EC3AB2-2DD8-4A2B-AB9E-7AF3E4D51EF7@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1457128520-53056-6-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57748 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcCGSpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 13:45:22 -0500
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 7 Mar 2016 11:45:21 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 6CF933E4004C
	for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2016 11:45:18 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u27IjIIp43909302
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2016 11:45:18 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u27IjD53011648
	for <linux-scsi@vger.kernel.org>; Mon, 7 Mar 2016 11:45:18 -0700
In-Reply-To: <1457128520-53056-6-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Mar 4, 2016, at 3:55 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
> 
> When switching to the internal LUN defined on the
> IBM CXL flash adapter, there is an unnecessary
> scan occurring on the second port. This scan leads
> to the following extra lines in the log:
> 
> Dec 17 10:09:00 tul83p1 kernel: [ 3708.561134] cxlflash 0008:00:00.0: cxlflash_queuecommand: (scp=c0000000fc1f0f00) 11/1/0/0 cdb=(A0000000-00000000-10000000-00000000)
> Dec 17 10:09:00 tul83p1 kernel: [ 3708.561147] process_cmd_err: cmd failed afu_rc=32 scsi_rc=0 fc_rc=0 afu_extra=0xE, scsi_extra=0x0, fc_extra=0x0
> 
> By definition, both of the internal LUNs are on the first port/channel.
> 
> When the lun_mode is switched to internal LUN the
> same value for host->max_channel is retained. This
> causes an unnecessary scan over the second port/channel.
> 
> This fix alters the host->max_channel to 0 (1 port), if internal
> LUNs are configured and switches it back to 1 (2 ports) while
> going back to external LUNs.
> 
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

