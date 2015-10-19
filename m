From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] ses: tighten range checking in
 ses_enclosure_data_process()
Date: Mon, 19 Oct 2015 13:15:38 +0300
Message-ID: <20151019101538.GA26688@mwanda>
References: <----An------QYmAn$4202951b-482d-4d92-98c2-3466de737b40@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbJSKP7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 06:15:59 -0400
Content-Disposition: inline
In-Reply-To: <----An------QYmAn$4202951b-482d-4d92-98c2-3466de737b40@alibaba-inc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, security <security@kernel.org>, =?utf-8?B?56iL5ZCbKOaIkOa3vCk=?= <chengmiao.cj@alibaba-inc.com>, throber3 <throber3@gmail.com>

"len" has to be at least 12 because we need that space for the overall
descriptor, otherwise we end up reading beyond the end of the array and
KASan complains.  Later on we have some more range checking on desc_ptr
but we are checking the start of the "desc_ptr" buffer instead of the
end of the buffer (desc_ptr + 4).  Let's tighten that up as well.

Reported-by: "Berry=C2=A0Cheng =E7=A8=8B=E5=90=9B(=E6=88=90=E6=B7=BC)" =
<chengmiao.cj@alibaba-inc.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index dcb0d76..ff474c7 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -476,6 +476,8 @@ static void ses_enclosure_data_process(struct enclo=
sure_device *edev,
 		goto simple_populate;
=20
 	page7_len =3D len =3D (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	if (len < 12)
+		goto simple_populate;
 	/* add 1 for trailing '\0' we'll use */
 	buf =3D kzalloc(len + 1, GFP_KERNEL);
 	if (!buf)
@@ -504,15 +506,19 @@ static void ses_enclosure_data_process(struct enc=
losure_device *edev,
 			struct enclosure_component *ecomp;
=20
 			if (desc_ptr) {
-				if (desc_ptr >=3D buf + page7_len) {
+				if (desc_ptr + 4 >=3D buf + page7_len) {
 					desc_ptr =3D NULL;
 				} else {
 					len =3D (desc_ptr[2] << 8) + desc_ptr[3];
 					desc_ptr +=3D 4;
 					/* Add trailing zero - pushes into
 					 * reserved space */
-					desc_ptr[len] =3D '\0';
-					name =3D desc_ptr;
+					if (desc_ptr + len >=3D buf + page7_len) {
+						desc_ptr =3D NULL;
+					} else {
+						desc_ptr[len] =3D '\0';
+						name =3D desc_ptr;
+					}
 				}
 			}
 			if (type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_DEVICE ||
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
