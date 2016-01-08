From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] tcm_fc: Convert acl lookup to modern
	get_initiator_node_acl usage
Date: Fri, 8 Jan 2016 10:05:29 +0100
Message-ID: <20160108090529.GA701@lst.de>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com> <1452237348-2277-4-git-send-email-nab@daterainc.com> <20160108082114.GC32138@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160108082114.GC32138@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 09:21:15AM +0100, Christoph Hellwig wrote:
> Btw, who is dropping the reference we're acuiring through
> core_tpg_get_initiator_node_acl?

Ok, we do in transport_deregister_session/transport_free_session.

But that means patches 3 and 4 need to go first, otherwise we fail
to grab a reference in tcm_fc and srpt that we later drop after patch 1.
