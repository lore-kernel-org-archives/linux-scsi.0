From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 05/15] libata: Add __ata_scsi_ioctl
Date: Wed, 22 Mar 2006 17:22:29 -0600
Message-ID: <4421DC35.6090109@us.ibm.com>
References: <200603172304.k2HN4Stx030065@d01av02.pok.ibm.com> <4420AE54.6090603@pobox.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060705080506060609020409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:29660 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932487AbWCVXWv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 18:22:51 -0500
In-Reply-To: <4420AE54.6090603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705080506060609020409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Brian King wrote:
>>  
>> -int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
>> +int __ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
>>  {
>> -	struct ata_port *ap;
>> -	struct ata_device *dev;
>>  	int val = -EINVAL, rc = -EINVAL;
>>  
>> -	ap = (struct ata_port *) &scsidev->host->hostdata[0];
>> -	if (!ap)
>> -		goto out;
>> -
>> -	dev = ata_scsi_find_dev(ap, scsidev);
>> -	if (!dev) {
>> -		rc = -ENODEV;
>> -		goto out;
>> -	}
>> -
>>  	switch (cmd) {
> 
> 
> Rather than create a new function, it looks like the above code can 
> simply be removed.  I don't see anything that uses 'ap' or 'dev'.
> 

Sounds good to me. Patch below.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------060705080506060609020409
Content-Type: text/x-patch;
 name="libata_scsi_ioctl.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="libata_scsi_ioctl.patch"

CkluIHByZXBhcmF0aW9uIGZvciBTQVMsIGtpbGwgc29tZSB1bm5lY2Vzc2FyeSBjb2RlIGlu
IGF0YV9zY3NpX2lvY3RsCnRvIGZpbmQgdGhlIEFUQSBwb3J0IGFuZCBkZXZpY2UgZ2l2ZW4g
dGhlIHNjc2lfZGV2aWNlLiBOZWl0aGVyIGxvY2FsCmlzIHVzZWQgaW4gdGhlIGZ1bmN0aW9u
LgoKU2lnbmVkLW9mZi1ieTogQnJpYW4gS2luZyA8YnJraW5nQHVzLmlibS5jb20+Ci0tLQoK
IGxpYmF0YS1kZXYtYmpraW5nMS9kcml2ZXJzL3Njc2kvbGliYXRhLXNjc2kuYyB8ICAgMTMg
LS0tLS0tLS0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMyBkZWxldGlvbnMoLSkKCmRpZmYg
LXB1TiBkcml2ZXJzL3Njc2kvbGliYXRhLXNjc2kuY35saWJhdGFfc2NzaV9pb2N0bCBkcml2
ZXJzL3Njc2kvbGliYXRhLXNjc2kuYwotLS0gbGliYXRhLWRldi9kcml2ZXJzL3Njc2kvbGli
YXRhLXNjc2kuY35saWJhdGFfc2NzaV9pb2N0bAkyMDA2LTAzLTIyIDExOjE2OjMzLjAwMDAw
MDAwMCAtMDYwMAorKysgbGliYXRhLWRldi1iamtpbmcxL2RyaXZlcnMvc2NzaS9saWJhdGEt
c2NzaS5jCTIwMDYtMDMtMjIgMTE6MTY6MzMuMDAwMDAwMDAwIC0wNjAwCkBAIC0yNTcsMjAg
KzI1Nyw4IEBAIGludCBhdGFfdGFza19pb2N0bChzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnMKIAog
aW50IGF0YV9zY3NpX2lvY3RsKHN0cnVjdCBzY3NpX2RldmljZSAqc2NzaWRldiwgaW50IGNt
ZCwgdm9pZCBfX3VzZXIgKmFyZykKIHsKLQlzdHJ1Y3QgYXRhX3BvcnQgKmFwOwotCXN0cnVj
dCBhdGFfZGV2aWNlICpkZXY7CiAJaW50IHZhbCA9IC1FSU5WQUwsIHJjID0gLUVJTlZBTDsK
IAotCWFwID0gKHN0cnVjdCBhdGFfcG9ydCAqKSAmc2NzaWRldi0+aG9zdC0+aG9zdGRhdGFb
MF07Ci0JaWYgKCFhcCkKLQkJZ290byBvdXQ7Ci0KLQlkZXYgPSBhdGFfc2NzaV9maW5kX2Rl
dihhcCwgc2NzaWRldik7Ci0JaWYgKCFkZXYpIHsKLQkJcmMgPSAtRU5PREVWOwotCQlnb3Rv
IG91dDsKLQl9Ci0KIAlzd2l0Y2ggKGNtZCkgewogCWNhc2UgQVRBX0lPQ19HRVRfSU8zMjoK
IAkJdmFsID0gMDsKQEAgLTI5OSw3ICsyODcsNiBAQCBpbnQgYXRhX3Njc2lfaW9jdGwoc3Ry
dWN0IHNjc2lfZGV2aWNlICpzCiAJCWJyZWFrOwogCX0KIAotb3V0OgogCXJldHVybiByYzsK
IH0KIApfCg==
--------------060705080506060609020409--
