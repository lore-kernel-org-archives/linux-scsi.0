From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ses: tighten range checks in ses_intf_add()
Date: Mon, 19 Oct 2015 16:48:20 +0300
Message-ID: <20151019134820.GA28752@mwanda>
References: <----An------QYmAn$10b010ca-f710-44aa-8ea3-3b65a3c21286@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40541 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbbJSNsp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2015 09:48:45 -0400
Content-Disposition: inline
In-Reply-To: <----An------QYmAn$10b010ca-f710-44aa-8ea3-3b65a3c21286@alibaba-inc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, =?utf-8?B?56iL5ZCbKOaIkOa3vCk=?= <chengmiao.cj@alibaba-inc.com>, throber3 <throber3@gmail.com>, security@kernel.org

We test that "type_ptr" is within the buffer but then we read from
"type_ptr[3]" so we could be reading beyond the end of the buffer.

Reported-by: "Berry Cheng =E7=A8=8B=E5=90=9B(=E6=88=90=E6=B7=BC)" <chen=
gmiao.cj@alibaba-inc.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This isn't a complete fix because we still need more range checking in
all the other places which use type_ptr like ses_get_page2_descriptor()=
=2E
We record len as page1_len but we don't use it anywhere...

I wonder if someone knew the expected format we could make reject too
short lengths earlier.

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index dcb0d76..39f69b0 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -641,7 +641,7 @@ static int ses_intf_add(struct device *cdev,
 	/* begin at the enclosure descriptor */
 	type_ptr =3D buf + 8;
 	/* skip all the enclosure descriptors */
-	for (i =3D 0; i < num_enclosures && type_ptr < buf + len; i++) {
+	for (i =3D 0; i < num_enclosures && type_ptr + 4 < buf + len; i++) {
 		types +=3D type_ptr[2];
 		type_ptr +=3D type_ptr[3] + 4;
 	}
@@ -649,7 +649,7 @@ static int ses_intf_add(struct device *cdev,
 	ses_dev->page1_types =3D type_ptr;
 	ses_dev->page1_num_types =3D types;
=20
-	for (i =3D 0; i < types && type_ptr < buf + len; i++, type_ptr +=3D 4=
) {
+	for (i =3D 0; i < types && type_ptr + 2 < buf + len; i++, type_ptr +=3D=
 4) {
 		if (type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_DEVICE ||
 		    type_ptr[0] =3D=3D ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components +=3D type_ptr[1];
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
