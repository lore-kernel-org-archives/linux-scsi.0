From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] strstrip incorrectly marked __must_check
Date: Tue, 03 Nov 2009 12:38:08 -0600
Message-ID: <1257273488.9427.27.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753915AbZKCSiM@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

strstrip strips whitespace from the beginning and end of a string.  I
agree you have to take the returned pointer if you want to strip from
the beginning.  However, if you wish to keep the whitespace at the
beginning and only wish strstrip to remove it from the end, then it's
entirely legitimate to discard the returned pointer.

This is what we have in drivers/scsi/ipr.c and the patch to make
strstrip __must_check is now causing SCSI spurious warnings in that
code.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

---

diff --git a/include/linux/string.h b/include/linux/string.h
index b850886..489019e 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -62,7 +62,7 @@ extern char * strnchr(const char *, size_t, int);
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
-extern char * __must_check strstrip(char *);
+extern char * strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
 #endif
