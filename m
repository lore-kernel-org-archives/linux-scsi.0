From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 01/11] lib/iovec: Add memcpy_fromiovec_out library function
Date: Mon,  2 Feb 2015 04:06:24 +0000
Message-ID: <1422849994-3419-2-git-send-email-nab@daterainc.com>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:46735 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbbBBEjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2015 23:39:33 -0500
Received: by mail-oi0-f50.google.com with SMTP id h136so42756384oig.9
        for <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2015 20:39:32 -0800 (PST)
In-Reply-To: <1422849994-3419-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new memcpy_fromiovec_out() library function which modifies
the passed *iov following memcpy_fromiovec(), but also returns the next current
iovec pointer via **iov_out.

This is useful for vhost ANY_LAYOUT support when guests are allowed to generate
incoming virtio request headers combined with subsequent SGL payloads into a
single iovec.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/uio.h |  2 ++
 lib/iovec.c         | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 1c5e453..3e4473d 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -136,6 +136,8 @@ size_t csum_and_copy_to_iter(void *addr, size_t bytes, __wsum *csum, struct iov_
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum, struct iov_iter *i);
 
 int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
+int memcpy_fromiovec_out(unsigned char *kdata, struct iovec *iov,
+			 struct iovec **iov_out, int len);
 int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
 			int offset, int len);
 int memcpy_toiovecend(const struct iovec *v, unsigned char *kdata,
diff --git a/lib/iovec.c b/lib/iovec.c
index 2d99cb4..24c8148 100644
--- a/lib/iovec.c
+++ b/lib/iovec.c
@@ -28,6 +28,41 @@ int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len)
 EXPORT_SYMBOL(memcpy_fromiovec);
 
 /*
+ *	Copy iovec to kernel, modifying the passed *iov entries.
+ *
+ *	Save **iov_out for the caller to use upon return, that may either
+ *	contain the current entry with a re-calculated iov_base + iov_len
+ *	or next unmodified entry.
+ *
+ *	Also note that any iovec entries preceeding the final *iov_out are
+ *	zeroed by copy_from_user().
+ *
+ *	Returns -EFAULT on error.
+ */
+
+int memcpy_fromiovec_out(unsigned char *kdata, struct iovec *iov,
+			 struct iovec **iov_out, int len)
+{
+	while (len > 0) {
+		if (iov->iov_len) {
+			int copy = min_t(unsigned int, len, iov->iov_len);
+			if (copy_from_user(kdata, iov->iov_base, copy))
+				return -EFAULT;
+			len -= copy;
+			kdata += copy;
+			iov->iov_base += copy;
+			iov->iov_len -= copy;
+		}
+		if (!iov->iov_len)
+			iov++;
+	}
+	*iov_out = iov;
+
+	return 0;
+}
+EXPORT_SYMBOL(memcpy_fromiovec_out);
+
+/*
  *	Copy kernel to iovec. Returns -EFAULT on error.
  */
 
-- 
1.9.1

