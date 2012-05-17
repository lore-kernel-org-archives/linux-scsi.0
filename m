From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 14:24:25 -0700
Message-ID: <1337289865.32217.307.camel@haakon2.linux-iscsi.org>
References: <20120511143341.GA18753@logfs.org>
	 <20120517162600.GA18067@logfs.org>
	 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-05-17 at 13:49 -0700, Roland Dreier wrote:
> > Mmmmm, I'd still like to try to avoid (another) atomic op in the fast
> > path w/ hardware_lock held if at all possible..
> 
> atomic_read() is not an atomic op.
> 

I know.  This was referring to Joern's comment in the code:

     * Proper fix would be to atomically drop the refcount and remove the
     * session from all data structures that would allow lookup.  Until
     * then this tasteless hack shall suffice.

> However this patch is not right, see below.
> 
> > Also thinking more about the case in your comment, I'm starting to
> > wonder if tcm_qla2xxx_free_session() should be obtaining hardware_lock +
> > clearing the s_id and loop_id lookup entries earlier than currently
> > done..
> >
> > That is, target_wait_for_sess_cmds() is called before clearing the
> > nodeacl pointers from s_id + loop_id in tcm_qla2xxx_free_session(),
> > which means that we still perform se_node_acl lookups in the case where
> > the individual tcm_qla2xxx endpoint was not also being shutdown as
> > well..
> >
> > So that said, I think your work-around is OK to address the current BUG,
> > but the s_id + loop_id clearing order in tcm_qla2xxx_free_session()
> > would be having an effect here as well..
> 
> Yes, in fact we need to clear the session from all lookup tables
> even earlier than ->free_session.  We need to make sure that as
> soon as target_release_session() is called, that session will no
> longer be used for any new commands.
> 
> So qla_tgt_unreg_sess() needs to clear the session from the
> "by loop_id" table as well as the "by fc_id" table.
> 

Yes, I think it should be fine to move the loop_id and by fc_id lookup
removal after the vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map()
call within the call to qlt_unreg_sess() w/ hardware_lock held..

This will require that find_sess_by_* be added to vha->hw->tgt.tgt_ops,
and currently needs to avoid tcm_qla2xxx.h structure usage in function
parameters to avoid circular include dependencies..

I'll take a look at making this change to test, and post a patch in a
bit..

--nab
