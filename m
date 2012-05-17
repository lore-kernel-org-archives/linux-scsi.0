From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 15:56:51 -0400
Message-ID: <20120517195651.GD18067@logfs.org>
References: <20120511143341.GA18753@logfs.org>
 <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
 <1337289865.32217.307.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1337289865.32217.307.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 17 May 2012 14:24:25 -0700, Nicholas A. Bellinger wrote:
>=20
> Yes, I think it should be fine to move the loop_id and by fc_id looku=
p
> removal after the vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map()
> call within the call to qlt_unreg_sess() w/ hardware_lock held..

Just in case it wasn't clear from my other mail: no, that will not be
fine.  Once the refcount drops to zero it must be impossible to hold
or obtain any new references.  My patch didn't completely plug this
hole and neither does your proposal.

If that means the fast path just got slower: tough luck!  Anyone can
write fast incorrect code.  If the only way to write correct code is
to be slow, we shall be slow.

J=C3=B6rn

--
Doubt is not a pleasant condition, but certainty is an absurd one.
-- Voltaire
