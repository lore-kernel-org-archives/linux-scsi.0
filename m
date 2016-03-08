From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/7] cxlflash: Fix to avoid unnecessary scan with internal
 LUNs
Date: Tue, 8 Mar 2016 11:56:04 -0600
Message-ID: <56DF1234.603@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-6-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50053 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbcCHR4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 12:56:08 -0500
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Tue, 8 Mar 2016 10:56:07 -0700
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id E0E8619D8048
	for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2016 10:44:00 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u28Hu5K645809888
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2016 10:56:05 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u28Hu3Md024881
	for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2016 10:56:04 -0700
In-Reply-To: <1457128520-53056-6-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 3/4/2016 3:55 PM, Uma Krishnan wrote:
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

Reviewed-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

