From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Thu, 17 May 2012 17:10:56 -0400
Message-ID: <20120517211055.GF18067@logfs.org>
References: <20120511143341.GA18753@logfs.org>
 <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
 <20120517192830.GC18067@logfs.org>
 <20120517210521.GE18067@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120517210521.GE18067@logfs.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

And below is a patch that allows speeding up the fast path a bit.
The code in tcm_qla2xxx_put_session() would turn into this:
	local_irq_save(flags);
	if (kref_put_and_lock(&se_sess->sess_kref, &ha->hardware_lock,
				target_release_session))
		spin_unlock(&ha->hardware_lock);
	local_irq_restore(flags);

I don't propose we do this yet, correct code is more important than
fast code at this point.  But we should be able to reclaim most of the
performance impact - if it is actually measureable.

J=C3=B6rn

--
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers

[PATCH] kref: add kref_put_and_lock()

Similar to kref_put(), but will only take a lock (and a performance hit=
)
if the refcount drops to zero.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 include/linux/kref.h |    3 +++
 lib/kref.c           |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index d4a62ab..9581493 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -16,6 +16,7 @@
 #define _KREF_H_
=20
 #include <linux/types.h>
+#include <linux/spinlock.h>
=20
 struct kref {
 	atomic_t refcount;
@@ -24,6 +25,8 @@ struct kref {
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
+int kref_put_and_lock(struct kref *kref, spinlock_t *lock,
+		void (*release)(struct kref *kref));
 int kref_sub(struct kref *kref, unsigned int count,
 	     void (*release) (struct kref *kref));
=20
diff --git a/lib/kref.c b/lib/kref.c
index 3efb882..07a82f3 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -62,6 +62,29 @@ int kref_put(struct kref *kref, void (*release)(stru=
ct kref *kref))
 	return 0;
 }
=20
+/**
+ * kref_put_and_lock - decrement refcount for object with locking
+ * @kref:	object
+ * @lock:	the lock to acquire when dropping the last refcount
+ * @release:	pointer to the function that will clean up the object whe=
n the
+ *		last reference to the object is released.
+ *
+ * Same as kref_put(), except that it will acquire the lock before dro=
pping the
+ * last refcount.  If the last refcount is dropped, the lock will be h=
eld on
+ * return and the return value will be 1.
+ */
+int kref_put_and_lock(struct kref *kref, spinlock_t *lock,
+		void (*release)(struct kref *kref))
+{
+	WARN_ON(release =3D=3D NULL);
+	WARN_ON(release =3D=3D (void (*)(struct kref *))kfree);
+
+	if (atomic_dec_and_lock(&kref->refcount, lock)) {
+		release(kref);
+		return 1;
+	}
+	return 0;
+}
=20
 /**
  * kref_sub - subtract a number of refcounts for object.
--=20
1.7.10
