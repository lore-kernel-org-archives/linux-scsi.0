From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 13:49:38 -0700
Message-ID: <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
References: <20120511143341.GA18753@logfs.org> <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:44668 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756135Ab2EQUuA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 16:50:00 -0400
Received: by ggnf2 with SMTP id f2so4409358ggn.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2012 13:49:58 -0700 (PDT)
In-Reply-To: <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

> Mmmmm, I'd still like to try to avoid (another) atomic op in the fast
> path w/ hardware_lock held if at all possible..

atomic_read() is not an atomic op.

However this patch is not right, see below.

> Also thinking more about the case in your comment, I'm starting to
> wonder if tcm_qla2xxx_free_session() should be obtaining hardware_lock +
> clearing the s_id and loop_id lookup entries earlier than currently
> done..
>
> That is, target_wait_for_sess_cmds() is called before clearing the
> nodeacl pointers from s_id + loop_id in tcm_qla2xxx_free_session(),
> which means that we still perform se_node_acl lookups in the case where
> the individual tcm_qla2xxx endpoint was not also being shutdown as
> well..
>
> So that said, I think your work-around is OK to address the current BUG,
> but the s_id + loop_id clearing order in tcm_qla2xxx_free_session()
> would be having an effect here as well..

Yes, in fact we need to clear the session from all lookup tables
even earlier than ->free_session.  We need to make sure that as
soon as target_release_session() is called, that session will no
longer be used for any new commands.

So qla_tgt_unreg_sess() needs to clear the session from the
"by loop_id" table as well as the "by fc_id" table.

 - R.
