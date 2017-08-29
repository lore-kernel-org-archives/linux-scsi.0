From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/3] Rework handling of scsi_device.vpd_pg8[03]
Date: Tue, 29 Aug 2017 08:33:03 +0200
Message-ID: <baef55b5-1423-6298-df0b-360234b4ad88@suse.de>
References: <20170828204149.28693-1-bart.vanassche@wdc.com>
 <20170828204149.28693-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39361 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750822AbdH2GdF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 02:33:05 -0400
In-Reply-To: <20170828204149.28693-3-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

On 08/28/2017 10:41 PM, Bart Van Assche wrote:
> Introduce struct scsi_vpd for the VPD page length, data and the
> RCU head that will be used to free the VPD data. Use kfree_rcu()
> instead of kfree() to free VPD data. Move the VPD buffer pointer
> check inside the RCU read lock in the sysfs code. Only annotate
> pointers that are shared across threads with __rcu. Use
> rcu_dereference() when dereferencing an RCU pointer. This patch
> suppresses about twenty sparse complaints about the vpd_pg8[03]
> pointers. This patch also fixes a race condition, namely that
> updating of the VPD pointers and length variables in struct
> scsi_device was not atomic with reference to the code reading
> these variables. See also "Does the update code tolerate concurrent
> accesses?" in Documentation/RCU/checklist.txt.
> 
> Fixes: commit 09e2b0b14690 ("scsi: rescan VPD attributes")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/scsi.c        | 44 ++++++++++++++++++--------------------------
>  drivers/scsi/scsi_lib.c    | 16 ++++++++--------
>  drivers/scsi/scsi_sysfs.c  | 29 ++++++++++++++++++++---------
>  include/scsi/scsi_device.h | 18 ++++++++++++++----
>  4 files changed, 60 insertions(+), 47 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
