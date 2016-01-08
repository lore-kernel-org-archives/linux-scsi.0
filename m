From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/4] ib_srpt: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Fri, 08 Jan 2016 01:17:13 -0800
Message-ID: <1452244633.27508.21.camel@haakon3.risingtidesystems.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
	 <1452237348-2277-5-git-send-email-nab@daterainc.com>
	 <568F78DB.9090404@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <568F78DB.9090404@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-01-08 at 09:52 +0100, Bart Van Assche wrote:
> On 01/08/2016 08:15 AM, Nicholas A. Bellinger wrote:
> > @@ -2574,24 +2558,18 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
> >
> >   	pr_debug("registering session %s\n", ch->sess_name);
> >
> > -	nacl = srpt_lookup_acl(sport, ch->i_port_id);
> > -	if (!nacl) {
> > +	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name);
> > +	if (!se_acl) {
> >   		pr_info("Rejected login because no ACL has been"
> >   			" configured yet for initiator %s.\n", ch->sess_name);
> >   		rej->reason = cpu_to_be32(
> > -			      SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
> > +				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
> > +		transport_free_session(ch->sess);
> >   		goto destroy_ib;
> >   	}
> > +	ch->sess->se_node_acl = se_acl;
> 
> This is a backwards-incompatible change. Today the ib_srpt target driver 
> accepts initiator port names with and without leading "0x". With this 
> change the "0x" prefix becomes mandatory.

The internally ib_srpt formatted ch->sess_name already needs to match
se_node_acl->initiatorname for se_node_acl->acl_group configfs group
shutdown reference..

How does this patch become a backworks-incompatible change for that..?

> 
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
> > index 5faad8ac..bb4fbe2 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> > @@ -364,11 +364,9 @@ struct srpt_port {
> >   	u16			sm_lid;
> >   	u16			lid;
> >   	union ib_gid		gid;
> > -	spinlock_t		port_acl_lock;
> >   	struct work_struct	work;
> >   	struct se_portal_group	port_tpg_1;
> >   	struct se_wwn		port_wwn;
> > -	struct list_head	port_acl_list;
> >   	struct srpt_port_attrib port_attrib;
> >   };
> 
> With this patch applied the following srpt_node_acl members are no 
> longer read: i_port_id, sport and list. Hence please remove the 
> srpt_node_acl structure definition and use struct se_node_acl instead.
> 

Dropping these now.
