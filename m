From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] g_NCR5380 - 2.6.0 -  problem with reloading module
Date: Sun, 11 Jan 2004 15:30:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040111153051.03d56e7e.rddunlap@osdl.org>
References: <20040105224220.GA1168@nihil.tappe.netz>
	<20040109112656.25313810.rddunlap@osdl.org>
	<20040110193814.GA371@nihil.tappe.netz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart_Sun__11_Jan_2004_15:30:51_-0800_085c0528"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:6868 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266023AbUAKXcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Jan 2004 18:32:43 -0500
In-Reply-To: <20040110193814.GA371@nihil.tappe.netz>
List-Id: linux-scsi@vger.kernel.org
To: Kevin Tappe <kevin@zerodivide.de>
Cc: linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

This is a multi-part message in MIME format.

--Multipart_Sun__11_Jan_2004_15:30:51_-0800_085c0528
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 10 Jan 2004 20:38:15 +0100 Kevin Tappe <kevin@zerodivide.de> wrote:

| Hi,
| 
| On Fri, Jan 09, 2004 at 11:26:56AM -0800, Randy.Dunlap wrote:
| > Can you show that 'modprobe -v g_NCR5380' output for the first time
| > that the driver is loaded also?
| 
| nihil:~# modprobe -v g_NCR5380
| insmod /lib/modules/2.6.0/kernel/drivers/scsi/g_NCR5380.ko ncr_irq=255
| ncr_addr=0x280 dtc_3181e=1

no output from the driver??
That's OK though, I found the problem.

| > What's in /proc/scsi/g_NCR5380 while the driver is loaded the first time?
| > and in /proc/ioports and /proc/iomem?
| 
| nihil:~# cat /proc/scsi/g_NCR5380/0
| SCSI host number 0 : Generic NCR5380/NCR53C400 Scsi Driver
| Generic NCR5380 driver version 1
| NCR5380 core version 7
| NO NCR53C400 driver extensions
| Using port mapping at port 0x280, no interrupt
| REQ not asserted, phase unknown.
| No currently connected command
| issue_queue
| disconnected_queue
| 
| nihil:~# cat /proc/ioports
...
| 0213-0213 : ISAPnP
| 0220-022f : SoundBlaster
| 0260-0261 : pnp 00:11
| 0280-028f : ncr53c80
| 02f8-02ff : serial
...
| 0a79-0a79 : isapnp write
...
| f800-f81f : pnp 00:12
| f820-f83f : pnp 00:12
| fc00-fc0f : pnp 00:12
| 
| nihil:~# cat /proc/iomem
...
| 
| > Also, the latter 2 files after the driver is removed.
| > and in /proc/scsi after the driver is removed.
| 
| nihil:~# cat /proc/ioports
| Segmentation fault

Yes, I see that one also.

The problem is that the detect function requests an IO region
of 16 bytes (at least when a command line override parameter is
used) but the release function only tries to release 8 bytes,
and this request isn't done because it doesn't match any allocated
IO region.  [NCR53C400 extensions are not enabled, so
NCR5380_region_size is 8, not 16, but the request uses
NCR5380_region_size regardless.]

If enough kernel messages are enabled (like 'echo 9 > /proc/sysrq-trigger'),
you should have seen this message when the driver module was unloaded:
  Trying to free nonexistent resource <280-287>
because 280-28f was allocated.

Options to fix this:

1/ if the release_region() in the release function fails, have it try
   a second time with a different region size; (easy, sorta sloppy);
2/ save the allocated region size in instance->n_io_ports and release
   that size only;  <<<<< PATCH ATTACHED <<<<<
3/ if an override was used, release a region size of 16 in the
   release function; (this only looks clean for one adapter, not
   multiple)

Kevin, please test and report the results.  I think that the
module will be reloadable now.

Patch comments?  If no problems, James, please apply.


| nihil:~# cat /proc/iomem
...
| 
| The files in /proc/scsi are attached. Hope that helps...
| -Kevin
| -- 

--
~Randy

--Multipart_Sun__11_Jan_2004_15:30:51_-0800_085c0528
Content-Type: application/octet-stream;
 name="gNCR_regions.patch"
Content-Disposition: attachment;
 filename="gNCR_regions.patch"
Content-Transfer-Encoding: base64

ZGVzY3JpcHRpb246ICAgICAgcmVsZWFzZSByZWdpb24gb2YgYWxsb2NhdGVkIChyZXF1ZXN0ZWQp
IHNpemUKcHJvZHVjdF92ZXJzaW9uczogTGludXggMi42LjEKCmRpZmZzdGF0Oj0KIGRyaXZlcnMv
c2NzaS9nX05DUjUzODAuYyB8ICAgIDkgKysrKysrKy0tCiAgMSBmaWxlcyBjaGFuZ2VkLCA3IGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC1OYXVycCAuL2RyaXZlcnMvc2NzaS9n
X05DUjUzODAuY35mYWtlaHcgLi9kcml2ZXJzL3Njc2kvZ19OQ1I1MzgwLmMKLS0tIC4vZHJpdmVy
cy9zY3NpL2dfTkNSNTM4MC5jfmZha2VodwkyMDA0LTAxLTA4IDIyOjU5OjEwLjAwMDAwMDAwMCAt
MDgwMAorKysgLi9kcml2ZXJzL3Njc2kvZ19OQ1I1MzgwLmMJMjAwNC0wMS0xMSAxNToyMTowMC4w
MDAwMDAwMDAgLTA4MDAKQEAgLTI5MCw2ICsyOTAsNyBAQCBpbnQgX19pbml0IGdlbmVyaWNfTkNS
NTM4MF9kZXRlY3QoU2NzaV9ICiAJc3RhdGljIGludCBjdXJyZW50X292ZXJyaWRlID0gMDsKIAlp
bnQgY291bnQsIGk7CiAJdW5zaWduZWQgaW50ICpwb3J0czsKKwl1bnNpZ25lZCBsb25nIHJlZ2lv
bl9zaXplID0gMTY7CiAJc3RhdGljIHVuc2lnbmVkIGludCBfX2luaXRkYXRhIG5jcl81M2M0MDBh
X3BvcnRzW10gPSB7CiAJCTB4MjgwLCAweDI5MCwgMHgzMDAsIDB4MzEwLCAweDMzMCwgMHgzNDAs
IDB4MzQ4LCAweDM1MCwgMAogCX07CkBAIC00MjAsNiArNDIxLDcgQEAgaW50IF9faW5pdCBnZW5l
cmljX05DUjUzODBfZGV0ZWN0KFNjc2lfSAogCQkJLyogTm90IGEgNTNDNDAwQSBzdHlsZSBzZXR1
cCAtIGp1c3QgZ3JhYiAqLwogCQkJaWYoIShyZXF1ZXN0X3JlZ2lvbihvdmVycmlkZXNbY3VycmVu
dF9vdmVycmlkZV0uTkNSNTM4MF9tYXBfbmFtZSwgTkNSNTM4MF9yZWdpb25fc2l6ZSwgIm5jcjUz
ODAiKSkpCiAJCQkJY29udGludWU7CisJCQlyZWdpb25fc2l6ZSA9IE5DUjUzODBfcmVnaW9uX3Np
emU7CiAJCX0KICNlbHNlCiAJCWlmKCFyZXF1ZXN0X21lbV9yZWdpb24ob3ZlcnJpZGVzW2N1cnJl
bnRfb3ZlcnJpZGVdLk5DUjUzODBfbWFwX25hbWUsIE5DUjUzODBfcmVnaW9uX3NpemUsICJuY3I1
MzgwIikpCkBAIC00MjgsNyArNDMwLDcgQEAgaW50IF9faW5pdCBnZW5lcmljX05DUjUzODBfZGV0
ZWN0KFNjc2lfSAogCQlpbnN0YW5jZSA9IHNjc2lfcmVnaXN0ZXIodHBudCwgc2l6ZW9mKHN0cnVj
dCBOQ1I1MzgwX2hvc3RkYXRhKSk7CiAJCWlmIChpbnN0YW5jZSA9PSBOVUxMKSB7CiAjaWZuZGVm
IENPTkZJR19TQ1NJX0dfTkNSNTM4MF9NRU0KLQkJCXJlbGVhc2VfcmVnaW9uKG92ZXJyaWRlc1tj
dXJyZW50X292ZXJyaWRlXS5OQ1I1MzgwX21hcF9uYW1lLCBOQ1I1MzgwX3JlZ2lvbl9zaXplKTsK
KwkJCXJlbGVhc2VfcmVnaW9uKG92ZXJyaWRlc1tjdXJyZW50X292ZXJyaWRlXS5OQ1I1MzgwX21h
cF9uYW1lLCByZWdpb25fc2l6ZSk7CiAjZWxzZQogCQkJcmVsZWFzZV9tZW1fcmVnaW9uKG92ZXJy
aWRlc1tjdXJyZW50X292ZXJyaWRlXS5OQ1I1MzgwX21hcF9uYW1lLCBOQ1I1MzgwX3JlZ2lvbl9z
aXplKTsKICNlbmRpZgpAQCAtNDM2LDYgKzQzOCw5IEBAIGludCBfX2luaXQgZ2VuZXJpY19OQ1I1
MzgwX2RldGVjdChTY3NpX0gKIAkJfQogCiAJCWluc3RhbmNlLT5OQ1I1MzgwX2luc3RhbmNlX25h
bWUgPSBvdmVycmlkZXNbY3VycmVudF9vdmVycmlkZV0uTkNSNTM4MF9tYXBfbmFtZTsKKyNpZm5k
ZWYgQ09ORklHX1NDU0lfR19OQ1I1MzgwX01FTQorCQlpbnN0YW5jZS0+bl9pb19wb3J0ID0gcmVn
aW9uX3NpemU7CisjZW5kaWYKIAogCQlOQ1I1MzgwX2luaXQoaW5zdGFuY2UsIGZsYWdzKTsKIApA
QCAtNDk4LDcgKzUwMyw3IEBAIGludCBnZW5lcmljX05DUjUzODBfcmVsZWFzZV9yZXNvdXJjZXMo
c3QKIAlOQ1I1MzgwX3NldHVwKGluc3RhbmNlKTsKIAogI2lmbmRlZiBDT05GSUdfU0NTSV9HX05D
UjUzODBfTUVNCi0JcmVsZWFzZV9yZWdpb24oaW5zdGFuY2UtPk5DUjUzODBfaW5zdGFuY2VfbmFt
ZSwgTkNSNTM4MF9yZWdpb25fc2l6ZSk7CisJcmVsZWFzZV9yZWdpb24oaW5zdGFuY2UtPk5DUjUz
ODBfaW5zdGFuY2VfbmFtZSwgaW5zdGFuY2UtPm5faW9fcG9ydCk7CiAjZWxzZQogCXJlbGVhc2Vf
bWVtX3JlZ2lvbihpbnN0YW5jZS0+TkNSNTM4MF9pbnN0YW5jZV9uYW1lLCBOQ1I1MzgwX3JlZ2lv
bl9zaXplKTsKICNlbmRpZgo=

--Multipart_Sun__11_Jan_2004_15:30:51_-0800_085c0528--
