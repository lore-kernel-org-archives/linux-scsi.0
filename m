From: James.Smart@Emulex.Com
Subject: [Patch] [Repost] Add FC transport host statistics (w/ patch attached)
Date: Tue, 30 Nov 2004 23:58:28 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E7DF@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C4D762.65C207AD"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:24225 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261151AbULAE64
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 23:58:56 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, MPESCHKE@de.ibm.com, schwidefsky@de.ibm.com, akpm@osdl.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C4D762.65C207AD
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Sorry.. here's the patch as well...

-----Original Message-----
From: Smart, James=20
Sent: Tuesday, November 30, 2004 11:45 PM
To: linux-scsi@vger.kernel.org
Cc: andrew.vasquez@qlogic.com; michaelc@cs.wisc.edu;
MPESCHKE@de.ibm.com; schwidefsky@de.ibm.com; akpm@osdl.org
Subject: [Patch] [Repost] Add FC transport host statistics


This patch has been updated so that it backs against scsi-misc-2.6 as of =
2004/11/27. This patch depends on the previous patch:
  "[Patch] [Repost] Add basic infrastructure for transport host =
statistics".

-- James S

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
> Sent: Thursday, October 14, 2004 10:49 AM
> To: linux-scsi@vger.kernel.org
> Cc: andrew.vasquez@qlogic.com; michaelc@cs.wisc.edu
> Subject: [Patch RFC] Add FC transport host statistics
>=20
>=20
>=20
> This patch updates the fc_transport with statistics for local FC ports
> (e.g. Hosts).  The statistics are defined per HBAAPI v2.0 definitions.
>=20
> Caveats:
> ------------
> - This patch applies to the scsi-target-2.6 bitkeeper tree.=20
> It is dependent
>   upon the previous "host statistics" patch.
>=20
> - The information below is supplied by a simple test driver=20
> that does not
>   talk to real hardware, but fully acts as a LLDD that supports the
>   fc transport.
>=20
>=20
> This patch results in the following in /sys/class:
> -----------------------------------------------------
>=20
> [jsmart@elxware class]$ cd /sys/class
> [jsmart@elxware class]$ ls
> fc_host       graphics  misc     pci_bus       scsi_host  usb_host
> fc_transport  input     net      scsi_device   tty        vc
> firmware      mem       netlink  scsi_generic  usb
> [jsmart@elxware class]$ cd fc_host
> [jsmart@elxware fc_host]$ ls
> host4
>=20
> [jsmart@elxware fc_host]$ cd host4
> [jsmart@elxware host4]$ ls
> device                 host_link_down_tmo           statistics
> [jsmart@elxware host4]$ ls -ld *
> lrwxrwxrwx  1 root root    0 Oct 13 17:16 device ->=20
> ../../../devices/platform/host4
> -rw-r--r--  1 root root 4096 Oct 13 17:16 host_link_down_tmo
> drwxr-xr-x  2 root root    0 Oct 13 17:16 statistics
>=20
> [jsmart@elxware host4]$ cd statistics
> dumped_frames         invalid_crc_count     =20
> prim_seq_protocol_err_count
> error_frames          invalid_tx_word_count  reset_statistics
> fcp_control_requests  link_failure_count     rx_frames
> fcp_input_megabytes   lip_count              rx_words
> fcp_input_requests    loss_of_signal_count   seconds_since_last_reset
> fcp_output_megabytes  loss_of_sync_count     tx_frames
> fcp_output_requests   nos_count              tx_words
>=20
> [jsmart@elxware statistics]$ ls -ld *
> -r--r--r--  1 root root 4096 Oct 13 17:16 dumped_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 error_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_control_requests
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_input_megabytes
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_input_requests
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_output_megabytes
> -r--r--r--  1 root root 4096 Oct 13 17:16 fcp_output_requests
> -r--r--r--  1 root root 4096 Oct 13 17:16 invalid_crc_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 invalid_tx_word_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 link_failure_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 lip_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 loss_of_signal_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 loss_of_sync_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 nos_count
> -r--r--r--  1 root root 4096 Oct 13 17:16 prim_seq_protocol_err_count
> --w-------  1 root root 4096 Oct 13 17:16 reset_statistics
> -r--r--r--  1 root root 4096 Oct 13 17:16 rx_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 rx_words
> -r--r--r--  1 root root 4096 Oct 13 17:16 seconds_since_last_reset
> -r--r--r--  1 root root 4096 Oct 13 17:16 tx_frames
> -r--r--r--  1 root root 4096 Oct 13 17:16 tx_words
>=20
>=20
> Using the following script (/tmp/show_attributes):
>     #!/bin/sh
>     FILES=3D`ls *`
>     for file in $FILES; do
>       if [ -f $file ] ; then
>         echo "$file : " `cat $file`
>       fi
>     done
>=20
> Here's a sample of querying the statistics:
>=20
> [jsmart@elxware /]$ cd /sys/class/fc_host/host4/statistics
> [jsmart@elxware statistics]$ /tmp/li
> dumped_frames :  0x8
> error_frames :  0x7
> fcp_control_requests :  0x11
> fcp_input_megabytes :  0x12
> fcp_input_requests :  0xf
> fcp_output_megabytes :  0x13
> fcp_output_requests :  0x10
> invalid_crc_count :  0xe
> invalid_tx_word_count :  0xd
> link_failure_count :  0x9
> lip_count :  0x5
> loss_of_signal_count :  0xb
> loss_of_sync_count :  0xa
> nos_count :  0x6
> prim_seq_protocol_err_count :  0xc
> cat: reset_statistics: Permission denied
> reset_statistics :=20
> rx_frames :  0x3
> rx_words :  0x4
> seconds_since_last_reset :  0x0
> tx_frames :  0x1
> tx_words :  0x2
>=20
>=20
>=20



------_=_NextPart_001_01C4D762.65C207AD
Content-Type: application/octet-stream;
	name="patch.fc_stat"
Content-Transfer-Encoding: base64
Content-Description: patch.fc_stat
Content-Disposition: attachment;
	filename="patch.fc_stat"

ZGlmZiAtdU5yIHNjc2ktbWlzYy0yLjYtMjAwNDExMjcvZHJpdmVycy9zY3NpL3Njc2lfdHJhbnNw
b3J0X2ZjLmMgc2NzaS1taXNjLTIuNi0yMDA0MTEyNy5wYXRjaC9kcml2ZXJzL3Njc2kvc2NzaV90
cmFuc3BvcnRfZmMuYwotLS0gc2NzaS1taXNjLTIuNi0yMDA0MTEyNy9kcml2ZXJzL3Njc2kvc2Nz
aV90cmFuc3BvcnRfZmMuYwkyMDA0LTExLTI4IDA4OjAxOjE0LjAwMDAwMDAwMCAtMDUwMAorKysg
c2NzaS1taXNjLTIuNi0yMDA0MTEyNy5wYXRjaC9kcml2ZXJzL3Njc2kvc2NzaV90cmFuc3BvcnRf
ZmMuYwkyMDA0LTExLTMwIDE0OjIyOjMwLjE3Mjg2NTgyNCAtMDUwMApAQCAtMjc5LDYgKzI3OSwx
MTIgQEAKIGZjX2hvc3RfcndfYXR0cihsaW5rX2Rvd25fdG1vLCAiJWRcbiIpOwogCiAKKy8qCisg
KiBIb3N0IFN0YXRpc3RpY3MgTWFuYWdlbWVudAorICovCisKKy8qIFNob3cgYSBnaXZlbiBhbiBh
dHRyaWJ1dGUgaW4gdGhlIHN0YXRpc3RpY3MgZ3JvdXAgKi8KK3N0YXRpYyBzc2l6ZV90CitmY19z
dGF0X3Nob3coY29uc3Qgc3RydWN0IGNsYXNzX2RldmljZSAqY2RldiwgY2hhciAqYnVmLCB1bnNp
Z25lZCBsb25nIG9mZnNldCkKK3sKKwlzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCA9IHRyYW5zcG9y
dF9jbGFzc190b19zaG9zdChjZGV2KTsKKwlzdHJ1Y3QgZmNfaW50ZXJuYWwgKmkgPSB0b19mY19p
bnRlcm5hbChzaG9zdC0+dHJhbnNwb3J0dCk7CisJc3RydWN0IGZjX2hvc3Rfc3RhdGlzdGljcyAq
c3RhdHM7CisJc3NpemVfdCByZXQgPSAtRU5PRU5UOworCisJaWYgKG9mZnNldCA+IHNpemVvZihz
dHJ1Y3QgZmNfaG9zdF9zdGF0aXN0aWNzKSB8fAorCSAgICBvZmZzZXQgJSBzaXplb2YodWludDY0
X3QpICE9IDApCisJCVdBUk5fT04oMSk7CisKKwlpZiAoaS0+Zi0+Z2V0X2ZjX2hvc3Rfc3RhdHMp
IHsKKwkJc3RhdHMgPSAoaS0+Zi0+Z2V0X2ZjX2hvc3Rfc3RhdHMpKHNob3N0KTsKKwkJaWYgKHN0
YXRzKQorCQkJcmV0ID0gc25wcmludGYoYnVmLCAyMCwgIjB4JWxseFxuIiwKKwkJCSAgICAgICoo
dWludDY0X3QgKikoKCh1OCAqKSBzdGF0cykgKyBvZmZzZXQpKTsKKwl9CisJcmV0dXJuIHJldDsK
K30KKworCisvKiBnZW5lcmF0ZSBhIHJlYWQtb25seSBzdGF0aXN0aWNzIGF0dHJpYnV0ZSAqLwor
I2RlZmluZSBmY19ob3N0X3N0YXRpc3RpYyhuYW1lKQkJCQkJCVwKK3N0YXRpYyBzc2l6ZV90IHNo
b3dfZmNzdGF0XyMjbmFtZShzdHJ1Y3QgY2xhc3NfZGV2aWNlICpjZCwgY2hhciAqYnVmKSAJXAor
ewkJCQkJCQkJCVwKKwlyZXR1cm4gZmNfc3RhdF9zaG93KGNkLCBidWYsIAkJCQkJXAorCQkJICAg
IG9mZnNldG9mKHN0cnVjdCBmY19ob3N0X3N0YXRpc3RpY3MsIG5hbWUpKTsJXAorfQkJCQkJCQkJ
CVwKK3N0YXRpYyBDTEFTU19ERVZJQ0VfQVRUUihuYW1lLCBTX0lSVUdPLCBzaG93X2Zjc3RhdF8j
I25hbWUsIE5VTEwpCisKK2ZjX2hvc3Rfc3RhdGlzdGljKHNlY29uZHNfc2luY2VfbGFzdF9yZXNl
dCk7CitmY19ob3N0X3N0YXRpc3RpYyh0eF9mcmFtZXMpOworZmNfaG9zdF9zdGF0aXN0aWModHhf
d29yZHMpOworZmNfaG9zdF9zdGF0aXN0aWMocnhfZnJhbWVzKTsKK2ZjX2hvc3Rfc3RhdGlzdGlj
KHJ4X3dvcmRzKTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGxpcF9jb3VudCk7CitmY19ob3N0X3N0YXRp
c3RpYyhub3NfY291bnQpOworZmNfaG9zdF9zdGF0aXN0aWMoZXJyb3JfZnJhbWVzKTsKK2ZjX2hv
c3Rfc3RhdGlzdGljKGR1bXBlZF9mcmFtZXMpOworZmNfaG9zdF9zdGF0aXN0aWMobGlua19mYWls
dXJlX2NvdW50KTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGxvc3Nfb2Zfc3luY19jb3VudCk7CitmY19o
b3N0X3N0YXRpc3RpYyhsb3NzX29mX3NpZ25hbF9jb3VudCk7CitmY19ob3N0X3N0YXRpc3RpYyhw
cmltX3NlcV9wcm90b2NvbF9lcnJfY291bnQpOworZmNfaG9zdF9zdGF0aXN0aWMoaW52YWxpZF90
eF93b3JkX2NvdW50KTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGludmFsaWRfY3JjX2NvdW50KTsKK2Zj
X2hvc3Rfc3RhdGlzdGljKGZjcF9pbnB1dF9yZXF1ZXN0cyk7CitmY19ob3N0X3N0YXRpc3RpYyhm
Y3Bfb3V0cHV0X3JlcXVlc3RzKTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGZjcF9jb250cm9sX3JlcXVl
c3RzKTsKK2ZjX2hvc3Rfc3RhdGlzdGljKGZjcF9pbnB1dF9tZWdhYnl0ZXMpOworZmNfaG9zdF9z
dGF0aXN0aWMoZmNwX291dHB1dF9tZWdhYnl0ZXMpOworCitzdGF0aWMgc3NpemVfdAorZmNfcmVz
ZXRfc3RhdGlzdGljcyhzdHJ1Y3QgY2xhc3NfZGV2aWNlICpjZGV2LCBjb25zdCBjaGFyICpidWYs
CisJCQkgICBzaXplX3QgY291bnQpCit7CisJc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QgPSB0cmFu
c3BvcnRfY2xhc3NfdG9fc2hvc3QoY2Rldik7CisJc3RydWN0IGZjX2ludGVybmFsICppID0gdG9f
ZmNfaW50ZXJuYWwoc2hvc3QtPnRyYW5zcG9ydHQpOworCisJLyogaWdub3JlIGFueSBkYXRhIHZh
bHVlIHdyaXR0ZW4gdG8gdGhlIGF0dHJpYnV0ZSAqLworCWlmIChpLT5mLT5yZXNldF9mY19ob3N0
X3N0YXRzKSB7CisJCWktPmYtPnJlc2V0X2ZjX2hvc3Rfc3RhdHMoc2hvc3QpOworCQlyZXR1cm4g
Y291bnQ7CisJfQorCisJcmV0dXJuIC1FTk9FTlQ7Cit9CitzdGF0aWMgQ0xBU1NfREVWSUNFX0FU
VFIocmVzZXRfc3RhdGlzdGljcywgU19JV1VTUiwgTlVMTCwgZmNfcmVzZXRfc3RhdGlzdGljcyk7
CisKKworc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGUgKmZjX3N0YXRpc3RpY3NfYXR0cnNbXSA9IHsK
KwkmY2xhc3NfZGV2aWNlX2F0dHJfc2Vjb25kc19zaW5jZV9sYXN0X3Jlc2V0LmF0dHIsCisJJmNs
YXNzX2RldmljZV9hdHRyX3R4X2ZyYW1lcy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl90eF93
b3Jkcy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9yeF9mcmFtZXMuYXR0ciwKKwkmY2xhc3Nf
ZGV2aWNlX2F0dHJfcnhfd29yZHMuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfbGlwX2NvdW50
LmF0dHIsCisJJmNsYXNzX2RldmljZV9hdHRyX25vc19jb3VudC5hdHRyLAorCSZjbGFzc19kZXZp
Y2VfYXR0cl9lcnJvcl9mcmFtZXMuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfZHVtcGVkX2Zy
YW1lcy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9saW5rX2ZhaWx1cmVfY291bnQuYXR0ciwK
KwkmY2xhc3NfZGV2aWNlX2F0dHJfbG9zc19vZl9zeW5jX2NvdW50LmF0dHIsCisJJmNsYXNzX2Rl
dmljZV9hdHRyX2xvc3Nfb2Zfc2lnbmFsX2NvdW50LmF0dHIsCisJJmNsYXNzX2RldmljZV9hdHRy
X3ByaW1fc2VxX3Byb3RvY29sX2Vycl9jb3VudC5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9p
bnZhbGlkX3R4X3dvcmRfY291bnQuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfaW52YWxpZF9j
cmNfY291bnQuYXR0ciwKKwkmY2xhc3NfZGV2aWNlX2F0dHJfZmNwX2lucHV0X3JlcXVlc3RzLmF0
dHIsCisJJmNsYXNzX2RldmljZV9hdHRyX2ZjcF9vdXRwdXRfcmVxdWVzdHMuYXR0ciwKKwkmY2xh
c3NfZGV2aWNlX2F0dHJfZmNwX2NvbnRyb2xfcmVxdWVzdHMuYXR0ciwKKwkmY2xhc3NfZGV2aWNl
X2F0dHJfZmNwX2lucHV0X21lZ2FieXRlcy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9mY3Bf
b3V0cHV0X21lZ2FieXRlcy5hdHRyLAorCSZjbGFzc19kZXZpY2VfYXR0cl9yZXNldF9zdGF0aXN0
aWNzLmF0dHIsCisJTlVMTAorfTsKKworc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgZmNf
c3RhdGlzdGljc19ncm91cCA9IHsKKwkubmFtZSA9ICJzdGF0aXN0aWNzIiwKKwkuYXR0cnMgPSBm
Y19zdGF0aXN0aWNzX2F0dHJzLAorfTsKKworCiAKIHN0cnVjdCBzY3NpX3RyYW5zcG9ydF90ZW1w
bGF0ZSAqCiBmY19hdHRhY2hfdHJhbnNwb3J0KHN0cnVjdCBmY19mdW5jdGlvbl90ZW1wbGF0ZSAq
ZnQpCkBAIC0zMDMsNiArNDA5LDEwIEBACiAJaS0+dC5ob3N0X3NldHVwID0gJmZjX3NldHVwX2hv
c3RfdHJhbnNwb3J0X2F0dHJzOwogCWktPnQuaG9zdF9kZXN0cm95ID0gJmZjX2Rlc3Ryb3lfaG9z
dDsKIAlpLT50Lmhvc3Rfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgZmNfaG9zdF9hdHRycyk7CisKKwlp
ZiAoZnQtPmdldF9mY19ob3N0X3N0YXRzKQorCQlpLT50Lmhvc3Rfc3RhdGlzdGljcyA9ICZmY19z
dGF0aXN0aWNzX2dyb3VwOworCiAJaS0+ZiA9IGZ0OwogCiAJCmRpZmYgLXVOciBzY3NpLW1pc2Mt
Mi42LTIwMDQxMTI3L2luY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9ydF9mYy5oIHNjc2ktbWlzYy0y
LjYtMjAwNDExMjcucGF0Y2gvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmgKLS0tIHNj
c2ktbWlzYy0yLjYtMjAwNDExMjcvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmgJMjAw
NC0xMS0yOCAwODowMjowNy4wMDAwMDAwMDAgLTA1MDAKKysrIHNjc2ktbWlzYy0yLjYtMjAwNDEx
MjcucGF0Y2gvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0X2ZjLmgJMjAwNC0xMS0zMCAxNDoy
MzoyNS4wMzQ1MjU1ODQgLTA1MDAKQEAgLTQzLDYgKzQzLDM5IEBACiAjZGVmaW5lIGZjX3N0YXJn
ZXRfZGV2X2xvc3Nfd29yayh4KSBcCiAJKCgoc3RydWN0IGZjX3N0YXJnZXRfYXR0cnMgKikmKHgp
LT5zdGFyZ2V0X2RhdGEpLT5kZXZfbG9zc193b3JrKQogCisKKy8qCisgKiBGQyBMb2NhbCBQb3J0
IChIb3N0KSBTdGF0aXN0aWNzCisgKi8KKworLyogRkMgU3RhdGlzdGljcyAtIEZvbGxvd2luZyBG
QyBIQkFBUEkgdjIuMCBndWlkZWxpbmVzICovCitzdHJ1Y3QgZmNfaG9zdF9zdGF0aXN0aWNzIHsK
KwkvKiBwb3J0IHN0YXRpc3RpY3MgKi8KKwl1aW50NjRfdCBzZWNvbmRzX3NpbmNlX2xhc3RfcmVz
ZXQ7CisJdWludDY0X3QgdHhfZnJhbWVzOworCXVpbnQ2NF90IHR4X3dvcmRzOworCXVpbnQ2NF90
IHJ4X2ZyYW1lczsKKwl1aW50NjRfdCByeF93b3JkczsKKwl1aW50NjRfdCBsaXBfY291bnQ7CisJ
dWludDY0X3Qgbm9zX2NvdW50OworCXVpbnQ2NF90IGVycm9yX2ZyYW1lczsKKwl1aW50NjRfdCBk
dW1wZWRfZnJhbWVzOworCXVpbnQ2NF90IGxpbmtfZmFpbHVyZV9jb3VudDsKKwl1aW50NjRfdCBs
b3NzX29mX3N5bmNfY291bnQ7CisJdWludDY0X3QgbG9zc19vZl9zaWduYWxfY291bnQ7CisJdWlu
dDY0X3QgcHJpbV9zZXFfcHJvdG9jb2xfZXJyX2NvdW50OworCXVpbnQ2NF90IGludmFsaWRfdHhf
d29yZF9jb3VudDsKKwl1aW50NjRfdCBpbnZhbGlkX2NyY19jb3VudDsKKwkKKwkvKiBmYzQgc3Rh
dGlzdGljcyAgKG9ubHkgRkNQIHN1cHBvcnRlZCBjdXJyZW50bHkpICovCisJdWludDY0X3QgZmNw
X2lucHV0X3JlcXVlc3RzOworCXVpbnQ2NF90IGZjcF9vdXRwdXRfcmVxdWVzdHM7CisJdWludDY0
X3QgZmNwX2NvbnRyb2xfcmVxdWVzdHM7CisJdWludDY0X3QgZmNwX2lucHV0X21lZ2FieXRlczsK
Kwl1aW50NjRfdCBmY3Bfb3V0cHV0X21lZ2FieXRlczsKK307CisKKwogc3RydWN0IGZjX2hvc3Rf
YXR0cnMgewogCXVpbnQzMl90IGxpbmtfZG93bl90bW87CS8qIExpbmsgRG93biB0aW1lb3V0IGlu
IHNlY29uZHMuICovCiAJc3RydWN0IHdvcmtfc3RydWN0IGxpbmtfZG93bl93b3JrOwpAQCAtNjUs
NiArOTgsOSBAQAogCXZvaWQgICAgKCpnZXRfaG9zdF9saW5rX2Rvd25fdG1vKShzdHJ1Y3QgU2Nz
aV9Ib3N0ICopOwogCXZvaWQJKCpzZXRfaG9zdF9saW5rX2Rvd25fdG1vKShzdHJ1Y3QgU2NzaV9I
b3N0ICosIHVpbnQzMl90KTsKIAorCXN0cnVjdCBmY19ob3N0X3N0YXRpc3RpY3MgKiAoKmdldF9m
Y19ob3N0X3N0YXRzKShzdHJ1Y3QgU2NzaV9Ib3N0ICopOworCXZvaWQJKCpyZXNldF9mY19ob3N0
X3N0YXRzKShzdHJ1Y3QgU2NzaV9Ib3N0ICopOworCiAJLyogCiAJICogVGhlIGRyaXZlciBzZXRz
IHRoZXNlIHRvIHRlbGwgdGhlIHRyYW5zcG9ydCBjbGFzcyBpdAogCSAqIHdhbnRzIHRoZSBhdHRy
aWJ1dGVzIGRpc3BsYXllZCBpbiBzeXNmcy4gIElmIHRoZSBzaG93XyBmbGFnCg==

------_=_NextPart_001_01C4D762.65C207AD--
