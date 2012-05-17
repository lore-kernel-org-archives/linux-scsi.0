From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 15:28:30 -0400
Message-ID: <20120517192830.GC18067@logfs.org>
References: <20120511143341.GA18753@logfs.org>
 <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 17 May 2012 13:49:38 -0700, Roland Dreier wrote:
>=20
> > Mmmmm, I'd still like to try to avoid (another) atomic op in the fa=
st
> > path w/ hardware_lock held if at all possible..
>=20
> atomic_read() is not an atomic op.

Or more importantly it doesn't force the cacheline out of shared mode,
which is the performance killer to avoid.

> > Also thinking more about the case in your comment, I'm starting to
> > wonder if tcm_qla2xxx_free_session() should be obtaining hardware_l=
ock +
> > clearing the s_id and loop_id lookup entries earlier than currently
> > done..
> >
> > That is, target_wait_for_sess_cmds() is called before clearing the
> > nodeacl pointers from s_id + loop_id in tcm_qla2xxx_free_session(),
> > which means that we still perform se_node_acl lookups in the case w=
here
> > the individual tcm_qla2xxx endpoint was not also being shutdown as
> > well..
> >
> > So that said, I think your work-around is OK to address the current=
 BUG,
> > but the s_id + loop_id clearing order in tcm_qla2xxx_free_session()
> > would be having an effect here as well..
>=20
> Yes, in fact we need to clear the session from all lookup tables
> even earlier than ->free_session.  We need to make sure that as
> soon as target_release_session() is called, that session will no
> longer be used for any new commands.
>=20
> So qla_tgt_unreg_sess() needs to clear the session from the
> "by loop_id" table as well as the "by fc_id" table.

Not even that is sufficient.  We need to atomically drop the refcount
and remove the session from all lookup tables.  Call stack is:

tcm_qla2xxx_free_session  <-- removes from lookup tables
qla_tgt_free_session_done
---                       <-- move to workqueue, dropping hardware_lock
qla_tgt_unreg_sess
tcm_qla2xxx_close_session <-- takes hardware_lock
target_release_session
target_put_session        <-- drops refcount

Since the lookup tables are protected by hardware_lock, we would have
to either take the hardware_lock _before_ dropping the reference count
or do atomic_dec_and_lock().  Both of which requires knowledge about
the qla2xxx hardware_lock in generic target code.

J=C3=B6rn

--
Tough times don't last, but tough people do.
-- Nigerian proverb
