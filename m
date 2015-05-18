From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to
	RCU hlist
Date: Mon, 18 May 2015 09:41:02 +0200
Message-ID: <20150518074102.GA6157@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-2-git-send-email-nab@daterainc.com> <20150513063555.GA21770@lst.de> <1431506771.26897.78.camel@haakon3.risingtidesystems.com> <20150517165142.GA17217@lst.de> <1431933444.24645.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431933444.24645.7.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 18, 2015 at 12:17:24AM -0700, Nicholas A. Bellinger wrote:
> On Sun, 2015-05-17 at 18:51 +0200, Christoph Hellwig wrote:
> > On Wed, May 13, 2015 at 01:46:11AM -0700, Nicholas A. Bellinger wrote:
> > > Updated to use a mirror lun->lun_rtpi, with the assignment from sep_rtpi
> > > occuring in core_dev_export() code.
> > 
> > From looking at your current tree I suspect freeing the se_port structure
> > using kfree_rcu might be a better idea.  Together with dropping the references
> > to the se_device from call_rcu context this basically means all pointers
> > in struct se_lun are rcu protected which is much safer if you want
> > to access struct se_lun under rcu protection, as this avoids having to
> > deal with special cases.  Additionally that basically allows you to
> > replace lun_sep_lock with rcu_read_lock for anything remotely like
> > a fast path.
> 
> Here's a first pass at this along with kref + completion conversion for
> the special case PR ALL_TGT_PT=1 pointer dereference.

Btw, I started hacking up a patch to merge se_port and t10_alua_tg_pt_gp_member
in se_lun, which seems even better as it closes all kinds of other
races.  Can you keep this one back for now, I'll send out that patch
ASAP after finishing some testing.
