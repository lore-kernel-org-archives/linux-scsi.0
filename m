From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH v4 3/3] Rework handling of scsi_device.vpd_pg8[03]
Date: Wed, 30 Aug 2017 00:07:50 +0000
Message-ID: <AT5PR84MB030881A42C6EE81C293CC1A1FD9C0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170829155013.11124-1-bart.vanassche@wdc.com>
 <20170829155013.11124-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2352.austin.hpe.com ([15.233.44.25]:32922 "EHLO
        g2t2352.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdH3AHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 20:07:54 -0400
In-Reply-To: <20170829155013.11124-4-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

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
> Acked-by: Hannes Reinecke <hare@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/scsi.c        | 44 ++++++++++++++++++--------------------------
>  drivers/scsi/scsi_lib.c    | 16 ++++++++--------
>  drivers/scsi/scsi_sysfs.c  | 29 ++++++++++++++++++++---------
>  include/scsi/scsi_device.h | 18 ++++++++++++++----
>  4 files changed, 60 insertions(+), 47 deletions(-)

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
