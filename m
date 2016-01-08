From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Fri, 8 Jan 2016 10:08:46 +0100
Message-ID: <20160108090846.GA746@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-2-git-send-email-nab@daterainc.com> <20160108081412.GA32138@lst.de> <568F73D2.2090808@sandisk.com> <1452242859.27508.12.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452242859.27508.12.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 12:47:39AM -0800, Nicholas A. Bellinger wrote:
> Actually no, they do not.  That's the way that everything outside of
> tcm_fc + ib_srpt driver code has already worked for a long time.

Another reason to introduce a helper to enforce that ordering!

Everything but iscsi and qla2xxx is absolutely trivial to convert.
qla2xxx needs some work, but I think it's actually wrong currently
as it sets the s_id and loop_id unconditionally even if we're
reusing an existing node ACL.  iscsi is black magic as usual, so I'm
a little lost..
