From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 07/10] sg: protect sdp->exclude
Date: Tue, 24 Apr 2012 16:16:59 -0400
Message-ID: <20120424201658.GD20610@logfs.org>
References: <20120412213217.GA17388@logfs.org>
 <20120412213418.GG17388@logfs.org>
 <4F95D426.7000406@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:50660 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146Ab2DXWQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2012 18:16:27 -0400
Content-Disposition: inline
In-Reply-To: <4F95D426.7000406@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, 23 April 2012 18:13:58 -0400, Douglas Gilbert wrote:
>=20
> I have gone through the rest of this series of patches (10 of
> them posted 12 April) and they look fine. The above line worries
> me and I raised it with the author but have received no response.
>=20
> A small test program suggests that the second argument to
> wait_event_interruptible [a condition] will always be true
> due to the trailing comma operator (i.e. the ", 1"). I suspect
> another set of parentheses is needed:
>   res =3D wait_event_interruptible(sdp->o_excl_wait,
>              ((!list_empty(&sdp->sfds) || get_exclude(sdp)) ?
> 		      0 : (set_exclude(sdp, 1), 1)));

You are right.  I made set_exclude() return the new value, which
simplifies this condition a bit.  Any simplification here is a good
thing, as I just proved that it is too complicated for my brain to
fully understand.

Thanks for spotting this, Doug!

J=C3=B6rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
