From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 10890] Heavy iSCSI traffic triggers memory allocation complaints
 and system lockup
Date: Mon, 21 May 2012 10:59:19 -0500
Message-ID: <4FBA6657.1080808@cs.wisc.edu>
References: <bug-10890-11613@https.bugzilla.kernel.org/> <20120521154840.51A4611FD17@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050503070902010707080509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48565 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2EUP71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2012 11:59:27 -0400
In-Reply-To: <20120521154840.51A4611FD17@bugzilla.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050503070902010707080509
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/21/2012 10:48 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=10890
> 

Weird. I am just seeing this bz now. Could you try the patches in this
thread

https://lkml.org/lkml/2012/5/17/215

a long with the attached patch for iscsi? The patchset is for swap over
storage, but because we do not check for that case specifially I think
they will allow you to dip into the reserves in your setup.

--------------050503070902010707080509
Content-Type: text/plain; charset=UTF-8;
 name="0001-iscsi-Set-SOCK_MEMALLOC-for-access-to-PFMEMALLOC-res.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-iscsi-Set-SOCK_MEMALLOC-for-access-to-PFMEMALLOC-res.pa";
 filename*1="tch"

RnJvbSA5MTdkNTNmMTZkMWUyNmIxMmU5MGU1ZTE1ZGY3NmE3YThiZWUzNWU4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtlIENocmlzdGllIDxtaWNoYWVsY0Bjcy53aXNj
LmVkdT4KRGF0ZTogVGh1LCAzIE1heSAyMDEyIDEyOjM2OjE4IC0wNTAwClN1YmplY3Q6IFtQ
QVRDSCAxLzFdIGlzY3NpOiBTZXQgU09DS19NRU1BTExPQyBmb3IgYWNjZXNzIHRvIFBGTUVN
QUxMT0MKIHJlc2VydmVzCgpTZXQgU09DS19NRU1BTExPQyBvbiB0aGUgaXNjc2kgc29ja2V0
IHRvIGFsbG93IGFjY2VzcyB0byBQRk1FTUFMTE9DCnJlc2VydmVzIHRvIHByZXZlbnQgZGVh
ZGxvY2suCgpTaWduZWQtb2ZmLWJ5OiBNaWtlIENocmlzdGllIDxtaWNoYWVsY0Bjcy53aXNj
LmVkdT4KLS0tCiBkcml2ZXJzL3Njc2kvaXNjc2lfdGNwLmMgfCAgIDE4ICsrKysrKysrKysr
KystLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9pc2NzaV90Y3AuYyBiL2RyaXZlcnMv
c2NzaS9pc2NzaV90Y3AuYwppbmRleCA0NTNhNzQwLi43MzYwZjRjIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3Njc2kvaXNjc2lfdGNwLmMKKysrIGIvZHJpdmVycy9zY3NpL2lzY3NpX3RjcC5j
CkBAIC0zNzAsMTcgKzM3MCwyNCBAQCBzdGF0aWMgaW5saW5lIGludCBpc2NzaV9zd190Y3Bf
eG1pdF9xbGVuKHN0cnVjdCBpc2NzaV9jb25uICpjb25uKQogc3RhdGljIGludCBpc2NzaV9z
d190Y3BfcGR1X3htaXQoc3RydWN0IGlzY3NpX3Rhc2sgKnRhc2spCiB7CiAJc3RydWN0IGlz
Y3NpX2Nvbm4gKmNvbm4gPSB0YXNrLT5jb25uOwotCWludCByYzsKKwl1bnNpZ25lZCBsb25n
IHBmbGFncyA9IGN1cnJlbnQtPmZsYWdzOworCWludCByYyA9IDA7CisKKwljdXJyZW50LT5m
bGFncyB8PSBQRl9NRU1BTExPQzsKIAogCXdoaWxlIChpc2NzaV9zd190Y3BfeG1pdF9xbGVu
KGNvbm4pKSB7CiAJCXJjID0gaXNjc2lfc3dfdGNwX3htaXQoY29ubik7Ci0JCWlmIChyYyA9
PSAwKQotCQkJcmV0dXJuIC1FQUdBSU47CisJCWlmIChyYyA9PSAwKSB7CisJCQlyYyA9IC1F
QUdBSU47CisJCQlicmVhazsKKwkJfQogCQlpZiAocmMgPCAwKQotCQkJcmV0dXJuIHJjOwor
CQkJYnJlYWs7CisJCXJjID0gMDsKIAl9CiAKLQlyZXR1cm4gMDsKKwl0c2tfcmVzdG9yZV9m
bGFncyhjdXJyZW50LCBwZmxhZ3MsIFBGX01FTUFMTE9DKTsKKwlyZXR1cm4gcmM7CiB9CiAK
IC8qCkBAIC02NjUsNiArNjcyLDcgQEAgaXNjc2lfc3dfdGNwX2Nvbm5fYmluZChzdHJ1Y3Qg
aXNjc2lfY2xzX3Nlc3Npb24gKmNsc19zZXNzaW9uLAogCXNrLT5za19yZXVzZSA9IDE7CiAJ
c2stPnNrX3NuZHRpbWVvID0gMTUgKiBIWjsgLyogRklYTUU6IG1ha2UgaXQgY29uZmlndXJh
YmxlICovCiAJc2stPnNrX2FsbG9jYXRpb24gPSBHRlBfQVRPTUlDOworCXNrX3NldF9tZW1h
bGxvYyhzayk7CiAKIAlpc2NzaV9zd190Y3BfY29ubl9zZXRfY2FsbGJhY2tzKGNvbm4pOwog
CXRjcF9zd19jb25uLT5zZW5kcGFnZSA9IHRjcF9zd19jb25uLT5zb2NrLT5vcHMtPnNlbmRw
YWdlOwotLSAKMS43LjcuNgoK
--------------050503070902010707080509--
