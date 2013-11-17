From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: be_iscsi: fix possible memory leak and refactor
 code
Date: Sun, 17 Nov 2013 13:38:59 -0800
Message-ID: <1384724339.2050.6.camel@dabdike.int.hansenpartnership.com>
References: <1384714284-13712-1-git-send-email-geyslan@gmail.com>
	 <1384717371.2050.2.camel@dabdike.int.hansenpartnership.com>
	 <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54799 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab3KQVjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Nov 2013 16:39:10 -0500
In-Reply-To: <CAGG-pURSnEeNvmHhQ-GvrnyuMHPrTRMoCKt3P=bB23OD9Vmkpg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geyslan =?ISO-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, "open list:SERVER ENGINES 10..." <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On Sun, 2013-11-17 at 19:09 -0200, Geyslan Greg=F3rio Bem wrote:
> 2013/11/17 James Bottomley <James.Bottomley@hansenpartnership.com>:
> > On Sun, 2013-11-17 at 15:51 -0300, Geyslan G. Bem wrote:
> >> This patch fix memory leakage in cases 'ISCSI_NET_PARAM_VLAN_ID' a=
nd
> >> 'ISCSI_NET_PARAM_VLAN_PRIORITY' and refactors code 'going out' whe=
n
> >> necessary.
> >
> > You pointlessly renamed a variable, which makes the diff hard to re=
ad.
> > Please don't do that.
>=20
> Ok, I can agree. 'len' means length? What is returned in case of non
> error?

it returns the length of buf written to or negative error.

> > You missed the fact that the passed in pointer is unmodified if
> > mgmt_get_if_info() returns non zero, so the kfree frees junk and wo=
uld
> > oops.
> >
> > There's no need for a goto; len =3D -EINVAL; does everything that's
> > needed.
>=20
> Well, that is a coverity catch. CID 1128954. Check it.

I didn't say coverity was wrong, I said your patch was (well not wrong,
just over complex and incomplete).  This is the way to fix both
problems.

James

---

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/b=
e_iscsi.c
index ffadbee..9dcbdfa 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -541,10 +541,8 @@ static int be2iscsi_get_if_param(struct beiscsi_hb=
a *phba,
 		ip_type =3D BE2_IPV6;
=20
 	len =3D mgmt_get_if_info(phba, ip_type, &if_info);
-	if (len) {
-		kfree(if_info);
+	if (len)
 		return len;
-	}
=20
 	switch (param) {
 	case ISCSI_NET_PARAM_IPV4_ADDR:
@@ -569,7 +567,7 @@ static int be2iscsi_get_if_param(struct beiscsi_hba=
 *phba,
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (if_info->vlan_priority =3D=3D BEISCSI_VLAN_DISABLE)
-			return -EINVAL;
+			len =3D -EINVAL;
 		else
 			len =3D sprintf(buf, "%d\n",
 				     (if_info->vlan_priority &


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
