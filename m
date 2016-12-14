From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: SCSI: usage of DID_REQUEUE vs DID_RESET for returning SCSI
 commands to be retried
Date: Wed, 14 Dec 2016 11:26:22 +0530
Message-ID: <f0e3eb70732ddee32ef3171ebcff88e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1141c45c2ffe66054397ff11
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34334 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbcLNF4Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 00:56:25 -0500
Received: by mail-oi0-f46.google.com with SMTP id y198so10220229oia.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 21:56:24 -0800 (PST)
References: a7bffd458a08ca13972064edaedef71a@mail.gmail.com
In-Reply-To: a7bffd458a08ca13972064edaedef71a@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Tomas Henzl <thenzl@redhat.com>, megaraidlinux.pdl@avagotech.com

--001a1141c45c2ffe66054397ff11
Content-Type: text/plain; charset=UTF-8

Adding direct email addresses of few people to avoid any filters.

Hannes/Martin/James/Tomas/Christoph,

Can you please comment on this?

Thanks,
Sumit

>-----Original Message-----
>From: Sumit Saxena [mailto:sumit.saxena@broadcom.com]
>Sent: Tuesday, December 13, 2016 6:50 PM
>To: 'linux-scsi'
>Subject: SCSI: usage of DID_REQUEUE vs DID_RESET for returning SCSI
>commands to be retried
>
>Hi all,
>
>I have query regarding usage of host_byte DID_REQUEUE vs DID_RESET
returned
>by LLD to SCSI mid layer.
>
>Let me give some background here.
>I am using megaraid_sas controller. megaraid_sas driver returns all
outstanding
>SCSI commands back to SCSI layer with DID_RESET host_byte before
resetting
>controller.
>The intent is- all these commands returned with DID_RESET before
controller
>reset should be retried by SCSI.
>
>In few distros, I have observed that if SYNCHRONIZE_CACHE command(should
be
>applicable for all non Read write commands) is outstanding before
resetting
>controller  and driver returns those commands back with DID_RESET then
>SYNCHRONIZE_CACHE command not retried but failed to upper layer but other
>READ/WRITE commands were not failed but retried. I was running filesystem
IOs
>and SYNHRONIZE_CACHE returned with error cause filesystem to go in READ
only
>mode.
>
>Later I checked and realized below commit was missing in that distro
kernel and
>seems to cause the problem-
>
>a621bac scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands
>
>But distro kernel has below commit-
>
>89fb4cd scsi: handle flush errors properly
>
>Issue does not hit on the kernels which don't have both commits but hits
when
>commit- "89fb4cd scsi: handle flush errors properly " is there but
commit-
>"a621bac scsi_lib: correctly retry failed zero length REQ_TYPE_FS
commands" is
>missing.
>
>This issue is observed with mpt3sas driver as well and should be
applicable to all
>LLDs returning non read write commands with DID_RESET.
>
>Returning DID_REQUEUE instead of DID_RESET from driver solves the problem
>irrespective of whether these above mentioned commits are there or not in
>kernel.
>So I am thinking to use DID_REQUEUE instead of DID_RESET in megaraid_sas
>driver for all SCSI commands(not only limited to SYNCHRONIZE_CACHE or non
>read write commands) before resetting controller. As I mentioned intent
is those
>outstanding commands returned by driver before doing controller reset
should be
>retried and as soon as reset is complete, driver will be processing those
>commands. There is no sense key associated with SCSI commands returned.
>
>I browsed SCSI code and get to know DID_REQUEUE causes command to be
>retried by calling- scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY).
>This seems to be good enough for our requirement of commands to be
re-tried
>by SCSI layer.
>
>Please provide feedback if anyone forsee any issue with using DID_REQUEUE
for
>this use case.
>I will be doing some testing with DID_REQUEUE in place of DID_RESET in
>megaraid_sas driver.
>
>I have attached here a proposed patch for megaraid_sas driver.
>If there are no concerns, I will send this patch to SCSI mailing list.
>
>Thanks,
>Sumit

--001a1141c45c2ffe66054397ff11
Content-Type: message/rfc822
Content-Disposition: attachment
Content-Transfer-Encoding: base64
X-Attachment-Id: 3d4590b8e6eb30d7_0.1


UmVjZWl2ZWQ6IGZyb20gZGhjcC0xMzUtMjQtMTkyLTE0Mi5sb2NhbGRvbWFpbiAoWzE5Mi4xOS4y
MzkuMjUwXSkNCiAgICAgICAgYnkgc210cC5nbWFpbC5jb20gd2l0aCBFU01UUFNBIGlkIHExMnNt
ODA0NjU0OTNwZmouMTguMjAxNi4xMi4xMy4wNS4wNS4xNQ0KICAgICAgICAodmVyc2lvbj1UTFMx
XzIgY2lwaGVyPUVDREhFLVJTQS1BRVMxMjgtR0NNLVNIQTI1NiBiaXRzPTEyOC8xMjgpOw0KICAg
ICAgICBUdWUsIDEzIERlYyAyMDE2IDA1OjA1OjE4IC0wODAwIChQU1QpDQpSZXR1cm4tUGF0aDog
PHN1bWl0LnNheGVuYUBicm9hZGNvbS5jb20+DQpGcm9tOiAiU3VtaXQgU2F4ZW5hIiA8c3VtaXQu
c2F4ZW5hQGJyb2FkY29tLmNvbT4NClRvOiA8a2FzaHlhcC5kZXNhaUBicm9hZGNvbS5jb20+LA0K
CTxzdW1pdC5zYXhlbmFAYnJvYWRjb20uY29tPg0KU3ViamVjdDogW1BBVENIXSBtZWdhcmFpZF9z
YXM6IFVzZSBESURfUkVRVUVVRSBpbnN0ZWFkIG9mIERJRF9SRVNFVCBpbiBPQ1IgcGF0aA0KRGF0
ZTogVHVlLCAxMyBEZWMgMjAxNiAxODozNDo1NSArMDUzMA0KTWVzc2FnZS1JRDogPDE0ODE2MzQy
OTUtMTY0MjktMS1naXQtc2VuZC1lbWFpbC1zdW1pdC5zYXhlbmFAYnJvYWRjb20uY29tPg0KTUlN
RS1WZXJzaW9uOiAxLjANCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsNCgljaGFyc2V0PSJpc28t
ODg1OS0xIg0KQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogN2JpdA0KWC1NYWlsZXI6IE1pY3Jv
c29mdCBPdXRsb29rIDE0LjANClRocmVhZC1JbmRleDogQVFIc1BiMG50UUFMRmpCSTZuMUdWSTBt
Z3kwekpnPT0NCg0KRHJpdmVyIHJldHVybnMgb3V0c3RhbmRpbmcgU0NTSSBjb21tYW5kcyB0byBT
Q1NJIGxheWVyIHdpdGggaG9zdF9ieXRlDQpzZXQgdG8gRElEX1JFU0VUIGJlZm9yZSByZXNldHRp
bmcgY29udHJvbGxlciBzbyB0aGF0IFNDU0kgbGF5ZXIgc2hvdWxkDQpyZXRyeQ0KdGhvc2UgY29t
bWFuZHMuDQpTZW5kaW5nIERJRF9SRVNFVCBmb3Igbm9uIFJXIGNvbW1hbmRzKGUuZyBTWU5DSFJP
TklaRV9DQUNIRSkgbWF5IGNhdXNlDQp0aG9zZSBjb21tYW5kcyBnZXR0aW5nIGZhaWxlZCBhbmQg
cmV0dXJuaW5nIEkvTyBlcnJvcyBvbiBmZXcgZGlzdHJvcyB3aGljaA0KaGFzIGluY2x1ZGVkIGNv
bW1pdC0gODlmYjRjZCBzY3NpOiBoYW5kbGUgZmx1c2ggZXJyb3JzIHByb3Blcmx5IGJ1dCBtaXNz
ZWQNCmNvbW1pdC0gYTYyMWJhYyBzY3NpX2xpYjogY29ycmVjdGx5IHJldHJ5IGZhaWxlZCB6ZXJv
IGxlbmd0aCBSRVFfVFlQRV9GUw0KY29tbWFuZHMuDQpIb3dldmVyIFJlYWQgd3JpdGUgY29tbWFu
ZHMgcmV0dXJuZWQgd2l0aCBESURfUkVTRVQgYXJlIG5vdCBmYWlsZWQgYnV0DQpyZXRyaWVkLg0K
DQpESURfUkVRVUVVRSBzZWVtcyBzYWZlciB0byB1c2UgaW5zdGVhZCBvZiBESURfUkVTRVQgZm9y
IGFsbCBvdXRzdGFuZGluZw0KY29tbWFuZHMgYmVmb3JlIGRvaW5nIGNoaXAgcmVzZXQgYXMgaXQg
c2VydmVzIHB1cnBvc2Ugb2YgZ2V0dGluZyBhbGwNCmNvbW1hbmRzDQp0byBiZSByZXRyaWVkIGJ5
IFNDU0kgbGF5ZXIuDQoNClNpZ25lZC1vZmYtYnk6IFN1bWl0IFNheGVuYSA8c3VtaXQuc2F4ZW5h
QGJyb2FkY29tLmNvbT4NClNpZ25lZC1vZmYtYnk6IEthc2h5YXAgRGVzYWkgPGthc2h5YXAuZGVz
YWlAYnJvYWRjb20uY29tPg0KLS0tDQogZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
c19iYXNlLmMgICB8IDQgKystLQ0KIGRyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMgfCAyICstDQogMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Jhc2UuYw0KYi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYw0K
aW5kZXggNjQ4NGMzOC4uOTU5Y2UzZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jDQorKysgYi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYw0KQEAgLTE2NjIsNyArMTY2Miw3IEBAIG1lZ2FzYXNfcXVldWVfY29tbWFu
ZChzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwNCnN0cnVjdCBzY3NpX2NtbmQgKnNjbWQpDQogCS8q
IENoZWNrIGZvciBhbiBtcGlvIHBhdGggYW5kIGFkanVzdCBiZWhhdmlvciAqLw0KIAlpZiAoYXRv
bWljX3JlYWQoJmluc3RhbmNlLT5hZHByZWNvdmVyeSkgPT0NCk1FR0FTQVNfQURQUkVTRVRfU01f
SU5GQVVMVCkgew0KIAkJaWYgKG1lZ2FzYXNfY2hlY2tfbXBpb19wYXRocyhpbnN0YW5jZSwgc2Nt
ZCkgPT0NCi0JCSAgICAoRElEX1JFU0VUIDw8IDE2KSkgew0KKwkJICAgIChESURfUkVRVUVVRSA8
PCAxNikpIHsNCiAJCQlyZXR1cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsNCiAJCX0gZWxzZSB7
DQogCQkJc2NtZC0+cmVzdWx0ID0gRElEX05PX0NPTk5FQ1QgPDwgMTY7DQpAQCAtMjQ4Myw3ICsy
NDgzLDcgQEAgc3RhdGljIGludCBtZWdhc2FzX3dhaXRfZm9yX291dHN0YW5kaW5nKHN0cnVjdA0K
bWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpDQogCQkJCQkJc3RydWN0IG1lZ2FzYXNfY21kLCBs
aXN0KTsNCiAJCQlsaXN0X2RlbF9pbml0KCZyZXNldF9jbWQtPmxpc3QpOw0KIAkJCWlmIChyZXNl
dF9jbWQtPnNjbWQpIHsNCi0JCQkJcmVzZXRfY21kLT5zY21kLT5yZXN1bHQgPSBESURfUkVTRVQg
PDwgMTY7DQorCQkJCXJlc2V0X2NtZC0+c2NtZC0+cmVzdWx0ID0gRElEX1JFUVVFVUUgPDwNCjE2
Ow0KIAkJCQlkZXZfbm90aWNlKCZpbnN0YW5jZS0+cGRldi0+ZGV2LCAiJWQ6JXANCnJlc2V0IFsl
MDJ4XVxuIiwNCiAJCQkJCXJlc2V0X2luZGV4LCByZXNldF9jbWQsDQogCQkJCQlyZXNldF9jbWQt
PnNjbWQtPmNtbmRbMF0pOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfZnVzaW9uLmMNCmIvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYw0KaW5kZXggMjQ3NzhiYS4uNThjYmUzMCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMNCisrKyBiL2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMNCkBAIC0zMzYyLDcgKzMzNjIsNyBAQCBpbnQgbWVn
YXNhc19jaGVja19tcGlvX3BhdGhzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlDQoqaW5zdGFuY2Us
DQogCXN0cnVjdCBzY3NpX2NtbmQgKnNjbWQpDQogew0KIAlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqcGVlcl9pbnN0YW5jZSA9IE5VTEw7DQotCWludCByZXR2YWwgPSAoRElEX1JFU0VUIDw8IDE2
KTsNCisJaW50IHJldHZhbCA9IChESURfUkVRVUVVRSA8PCAxNik7DQogDQogCWlmIChpbnN0YW5j
ZS0+cGVlcklzUHJlc2VudCkgew0KIAkJcGVlcl9pbnN0YW5jZSA9IG1lZ2FzYXNfZ2V0X3BlZXJf
aW5zdGFuY2UoaW5zdGFuY2UpOw0KLS0gDQoyLjQuMTENCg0K
--001a1141c45c2ffe66054397ff11--
