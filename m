From: Tom Yan <tom.ty89@gmail.com>
Subject: configurable discard parameters
Date: Sun, 21 Jun 2015 01:12:10 +0800
Message-ID: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11357bd01988740518f62475
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34373 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbbFTRML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Jun 2015 13:12:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

--001a11357bd01988740518f62475
Content-Type: text/plain; charset=UTF-8

Today I check if blkdiscard really does a full device trim/wipe for my
Intel 530 SSD (240gb) with hexdump. I end up found that it fail to do
so because it report garbage info on its block limits VPD.

[tom@localhost ~]$ sudo sg_vpd -p 0xb0 /dev/sda
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 0 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 1
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x3fffc0 blocks
  Maximum atomic transfer length: 0
  Atomic alignment: 0
  Atomic transfer length granularity: 0

The fact is, in each iteration, for this drive, blkdiscard can only
trim a maximum of 65528 sectors, which is the largest multiple of 8
sectors, which is the minimum possible. (In fact 65535 sectors seems
to be some sort of limit of ATA TRIM commands. It's also the maximum
of WRITE SAME (10).)

With `blkdiscard`, I can still workaround this with the "--step"
option, but for discard mount options, I don't think I have any way to
deal with it. Although it's basically the reponsibility of Intel (Well
I tried to find a way to complain to them but even their website is
borked as always), but still I would like to know why the kernel
doesn't allow "discard_granularity" and "discard_max_bytes" to be
configurable for users. Also wanna share about this in case nobody
ever noticed.


Another case is, I have a SanDisk Extreme USB (32gb, w/o UASP), which
is sort of a SATA SSD with USB bridge. I can basically TRIM the drive
with hdparm (although there's a minor issue:
https://sourceforge.net/p/hdparm/bugs/63/), but I can't do it with
blkdiscard. At first I thought it was only because its VPD doesn't
provide limits of discard:

[tom@localhost ~]$ sudo sg_vpd -p 0xb0 /dev/sdc
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 0 blocks
  Maximum transfer length: 8388607 blocks
  Optimal transfer length: 8388607 blocks
  Maximum prefetch length: 0 blocks

but then I try to use the attached patch to force some value for it,
blkdiscard still gives me "I/O error" instead of "NOT SUPPROTED". So
what's the requirement of the current discard way in the kernel? Does
it work differently on SATA drives than on USB drives because of the
controller (like involvement of libata)? Does it require capability of
one of the three scsi unmap ways? Or did I just miss some other dirty
hacking bits?

--001a11357bd01988740518f62475
Content-Type: text/x-patch; charset=US-ASCII; name="discard.patch"
Content-Disposition: attachment; filename="discard.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ib5aryhs0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZC5jfiBiL2RyaXZlcnMvc2NzaS9zZC5jCmluZGV4
IGE2NjFkMzMuLmE5Y2RmYjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zZC5jfgorKysgYi9k
cml2ZXJzL3Njc2kvc2QuYwpAQCAtOTksNiArOTksNyBAQCBNT0RVTEVfQUxJQVNfU0NTSV9ERVZJ
Q0UoVFlQRV9SQkMpOwogI2VuZGlmCiAKIHN0YXRpYyB2b2lkIHNkX2NvbmZpZ19kaXNjYXJkKHN0
cnVjdCBzY3NpX2Rpc2sgKiwgdW5zaWduZWQgaW50KTsKK3N0YXRpYyB2b2lkIHNkX2NvbmZpZ19k
aXNjYXJkX25vdnBkKHN0cnVjdCBzY3NpX2Rpc2sgKik7CiBzdGF0aWMgdm9pZCBzZF9jb25maWdf
d3JpdGVfc2FtZShzdHJ1Y3Qgc2NzaV9kaXNrICopOwogc3RhdGljIGludCAgc2RfcmV2YWxpZGF0
ZV9kaXNrKHN0cnVjdCBnZW5kaXNrICopOwogc3RhdGljIHZvaWQgc2RfdW5sb2NrX25hdGl2ZV9j
YXBhY2l0eShzdHJ1Y3QgZ2VuZGlzayAqZGlzayk7CkBAIC03MDAsNiArNzAxLDIyIEBAIHN0YXRp
YyB2b2lkIHNkX2NvbmZpZ19kaXNjYXJkKHN0cnVjdCBzY3NpX2Rpc2sgKnNka3AsIHVuc2lnbmVk
IGludCBtb2RlKQogCXF1ZXVlX2ZsYWdfc2V0X3VubG9ja2VkKFFVRVVFX0ZMQUdfRElTQ0FSRCwg
cSk7CiB9CiAKK3N0YXRpYyB2b2lkIHNkX2NvbmZpZ19kaXNjYXJkX25vdnBkKHN0cnVjdCBzY3Np
X2Rpc2sgKnNka3ApCit7CisJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBzZGtwLT5kaXNrLT5x
dWV1ZTsKKwl1bnNpZ25lZCBpbnQgbG9naWNhbF9ibG9ja19zaXplID0gc2RrcC0+ZGV2aWNlLT5z
ZWN0b3Jfc2l6ZTsKKwl1bnNpZ25lZCBpbnQgbWF4X2Jsb2NrcyA9ICh1MzIpU0RfTUFYX1dTMTZf
QkxPQ0tTOworCisJcS0+bGltaXRzLmRpc2NhcmRfemVyb2VzX2RhdGEgPSAwOworCXEtPmxpbWl0
cy5kaXNjYXJkX2FsaWdubWVudCA9IDA7CisJcS0+bGltaXRzLmRpc2NhcmRfZ3JhbnVsYXJpdHkg
PSBzZGtwLT5waHlzaWNhbF9ibG9ja19zaXplOworCisJc2RrcC0+cHJvdmlzaW9uaW5nX21vZGUg
PSBTRF9MQlBfV1MxNjsKKworCXEtPmxpbWl0cy5tYXhfZGlzY2FyZF9zZWN0b3JzID0gbWF4X2Js
b2NrcyAqIChsb2dpY2FsX2Jsb2NrX3NpemUgPj4gOSk7CisJcXVldWVfZmxhZ19zZXRfdW5sb2Nr
ZWQoUVVFVUVfRkxBR19ESVNDQVJELCBxKTsKK30KKwogLyoqCiAgKiBzZF9zZXR1cF9kaXNjYXJk
X2NtbmQgLSB1bm1hcCBibG9ja3Mgb24gdGhpbmx5IHByb3Zpc2lvbmVkIGRldmljZQogICogQHNk
cDogc2NzaSBkZXZpY2UgdG8gb3BlcmF0ZSBvbmUKQEAgLTI3NzYsNiArMjc5Myw5IEBAIHN0YXRp
YyBpbnQgc2RfcmV2YWxpZGF0ZV9kaXNrKHN0cnVjdCBnZW5kaXNrICpkaXNrKQogCQkJc2RfcmVh
ZF9ibG9ja19saW1pdHMoc2RrcCk7CiAJCQlzZF9yZWFkX2Jsb2NrX2NoYXJhY3RlcmlzdGljcyhz
ZGtwKTsKIAkJfQorCQllbHNlIHsKKwkJCXNkX2NvbmZpZ19kaXNjYXJkX25vdnBkKHNka3ApOwor
CQl9CiAKIAkJc2RfcmVhZF93cml0ZV9wcm90ZWN0X2ZsYWcoc2RrcCwgYnVmZmVyKTsKIAkJc2Rf
cmVhZF9jYWNoZV90eXBlKHNka3AsIGJ1ZmZlcik7Cg==
--001a11357bd01988740518f62475--
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
