From: Brian King <brking@us.ibm.com>
Subject: Re: Fw: SCSI device not spinning up on rw
Date: Mon, 05 Jun 2006 13:04:46 -0500
Message-ID: <4484723E.7060906@us.ibm.com>
References: <20060603182302.7136831f.akpm@osdl.org> <44825D9F.9070305@torque.net> <44835AA2.1070809@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030009000106030900090808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:16852 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751263AbWFESEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2006 14:04:55 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k55I4njh018325
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jun 2006 14:04:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k55I4nxD161620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jun 2006 14:04:49 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k55I4nU8003974
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jun 2006 14:04:49 -0400
In-Reply-To: <44835AA2.1070809@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: dougg@torque.net, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Ruben Faelens <parasietje@gmail.com>

This is a multi-part message in MIME format.
--------------030009000106030900090808
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Brian King wrote:
> Douglas Gilbert wrote:
>>> I have a SCSI disk, which I want to spin down when the system is not in
>>> use. I do this by using sdparm, scsi-spin or sg-utils. These tools all
>>> spin down the SCSI drive by using an IOCTL.
>>>
>>> Problem is that the kernel doesn't spin the drive back up. When a
>>> process requests data from the disk (a simple ls), the kernel responds
>>> with an I/O error. After some of these errors, reiserfs marks the drive
>>> read-only.
> 
> Setting sdev->allow_restart in struct scsi_device will cause sense
> key/code/qual of 02/04/02 (not ready, initialization command required)
> to wake up the scsi error handler and will force scsi core to issue
> a start unit command to the disk. I added this a while back to handle
> ipr raid arrays which need a start unit command each time the adapter
> gets reset. It would be easy enough for sd to use this, either
> all the time, or only when directed to, or we could add a sysfs attribute
> to the disk to enable/disable this behavior.

Please try the attached patch. It adds a sysfs device attribute "allow_restart".
If you set it to 1, then scsi core will issue a start unit when it sees 02/04/02
sense data. The attribute is in the same place as the FUA and cache_type
attributes (eg. /sys/block/sdc/device/scsi_disk:1:1:9:0/allow_restart). 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------030009000106030900090808
Content-Type: text/x-patch;
 name="sd_allow_restart_sysfs_attr.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sd_allow_restart_sysfs_attr.patch"

CgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBLaW5nIDxicmtpbmdAdXMuaWJtLmNvbT4KLS0tCgog
bGludXgtMi42LWJqa2luZzEvZHJpdmVycy9zY3NpL3NkLmMgfCAgIDI2ICsrKysrKysrKysr
KysrKysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKykKCmRp
ZmYgLXB1TiBkcml2ZXJzL3Njc2kvc2QuY35zZF9hbGxvd19yZXN0YXJ0X3N5c2ZzX2F0dHIg
ZHJpdmVycy9zY3NpL3NkLmMKLS0tIGxpbnV4LTIuNi9kcml2ZXJzL3Njc2kvc2QuY35zZF9h
bGxvd19yZXN0YXJ0X3N5c2ZzX2F0dHIJMjAwNi0wNi0wNSAxMjozMzowNi4wMDAwMDAwMDAg
LTA1MDAKKysrIGxpbnV4LTIuNi1iamtpbmcxL2RyaXZlcnMvc2NzaS9zZC5jCTIwMDYtMDYt
MDUgMTI6MzQ6MjIuMDAwMDAwMDAwIC0wNTAwCkBAIC0yMDgsNiArMjA4LDIzIEBAIHN0YXRp
YyBzc2l6ZV90IHNkX3N0b3JlX2NhY2hlX3R5cGUoc3RydWMKIAlyZXR1cm4gY291bnQ7CiB9
CiAKK3N0YXRpYyBzc2l6ZV90IHNkX3N0b3JlX2FsbG93X3Jlc3RhcnQoc3RydWN0IGNsYXNz
X2RldmljZSAqY2RldiwgY29uc3QgY2hhciAqYnVmLAorCQkJCSAgICAgIHNpemVfdCBjb3Vu
dCkKK3sKKwlzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwID0gdG9fc2NzaV9kaXNrKGNkZXYpOwor
CXN0cnVjdCBzY3NpX2RldmljZSAqc2RwID0gc2RrcC0+ZGV2aWNlOworCisJaWYgKCFjYXBh
YmxlKENBUF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVBQ0NFUzsKKworCWlmIChzZHAtPnR5
cGUgIT0gVFlQRV9ESVNLKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCXNkcC0+YWxsb3dfcmVz
dGFydCA9IHNpbXBsZV9zdHJ0b3VsKGJ1ZiwgTlVMTCwgMTApOworCisJcmV0dXJuIGNvdW50
OworfQorCiBzdGF0aWMgc3NpemVfdCBzZF9zaG93X2NhY2hlX3R5cGUoc3RydWN0IGNsYXNz
X2RldmljZSAqY2RldiwgY2hhciAqYnVmKQogewogCXN0cnVjdCBzY3NpX2Rpc2sgKnNka3Ag
PSB0b19zY3NpX2Rpc2soY2Rldik7CkBAIC0yMjMsMTAgKzI0MCwxOSBAQCBzdGF0aWMgc3Np
emVfdCBzZF9zaG93X2Z1YShzdHJ1Y3QgY2xhc3NfCiAJcmV0dXJuIHNucHJpbnRmKGJ1Ziwg
MjAsICIldVxuIiwgc2RrcC0+RFBPRlVBKTsKIH0KIAorc3RhdGljIHNzaXplX3Qgc2Rfc2hv
d19hbGxvd19yZXN0YXJ0KHN0cnVjdCBjbGFzc19kZXZpY2UgKmNkZXYsIGNoYXIgKmJ1ZikK
K3sKKwlzdHJ1Y3Qgc2NzaV9kaXNrICpzZGtwID0gdG9fc2NzaV9kaXNrKGNkZXYpOworCisJ
cmV0dXJuIHNucHJpbnRmKGJ1ZiwgNDAsICIlZFxuIiwgc2RrcC0+ZGV2aWNlLT5hbGxvd19y
ZXN0YXJ0KTsKK30KKwogc3RhdGljIHN0cnVjdCBjbGFzc19kZXZpY2VfYXR0cmlidXRlIHNk
X2Rpc2tfYXR0cnNbXSA9IHsKIAlfX0FUVFIoY2FjaGVfdHlwZSwgU19JUlVHT3xTX0lXVVNS
LCBzZF9zaG93X2NhY2hlX3R5cGUsCiAJICAgICAgIHNkX3N0b3JlX2NhY2hlX3R5cGUpLAog
CV9fQVRUUihGVUEsIFNfSVJVR08sIHNkX3Nob3dfZnVhLCBOVUxMKSwKKwlfX0FUVFIoYWxs
b3dfcmVzdGFydCwgU19JUlVHT3xTX0lXVVNSLCBzZF9zaG93X2FsbG93X3Jlc3RhcnQsCisJ
ICAgICAgIHNkX3N0b3JlX2FsbG93X3Jlc3RhcnQpLAogCV9fQVRUUl9OVUxMLAogfTsKIApf
Cg==
--------------030009000106030900090808--
