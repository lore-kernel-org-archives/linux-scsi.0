From: James.Smart@Emulex.Com
Subject: [Patch RFC] Add FC transport host statistics
Date: Thu, 14 Oct 2004 10:49:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C0866CF@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C4B1FC.F793C237"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:14271 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264113AbUJNOta
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 10:49:30 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu

This is a multi-part message in MIME format.

------_=_NextPart_001_01C4B1FC.F793C237
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


This patch updates the fc_transport with statistics for local FC ports
(e.g. Hosts).  The statistics are defined per HBAAPI v2.0 definitions.

Caveats:
------------
- This patch applies to the scsi-target-2.6 bitkeeper tree. It is =
dependent
  upon the previous "host statistics" patch.

- The information below is supplied by a simple test driver that does =
not
  talk to real hardware, but fully acts as a LLDD that supports the
  fc transport.


This patch results in the following in /sys/class:
-----------------------------------------------------

[jsmart@elxware class]$ cd /sys/class
[jsmart@elxware class]$ ls
fc_host       graphics  misc     pci_bus       scsi_host  usb_host
fc_transport  input     net      scsi_device   tty        vc
firmware      mem       netlink  scsi_generic  usb
[jsmart@elxware class]$ cd fc_host
[jsmart@elxware fc_host]$ ls
host4

[jsmart@elxware fc_host]$ cd host4
[jsmart@elxware host4]$ ls
device                 host_link_down_tmo           statistics
[jsmart@elxware host4]$ ls -ld *
lrwxrwxrwx  1 root root    0 Oct 13 17:16 device -> =
../../../devices/platform/host4
-rw-r--r--  1 root root 4096 Oct 13 17:16 host_link_down_tmo
drwxr-xr-x  2 root root    0 Oct 13 17:16 statistics

[jsmart@elxware host4]$ cd statistics
dumped_frames         invalid_crc_count      prim_seq_protocol_err_count
error_frames          invalid_tx_word_count  reset_statistics
fcp_control_requests  link_failure_count     rx_frames
fcp_input_megabytes   lip_count              rx_words
fcp_input_requests    loss_of_signal_count   seconds_since_last_reset
fcp_output_megabytes  loss_of_sync_count     tx_frames
fcp_output_requests   nos_count              tx_words

[jsmart@elxware statistics]$ ls -ld *
-r--r--r--  1 root root 4096 Oct 13 17:16 dumped_frames
-r--r--r--  1 root root 4096 Oct 13 17:16 error_frames
-r--r--r--  1 root root 4096 Oct 13 17:16 fcp_control_requests
-r--r--r--  1 root root 4096 Oct 13 17:16 fcp_input_megabytes
-r--r--r--  1 root root 4096 Oct 13 17:16 fcp_input_requests
-r--r--r--  1 root root 4096 Oct 13 17:16 fcp_output_megabytes
-r--r--r--  1 root root 4096 Oct 13 17:16 fcp_output_requests
-r--r--r--  1 root root 4096 Oct 13 17:16 invalid_crc_count
-r--r--r--  1 root root 4096 Oct 13 17:16 invalid_tx_word_count
-r--r--r--  1 root root 4096 Oct 13 17:16 link_failure_count
-r--r--r--  1 root root 4096 Oct 13 17:16 lip_count
-r--r--r--  1 root root 4096 Oct 13 17:16 loss_of_signal_count
-r--r--r--  1 root root 4096 Oct 13 17:16 loss_of_sync_count
-r--r--r--  1 root root 4096 Oct 13 17:16 nos_count
-r--r--r--  1 root root 4096 Oct 13 17:16 prim_seq_protocol_err_count
--w-------  1 root root 4096 Oct 13 17:16 reset_statistics
-r--r--r--  1 root root 4096 Oct 13 17:16 rx_frames
-r--r--r--  1 root root 4096 Oct 13 17:16 rx_words
-r--r--r--  1 root root 4096 Oct 13 17:16 seconds_since_last_reset
-r--r--r--  1 root root 4096 Oct 13 17:16 tx_frames
-r--r--r--  1 root root 4096 Oct 13 17:16 tx_words


Using the following script (/tmp/show_attributes):
    #!/bin/sh
    FILES=3D`ls *`
    for file in $FILES; do
      if [ -f $file ] ; then
        echo "$file : " `cat $file`
      fi
    done

Here's a sample of querying the statistics:

[jsmart@elxware /]$ cd /sys/class/fc_host/host4/statistics
[jsmart@elxware statistics]$ /tmp/li
dumped_frames :  0x8
error_frames :  0x7
fcp_control_requests :  0x11
fcp_input_megabytes :  0x12
fcp_input_requests :  0xf
fcp_output_megabytes :  0x13
fcp_output_requests :  0x10
invalid_crc_count :  0xe
invalid_tx_word_count :  0xd
link_failure_count :  0x9
lip_count :  0x5
loss_of_signal_count :  0xb
loss_of_sync_count :  0xa
nos_count :  0x6
prim_seq_protocol_err_count :  0xc
cat: reset_statistics: Permission denied
reset_statistics :=20
rx_frames :  0x3
rx_words :  0x4
seconds_since_last_reset :  0x0
tx_frames :  0x1
tx_words :  0x2



------_=_NextPart_001_01C4B1FC.F793C237
Content-Type: application/octet-stream;
	name="fc_stats.patch"
Content-Transfer-Encoding: base64
Content-Description: fc_stats.patch
Content-Disposition: attachment;
	filename="fc_stats.patch"

ZGlmZiAtdU5yIHNjc2ktdGFyZ2V0LTIuNi9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfZmMu
YyBzY3NpLXRhcmdldC0yLjYucGF0Y2gvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmMK
LS0tIHNjc2ktdGFyZ2V0LTIuNi9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRfZmMuYwkyMDA0
LTEwLTEwIDA5OjU1OjIzLjY2NTg4MTYwOCAtMDQwMAorKysgc2NzaS10YXJnZXQtMi42LnBhdGNo
L2RyaXZlcnMvc2NzaS9zY3NpX3RyYW5zcG9ydF9mYy5jCTIwMDQtMTAtMTAgMDk6NTU6MjMuNjY4
ODgxMTUyIC0wNDAwCkBAIC0yNjEsNiArMjYxLDExMiBAQAogZmNfaG9zdF9yd19hdHRyKGxpbmtf
ZG93bl90bW8sICIlZFxuIik7CiAKIAorLyoKKyAqIEhvc3QgU3RhdGlzdGljcyBNYW5hZ2VtZW50
CisgKi8KKworLyogU2hvdyBhIGdpdmVuIGFuIGF0dHJpYnV0ZSBpbiB0aGUgc3RhdGlzdGljcyBn
cm91cCAqLworc3RhdGljIHNzaXplX3QKK2ZjX3N0YXRfc2hvdyhjb25zdCBzdHJ1Y3QgY2xhc3Nf
ZGV2aWNlICpjZGV2LCBjaGFyICpidWYsIHVuc2lnbmVkIGxvbmcgb2Zmc2V0KQoreworCXN0cnVj
dCBTY3NpX0hvc3QgKnNob3N0ID0gdHJhbnNwb3J0X2NsYXNzX3RvX3Nob3N0KGNkZXYpOworCXN0
cnVjdCBmY19pbnRlcm5hbCAqaSA9IHRvX2ZjX2ludGVybmFsKHNob3N0LT50cmFuc3BvcnR0KTsK
KwlzdHJ1Y3QgZmNfaG9zdF9zdGF0aXN0aWNzICpzdGF0czsKKwlzc2l6ZV90IHJldCA9IC1FTk9F
TlQ7CisKKwlpZiAob2Zmc2V0ID4gc2l6ZW9mKHN0cnVjdCBmY19ob3N0X3N0YXRpc3RpY3MpIHx8
CisJICAgIG9mZnNldCAlIHNpemVvZih1aW50NjRfdCkgIT0gMCkKKwkJV0FSTl9PTigxKTsKKwor
CWlmIChpLT5mLT5nZXRfZmNfaG9zdF9zdGF0cykgeworCQlzdGF0cyA9IChpLT5mLT5nZXRfZmNf
aG9zdF9zdGF0cykoc2hvc3QpOworCQlpZiAoc3RhdHMpCisJCQlyZXQgPSBzbnByaW50ZihidWYs
IDIwLCAiMHglbGx4XG4iLAorCQkJICAgICAgKih1aW50NjRfdCAqKSgoKHU4ICopIHN0YXRzKSAr
IG9mZnNldCkpOworCX0KKwlyZXR1cm4gcmV0OworfQorCisKKy8qIGdlbmVyYXRlIGEgcmVhZC1v
bmx5IHN0YXRpc3RpY3MgYXR0cmlidXRlICovCisjZGVmaW5lIGZjX2hvc3Rfc3RhdGlzdGljKG5h
bWUpCQkJCQkJXAorc3RhdGljIHNzaXplX3Qgc2hvd19mY3N0YXRfIyNuYW1lKHN0cnVjdCBjbGFz
c19kZXZpY2UgKmNkLCBjaGFyICpidWYpIAlcCit7CQkJCQkJCQkJXAorCXJldHVybiBmY19zdGF0
X3Nob3coY2QsIGJ1ZiwgCQkJCQlcCisJCQkgICAgb2Zmc2V0b2Yoc3RydWN0IGZjX2hvc3Rfc3Rh
dGlzdGljcywgbmFtZSkpOwlcCit9CQkJCQkJCQkJXAorc3RhdGljIENMQVNTX0RFVklDRV9BVFRS
KG5hbWUsIFNfSVJVR08sIHNob3dfZmNzdGF0XyMjbmFtZSwgTlVMTCkKKworZmNfaG9zdF9zdGF0
aXN0aWMoc2Vjb25kc19zaW5jZV9sYXN0X3Jlc2V0KTsKK2ZjX2hvc3Rfc3RhdGlzdGljKHR4X2Zy
YW1lcyk7CitmY19ob3N0X3N0YXRpc3RpYyh0eF93b3Jkcyk7CitmY19ob3N0X3N0YXRpc3RpYyhy
eF9mcmFtZXMpOworZmNfaG9zdF9zdGF0aXN0aWMocnhfd29yZHMpOworZmNfaG9zdF9zdGF0aXN0
aWMobGlwX2NvdW50KTsKK2ZjX2hvc3Rfc3RhdGlzdGljKG5vc19jb3VudCk7CitmY19ob3N0X3N0
YXRpc3RpYyhlcnJvcl9mcmFtZXMpOworZmNfaG9zdF9zdGF0aXN0aWMoZHVtcGVkX2ZyYW1lcyk7
CitmY19ob3N0X3N0YXRpc3RpYyhsaW5rX2ZhaWx1cmVfY291bnQpOworZmNfaG9zdF9zdGF0aXN0
aWMobG9zc19vZl9zeW5jX2NvdW50KTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGxvc3Nfb2Zfc2lnbmFs
X2NvdW50KTsKK2ZjX2hvc3Rfc3RhdGlzdGljKHByaW1fc2VxX3Byb3RvY29sX2Vycl9jb3VudCk7
CitmY19ob3N0X3N0YXRpc3RpYyhpbnZhbGlkX3R4X3dvcmRfY291bnQpOworZmNfaG9zdF9zdGF0
aXN0aWMoaW52YWxpZF9jcmNfY291bnQpOworZmNfaG9zdF9zdGF0aXN0aWMoZmNwX2lucHV0X3Jl
cXVlc3RzKTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGZjcF9vdXRwdXRfcmVxdWVzdHMpOworZmNfaG9z
dF9zdGF0aXN0aWMoZmNwX2NvbnRyb2xfcmVxdWVzdHMpOworZmNfaG9zdF9zdGF0aXN0aWMoZmNw
X2lucHV0X21lZ2FieXRlcyk7CitmY19ob3N0X3N0YXRpc3RpYyhmY3Bfb3V0cHV0X21lZ2FieXRl
cyk7CisKK3N0YXRpYyBzc2l6ZV90CitmY19yZXNldF9zdGF0aXN0aWNzKHN0cnVjdCBjbGFzc19k
ZXZpY2UgKmNkZXYsIGNvbnN0IGNoYXIgKmJ1ZiwKKwkJCSAgIHNpemVfdCBjb3VudCkKK3sKKwlz
dHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCA9IHRyYW5zcG9ydF9jbGFzc190b19zaG9zdChjZGV2KTsK
KwlzdHJ1Y3QgZmNfaW50ZXJuYWwgKmkgPSB0b19mY19pbnRlcm5hbChzaG9zdC0+dHJhbnNwb3J0
dCk7CisKKwkvKiBpZ25vcmUgYW55IGRhdGEgdmFsdWUgd3JpdHRlbiB0byB0aGUgYXR0cmlidXRl
ICovCisJaWYgKGktPmYtPnJlc2V0X2ZjX2hvc3Rfc3RhdHMpIHsKKwkJaS0+Zi0+cmVzZXRfZmNf
aG9zdF9zdGF0cyhzaG9zdCk7CisJCXJldHVybiBjb3VudDsKKwl9CisKKwlyZXR1cm4gLUVOT0VO
VDsKK30KK3N0YXRpYyBDTEFTU19ERVZJQ0VfQVRUUihyZXNldF9zdGF0aXN0aWNzLCBTX0lXVVNS
LCBOVUxMLCBmY19yZXNldF9zdGF0aXN0aWNzKTsKKworCitzdGF0aWMgc3RydWN0IGF0dHJpYnV0
ZSAqZmNfc3RhdGlzdGljc19hdHRyc1tdID0geworCSZjbGFzc19kZXZpY2VfYXR0cl9zZWNvbmRz
X3NpbmNlX2xhc3RfcmVzZXQuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfdHhfZnJhbWVzLmF0
dHIsCisJJmNsYXNzX2RldmljZV9hdHRyX3R4X3dvcmRzLmF0dHIsCisJJmNsYXNzX2RldmljZV9h
dHRyX3J4X2ZyYW1lcy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9yeF93b3Jkcy5hdHRyLAor
CSZjbGFzc19kZXZpY2VfYXR0cl9saXBfY291bnQuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJf
bm9zX2NvdW50LmF0dHIsCisJJmNsYXNzX2RldmljZV9hdHRyX2Vycm9yX2ZyYW1lcy5hdHRyLAor
CSZjbGFzc19kZXZpY2VfYXR0cl9kdW1wZWRfZnJhbWVzLmF0dHIsCisJJmNsYXNzX2RldmljZV9h
dHRyX2xpbmtfZmFpbHVyZV9jb3VudC5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9sb3NzX29m
X3N5bmNfY291bnQuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfbG9zc19vZl9zaWduYWxfY291
bnQuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfcHJpbV9zZXFfcHJvdG9jb2xfZXJyX2NvdW50
LmF0dHIsCisJJmNsYXNzX2RldmljZV9hdHRyX2ludmFsaWRfdHhfd29yZF9jb3VudC5hdHRyLAor
CSZjbGFzc19kZXZpY2VfYXR0cl9pbnZhbGlkX2NyY19jb3VudC5hdHRyLAorCSZjbGFzc19kZXZp
Y2VfYXR0cl9mY3BfaW5wdXRfcmVxdWVzdHMuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfZmNw
X291dHB1dF9yZXF1ZXN0cy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9mY3BfY29udHJvbF9y
ZXF1ZXN0cy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9mY3BfaW5wdXRfbWVnYWJ5dGVzLmF0
dHIsCisJJmNsYXNzX2RldmljZV9hdHRyX2ZjcF9vdXRwdXRfbWVnYWJ5dGVzLmF0dHIsCisJJmNs
YXNzX2RldmljZV9hdHRyX3Jlc2V0X3N0YXRpc3RpY3MuYXR0ciwKKwlOVUxMCit9OworCitzdGF0
aWMgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCBmY19zdGF0aXN0aWNzX2dyb3VwID0geworCS5uYW1l
ID0gInN0YXRpc3RpY3MiLAorCS5hdHRycyA9IGZjX3N0YXRpc3RpY3NfYXR0cnMsCit9OworCisK
IAogc3RydWN0IHNjc2lfdHJhbnNwb3J0X3RlbXBsYXRlICoKIGZjX2F0dGFjaF90cmFuc3BvcnQo
c3RydWN0IGZjX2Z1bmN0aW9uX3RlbXBsYXRlICpmdCkKQEAgLTI4Myw2ICszODksMTAgQEAKIAlp
LT50Lmhvc3RfY2xhc3MgPSAmZmNfaG9zdF9jbGFzczsKIAlpLT50Lmhvc3Rfc2V0dXAgPSAmZmNf
c2V0dXBfaG9zdF90cmFuc3BvcnRfYXR0cnM7CiAJaS0+dC5ob3N0X3NpemUgPSBzaXplb2Yoc3Ry
dWN0IGZjX2hvc3RfYXR0cnMpOworCisJaWYgKGZ0LT5nZXRfZmNfaG9zdF9zdGF0cykKKwkJaS0+
dC5ob3N0X3N0YXRpc3RpY3MgPSAmZmNfc3RhdGlzdGljc19ncm91cDsKKwogCWktPmYgPSBmdDsK
IAogCQpkaWZmIC11TnIgc2NzaS10YXJnZXQtMi42L2luY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9y
dF9mYy5oIHNjc2ktdGFyZ2V0LTIuNi5wYXRjaC9pbmNsdWRlL3Njc2kvc2NzaV90cmFuc3BvcnRf
ZmMuaAotLS0gc2NzaS10YXJnZXQtMi42L2luY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9ydF9mYy5o
CTIwMDQtMTAtMTAgMDk6NTU6MjMuNjUzODgzNDMyIC0wNDAwCisrKyBzY3NpLXRhcmdldC0yLjYu
cGF0Y2gvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmgJMjAwNC0xMC0xMCAxMDowNDox
NS42MDAwMTUzMjggLTA0MDAKQEAgLTQzLDYgKzQzLDM5IEBACiAjZGVmaW5lIGZjX3N0YXJnZXRf
ZGV2X2xvc3NfdGltZXIoeCkgXAogCSgoKHN0cnVjdCBmY19zdGFyZ2V0X2F0dHJzICopJih4KS0+
c3RhcmdldF9kYXRhKS0+ZGV2X2xvc3NfdGltZXIpCiAKKworLyoKKyAqIEZDIExvY2FsIFBvcnQg
KEhvc3QpIFN0YXRpc3RpY3MKKyAqLworCisvKiBGQyBTdGF0aXN0aWNzIC0gRm9sbG93aW5nIEZD
IEhCQUFQSSB2Mi4wIGd1aWRlbGluZXMgKi8KK3N0cnVjdCBmY19ob3N0X3N0YXRpc3RpY3Mgewor
CS8qIHBvcnQgc3RhdGlzdGljcyAqLworCXVpbnQ2NF90IHNlY29uZHNfc2luY2VfbGFzdF9yZXNl
dDsKKwl1aW50NjRfdCB0eF9mcmFtZXM7CisJdWludDY0X3QgdHhfd29yZHM7CisJdWludDY0X3Qg
cnhfZnJhbWVzOworCXVpbnQ2NF90IHJ4X3dvcmRzOworCXVpbnQ2NF90IGxpcF9jb3VudDsKKwl1
aW50NjRfdCBub3NfY291bnQ7CisJdWludDY0X3QgZXJyb3JfZnJhbWVzOworCXVpbnQ2NF90IGR1
bXBlZF9mcmFtZXM7CisJdWludDY0X3QgbGlua19mYWlsdXJlX2NvdW50OworCXVpbnQ2NF90IGxv
c3Nfb2Zfc3luY19jb3VudDsKKwl1aW50NjRfdCBsb3NzX29mX3NpZ25hbF9jb3VudDsKKwl1aW50
NjRfdCBwcmltX3NlcV9wcm90b2NvbF9lcnJfY291bnQ7CisJdWludDY0X3QgaW52YWxpZF90eF93
b3JkX2NvdW50OworCXVpbnQ2NF90IGludmFsaWRfY3JjX2NvdW50OworCQorCS8qIGZjNCBzdGF0
aXN0aWNzICAob25seSBGQ1Agc3VwcG9ydGVkIGN1cnJlbnRseSkgKi8KKwl1aW50NjRfdCBmY3Bf
aW5wdXRfcmVxdWVzdHM7CisJdWludDY0X3QgZmNwX291dHB1dF9yZXF1ZXN0czsKKwl1aW50NjRf
dCBmY3BfY29udHJvbF9yZXF1ZXN0czsKKwl1aW50NjRfdCBmY3BfaW5wdXRfbWVnYWJ5dGVzOwor
CXVpbnQ2NF90IGZjcF9vdXRwdXRfbWVnYWJ5dGVzOworfTsKKworCiBzdHJ1Y3QgZmNfaG9zdF9h
dHRycyB7CiAJdWludDMyX3QgbGlua19kb3duX3RtbzsJLyogTGluayBEb3duIHRpbWVvdXQgaW4g
c2Vjb25kcy4gKi8KIAlzdHJ1Y3QgdGltZXJfbGlzdCBsaW5rX2Rvd25fdGltZXI7CkBAIC02NSw2
ICs5OCw5IEBACiAJdm9pZCAgICAoKmdldF9ob3N0X2xpbmtfZG93bl90bW8pKHN0cnVjdCBTY3Np
X0hvc3QgKik7CiAJdm9pZAkoKnNldF9ob3N0X2xpbmtfZG93bl90bW8pKHN0cnVjdCBTY3NpX0hv
c3QgKiwgdWludDMyX3QpOwogCisJc3RydWN0IGZjX2hvc3Rfc3RhdGlzdGljcyAqICgqZ2V0X2Zj
X2hvc3Rfc3RhdHMpKHN0cnVjdCBTY3NpX0hvc3QgKik7CisJdm9pZAkoKnJlc2V0X2ZjX2hvc3Rf
c3RhdHMpKHN0cnVjdCBTY3NpX0hvc3QgKik7CisKIAkvKiAKIAkgKiBUaGUgZHJpdmVyIHNldHMg
dGhlc2UgdG8gdGVsbCB0aGUgdHJhbnNwb3J0IGNsYXNzIGl0CiAJICogd2FudHMgdGhlIGF0dHJp
YnV0ZXMgZGlzcGxheWVkIGluIHN5c2ZzLiAgSWYgdGhlIHNob3dfIGZsYWcK

------_=_NextPart_001_01C4B1FC.F793C237--
