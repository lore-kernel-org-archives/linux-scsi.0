From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] drivers/scsi/cxgbi: correcting the include path, so can
 pass compiling.
Date: Sun, 20 Jan 2013 15:18:11 +0800
Message-ID: <50FB9A33.2090204@asianux.com>
References: <50F15A35.4000400@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:27800 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3ATHRZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2013 02:17:25 -0500
In-Reply-To: <50F15A35.4000400@asianux.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: David Miller <davem@davemloft.net>, kxie@chelsio.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Hello JBottomley@parallels.com

  when you have free time, could you give a glance for this patch ?

  thanks.

gchen.


=D3=DA 2013=C4=EA01=D4=C212=C8=D5 20:42, Chen Gang =D0=B4=B5=C0:
>=20
>   correct the include path,
>   or the compiler will report can not find "common.h"...
>=20
>   both cxgb3/ and cxgb4/ sub directly have l2t.h (they are different)=
=2E
>   so it is not suitable to '-I' sub-directy, directly.
>=20
>=20
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/scsi/cxgbi/Makefile        |    4 ++++
>  drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |   14 +++++++-------
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   10 +++++-----
>  3 files changed, 16 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefil=
e
> index 86007e3..aff2998 100644
> --- a/drivers/scsi/cxgbi/Makefile
> +++ b/drivers/scsi/cxgbi/Makefile
> @@ -1,2 +1,6 @@
> +
> +ccflags-y			:=3D -Idrivers/net/ethernet/chelsio
> +subdir-ccflags-y		:=3D -Idrivers/net/ethernet/chelsio
> +
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libcxgbi.o cxgb3i/
>  obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+=3D libcxgbi.o cxgb4i/
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/=
cxgb3i/cxgb3i.c
> index 49692a1..ca92e72 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -18,13 +18,13 @@
>  #include <linux/moduleparam.h>
>  #include <scsi/scsi_host.h>
> =20
> -#include "common.h"
> -#include "t3_cpl.h"
> -#include "t3cdev.h"
> -#include "cxgb3_defs.h"
> -#include "cxgb3_ctl_defs.h"
> -#include "cxgb3_offload.h"
> -#include "firmware_exports.h"
> +#include "cxgb3/common.h"
> +#include "cxgb3/t3_cpl.h"
> +#include "cxgb3/t3cdev.h"
> +#include "cxgb3/cxgb3_defs.h"
> +#include "cxgb3/cxgb3_ctl_defs.h"
> +#include "cxgb3/cxgb3_offload.h"
> +#include "cxgb3/firmware_exports.h"
>  #include "cxgb3i.h"
> =20
>  static unsigned int dbg_level;
> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/=
cxgb4i/cxgb4i.c
> index f924b3c..a5795d5 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> @@ -20,11 +20,11 @@
>  #include <net/dst.h>
>  #include <linux/netdevice.h>
> =20
> -#include "t4_msg.h"
> -#include "cxgb4.h"
> -#include "cxgb4_uld.h"
> -#include "t4fw_api.h"
> -#include "l2t.h"
> +#include "cxgb4/t4_msg.h"
> +#include "cxgb4/cxgb4.h"
> +#include "cxgb4/cxgb4_uld.h"
> +#include "cxgb4/t4fw_api.h"
> +#include "cxgb4/l2t.h"
>  #include "cxgb4i.h"
> =20
>  static unsigned int dbg_level;
>=20


--=20
Chen Gang

Asianux Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
