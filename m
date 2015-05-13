From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Tue, 12 May 2015 22:08:51 -0700
Message-ID: <1431493731.26897.35.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-2-git-send-email-nab@daterainc.com>
	 <5552696F.8080904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5552696F.8080904@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-12 at 13:58 -0700, Andy Grover wrote:
> On 05/12/2015 02:25 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch converts se_node_acl->device_list[] table for mappedluns
> > to modern RCU hlist_head usage in order to support an arbitrary number
> > of node_acl lun mappings.
> >
> > This includes changes to core_[enable,disable]_device_list_for_node()
> > rcu_assign_pointer() and invokes call_rcu() for releasing memory, along
> > with a number of RCU read path conversions in target_core_device.c code.
> >
> > Required for subsequent conversion of transport_lookup_cmd() to lock-less
> > RCU read path.
> >
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

<SNIP>

> > diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> > index 042a734..6fb38df 100644
> > --- a/include/target/target_core_base.h
> > +++ b/include/target/target_core_base.h
> > @@ -584,10 +584,12 @@ struct se_node_acl {
> >   	char			acl_tag[MAX_ACL_TAG_SIZE];
> >   	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
> >   	atomic_t		acl_pr_ref_count;
> > +	struct hlist_head	lun_entry_hlist;
> >   	struct se_dev_entry	**device_list;
> 
> Very nice to see all this posted!
> 
> Patch 6 is where device_list is finally removed. Suggest squashing 1-6, 
> maybe after review, I'm guessing they're not bisectable.
> 

The series is bisectable.  With patch #1 in place ->device_list[] is
still kzalloc()'ed, but new RCU pointer assignments are made into
lun_entry_hlist[].

Squashing the RCU reader paths (#2-6) for merge is OK, but it's still
nice to break up reader / updater changes into separate patches.

--nab
