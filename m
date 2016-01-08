From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] target: Remove useless
	set_initiator_node_queue_depth acl lookup
Date: Fri, 8 Jan 2016 09:17:12 +0100
Message-ID: <20160108081712.GB32138@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452237348-2277-3-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 07:15:46AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> With the changes in place to obtain se_node_acl->acl_kref
> from within core_tpg_del_initiator_node_acl() and auditing
> existing users, it's clear there is no need to perform the
> lookup during core_tpg_set_initiator_node_queue_depth().
> 
> This is because se_node_acl->acl_group is already protecting
> the se_node_acl reference via configfs, and ->acl_group
> shutdown in core_tpg_del_initiator_node_acl() can't occur
> until core_tpg_set_initiator_node_queue_depth() completes.
> 
> Also, remove a related pointless wrapper in iscsi-target.

While we're at it, can you please remove the always true
force argument from core_tpg_set_initiator_node_queue_depth and rename
the funcion to something like target_set_initiator_node_queue_depth.

Btw, what's the use case for modifying this on a 'live' session that
gets shutdown for that purpose?  The whole algorithm looks somewhat
fishy to me to be honest.
