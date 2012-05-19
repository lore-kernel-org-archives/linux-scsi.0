From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Fri, 18 May 2012 18:26:08 -0700
Message-ID: <1337390768.32217.508.camel@haakon2.linux-iscsi.org>
References: <20120511143341.GA18753@logfs.org>
	 <20120517162600.GA18067@logfs.org>
	 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
	 <20120517192830.GC18067@logfs.org> <20120517210521.GE18067@logfs.org>
	 <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
	 <20120518011528.GG18067@logfs.org>
	 <1337321367.32217.412.camel@haakon2.linux-iscsi.org>
	 <20120518224948.GB21634@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120518224948.GB21634@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-05-18 at 18:49 -0400, J=C3=B6rn Engel wrote:
> On Thu, 17 May 2012 23:09:27 -0700, Nicholas A. Bellinger wrote:
> >=20
> > So that means your testing with it now, right..?
>=20
> Our kernel has diverged too much from yours to easily move patches
> back and forth, so no.
>=20
> But more importantly, we still don't have a complete patchset.
>=20

Ok, I've pushed into lio-core the following WIP patches based on your
original patch + s_id + loop_id clearing patch from today:

6fc162d3 tcm_qla2xxx: Clear session s_id + loop_id earlier during shutd=
own
dfebe3b5 tcm_qla2xxx: Convert to TFO->put_session() usage
ec7cf009 target: Add TFO->put_session() caller for HW fabric session sh=
utdown

Today I've been testing these changes against typical active I/O during
tcm_qla2xxx endpoint shutdown, and against explict NodeACL + MappedLUNs
removal case.  So far with active FCP of the order of ~100K IOPs with
random mixed mode 4K blocks, these patches are performing session
shutdown and unloading tcm_qla2xxx references as expected.

Certainly these need more testing wrt to a number of special cases for
active I/O shutdown, but I think they look reasonable enough to put int=
o
lio-core for now..

Please have a look and let me know if you have any problems getting it
applied for testing into your .39 tree.

Thanks,

--nab
