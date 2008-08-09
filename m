From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH v5] cmdfilter: clean up sysfs interface
Date: Sat, 9 Aug 2008 12:09:38 +0200
Message-ID: <6cf6b73e0808090309y94a071dh3079d4e89cc1154f@mail.gmail.com>
References: <6cf6b73e0808081456g7d50f66dvc98f5b42a6bab65b@mail.gmail.com>
	 <20080809033935.GI8618@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_27694_13597530.1218276578665"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from po-out-1718.google.com ([72.14.252.155]:36185 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYHIKJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Aug 2008 06:09:40 -0400
Received: by po-out-1718.google.com with SMTP id c31so2070417poi.1
        for <linux-scsi@vger.kernel.org>; Sat, 09 Aug 2008 03:09:38 -0700 (PDT)
In-Reply-To: <20080809033935.GI8618@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, viro@zeniv.linux.org.uk, Peter Jones <pjones@redhat.com>, dougg@torque.net, dan.j.williams@intel.com, James.Bottomley@hansenpartnership.com

------=_Part_27694_13597530.1218276578665
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/8/9 Matthew Wilcox <matthew@wil.cx>:
> On Fri, Aug 08, 2008 at 11:56:35PM +0200, Adel Gadllah wrote:
>> @@ -84,8 +83,8 @@ static ssize_t rcf_cmds_show(struct
>> blk_scsi_cmd_filter *filter, char *page,
>>
>>       for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
>>               if (test_bit(i, okbits)) {
>> -                     sprintf(npage, "%02x", i);
>> -                     npage += 2;
>> +                     sprintf(npage, "0x%02x", i);
>> +                     npage += 4;
>>                       if (i < BLK_SCSI_MAX_CMDS - 1)
>>                               sprintf(npage++, " ");
>>               }
>
> Why not:
>
>                        npage += sprintf(npage, "0x%02x", i);
> ?

no reason .. that how the original patch was... changed it.


>> +     while ((p = strsep((char **)&page, " ")) != NULL) {
>> +             set = 1;
>> +
>> +             if (p[0] == '-') {
>> +                     set = 0;
>> +                     p++;
>> +             }
>> +
>> +             if (p[0] == '+')
>> +                     p++;
>> +
>> +             cmd = simple_strtol(p, &status, 16);
>> +
>>               /* either of these cases means invalid input, so do nothing. */
>> -             if (status || cmd >= BLK_SCSI_MAX_CMDS)
>> +             if ((status == p) || cmd >= BLK_SCSI_MAX_CMDS)
>>                       return -EINVAL;
>
> Doesn't this accept -+0x20 for example?  Why not:

-+ seems abit odd....

>                set = 1;
>                if (p[0] == '+') {
>                        p++;
>                } else if (p[0] == '-') {
>                        set = 0;
>                        p++;
>                }
>                cmd = simple_strtol(p, &status, 16);

done

>> -             __set_bit(cmd, okbits);
>> +             if (set)
>> +                     __set_bit(cmd, okbits);
>> +             else
>> +                     __clear_bit(cmd, okbits);
>>       }
>>
>> -     if (rw == READ)
>> -             target_okbits = filter->read_ok;
>> -     else
>> -             target_okbits = filter->write_ok;
>> -
>>       memmove(target_okbits, okbits, sizeof(okbits));
>
> target_okbits can't overlap with okbits, so you can use memcpy instead
> of memmove here.

left over from the old patch, changed.

v5 attached with this changed (build tested only)

------------------------
This patch changes the interface of the cmd filter to use a +/- notation like:
echo -- +0x02 +0x03 -0x08
If neither + or - is given it defaults to + (allow command).

Note: The interface was added in 2.6.17-rc1 and is unused
and undocumented so far so it's safe to change it.

Cc: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp
Cc: jens.axboe@oracle.com
Cc: James.Bottomley@hansenpartnership.com
Cc: dan.j.williams@intel.com
Cc: pjones@redhat.com
Cc: viro@zeniv.linux.org.uk
Cc: dougg@torque.net
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

 block/cmd-filter.c |   54 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index eec4404..e51648c 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -20,7 +20,6 @@
 #include <linux/list.h>
 #include <linux/genhd.h>
 #include <linux/spinlock.h>
-#include <linux/parser.h>
 #include <linux/capability.h>
 #include <linux/bitops.h>

@@ -84,8 +83,7 @@ static ssize_t rcf_cmds_show(struct
blk_scsi_cmd_filter *filter, char *page,

 	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
 		if (test_bit(i, okbits)) {
-			sprintf(npage, "%02x", i);
-			npage += 2;
+			npage += sprintf(npage, "0x%02x", i);
 			if (i < BLK_SCSI_MAX_CMDS - 1)
 				sprintf(npage++, " ");
 		}
@@ -111,33 +109,41 @@ static ssize_t rcf_writecmds_show(struct
blk_scsi_cmd_filter *filter,
 static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
 			      const char *page, size_t count, int rw)
 {
-	ssize_t ret = 0;
 	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
-	int cmd, status, len;
-	substring_t ss;
-
-	memset(&okbits, 0, sizeof(okbits));
-
-	for (len = strlen(page); len > 0; len -= 3) {
-		if (len < 2)
-			break;
-		ss.from = (char *) page + ret;
-		ss.to = (char *) page + ret + 2;
-		ret += 3;
-		status = match_hex(&ss, &cmd);
+	int cmd, set;
+	char *p, *status;
+
+	if (rw == READ) {
+		memcpy(&okbits, filter->read_ok, sizeof(okbits));
+		target_okbits = filter->read_ok;
+	} else {
+		memcpy(&okbits, filter->write_ok, sizeof(okbits));
+		target_okbits = filter->write_ok;
+	}
+
+	while ((p = strsep((char **)&page, " ")) != NULL) {
+		set = 1;
+
+		if (p[0] == '+') {
+			p++;
+		} else if (p[0] == '-') {
+			set = 0;
+			p++;
+		}
+
+		cmd = simple_strtol(p, &status, 16);
+
 		/* either of these cases means invalid input, so do nothing. */
-		if (status || cmd >= BLK_SCSI_MAX_CMDS)
+		if ((status == p) || cmd >= BLK_SCSI_MAX_CMDS)
 			return -EINVAL;

-		__set_bit(cmd, okbits);
+		if (set)
+			__set_bit(cmd, okbits);
+		else
+			__clear_bit(cmd, okbits);
 	}

-	if (rw == READ)
-		target_okbits = filter->read_ok;
-	else
-		target_okbits = filter->write_ok;
-
-	memmove(target_okbits, okbits, sizeof(okbits));
+	memcpy(target_okbits, okbits, sizeof(okbits));
 	return count;
 }

----
attached in case gmail breaks it again

------=_Part_27694_13597530.1218276578665
Content-Type: application/octet-stream; name=cmd-filter-new-iface.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjo2d6sp0
Content-Disposition: attachment; filename=cmd-filter-new-iface.patch

VGhpcyBwYXRjaCBjaGFuZ2VzIHRoZSBpbnRlcmZhY2Ugb2YgdGhlIGNtZCBmaWx0ZXIgdG8gdXNl
IGEgKy8tIG5vdGF0aW9uIGxpa2U6CmVjaG8gLS0gKzB4MDIgKzB4MDMgLTB4MDgKSWYgbmVpdGhl
ciArIG9yIC0gaXMgZ2l2ZW4gaXQgZGVmYXVsdHMgdG8gKyAoYWxsb3cgY29tbWFuZCkuCgpOb3Rl
OiBUaGUgaW50ZXJmYWNlIHdhcyBhZGRlZCBpbiAyLjYuMTctcmMxIGFuZCBpcyB1bnVzZWQKYW5k
IHVuZG9jdW1lbnRlZCBzbyBmYXIgc28gaXQncyBzYWZlIHRvIGNoYW5nZSBpdC4KCkNjOiBtYXR0
aGV3QHdpbC5jeApDYzogZnVqaXRhLnRvbW9ub3JpQGxhYi5udHQuY28uanAKQ2M6IGplbnMuYXhi
b2VAb3JhY2xlLmNvbQpDYzogSmFtZXMuQm90dG9tbGV5QGhhbnNlbnBhcnRuZXJzaGlwLmNvbQpD
YzogZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tCkNjOiBwam9uZXNAcmVkaGF0LmNvbQpDYzogdmly
b0B6ZW5pdi5saW51eC5vcmcudWsKQ2M6IGRvdWdnQHRvcnF1ZS5uZXQKU2lnbmVkLW9mZi1ieTog
QWRlbCBHYWRsbGFoIDxhZGVsLmdhZGxsYWhAZ21haWwuY29tPgoKIGJsb2NrL2NtZC1maWx0ZXIu
YyB8ICAgNTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCiAxIGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKyksIDI0IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2Jsb2NrL2NtZC1maWx0ZXIuYyBiL2Jsb2NrL2NtZC1maWx0ZXIuYwppbmRl
eCBlZWM0NDA0Li5lNTE2NDhjIDEwMDY0NAotLS0gYS9ibG9jay9jbWQtZmlsdGVyLmMKKysrIGIv
YmxvY2svY21kLWZpbHRlci5jCkBAIC0yMCw3ICsyMCw2IEBACiAjaW5jbHVkZSA8bGludXgvbGlz
dC5oPgogI2luY2x1ZGUgPGxpbnV4L2dlbmhkLmg+CiAjaW5jbHVkZSA8bGludXgvc3BpbmxvY2su
aD4KLSNpbmNsdWRlIDxsaW51eC9wYXJzZXIuaD4KICNpbmNsdWRlIDxsaW51eC9jYXBhYmlsaXR5
Lmg+CiAjaW5jbHVkZSA8bGludXgvYml0b3BzLmg+CiAKQEAgLTg0LDggKzgzLDcgQEAgc3RhdGlj
IHNzaXplX3QgcmNmX2NtZHNfc2hvdyhzdHJ1Y3QgYmxrX3Njc2lfY21kX2ZpbHRlciAqZmlsdGVy
LCBjaGFyICpwYWdlLAogCiAJZm9yIChpID0gMDsgaSA8IEJMS19TQ1NJX01BWF9DTURTOyBpKysp
IHsKIAkJaWYgKHRlc3RfYml0KGksIG9rYml0cykpIHsKLQkJCXNwcmludGYobnBhZ2UsICIlMDJ4
IiwgaSk7Ci0JCQlucGFnZSArPSAyOworCQkJbnBhZ2UgKz0gc3ByaW50ZihucGFnZSwgIjB4JTAy
eCIsIGkpOwogCQkJaWYgKGkgPCBCTEtfU0NTSV9NQVhfQ01EUyAtIDEpCiAJCQkJc3ByaW50Zihu
cGFnZSsrLCAiICIpOwogCQl9CkBAIC0xMTEsMzMgKzEwOSw0MSBAQCBzdGF0aWMgc3NpemVfdCBy
Y2Zfd3JpdGVjbWRzX3Nob3coc3RydWN0IGJsa19zY3NpX2NtZF9maWx0ZXIgKmZpbHRlciwKIHN0
YXRpYyBzc2l6ZV90IHJjZl9jbWRzX3N0b3JlKHN0cnVjdCBibGtfc2NzaV9jbWRfZmlsdGVyICpm
aWx0ZXIsCiAJCQkgICAgICBjb25zdCBjaGFyICpwYWdlLCBzaXplX3QgY291bnQsIGludCBydykK
IHsKLQlzc2l6ZV90IHJldCA9IDA7CiAJdW5zaWduZWQgbG9uZyBva2JpdHNbQkxLX1NDU0lfQ01E
X1BFUl9MT05HXSwgKnRhcmdldF9va2JpdHM7Ci0JaW50IGNtZCwgc3RhdHVzLCBsZW47Ci0Jc3Vi
c3RyaW5nX3Qgc3M7Ci0KLQltZW1zZXQoJm9rYml0cywgMCwgc2l6ZW9mKG9rYml0cykpOwotCi0J
Zm9yIChsZW4gPSBzdHJsZW4ocGFnZSk7IGxlbiA+IDA7IGxlbiAtPSAzKSB7Ci0JCWlmIChsZW4g
PCAyKQotCQkJYnJlYWs7Ci0JCXNzLmZyb20gPSAoY2hhciAqKSBwYWdlICsgcmV0OwotCQlzcy50
byA9IChjaGFyICopIHBhZ2UgKyByZXQgKyAyOwotCQlyZXQgKz0gMzsKLQkJc3RhdHVzID0gbWF0
Y2hfaGV4KCZzcywgJmNtZCk7CisJaW50IGNtZCwgc2V0OworCWNoYXIgKnAsICpzdGF0dXM7CisK
KwlpZiAocncgPT0gUkVBRCkgeworCQltZW1jcHkoJm9rYml0cywgZmlsdGVyLT5yZWFkX29rLCBz
aXplb2Yob2tiaXRzKSk7CisJCXRhcmdldF9va2JpdHMgPSBmaWx0ZXItPnJlYWRfb2s7CisJfSBl
bHNlIHsKKwkJbWVtY3B5KCZva2JpdHMsIGZpbHRlci0+d3JpdGVfb2ssIHNpemVvZihva2JpdHMp
KTsKKwkJdGFyZ2V0X29rYml0cyA9IGZpbHRlci0+d3JpdGVfb2s7CisJfQorCisJd2hpbGUgKChw
ID0gc3Ryc2VwKChjaGFyICoqKSZwYWdlLCAiICIpKSAhPSBOVUxMKSB7CisJCXNldCA9IDE7CisK
KwkJaWYgKHBbMF0gPT0gJysnKSB7CisJCQlwKys7CisJCX0gZWxzZSBpZiAocFswXSA9PSAnLScp
IHsKKwkJCXNldCA9IDA7CisJCQlwKys7CisJCX0KKworCQljbWQgPSBzaW1wbGVfc3RydG9sKHAs
ICZzdGF0dXMsIDE2KTsKKwogCQkvKiBlaXRoZXIgb2YgdGhlc2UgY2FzZXMgbWVhbnMgaW52YWxp
ZCBpbnB1dCwgc28gZG8gbm90aGluZy4gKi8KLQkJaWYgKHN0YXR1cyB8fCBjbWQgPj0gQkxLX1ND
U0lfTUFYX0NNRFMpCisJCWlmICgoc3RhdHVzID09IHApIHx8IGNtZCA+PSBCTEtfU0NTSV9NQVhf
Q01EUykKIAkJCXJldHVybiAtRUlOVkFMOwogCi0JCV9fc2V0X2JpdChjbWQsIG9rYml0cyk7CisJ
CWlmIChzZXQpCisJCQlfX3NldF9iaXQoY21kLCBva2JpdHMpOworCQllbHNlCisJCQlfX2NsZWFy
X2JpdChjbWQsIG9rYml0cyk7CiAJfQogCi0JaWYgKHJ3ID09IFJFQUQpCi0JCXRhcmdldF9va2Jp
dHMgPSBmaWx0ZXItPnJlYWRfb2s7Ci0JZWxzZQotCQl0YXJnZXRfb2tiaXRzID0gZmlsdGVyLT53
cml0ZV9vazsKLQotCW1lbW1vdmUodGFyZ2V0X29rYml0cywgb2tiaXRzLCBzaXplb2Yob2tiaXRz
KSk7CisJbWVtY3B5KHRhcmdldF9va2JpdHMsIG9rYml0cywgc2l6ZW9mKG9rYml0cykpOwogCXJl
dHVybiBjb3VudDsKIH0KIAo=
------=_Part_27694_13597530.1218276578665--
