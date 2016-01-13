From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
 function
Date: Wed, 13 Jan 2016 02:14:21 -0800
Message-ID: <1452680061.27508.93.camel@haakon3.risingtidesystems.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
	 <1452458668-11034-2-git-send-email-nab@daterainc.com>
	 <20160112151119.GD2058@lst.de>
	 <1452672566.27508.44.camel@haakon3.risingtidesystems.com>
	 <20160113081700.GB12642@lst.de>
	 <1452676969.27508.60.camel@haakon3.risingtidesystems.com>
	 <20160113093336.GB14377@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160113093336.GB14377@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 10:33 +0100, Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 01:22:49AM -0800, Nicholas A. Bellinger wrote:
> > Huh..?  It's used by iscsi-target, ib_isert, tcm_qla2xxx, vhost-scsi and
> > tcm_fc.
> > 
> > That's the majority of the drivers people care about.
> 
> ib_isert never calls transport_init_session / transport_init_session_tags
> directly.
> 

Yes.

Not to mention, there is a new struct iscsit_transport based driver on
the way that assumes percpu-ida tag preallocation using this same
method.

> We've got 3 callers to transport_init_session_tags vs 6 to
> transport_init_session.
> 

In that case, I'll look into converting sbp-target, usb-gadget and
xen-scsiback to use percpu-ida like the other consumers here for v4.6
code. 

> iSCSI already works roughly the way I suggest everything should
> work in the future - it uses transport_init_session but manually
> allocates the tags.

iscsi-target needs it open-coded for discovery purposes, because
se_node_acl lookup does not occur.

However for the normal session login se_node_acl lookup back, I don't
see a reason why iscsi-target can't use target_alloc_session() here too.
