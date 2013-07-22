From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
Date: Mon, 22 Jul 2013 13:03:38 -0400
Message-ID: <20130722170338.GA15824@logfs.org>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59878 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3GVSf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jul 2013 14:35:28 -0400
Content-Disposition: inline
In-Reply-To: <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>=20
> There is a race when open sg with O_EXCL flag. Also a race may happen=
 between
> sg_open and sg_remove.
>=20
> Changes from v4:
>  * [3/4] use ERR_PTR series instead of adding another parameter in sg=
_add_sfp
>  * [4/4] fix conflict for cherry-pick from v3.
>=20
> Changes from v3:
>  * release o_sem in sg_release(), not in sg_remove_sfp().
>  * not set exclude with sfd_lock held.
>=20
> Vaughan Cao (4):
>   [SCSI] sg: use rwsem to solve race during exclusive open
>   [SCSI] sg: no need sg_open_exclusive_lock
>   [SCSI] sg: checking sdp->detached isn't protected when open
>   [SCSI] sg: push file descriptor list locking down to per-device
>     locking
>=20
>  drivers/scsi/sg.c | 178 +++++++++++++++++++++++++-------------------=
----------
>  1 file changed, 83 insertions(+), 95 deletions(-)

Patchset looks good to me, although I didn't test it on hardware yet.
Signed-off-by: Joern Engel <joern@logfs.org>

James, care to pick this up?

J=C3=B6rn

--
Good warriors cause others to come to them and do not go to others.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
