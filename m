From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2] Separate target visibility from reaped state
 information
Date: Wed, 18 Nov 2015 16:37:46 -0800
Message-ID: <564D19DA.40006@sandisk.com>
References: <564A7261.7040403@sandisk.com>
 <1447741343.5417.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0069.outbound.protection.outlook.com ([157.56.111.69]:21318
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932461AbbKSAhu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Nov 2015 19:37:50 -0500
In-Reply-To: <1447741343.5417.7.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/16/2015 10:22 PM, James Bottomley wrote:
> OK, could you justify this, please ... like with traces and things.
> [ ... ]
> If that isn't the case, we can fix it, but I'd like to see the evidence.

Hello James,

To my own surprise so far I have not yet been able to trigger a lockup 
without this patch. After I had inserted an msleep() call at the start 
of scsi_target_reap_ref_release() to delay the starget->state = 
STARGET_DEL assignment I rebuilt and rebooted the kernel, started 
multipathd and held a SCSI device open by creating a filesystem on it 
and by mounting it. Next I removed all SRP targets (for p in 
/sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done). During this 
test no lockup was reported.

Bart.
