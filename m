From: james.smart@broadcom.com (James Smart)
Subject: [PATCH] add u64 number parser
Date: Fri, 22 Jul 2016 17:23:53 -0700
Message-ID: <5792b919.0C1gyf+dF4XKu6Zj%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


add u64 number parser

Will be used by the nvme-fabrics FC transport in parsing options

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 include/linux/parser.h |  1 +
 lib/parser.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/parser.h b/include/linux/parser.h
index 39d5b79..884c1e6 100644
--- a/include/linux/parser.h
+++ b/include/linux/parser.h
@@ -27,6 +27,7 @@ typedef struct {
 
 int match_token(char *, const match_table_t table, substring_t args[]);
 int match_int(substring_t *, int *result);
+int match_u64(substring_t *, u64 *result);
 int match_octal(substring_t *, int *result);
 int match_hex(substring_t *, int *result);
 bool match_wildcard(const char *pattern, const char *str);
diff --git a/lib/parser.c b/lib/parser.c
index b6d1163..3278958 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -152,6 +152,36 @@ static int match_number(substring_t *s, int *result, int base)
 }
 
 /**
+ * match_u64int: scan a number in the given base from a substring_t
+ * @s: substring to be scanned
+ * @result: resulting u64 on success
+ * @base: base to use when converting string
+ *
+ * Description: Given a &substring_t and a base, attempts to parse the substring
+ * as a number in that base. On success, sets @result to the integer represented
+ * by the string and returns 0. Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ */
+static int match_u64int(substring_t *s, u64 *result, int base)
+{
+	char *buf;
+	int ret;
+	u64 val;
+	size_t len = s->to - s->from;
+
+	buf = kmalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	memcpy(buf, s->from, len);
+	buf[len] = '\0';
+
+	ret = kstrtoull(buf, base, &val);
+	if (!ret)
+		*result = val;
+	kfree(buf);
+	return ret;
+}
+
+/**
  * match_int: - scan a decimal representation of an integer from a substring_t
  * @s: substring_t to be scanned
  * @result: resulting integer on success
@@ -167,6 +197,23 @@ int match_int(substring_t *s, int *result)
 EXPORT_SYMBOL(match_int);
 
 /**
+ * match_u64: - scan a decimal representation of a u64 from
+ *                  a substring_t
+ * @s: substring_t to be scanned
+ * @result: resulting unsigned long long on success
+ *
+ * Description: Attempts to parse the &substring_t @s as a long decimal
+ * integer. On success, sets @result to the integer represented by the
+ * string and returns 0.
+ * Returns -ENOMEM, -EINVAL, or -ERANGE on failure.
+ */
+int match_u64(substring_t *s, u64 *result)
+{
+	return match_u64int(s, result, 0);
+}
+EXPORT_SYMBOL(match_u64);
+
+/**
  * match_octal: - scan an octal representation of an integer from a substring_t
  * @s: substring_t to be scanned
  * @result: resulting integer on success
-- 
2.5.0
