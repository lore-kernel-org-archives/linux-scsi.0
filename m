From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Fri, 29 Apr 2016 14:49:13 +0200
Message-ID: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1137bac80cf94a05319f13cf
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36493 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbcD2Mtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 08:49:33 -0400
Received: by mail-oi0-f45.google.com with SMTP id x201so117015204oif.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2016 05:49:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

--001a1137bac80cf94a05319f13cf
Content-Type: text/plain; charset=UTF-8

Hi, all

We hit IO error on fsync, it turns out was because sd treat succeeded
SYNC as error. From what I checked in SBC spec there is no indication
we should fail IO in this case, so we create this patch.


Best Regards,

Jack Wang

v2:
No change on patch itself, only resend in body as suggested by Bart,
still keep the attachment in case mail client break the format.

>From 5d1f72d9643ce61cd9f3d312377378c43f171d0c Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang@profitbricks.com>
Date: Mon, 25 Apr 2016 12:05:22 +0200
Subject: [PATCH] sd: Don't treat succeeded SYNC as error

We hit IO error in our production on multipath devices during resize
device on target side, the problem turns out sd driver passes up as IO
error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
Capacity data has changed, even storage side sync the data properly.

In order to fix this check in sd_done, report success if condition
matches.

Sebastian Parschauer report/analyze the bug here:
https://sourceforge.net/p/scst/mailman/message/34953416/

Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/sd.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a5457a..e9bfe01 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1833,6 +1833,19 @@ static int sd_done(struct scsi_cmnd *SCpnt)
  }
  }
  break;
+ case UNIT_ATTENTION:
+ /* Capacity data has changed */
+ if (sshdr.asc == 0x2a && sshdr.ascq == 0x09) {
+ switch (op) {
+ /* don't treat succeeded fsync() as error */
+ case SYNCHRONIZE_CACHE:
+ case SYNCHRONIZE_CACHE_16:
+ if (good_bytes == scsi_bufflen(SCpnt))
+ SCpnt->result = 0;
+ break;
+ }
+ }
+ break;
  default:
  break;
  }
-- 
1.9.1

--001a1137bac80cf94a05319f13cf
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-sd-Don-t-treat-succeeded-SYNC-as-error.patch"
Content-Disposition: attachment;
	filename="0001-sd-Don-t-treat-succeeded-SYNC-as-error.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_inlprkp90

RnJvbSA1ZDFmNzJkOTY0M2NlNjFjZDlmM2QzMTIzNzczNzhjNDNmMTcxZDBjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAyNSBBcHIgMjAxNiAxMjowNToyMiArMDIwMApTdWJqZWN0OiBbUEFUQ0hd
IHNkOiBEb24ndCB0cmVhdCBzdWNjZWVkZWQgU1lOQyBhcyBlcnJvcgoKV2UgaGl0IElPIGVycm9y
IGluIG91ciBwcm9kdWN0aW9uIG9uIG11bHRpcGF0aCBkZXZpY2VzIGR1cmluZyByZXNpemUKZGV2
aWNlIG9uIHRhcmdldCBzaWRlLCB0aGUgcHJvYmxlbSB0dXJucyBvdXQgc2QgZHJpdmVyIHBhc3Nl
cyB1cCBhcyBJTwplcnJvciB3aGVuIHNlbnNlIGRhdGEgaXMgVU5JVF9BVFRFTlRJT04gYW5kIEFT
QyAmJiBBU0NRIGluZGljYXRlCkNhcGFjaXR5IGRhdGEgaGFzIGNoYW5nZWQsIGV2ZW4gc3RvcmFn
ZSBzaWRlIHN5bmMgdGhlIGRhdGEgcHJvcGVybHkuCgpJbiBvcmRlciB0byBmaXggdGhpcyBjaGVj
ayBpbiBzZF9kb25lLCByZXBvcnQgc3VjY2VzcyBpZiBjb25kaXRpb24KbWF0Y2hlcy4KClNlYmFz
dGlhbiBQYXJzY2hhdWVyIHJlcG9ydC9hbmFseXplIHRoZSBidWcgaGVyZToKaHR0cHM6Ly9zb3Vy
Y2Vmb3JnZS5uZXQvcC9zY3N0L21haWxtYW4vbWVzc2FnZS8zNDk1MzQxNi8KClNpZ25lZC1vZmYt
Ynk6IFNlYmFzdGlhbiBQYXJzY2hhdWVyIDxzLnBhcnNjaGF1ZXJAZ214LmRlPgpTaWduZWQtb2Zm
LWJ5OiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNvbT4KLS0tCiBkcml2ZXJz
L3Njc2kvc2QuYyB8IDEzICsrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3NkLmMgYi9kcml2ZXJzL3Njc2kvc2Qu
YwppbmRleCA1YTU0NTdhLi5lOWJmZTAxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvc2QuYwor
KysgYi9kcml2ZXJzL3Njc2kvc2QuYwpAQCAtMTgzMyw2ICsxODMzLDE5IEBAIHN0YXRpYyBpbnQg
c2RfZG9uZShzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCkKIAkJCX0KIAkJfQogCQlicmVhazsKKwlj
YXNlIFVOSVRfQVRURU5USU9OOgorCQkvKiBDYXBhY2l0eSBkYXRhIGhhcyBjaGFuZ2VkICovCisJ
CWlmIChzc2hkci5hc2MgPT0gMHgyYSAmJiBzc2hkci5hc2NxID09IDB4MDkpIHsKKwkJCXN3aXRj
aCAob3ApIHsKKwkJCS8qIGRvbid0IHRyZWF0IHN1Y2NlZWRlZCBmc3luYygpIGFzIGVycm9yICov
CisJCQljYXNlIFNZTkNIUk9OSVpFX0NBQ0hFOgorCQkJY2FzZSBTWU5DSFJPTklaRV9DQUNIRV8x
NjoKKwkJCQlpZiAoZ29vZF9ieXRlcyA9PSBzY3NpX2J1ZmZsZW4oU0NwbnQpKQorCQkJCQlTQ3Bu
dC0+cmVzdWx0ID0gMDsKKwkJCQkJYnJlYWs7CisJCQl9CisJCX0KKwkJYnJlYWs7CiAJZGVmYXVs
dDoKIAkJYnJlYWs7CiAJfQotLSAKMS45LjEKCg==
--001a1137bac80cf94a05319f13cf--
