From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH v4] add u64 number parser
Date: Tue, 31 Jan 2017 00:08:00 +0900
Message-ID: <26045.1485788880@jrobl>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com
Cc: sagi@grimberg.me, james_p_freyensee@linux.intel.com, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello James,

Your commit
	a317178 2016-12-06 parser: add u64 number parser
was merged into v4.10-rc1. Good.
I have a very similar function and used for a long time. Here I'd
suggest you a tiny optimization based on my version.

If you think another value is more apropriate as the size of an internal
array, you can change it freely.


J. R. Okajima

commit 030361e78d327d9d89254dc3b320c092221c7cd0
Author: J. R. Okajima <hooanon05g@gmail.com>
Date:   Tue Jan 31 00:01:16 2017 +0900

    parser: match_u64, short string optimization
 =

    When the given string is short enough, we can skip kmalloc/kfree.

    Signed-off-by: J. R. Okajima <hooanon05g@gmail.com>

diff --git a/lib/parser.c b/lib/parser.c
index 3278958..cfbc6ec 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -163,21 +163,25 @@ static int match_number(substring_t *s, int *result,=
 int base)
  */
 static int match_u64int(substring_t *s, u64 *result, int base)
 {
-	char *buf;
+	char *buf, a[32];
 	int ret;
 	u64 val;
 	size_t len =3D s->to - s->from;
 =

-	buf =3D kmalloc(len + 1, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	buf =3D a;
+	if (len + 1 > sizeof(a)) {
+		buf =3D kmalloc(len + 1, GFP_KERNEL);
+		if (unlikely(!buf))
+			return -ENOMEM;
+	}
 	memcpy(buf, s->from, len);
 	buf[len] =3D '\0';
 =

 	ret =3D kstrtoull(buf, base, &val);
 	if (!ret)
 		*result =3D val;
-	kfree(buf);
+	if (buf !=3D a)
+		kfree(buf);
 	return ret;
 }
 =
