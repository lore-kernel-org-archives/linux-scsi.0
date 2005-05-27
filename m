From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 09:35:37 -0500
Message-ID: <42973039.30005@us.ibm.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com> <42972A72.8060600@us.ibm.com> <20050527141718.GD14929@parcelfarce.linux.theplanet.co.uk>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070901070506030702040305"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:12708 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261770AbVE0Ofz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 10:35:55 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4REZsv6014074
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 10:35:54 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4REZsX8124898
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 10:35:54 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4REZmWX014639
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 10:35:48 -0400
In-Reply-To: <20050527141718.GD14929@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070901070506030702040305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Matthew Wilcox wrote:
> On Fri, May 27, 2005 at 09:10:58AM -0500, Brian King wrote:
> 
>>diff -puN drivers/scsi/ipr.c~ipr_abort_locking drivers/scsi/ipr.c
>>--- linux-2.6.12-rc5/drivers/scsi/ipr.c~ipr_abort_locking	2005-05-27 08:57:49.000000000 -0500
>>+++ linux-2.6.12-rc5-bjking1/drivers/scsi/ipr.c	2005-05-27 09:00:48.000000000 -0500
>>@@ -3069,6 +3069,11 @@ static int ipr_cancel_op(struct scsi_cmn
>> 	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
>> 	res = scsi_cmd->device->hostdata;
>> 
>>+	/* If we are currently going through reset/reload, return failed. This will force the
>>+	   mid-layer to call ipr_eh_host_reset, which will then go to sleep and wait for the
>>+	   reset to complete */
>>+	if (ioa_cfg->in_reset_reload || ioa_cfg->ioa_is_dead)
>>+		return FAILED;
> 
> 
> I appreciate you've only moved this comment from elsewhere, but could
> you reformat it to fewer than 80 columns please?
> 

Here is a new patch with the comment changed to fit in 80 columns.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------070901070506030702040305
Content-Type: text/plain;
 name="ipr_abort_locking.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ipr_abort_locking.patch"

CgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLaW5nIDxicmtpbmdAdXMuaWJtLmNvbT4KLS0tCgog
bGludXgtMi42LjEyLXJjNS1iamtpbmcxL2RyaXZlcnMvc2NzaS9pcHIuYyB8ICAgMTkgKysr
KysrKy0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEy
IGRlbGV0aW9ucygtKQoKZGlmZiAtcHVOIGRyaXZlcnMvc2NzaS9pcHIuY35pcHJfYWJvcnRf
bG9ja2luZyBkcml2ZXJzL3Njc2kvaXByLmMKLS0tIGxpbnV4LTIuNi4xMi1yYzUvZHJpdmVy
cy9zY3NpL2lwci5jfmlwcl9hYm9ydF9sb2NraW5nCTIwMDUtMDUtMjcgMDg6NTc6NDkuMDAw
MDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMTItcmM1LWJqa2luZzEvZHJpdmVycy9zY3Np
L2lwci5jCTIwMDUtMDUtMjcgMDk6MzQ6MTcuMDAwMDAwMDAwIC0wNTAwCkBAIC0zMDY5LDYg
KzMwNjksMTMgQEAgc3RhdGljIGludCBpcHJfY2FuY2VsX29wKHN0cnVjdCBzY3NpX2Ntbgog
CWlvYV9jZmcgPSAoc3RydWN0IGlwcl9pb2FfY2ZnICopc2NzaV9jbWQtPmRldmljZS0+aG9z
dC0+aG9zdGRhdGE7CiAJcmVzID0gc2NzaV9jbWQtPmRldmljZS0+aG9zdGRhdGE7CiAKKwkv
KgorCSAqIElmIHdlIGFyZSBjdXJyZW50bHkgZ29pbmcgdGhyb3VnaCByZXNldC9yZWxvYWQs
IHJldHVybiBmYWlsZWQuCisJICogVGhpcyB3aWxsIGZvcmNlIHRoZSBtaWQtbGF5ZXIgdG8g
Y2FsbCBpcHJfZWhfaG9zdF9yZXNldCwgd2hpY2gKKwkgKiB3aWxsIHRoZW4gZ28gdG8gc2xl
ZXAgYW5kIHdhaXQgZm9yIHRoZSByZXNldCB0byBjb21wbGV0ZQorCSAqLworCWlmIChpb2Ff
Y2ZnLT5pbl9yZXNldF9yZWxvYWQgfHwgaW9hX2NmZy0+aW9hX2lzX2RlYWQpCisJCXJldHVy
biBGQUlMRUQ7CiAJaWYgKCFyZXMgfHwgKCFpcHJfaXNfZ3Njc2kocmVzKSAmJiAhaXByX2lz
X3ZzZXRfZGV2aWNlKHJlcykpKQogCQlyZXR1cm4gRkFJTEVEOwogCkBAIC0zMTE5LDIyICsz
MTI2LDEwIEBAIHN0YXRpYyBpbnQgaXByX2NhbmNlbF9vcChzdHJ1Y3Qgc2NzaV9jbW4KICAq
Ki8KIHN0YXRpYyBpbnQgaXByX2VoX2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKiBzY3NpX2Nt
ZCkKIHsKLQlzdHJ1Y3QgaXByX2lvYV9jZmcgKmlvYV9jZmc7CiAJdW5zaWduZWQgbG9uZyBm
bGFnczsKIAlpbnQgcmM7CiAKIAlFTlRFUjsKLQlpb2FfY2ZnID0gKHN0cnVjdCBpcHJfaW9h
X2NmZyAqKSBzY3NpX2NtZC0+ZGV2aWNlLT5ob3N0LT5ob3N0ZGF0YTsKLQotCS8qIElmIHdl
IGFyZSBjdXJyZW50bHkgZ29pbmcgdGhyb3VnaCByZXNldC9yZWxvYWQsIHJldHVybiBmYWls
ZWQuIFRoaXMgd2lsbCBmb3JjZSB0aGUKLQkgICBtaWQtbGF5ZXIgdG8gY2FsbCBpcHJfZWhf
aG9zdF9yZXNldCwgd2hpY2ggd2lsbCB0aGVuIGdvIHRvIHNsZWVwIGFuZCB3YWl0IGZvciB0
aGUKLQkgICByZXNldCB0byBjb21wbGV0ZSAqLwotCWlmIChpb2FfY2ZnLT5pbl9yZXNldF9y
ZWxvYWQpCi0JCXJldHVybiBGQUlMRUQ7Ci0JaWYgKGlvYV9jZmctPmlvYV9pc19kZWFkKQot
CQlyZXR1cm4gRkFJTEVEOwotCWlmICghc2NzaV9jbWQtPmRldmljZS0+aG9zdGRhdGEpCi0J
CXJldHVybiBGQUlMRUQ7CiAKIAlzcGluX2xvY2tfaXJxc2F2ZShzY3NpX2NtZC0+ZGV2aWNl
LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKIAlyYyA9IGlwcl9jYW5jZWxfb3Aoc2NzaV9j
bWQpOwpfCg==
--------------070901070506030702040305--
