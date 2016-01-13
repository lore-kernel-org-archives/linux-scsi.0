From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
	function
Date: Wed, 13 Jan 2016 10:33:36 +0100
Message-ID: <20160113093336.GB14377@lst.de>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com> <1452458668-11034-2-git-send-email-nab@daterainc.com> <20160112151119.GD2058@lst.de> <1452672566.27508.44.camel@haakon3.risingtidesystems.com> <20160113081700.GB12642@lst.de> <1452676969.27508.60.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452676969.27508.60.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 01:22:49AM -0800, Nicholas A. Bellinger wrote:
> Huh..?  It's used by iscsi-target, ib_isert, tcm_qla2xxx, vhost-scsi and
> tcm_fc.
> 
> That's the majority of the drivers people care about.

ib_isert never calls transport_init_session / transport_init_session_tags
directly.

We've got 3 callers to transport_init_session_tags vs 6 to
transport_init_session.

iSCSI already works roughly the way I suggest everything should
work in the future - it uses transport_init_session but manually
allocates the tags.
