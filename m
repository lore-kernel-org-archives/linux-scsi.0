From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH -resend_2 1/1] cxgbi: fix build with EXTRA_CFLAGS
Date: Tue, 06 Oct 2015 14:08:25 +0200
Message-ID: <mqdmvvwb3nq.fsf@c203.arch.suse.de>
References: <1444131587-28749-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbbJFMI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2015 08:08:27 -0400
In-Reply-To: <1444131587-28749-1-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Tue, 6 Oct 2015 13:39:47 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, JBottomley@Odin.com, kxie@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> EXTRA_CFLAGS are intended to be used on the command line, not by
> Kbuild. In case of cxgbi drivers, use of EXTRA_CFLAGS results in a
> compilation failure:
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:24:21: fatal error: t4_regs.h: No =
such file or directory
> when building like:
> $ make drivers/scsi/cxgbi/ EXTRA_CFLAGS=3D-Wwhatever
>
> Use ccflags-y instead of EXTRA_CFLAGS.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
> Sent on:
> Sep 10
> Jun 9
>
>  drivers/scsi/cxgbi/cxgb3i/Kbuild | 2 +-
>  drivers/scsi/cxgbi/cxgb4i/Kbuild | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/cxgbi/cxgb3i/Kbuild b/drivers/scsi/cxgbi/cx=
gb3i/Kbuild
> index 6f095e28a974..961a12f6d318 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/Kbuild
> +++ b/drivers/scsi/cxgbi/cxgb3i/Kbuild
> @@ -1,3 +1,3 @@
> -EXTRA_CFLAGS +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
> +ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
> =20
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI) +=3D cxgb3i.o
> diff --git a/drivers/scsi/cxgbi/cxgb4i/Kbuild b/drivers/scsi/cxgbi/cx=
gb4i/Kbuild
> index 8290cdaa4652..37458643749b 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/Kbuild
> +++ b/drivers/scsi/cxgbi/cxgb4i/Kbuild
> @@ -1,3 +1,3 @@
> -EXTRA_CFLAGS +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
> +ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
> =20
>  obj-$(CONFIG_SCSI_CXGB4_ISCSI) +=3D cxgb4i.o

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
