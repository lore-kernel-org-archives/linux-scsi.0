From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements
 of ->host_failed
Date: Wed, 01 Jun 2016 10:06:11 -0400
Message-ID: <1464789971.23285.1.camel@linux.vnet.ibm.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:46988 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328AbcFAOGn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 10:06:43 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 08:06:41 -0600
In-Reply-To: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, tj@kernel.org, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, 2016-05-31 at 16:38 +0800, Wei Fang wrote:
> sas_ata_strategy_handler() adds the works of the ata error handler
> to system_unbound_wq. This workqueue asynchronously runs work items,
> so the ata error handler will be performed concurrently on different
> CPUs. In this case, ->host_failed will be decreased simultaneously in
> scsi_eh_finish_cmd() on different CPUs, and become abnormal.
> 
> It will lead to permanently inequal between ->host_failed and
>  ->host_busy, and scsi error handler thread won't become running.
> IO errors after that won't be handled forever.
> 
> Use atomic type for ->host_failed to fix this race.

As I said previously, you don't need atomics to do this, could you just
remove the decrement in scsi_eh_finish_command() and zero the counter
after the strategy handler completes.

Thanks,

James


