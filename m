From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v3 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Date: Mon, 15 Jul 2013 16:37:30 -0400
Message-ID: <20130715203730.GA21804@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
 <20130605154106.GA2737@logfs.org>
 <51BF0ADD.1080604@oracle.com>
 <20130705173953.GA15089@logfs.org>
 <51D852DC.4070808@oracle.com>
 <51D9C74D.6060708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51D9C74D.6060708@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 8 July 2013 03:53:49 +0800, vaughan wrote:
>=20
> Use rwsem to aid opens. Exclusive open has to get write lock and non-=
exclusive open should get read lock.
> Replace global sg_open_exclusive_lock with a per device lock - sfd_lo=
ck. Since sfds list is now protected by the lock owned by the same sg_d=
evice, sg_index_lock becomes a real global lock to only protect sg devi=
ces lookup.
>=20
> Please pay attention to sdp->detached. Previously sg_open may also ra=
ce with sg_remove. Now there are two points for sg_open to detect detac=
hed and finish itself. One is at sg_device lookup and the other is when=
 trying to link new sfp into the sfds list in sg_add_sfp.
> I don't think it's necessary to do extra set_exclude and wake_up o_ex=
cl_wait in sg_release before, so I remove them and only do the cleanup =
in sg_remove_sfp.
> Although simple testcases are passed, I'm not certain if I've fixed i=
t well, please give me any comments as you wish.
>=20
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/sg.c | 187 ++++++++++++++++++++++++++------------------=
----------
>  1 file changed, 89 insertions(+), 98 deletions(-)

Had a quick read and I think I like the code.  What I still dislike is
that it merges several independent functional changes into one patch.

Can you create three patches, one for the rwsem part, one for pushing
the locking down to per-device locking and one for the rest?  That
would make it easier for me to understand and trust the individual
patches and for James/Linus to revert one, if it turns out to be bad.

J=C3=B6rn

--
There are two ways of constructing a software design: one way is to mak=
e
it so simple that there are obviously no deficiencies, and the other is
to make it so complicated that there are no obvious deficiencies.
-- C. A. R. Hoare
