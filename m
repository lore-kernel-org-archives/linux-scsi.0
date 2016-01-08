From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Fri, 8 Jan 2016 09:35:47 +0100
Message-ID: <20160108083547.GA32501@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-2-git-send-email-nab@daterainc.com> <20160108081412.GA32138@lst.de> <568F73D2.2090808@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <568F73D2.2090808@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 09:31:14AM +0100, Bart Van Assche wrote:
> Indeed. All error paths in all target drivers will have to be modified to 
> avoid that an acl reference leak is triggered if transport_init_session() 
> fails after core_tpg_check_initiator_node_acl() succeeded.

I'm still hoping for a nice helper that does transport_init_session +
core_tpg_check_initiator_node_acl + transport_register_session to
isolated all that.  It might need a callout to the driver somewhere
to be flexible enough but still would be a huge win..
