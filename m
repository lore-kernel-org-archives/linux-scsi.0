From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 16:43:18 -0500
Message-ID: <44528C76.2010006@us.ibm.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>	 <44522672.5010607@us.ibm.com>	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>	 <44525CBE.1030409@us.ibm.com>	 <1146249006.5251.64.camel@mulgrave.il.steeleye.com>	 <44526702.1010400@us.ibm.com> <1146257803.5251.82.camel@mulgrave.il.steeleye.com> <44528508.3060003@us.ibm.com> <445289F5.6070608@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040006040102080207070502"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:65248 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751376AbWD1Vn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 17:43:27 -0400
In-Reply-To: <445289F5.6070608@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.
--------------040006040102080207070502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Brian King wrote:
>> Going along with that argument, there's really no good reason for
>> libata to be playing games with scsi_host->max_cmd_len based on
>> the attached devices.
> 
> If both host controller and device support 16-byte CDB, it should not be 
> limited to 12 bytes.

Agreed.

> libata is not "playing games", just exporting what the hardware supports 
> as best the API allows.  It needs to support 16-byte CDBs for the same 
> reason any SCSI LLDD supports 16-byte CDBs.
> 
> Remember ATAPI<->SCSI bridges exist, thus any SCSI disk can appear 
> attached to ATAPI.

The libata code in question is the code that changes
scsi_host->max_cmd_len based on what the attached devices support.
I propose the following patch. This patch is untested.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------040006040102080207070502
Content-Type: text/x-patch;
 name="libata_max_cmd_len.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="libata_max_cmd_len.patch"

CgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLaW5nIDxicmtpbmdAdXMuaWJtLmNvbT4KLS0tCgog
bGliYXRhLWRldi1iamtpbmcxL2RyaXZlcnMvc2NzaS9saWJhdGEtY29yZS5jIHwgICAgOCAr
LS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNyBkZWxldGlvbnMo
LSkKCmRpZmYgLXB1TiBkcml2ZXJzL3Njc2kvbGliYXRhLWNvcmUuY35saWJhdGFfbWF4X2Nt
ZF9sZW4gZHJpdmVycy9zY3NpL2xpYmF0YS1jb3JlLmMKLS0tIGxpYmF0YS1kZXYvZHJpdmVy
cy9zY3NpL2xpYmF0YS1jb3JlLmN+bGliYXRhX21heF9jbWRfbGVuCTIwMDYtMDQtMjggMTY6
MzQ6MTYuMDAwMDAwMDAwIC0wNTAwCisrKyBsaWJhdGEtZGV2LWJqa2luZzEvZHJpdmVycy9z
Y3NpL2xpYmF0YS1jb3JlLmMJMjAwNi0wNC0yOCAxNjozNDo0MC4wMDAwMDAwMDAgLTA1MDAK
QEAgLTEzMjgsMTIgKzEzMjgsNiBAQCBzdGF0aWMgaW50IGF0YV9kZXZfY29uZmlndXJlKHN0
cnVjdCBhdGFfCiAJCQkgICAgICAgYXAtPmlkLCBkZXYtPmRldm5vLCBhdGFfbW9kZV9zdHJp
bmcoeGZlcl9tYXNrKSk7CiAJfQogCi0JYXAtPmhvc3QtPm1heF9jbWRfbGVuID0gMDsKLQlm
b3IgKGkgPSAwOyBpIDwgQVRBX01BWF9ERVZJQ0VTOyBpKyspCi0JCWFwLT5ob3N0LT5tYXhf
Y21kX2xlbiA9IG1heF90KHVuc2lnbmVkIGludCwKLQkJCQkJICAgICAgYXAtPmhvc3QtPm1h
eF9jbWRfbGVuLAotCQkJCQkgICAgICBhcC0+ZGV2aWNlW2ldLmNkYl9sZW4pOwotCiAJLyog
bGltaXQgYnJpZGdlIHRyYW5zZmVycyB0byB1ZG1hNSwgMjAwIHNlY3RvcnMgKi8KIAlpZiAo
YXRhX2Rldl9rbm9iYmxlKGFwLCBkZXYpKSB7CiAJCWlmIChwcmludF9pbmZvKQpAQCAtNDU3
Myw3ICs0NTY3LDcgQEAgc3RhdGljIHZvaWQgYXRhX2hvc3RfaW5pdChzdHJ1Y3QgYXRhX3Bv
cgogCWhvc3QtPm1heF9sdW4gPSAxOwogCWhvc3QtPm1heF9jaGFubmVsID0gMTsKIAlob3N0
LT51bmlxdWVfaWQgPSBhdGFfdW5pcXVlX2lkKys7Ci0JaG9zdC0+bWF4X2NtZF9sZW4gPSAx
MjsKKwlob3N0LT5tYXhfY21kX2xlbiA9IEFUQVBJX0NEQl9MRU47CiAKIAlhcC0+ZmxhZ3Mg
PSBBVEFfRkxBR19ESVNBQkxFRDsKIAlhcC0+aWQgPSBob3N0LT51bmlxdWVfaWQ7Cl8K
--------------040006040102080207070502--
