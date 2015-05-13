From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/12] target/pr: Convert se_dev_entry to kref for RCU
Date: Wed, 13 May 2015 07:59:45 +0200
Message-ID: <20150513055945.GE20825@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-7-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431422736-29125-7-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2015 at 09:25:30AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts se_dev_entry->pr_ref_count access to use modern
> struct kref counting.
> 
> It updates core_enable_device_list_for_node() to kref_init() when se_dev_entry
> is being enabled, and updates core_disable_device_list_for_node() to kref_put()
> and blocks on ->pr_comp waiting for outstanding PR references to drop.
> 
> Also, go ahead and convert core_get_se_deve_from_rtpi() code to use pr_kref
> for RELATIVE TARGET PORT IDENTIFIER lookup.

This seems to be two very different things.  Once a fix up of the
->se_deve access in the PR code, and second changing the way the references
work.

The kref change looks fine to me as a standalone patch.

The RCU lookup changes really need to be squashed into the others,
for one thing before this patch the PR code still tries to use
->device_list which isn't even maintained any more.

It might be a good idea to grab these three patches from my older series
and add them before your actual RCU changes to simplify the PR code
in preparation of the RCU changes:

http://git.infradead.org/users/hch/scsi.git/commitdiff/e9a71bda1a120e0488c5c4e4b2f17f14333e2dc6
http://git.infradead.org/users/hch/scsi.git/commitdiff/6372d9f62c83acb30d051387c40deb4dbdcaa376
http://git.infradead.org/users/hch/scsi.git/commitdiff/1c52408094cb831ee3c791b71ef631b9c5609d35
