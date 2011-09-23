From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes
 build error
Date: Fri, 23 Sep 2011 16:43:45 -0700
Message-ID: <CAA9_cmcJv_A4SgpGFMpwBYLJ8NEzHKw-LOnQwWKFZRTTLRCO5Q@mail.gmail.com>
References: <4E7D0BAA.3080900@xenotime.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf300fb08d4fce8804ada461a6
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44512 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1IWXnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 19:43:46 -0400
Received: by qyk30 with SMTP id 30so7795184qyk.19
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2011 16:43:45 -0700 (PDT)
In-Reply-To: <4E7D0BAA.3080900@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Andrew Morton <akpm@linux-foundation.org>, intel-linux-scu@intel.com, Linus Torvalds <torvalds@linux-foundation.org>

--20cf300fb08d4fce8804ada461a6
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 23, 2011 at 3:43 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> SCSI_ISCI needs to select SCSI_SAS_HOST_SMP to ensure that all
> needed symbols are available to it.
>
> Fixes this build error:
> ERROR: "try_test_sas_gpio_gp_bit" [drivers/scsi/isci/isci.ko] undefined!
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks Randy!

Here's a replacement patch (also attached), that just stubs out that
routine in the !SCSI_SAS_HOST_SMP case.

>From 645ea60066251c2728197bf7a1048d885626936f Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Sep 2011 16:28:53 -0700
Subject: [PATCH] libsas: fix try_test_sas_gpio_gp_bit() build error

If the user has disabled CONFIG_SCSI_SAS_HOST_SMP then libsas drivers
will not be receiving smp-gpio frames and do not need this lookup code.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/scsi/libsas.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 44f5634..0d78bfa 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -407,7 +407,14 @@ static inline unsigned int to_sas_gpio_od(int
device, int bit)
 	return 3 * device + bit;
 }

+#ifdef CONFIG_SCSI_SAS_HOST_SMP
 int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data, u8 index, u8 count);
+#else
+static inline int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data,
u8 index, u8 count)
+{
+	return -1;
+}
+#endif

 /* ---------- Tasks ---------- */
 /*
-- 
1.7.6

--20cf300fb08d4fce8804ada461a6
Content-Type: application/octet-stream;
	name="0001-libsas-fix-try_test_sas_gpio_gp_bit-build-error.patch"
Content-Disposition: attachment;
	filename="0001-libsas-fix-try_test_sas_gpio_gp_bit-build-error.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsxtehm30

RnJvbSA2NDVlYTYwMDY2MjUxYzI3MjgxOTdiZjdhMTA0OGQ4ODU2MjY5MzZmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNv
bT4KRGF0ZTogRnJpLCAyMyBTZXAgMjAxMSAxNjoyODo1MyAtMDcwMApTdWJqZWN0OiBbUEFUQ0hd
IGxpYnNhczogZml4IHRyeV90ZXN0X3Nhc19ncGlvX2dwX2JpdCgpIGJ1aWxkIGVycm9yCgpJZiB0
aGUgdXNlciBoYXMgZGlzYWJsZWQgQ09ORklHX1NDU0lfU0FTX0hPU1RfU01QIHRoZW4gbGlic2Fz
IGRyaXZlcnMKd2lsbCBub3QgYmUgcmVjZWl2aW5nIHNtcC1ncGlvIGZyYW1lcyBhbmQgZG8gbm90
IG5lZWQgdGhpcyBsb29rdXAgY29kZS4KClJlcG9ydGVkLWJ5OiBSYW5keSBEdW5sYXAgPHJkdW5s
YXBAeGVub3RpbWUubmV0PgpTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxp
YW1zQGludGVsLmNvbT4KLS0tCiBpbmNsdWRlL3Njc2kvbGlic2FzLmggfCAgICA3ICsrKysrKysK
IDEgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvc2NzaS9saWJzYXMuaCBiL2luY2x1ZGUvc2NzaS9saWJzYXMuaAppbmRl
eCA0NGY1NjM0Li4wZDc4YmZhIDEwMDY0NAotLS0gYS9pbmNsdWRlL3Njc2kvbGlic2FzLmgKKysr
IGIvaW5jbHVkZS9zY3NpL2xpYnNhcy5oCkBAIC00MDcsNyArNDA3LDE0IEBAIHN0YXRpYyBpbmxp
bmUgdW5zaWduZWQgaW50IHRvX3Nhc19ncGlvX29kKGludCBkZXZpY2UsIGludCBiaXQpCiAJcmV0
dXJuIDMgKiBkZXZpY2UgKyBiaXQ7CiB9CiAKKyNpZmRlZiBDT05GSUdfU0NTSV9TQVNfSE9TVF9T
TVAKIGludCB0cnlfdGVzdF9zYXNfZ3Bpb19ncF9iaXQodW5zaWduZWQgaW50IG9kLCB1OCAqZGF0
YSwgdTggaW5kZXgsIHU4IGNvdW50KTsKKyNlbHNlCitzdGF0aWMgaW5saW5lIGludCB0cnlfdGVz
dF9zYXNfZ3Bpb19ncF9iaXQodW5zaWduZWQgaW50IG9kLCB1OCAqZGF0YSwgdTggaW5kZXgsIHU4
IGNvdW50KQoreworCXJldHVybiAtMTsKK30KKyNlbmRpZgogCiAvKiAtLS0tLS0tLS0tIFRhc2tz
IC0tLS0tLS0tLS0gKi8KIC8qCi0tIAoxLjcuNgoK
--20cf300fb08d4fce8804ada461a6--
