From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Thu, 24 Aug 2017 11:07:18 +0200
Message-ID: <20170824090718.GG19886@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-8-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48628 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbdHXJHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 05:07:19 -0400
Content-Disposition: inline
In-Reply-To: <20170823214009.15015-8-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

On Wed, Aug 23, 2017 at 02:39:57PM -0700, Bart Van Assche wrote:
> Only annotate pointers that are shared across threads with __rcu.
> Use rcu_dereference() when dereferencing an RCU pointer. Protect
> also the RCU pointer dereferences when freeing RCU pointers. This
> patch suppresses about twenty sparse complaints about the vpd_pg8[03]
> pointers.

Shouldn't the kfrees be kfree_rcu?  or where else is the rcu protection
for them?
