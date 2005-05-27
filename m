From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 09:10:58 -0500
Message-ID: <42972A72.8060600@us.ibm.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org> <4296FA61.4010003@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050000010206040903040807"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:14269 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261449AbVE0OLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 10:11:05 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4REB1Lc018209
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 10:11:02 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4REB1RS099830
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 10:11:01 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4REB0Bs032425
	for <linux-scsi@vger.kernel.org>; Fri, 27 May 2005 10:11:01 -0400
In-Reply-To: <4296FA61.4010003@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050000010206040903040807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Christoph Hellwig wrote:
> 
>>On Fri, May 27, 2005 at 04:37:29AM -0400, Jeff Garzik wrote:
>>
>>
>>>Christoph Hellwig wrote:
>>>
>>>
>>>>You can sleep in them.  You must however release the host lock and enable
>>>>irqs first and reverse that before returning.  The error handlers don't
>>>>need the host lock, but we're stuck with the unfortunate calling convention
>>>>for now.
>>>
>>>Why are we stuck with this calling convention, when everyone who cares 
>>>circumvents it?
>>
>>
>>Because no one found the time to do a full transition yet.  If you want to
>>update all scsi drivers feel free.  One patch per method please.
> 
> 

Jeff,

Please add the following patch to your eh_abort locking patch for the ipr driver.
It fixes a race condition your patch would introduce. Thanks.

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------050000010206040903040807
Content-Type: text/plain;
 name="ipr_abort_locking.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ipr_abort_locking.patch"

CgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLaW5nIDxicmtpbmdAdXMuaWJtLmNvbT4KLS0tCgog
bGludXgtMi42LjEyLXJjNS1iamtpbmcxL2RyaXZlcnMvc2NzaS9pcHIuYyB8ICAgMTcgKysr
KystLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLXB1TiBkcml2ZXJzL3Njc2kvaXByLmN+aXByX2Fib3J0X2xv
Y2tpbmcgZHJpdmVycy9zY3NpL2lwci5jCi0tLSBsaW51eC0yLjYuMTItcmM1L2RyaXZlcnMv
c2NzaS9pcHIuY35pcHJfYWJvcnRfbG9ja2luZwkyMDA1LTA1LTI3IDA4OjU3OjQ5LjAwMDAw
MDAwMCAtMDUwMAorKysgbGludXgtMi42LjEyLXJjNS1iamtpbmcxL2RyaXZlcnMvc2NzaS9p
cHIuYwkyMDA1LTA1LTI3IDA5OjAwOjQ4LjAwMDAwMDAwMCAtMDUwMApAQCAtMzA2OSw2ICsz
MDY5LDExIEBAIHN0YXRpYyBpbnQgaXByX2NhbmNlbF9vcChzdHJ1Y3Qgc2NzaV9jbW4KIAlp
b2FfY2ZnID0gKHN0cnVjdCBpcHJfaW9hX2NmZyAqKXNjc2lfY21kLT5kZXZpY2UtPmhvc3Qt
Pmhvc3RkYXRhOwogCXJlcyA9IHNjc2lfY21kLT5kZXZpY2UtPmhvc3RkYXRhOwogCisJLyog
SWYgd2UgYXJlIGN1cnJlbnRseSBnb2luZyB0aHJvdWdoIHJlc2V0L3JlbG9hZCwgcmV0dXJu
IGZhaWxlZC4gVGhpcyB3aWxsIGZvcmNlIHRoZQorCSAgIG1pZC1sYXllciB0byBjYWxsIGlw
cl9laF9ob3N0X3Jlc2V0LCB3aGljaCB3aWxsIHRoZW4gZ28gdG8gc2xlZXAgYW5kIHdhaXQg
Zm9yIHRoZQorCSAgIHJlc2V0IHRvIGNvbXBsZXRlICovCisJaWYgKGlvYV9jZmctPmluX3Jl
c2V0X3JlbG9hZCB8fCBpb2FfY2ZnLT5pb2FfaXNfZGVhZCkKKwkJcmV0dXJuIEZBSUxFRDsK
IAlpZiAoIXJlcyB8fCAoIWlwcl9pc19nc2NzaShyZXMpICYmICFpcHJfaXNfdnNldF9kZXZp
Y2UocmVzKSkpCiAJCXJldHVybiBGQUlMRUQ7CiAKQEAgLTMxMTksMjIgKzMxMjQsMTAgQEAg
c3RhdGljIGludCBpcHJfY2FuY2VsX29wKHN0cnVjdCBzY3NpX2NtbgogICoqLwogc3RhdGlj
IGludCBpcHJfZWhfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqIHNjc2lfY21kKQogewotCXN0
cnVjdCBpcHJfaW9hX2NmZyAqaW9hX2NmZzsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCWlu
dCByYzsKIAogCUVOVEVSOwotCWlvYV9jZmcgPSAoc3RydWN0IGlwcl9pb2FfY2ZnICopIHNj
c2lfY21kLT5kZXZpY2UtPmhvc3QtPmhvc3RkYXRhOwotCi0JLyogSWYgd2UgYXJlIGN1cnJl
bnRseSBnb2luZyB0aHJvdWdoIHJlc2V0L3JlbG9hZCwgcmV0dXJuIGZhaWxlZC4gVGhpcyB3
aWxsIGZvcmNlIHRoZQotCSAgIG1pZC1sYXllciB0byBjYWxsIGlwcl9laF9ob3N0X3Jlc2V0
LCB3aGljaCB3aWxsIHRoZW4gZ28gdG8gc2xlZXAgYW5kIHdhaXQgZm9yIHRoZQotCSAgIHJl
c2V0IHRvIGNvbXBsZXRlICovCi0JaWYgKGlvYV9jZmctPmluX3Jlc2V0X3JlbG9hZCkKLQkJ
cmV0dXJuIEZBSUxFRDsKLQlpZiAoaW9hX2NmZy0+aW9hX2lzX2RlYWQpCi0JCXJldHVybiBG
QUlMRUQ7Ci0JaWYgKCFzY3NpX2NtZC0+ZGV2aWNlLT5ob3N0ZGF0YSkKLQkJcmV0dXJuIEZB
SUxFRDsKIAogCXNwaW5fbG9ja19pcnFzYXZlKHNjc2lfY21kLT5kZXZpY2UtPmhvc3QtPmhv
c3RfbG9jaywgZmxhZ3MpOwogCXJjID0gaXByX2NhbmNlbF9vcChzY3NpX2NtZCk7Cl8K
--------------050000010206040903040807--
