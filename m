From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] libiscsi: fix iscsi pool error path
Date: Wed,  1 Apr 2009 13:11:29 -0500
Message-ID: <12386094933319-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
 <12386094902138-git-send-email-michaelc@cs.wisc.edu>
 <12386094901595-git-send-email-michaelc@cs.wisc.edu>
 <123860949112-git-send-email-michaelc@cs.wisc.edu>
 <12386094913176-git-send-email-michaelc@cs.wisc.edu>
 <1238609492308-git-send-email-michaelc@cs.wisc.edu>
 <12386094922477-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41474 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765359AbZDASLr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:47 -0400
In-Reply-To: <12386094922477-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

=46rom: Jean Delvare <jdelvare@suse.de>

Le lundi 30 mars 2009, Chris Wright a =C3=A9crit=C2=A0:
> q->queue could be ERR_PTR(-ENOMEM) which will break unwinding
> on error.  Make iscsi_pool_free more defensive.
>

Making the freeing of q->queue dependent on q->pool being set looks
really weird (although it is correct at the moment. But this seems
to be fixable in a much simpler way.

With the benefit that only the error case is slowed down. In both
cases we have a problem if q->queue contains an error value but it's
not -ENOMEM. Apparently this can't happen today, but it doesn't feel
right to assume this will always be true. Maybe it's the right time
to fix this as well.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index dfaa8ad..6896283 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1999,8 +1999,10 @@ iscsi_pool_init(struct iscsi_pool *q, int max, v=
oid ***items, int item_size)
=20
 	q->queue =3D kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
-	if (q->queue =3D=3D ERR_PTR(-ENOMEM))
+	if (IS_ERR(q->queue)) {
+		q->queue =3D NULL;
 		goto enomem;
+	}
=20
 	for (i =3D 0; i < max; i++) {
 		q->pool[i] =3D kzalloc(item_size, GFP_KERNEL);
--=20
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
