From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 06/15] libata: Stop using host->max_cmd_len
Date: Wed, 22 Mar 2006 17:29:16 -0600
Message-ID: <4421DDCC.3@us.ibm.com>
References: <200603172304.k2HN4YEF019986@d03av01.boulder.ibm.com> <4420B05B.6090702@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020305030605050309020408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:28293 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932539AbWCVX3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 18:29:39 -0500
In-Reply-To: <4420B05B.6090702@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020305030605050309020408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Brian King wrote:
>> In preparation for SAS attached SATA devices, quit using
>> the max_cmd_len in the scsi_host struct.
>>
>> Signed-off-by: Brian King <brking@us.ibm.com>
> 
> I see this as a bit of a hack.  In general, its best to inform upper 
> layers of known limits as soon as possible.  For the non-SAS case, for 
> that point of view, this patch is a regression.
> 
> 	Jeff

Is the patch below ok? Then I'll add the cdb_len checking in the SAS
unique queuecommand entry point. This would still be a hack, but it wouldn't
be a regression for the non-SAS case. The other option I see would be to
add a max_cmd_len to the scsi_device which scsi core would check.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------020305030605050309020408
Content-Type: text/x-patch;
 name="libata_cdb_len.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="libata_cdb_len.patch"

CkluIHByZXBhcmF0aW9uIGZvciBTQVMgYXR0YWNoZWQgU0FUQSBkZXZpY2VzLCB3aGljaCB3
aWxsCm5vdCBoYXZlIGEgbGliYXRhIHNjc2lfaG9zdCwgb25seSBzZXR1cCBob3N0LT5tYXhf
Y21kX2xlbgppZiBhcC0+aG9zdCBleGlzdHMuCgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLaW5n
IDxicmtpbmdAdXMuaWJtLmNvbT4KLS0tCgogbGliYXRhLWRldi1iamtpbmcxL2RyaXZlcnMv
c2NzaS9saWJhdGEtY29yZS5jIHwgICAxMiArKysrKysrLS0tLS0KIDEgZmlsZXMgY2hhbmdl
ZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtcHVOIGRyaXZlcnMv
c2NzaS9saWJhdGEtY29yZS5jfmxpYmF0YV9jZGJfbGVuIGRyaXZlcnMvc2NzaS9saWJhdGEt
Y29yZS5jCi0tLSBsaWJhdGEtZGV2L2RyaXZlcnMvc2NzaS9saWJhdGEtY29yZS5jfmxpYmF0
YV9jZGJfbGVuCTIwMDYtMDMtMjIgMTE6MjU6MjUuMDAwMDAwMDAwIC0wNjAwCisrKyBsaWJh
dGEtZGV2LWJqa2luZzEvZHJpdmVycy9zY3NpL2xpYmF0YS1jb3JlLmMJMjAwNi0wMy0yMiAx
MToyNToyNS4wMDAwMDAwMDAgLTA2MDAKQEAgLTEzMDEsMTEgKzEzMDEsMTMgQEAgc3RhdGlj
IGludCBhdGFfZGV2X2NvbmZpZ3VyZShzdHJ1Y3QgYXRhXwogCQkJICAgICAgIGFwLT5pZCwg
ZGV2LT5kZXZubywgYXRhX21vZGVfc3RyaW5nKHhmZXJfbWFzaykpOwogCX0KIAotCWFwLT5o
b3N0LT5tYXhfY21kX2xlbiA9IDA7Ci0JZm9yIChpID0gMDsgaSA8IEFUQV9NQVhfREVWSUNF
UzsgaSsrKQotCQlhcC0+aG9zdC0+bWF4X2NtZF9sZW4gPSBtYXhfdCh1bnNpZ25lZCBpbnQs
Ci0JCQkJCSAgICAgIGFwLT5ob3N0LT5tYXhfY21kX2xlbiwKLQkJCQkJICAgICAgYXAtPmRl
dmljZVtpXS5jZGJfbGVuKTsKKwlpZiAoYXAtPmhvc3QpIHsKKwkJYXAtPmhvc3QtPm1heF9j
bWRfbGVuID0gMDsKKwkJZm9yIChpID0gMDsgaSA8IEFUQV9NQVhfREVWSUNFUzsgaSsrKQor
CQkJYXAtPmhvc3QtPm1heF9jbWRfbGVuID0gbWF4X3QodW5zaWduZWQgaW50LAorCQkJCQkJ
ICAgICAgYXAtPmhvc3QtPm1heF9jbWRfbGVuLAorCQkJCQkJICAgICAgYXAtPmRldmljZVtp
XS5jZGJfbGVuKTsKKwl9CiAKIAkvKiBsaW1pdCBicmlkZ2UgdHJhbnNmZXJzIHRvIHVkbWE1
LCAyMDAgc2VjdG9ycyAqLwogCWlmIChhdGFfZGV2X2tub2JibGUoYXAsIGRldikpIHsKXwo=
--------------020305030605050309020408--
