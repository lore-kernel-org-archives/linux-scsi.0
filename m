From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Wed, 13 May 2015 08:48:17 +0200
Message-ID: <20150513064817.GA22079@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com> <20150513054646.GA20825@lst.de> <1431498012.26897.61.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431498012.26897.61.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2015 at 11:20:12PM -0700, Nicholas A. Bellinger wrote:
> Ugh, yes.  Fixing up clear_lun_from_tpg + free_device_list_for_node to
> use a common caller acquiring se_node_acl->lun_entry_mutex during
> se_dev_entry release.
> 
> Fixing up target_fabric_mappedlun_unlink() as well.

Good prep for that one might be:

http://git.infradead.org/users/hch/scsi.git/commitdiff/111b30a2430c8af492d8e67d18658f60313ad3be

and 

http://git.infradead.org/users/hch/scsi.git/commitdiff/054d9e0cc048f664cde5b13d34742c61ee535a04

> > The case where we have an original one is the demo mode -> explicit
> > change.  So I don't think we actually need the newly allocate dev
> > entry here.  Just change lun_flags like in core_update_device_list_access
> > and do an rcu_assign_pointer for the lun ACLs.
> 
> Will take a look at this.

FYI, this was my idea how to handle the transition from generate
to explicit ACLs:

http://git.infradead.org/users/hch/scsi.git/commitdiff/e3438480c0eaa020d1ad55ec1a0be88f05ae8372

I don't think it's quite correct, though as we need to update ->lun_flags
in the transition case as well.
