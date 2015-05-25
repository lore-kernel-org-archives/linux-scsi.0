From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/9] target/pr: Use atomic bitop for
 se_dev_entry->pr_reg reservation check
Date: Mon, 25 May 2015 14:59:46 -0700
Message-ID: <1432591186.722.5.camel@haakon3.risingtidesystems.com>
References: <1432275071-28882-1-git-send-email-nab@daterainc.com>
	 <1432275071-28882-3-git-send-email-nab@daterainc.com>
	 <555F0107.6030102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54742 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbbEYV74 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2015 17:59:56 -0400
In-Reply-To: <555F0107.6030102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

On Fri, 2015-05-22 at 12:12 +0200, Bart Van Assche wrote:
> On 05/22/15 08:11, Nicholas A. Bellinger wrote:
> > diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> > index e2c0eaf..def5bc8 100644
> > --- a/include/target/target_core_base.h
> > +++ b/include/target/target_core_base.h
> > @@ -638,7 +638,6 @@ struct se_lun_acl {
> >   };
> >
> >   struct se_dev_entry {
> > -	bool			def_pr_registered;
> >   	/* See transport_lunflags_table */
> >   	u32			lun_flags;
> >   	u32			mapped_lun;
> > @@ -655,7 +654,8 @@ struct se_dev_entry {
> >   	struct se_node_acl	*se_node_acl;
> >   	struct se_lun_acl __rcu	*se_lun_acl;
> >   	spinlock_t		ua_lock;
> > -	struct se_lun		*se_lun;
> > +	struct se_lun __rcu	*se_lun;
> > +	unsigned long		pr_reg;
> >   	struct list_head	alua_port_list;
> >   	struct list_head	ua_list;
> >   	struct hlist_node	link;
> 
> Hello Nic,
> 
> This change causes the "se_lun = deve->se_lun" assignment in 
> transport_lookup_cmd_lun() to assign an RCU pointer to a non-RCU 
> pointer. Shouldn't such an assignment be protected via rcu_dereference() ?
> 

FYI, these assignments are done in patch #1.

This __rcu notation should be included there instead.

