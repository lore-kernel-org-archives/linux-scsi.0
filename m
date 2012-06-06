From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_qla2xxx: Don't insert nacls without sessions into
 the btree
Date: Tue, 05 Jun 2012 17:04:06 -0700
Message-ID: <1338941046.28824.266.camel@haakon2.linux-iscsi.org>
References: <1338878254-4145-1-git-send-email-roland@kernel.org>
	 <1338936045.28824.229.camel@haakon2.linux-iscsi.org>
	 <CAG4TOxOk4E-CCqf9sPMsBR3khSjNfE+DE5Tux7zNFS9=_1HG-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxOk4E-CCqf9sPMsBR3khSjNfE+DE5Tux7zNFS9=_1HG-g@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-06-05 at 16:41 -0700, Roland Dreier wrote:
> > Looking at this patch which removes tcm_qla2xxx_setup_nacl_from_rport()
> > usage during explicit tcm_qla2xxx_make_nodeacl() creation, how does an
> > explicit NodeACL get picked up in tcm_qla2xxx_check_initiator_node_acl()
> > now with this change ?
> >
> > AFAICT this patch makes every new initiator login attempt result in a
> > demo-mode se_node_acl being generated with virtual LUN=0 access, and
> > ignores explicit se_node_acl + MappedLUNs groups + links to TPG_LUN in
> > individual ../target/qla2xxx/$TARGET_WWPN/tpgt_1/acls/$INITIATOR_WWPN/
> >
> > Is there something else that I'm missing here..?
> 
> [Reply to all this time]
> 
> We still insert the nacl into the tpg->acl_node_list so we'll find it when we
> do the check when the session actually shows up.
> 

Err, yes of course..

> Inserting the nacl into the btree doesn't do anything, since it would have no
> session pointer and so tcm_qla2xxx_find_sess_by_s_id() will return NULL
> whether or not we insert the nacl in tcm_qla2xxx_setup_nacl_from_rport().
> (And that's the only place that does a btree lookup)
> 

OK, I've applied this patch to lio-core.git on top of the following
tcm_qla2xxx patches that where not included in the initial merge:

commit dfebe3b51dd3e263fdc6151e3f1ec9aba1716d03
Author: Joern Engel <joern@logfs.org>
Date:   Fri May 18 13:58:23 2012 -0700

    tcm_qla2xxx: Convert to TFO->put_session() usage

commit 6fc162d3f4a4647576e5dad23435e505a8ef0dc3
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri May 18 15:37:53 2012 -0700

    tcm_qla2xxx: Clear session s_id + loop_id earlier during shutdown


I'll include these over the next days into target-pending as
3.5-rc-fixes items.

Thanks Roland!

--nab
