From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 3/4] target: Fix change depth se_session reference
 usage
Date: Wed, 13 Jan 2016 00:56:48 -0800
Message-ID: <1452675408.27508.51.camel@haakon3.risingtidesystems.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
	 <1452457724-10629-4-git-send-email-nab@daterainc.com>
	 <20160112150707.GB2058@lst.de>
	 <1452670172.27508.32.camel@haakon3.risingtidesystems.com>
	 <20160113082436.GA13113@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160113082436.GA13113@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 09:24 +0100, Christoph Hellwig wrote:
> On Tue, Jan 12, 2016 at 11:29:32PM -0800, Nicholas A. Bellinger wrote:
> > With this patch in place, this function is now also called by
> > core_tpg_set_initiator_node_queue_depth(), where previously it was
> > called only during target_alloc_node_acl().
> > 
> > Might as well drop the ignored return while we're at it..
> 
> Please add it to the patch description..
> 

Done.

> > > > +			continue;
> > > > +		}
> > > > +		target_put_session(sess);
> > > > +		spin_lock_irqsave(&acl->nacl_sess_lock, flags);
> > > >  	}
> > > > +	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
> > > 
> > > It seems at thus point there is no need for ->shutdown_session, it
> > > could be folded into ->close_session in a follow on patch.
> > > 
> > 
> > Not exactly.
> > 
> > It's the final target_put_session() -> kref_put() upon
> > se_sess->sess_kref that invokes TFO->close_session().
> 
> I know.  But we are dropping the only long term held reference
> here, so the two are more or less equivalent. 

No.  If ->shutdown_session() succeeds, then target-core is
responsible for dropping both references.

> > > > -void target_get_session(struct se_session *se_sess)
> > > > +int target_get_session(struct se_session *se_sess)
> > > >  {
> > > > -	kref_get(&se_sess->sess_kref);
> > > > +	return kref_get_unless_zero(&se_sess->sess_kref);
> > > >  }
> > > >  EXPORT_SYMBOL(target_get_session);
> > > 
> > > I'd be much happier to have a separate prep patch for this..
> > 
> > Since this will need to hit stable at some point, it likely needs to
> > stay with the original bug-fix.
> 
> Please at least document it in the patch description.  I'd still
> be happier to have the change to target_get_session as a preparatory
> patch, though.

Done.
