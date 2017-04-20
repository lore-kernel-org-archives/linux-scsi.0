From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Thu, 20 Apr 2017 22:27:28 +0000
Message-ID: <1492727247.2642.12.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
         <1492725550.2642.9.camel@sandisk.com>
         <1492726397.21601.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="_003_1492727247264212camelsandiskcom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27068 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947977AbdDTW1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:27:33 -0400
In-Reply-To: <1492726397.21601.16.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

--_003_1492727247264212camelsandiskcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <0CB0E6F4BBEF4C4C8A6E34C1E2398C2E@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-04-20 at 15:13 -0700, James Bottomley wrote:
> On Thu, 2017-04-20 at 21:59 +0000, Bart Van Assche wrote:
> > This approach cannot work. A scsi_target_block() call by the=20
> > transport layer can happen concurrently with the=20
> > __scsi_remove_device() call and hence can occur at any time between=20
> > the scsi_start_queue() call by __scsi_remove_device() and the=20
> > sd_shutdown() call, resulting in a deadlock.
>=20
> How is that possible?  Once the device goes into the CANCEL state, it
> no longer can be found by starget_for_each_device() because
> scsi_device_get() returns NULL ... unless you also have a patch
> altering that?

No changes were made in the SCSI core other than the attached two patches.
I'm not sure about the root cause but every time I simulated a transport
layer failure before I tried to remove the ib_srp kernel module I ran into
a deadlock (see also the call traces below). Inspection of the lsscsi
output and /sys/kernel/debug/block learned me that both queues involved in
the deadlock were stopped.

sysrq: SysRq : Show Blocked State
=A0 task=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0PC stack=A0=A0=A0pid father
kworker/11:3=A0=A0=A0=A0D=A0=A0=A0=A00=A0=A02910=A0=A0=A0=A0=A0=A02 0x00000=
000
Workqueue: srp_remove srp_remove_work [ib_srp]
Call Trace:
=A0__schedule+0x3df/0xc10
=A0schedule+0x3d/0x90
=A0schedule_timeout+0x234/0x4b0
=A0io_schedule_timeout+0x1e/0x50
=A0wait_for_completion_io_timeout+0x118/0x180
=A0blk_execute_rq+0x8e/0xc0
=A0scsi_execute+0xe7/0x200
=A0sd_sync_cache+0x8a/0x170
=A0sd_shutdown+0x5f/0xe0
=A0sd_remove+0x63/0xc0
=A0device_release_driver_internal+0x13f/0x1e0
=A0device_release_driver+0x12/0x20
=A0bus_remove_device+0x114/0x190
=A0device_del+0x205/0x320
=A0__scsi_remove_device+0x132/0x140
=A0scsi_forget_host+0x60/0x70
=A0scsi_remove_host+0x71/0x110
=A0srp_remove_work+0x90/0x220 [ib_srp]
=A0process_one_work+0x20b/0x6a0
=A0worker_thread+0x4e/0x4a0
=A0kthread+0x113/0x150
=A0ret_from_fork+0x2e/0x40
kworker/4:3=A0=A0=A0=A0=A0D=A0=A0=A0=A00=A0=A02913=A0=A0=A0=A0=A0=A02 0x000=
00000
Workqueue: srp_remove srp_remove_work [ib_srp]
Call Trace:
=A0__schedule+0x3df/0xc10
=A0schedule+0x3d/0x90
=A0schedule_timeout+0x234/0x4b0
=A0io_schedule_timeout+0x1e/0x50
=A0wait_for_completion_io_timeout+0x118/0x180
=A0blk_execute_rq+0x8e/0xc0
=A0scsi_execute+0xe7/0x200
=A0sd_sync_cache+0x8a/0x170
=A0sd_shutdown+0x5f/0xe0
=A0sd_remove+0x63/0xc0
=A0device_release_driver_internal+0x13f/0x1e0
=A0device_release_driver+0x12/0x20
=A0bus_remove_device+0x114/0x190
=A0device_del+0x205/0x320
=A0__scsi_remove_device+0x132/0x140
=A0scsi_forget_host+0x60/0x70
=A0scsi_remove_host+0x71/0x110
=A0srp_remove_work+0x90/0x220 [ib_srp]
=A0process_one_work+0x20b/0x6a0
=A0worker_thread+0x4e/0x4a0
=A0kthread+0x113/0x150
=A0ret_from_fork+0x2e/0x40
modprobe=A0=A0=A0=A0=A0=A0=A0=A0D=A0=A0=A0=A00=A0=A02916=A0=A0=A02218 0x000=
00000
Call Trace:
=A0__schedule+0x3df/0xc10
=A0schedule+0x3d/0x90
=A0schedule_timeout+0x273/0x4b0
=A0wait_for_completion+0x108/0x170
=A0flush_workqueue+0x207/0x720
=A0srp_remove_one+0xbe/0x110 [ib_srp]
=A0ib_unregister_client+0x18f/0x200 [ib_core]
=A0srp_cleanup_module+0x10/0x618 [ib_srp]
=A0SyS_delete_module+0x198/0x1f0
=A0entry_SYSCALL_64_fastpath+0x18/0xad

Bart.=

--_003_1492727247264212camelsandiskcom_
Content-Type: text/x-patch; name="0001-Introduce-scsi_start_queue.patch"
Content-Description: 0001-Introduce-scsi_start_queue.patch
Content-Disposition: attachment;
	filename="0001-Introduce-scsi_start_queue.patch"; size=2756;
	creation-date="Thu, 20 Apr 2017 22:27:28 GMT";
	modification-date="Thu, 20 Apr 2017 22:27:28 GMT"
Content-ID: <B4A6E301C992FF47B2C0CD30DCFC078A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSBjMzk1Y2UyYWFmNmQ4YTY0NDMxMWY0YzU1ZGZhNmFhNTYwYTkzMjQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHNhbmRp
c2suY29tPgpEYXRlOiBUdWUsIDI4IE1hciAyMDE3IDE0OjAwOjE3IC0wNzAwClN1YmplY3Q6IFtQ
QVRDSCAxLzJdIEludHJvZHVjZSBzY3NpX3N0YXJ0X3F1ZXVlKCkKClRoaXMgcGF0Y2ggZG9lcyBu
b3QgY2hhbmdlIGFueSBmdW5jdGlvbmFsaXR5LgoKU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNz
Y2hlIDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4KQ2M6IElzcmFlbCBSdWtzaGluIDxpc3Jh
ZWxyQG1lbGxhbm94LmNvbT4KQ2M6IE1heCBHdXJ0b3ZveSA8bWF4Z0BtZWxsYW5veC5jb20+CkNj
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KQ2M6IEJlbmphbWluIEJsb2NrIDxiYmxv
Y2tAbGludXgudm5ldC5pYm0uY29tPgotLS0KIGRyaXZlcnMvc2NzaS9zY3NpX2xpYi5jICB8IDI1
ICsrKysrKysrKysrKysrKy0tLS0tLS0tLS0KIGRyaXZlcnMvc2NzaS9zY3NpX3ByaXYuaCB8ICAx
ICsKIDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMgYi9kcml2ZXJzL3Njc2kvc2NzaV9s
aWIuYwppbmRleCBlZWNjMDA1MDk5YjIuLmZmYTZlNjEyOTlhOSAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zY3NpL3Njc2lfbGliLmMKKysrIGIvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKQEAgLTI5ODcs
NiArMjk4NywyMCBAQCBzY3NpX2ludGVybmFsX2RldmljZV9ibG9jayhzdHJ1Y3Qgc2NzaV9kZXZp
Y2UgKnNkZXYsIGJvb2wgd2FpdCkKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKHNjc2lfaW50ZXJuYWxf
ZGV2aWNlX2Jsb2NrKTsKICAKK3ZvaWQgc2NzaV9zdGFydF9xdWV1ZShzdHJ1Y3Qgc2NzaV9kZXZp
Y2UgKnNkZXYpCit7CisJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBzZGV2LT5yZXF1ZXN0X3F1
ZXVlOworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisKKwlpZiAocS0+bXFfb3BzKSB7CisJCWJsa19t
cV9zdGFydF9zdG9wcGVkX2h3X3F1ZXVlcyhxLCBmYWxzZSk7CisJfSBlbHNlIHsKKwkJc3Bpbl9s
b2NrX2lycXNhdmUocS0+cXVldWVfbG9jaywgZmxhZ3MpOworCQlibGtfc3RhcnRfcXVldWUocSk7
CisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUocS0+cXVldWVfbG9jaywgZmxhZ3MpOworCX0KK30K
KwogLyoqCiAgKiBzY3NpX2ludGVybmFsX2RldmljZV91bmJsb2NrIC0gcmVzdW1lIGEgZGV2aWNl
IGFmdGVyIGEgYmxvY2sgcmVxdWVzdAogICogQHNkZXY6CWRldmljZSB0byByZXN1bWUKQEAgLTMw
MDcsOSArMzAyMSw2IEBAIGludAogc2NzaV9pbnRlcm5hbF9kZXZpY2VfdW5ibG9jayhzdHJ1Y3Qg
c2NzaV9kZXZpY2UgKnNkZXYsCiAJCQkgICAgIGVudW0gc2NzaV9kZXZpY2Vfc3RhdGUgbmV3X3N0
YXRlKQogewotCXN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxID0gc2Rldi0+cmVxdWVzdF9xdWV1ZTsg
Ci0JdW5zaWduZWQgbG9uZyBmbGFnczsKLQogCS8qCiAJICogVHJ5IHRvIHRyYW5zaXRpb24gdGhl
IHNjc2kgZGV2aWNlIHRvIFNERVZfUlVOTklORyBvciBvbmUgb2YgdGhlCiAJICogb2ZmbGluZWQg
c3RhdGVzIGFuZCBnb29zZSB0aGUgZGV2aWNlIHF1ZXVlIGlmIHN1Y2Nlc3NmdWwuCkBAIC0zMDI3
LDEzICszMDM4LDcgQEAgc2NzaV9pbnRlcm5hbF9kZXZpY2VfdW5ibG9jayhzdHJ1Y3Qgc2NzaV9k
ZXZpY2UgKnNkZXYsCiAJCSBzZGV2LT5zZGV2X3N0YXRlICE9IFNERVZfT0ZGTElORSkKIAkJcmV0
dXJuIC1FSU5WQUw7CiAKLQlpZiAocS0+bXFfb3BzKSB7Ci0JCWJsa19tcV9zdGFydF9zdG9wcGVk
X2h3X3F1ZXVlcyhxLCBmYWxzZSk7Ci0JfSBlbHNlIHsKLQkJc3Bpbl9sb2NrX2lycXNhdmUocS0+
cXVldWVfbG9jaywgZmxhZ3MpOwotCQlibGtfc3RhcnRfcXVldWUocSk7Ci0JCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUocS0+cXVldWVfbG9jaywgZmxhZ3MpOwotCX0KKwlzY3NpX3N0YXJ0X3F1ZXVl
KHNkZXYpOwogCiAJcmV0dXJuIDA7CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9w
cml2LmggYi9kcml2ZXJzL3Njc2kvc2NzaV9wcml2LmgKaW5kZXggZjExYmQxMDJkNmQ1Li5jNzYy
OWUzMWE3NWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3ByaXYuaAorKysgYi9kcml2
ZXJzL3Njc2kvc2NzaV9wcml2LmgKQEAgLTg5LDYgKzg5LDcgQEAgZXh0ZXJuIHZvaWQgc2NzaV9y
dW5faG9zdF9xdWV1ZXMoc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QpOwogZXh0ZXJuIHZvaWQgc2Nz
aV9yZXF1ZXVlX3J1bl9xdWV1ZShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwogZXh0ZXJuIHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpzY3NpX2FsbG9jX3F1ZXVlKHN0cnVjdCBzY3NpX2RldmljZSAq
c2Rldik7CiBleHRlcm4gc3RydWN0IHJlcXVlc3RfcXVldWUgKnNjc2lfbXFfYWxsb2NfcXVldWUo
c3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KTsKK2V4dGVybiB2b2lkIHNjc2lfc3RhcnRfcXVldWUo
c3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KTsKIGV4dGVybiBpbnQgc2NzaV9tcV9zZXR1cF90YWdz
KHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0KTsKIGV4dGVybiB2b2lkIHNjc2lfbXFfZGVzdHJveV90
YWdzKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0KTsKIGV4dGVybiBpbnQgc2NzaV9pbml0X3F1ZXVl
KHZvaWQpOwotLSAKMi4xMi4yCgo=

--_003_1492727247264212camelsandiskcom_
Content-Type: text/x-patch;
	name="0002-Make-__scsi_remove_device-go-straight-from-BLOCKED-t.patch"
Content-Description: 0002-Make-__scsi_remove_device-go-straight-from-BLOCKED-t.patch
Content-Disposition: attachment;
	filename="0002-Make-__scsi_remove_device-go-straight-from-BLOCKED-t.patch";
	size=2731; creation-date="Thu, 20 Apr 2017 22:27:28 GMT";
	modification-date="Thu, 20 Apr 2017 22:27:28 GMT"
Content-ID: <5D2AF2394462654488379A246B9B1D95@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSBmYTY5MDkyZDIyZjRmNThlZGU3ZDM3ZTY4MTQ4YTRhYTQ2MTVkMmFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCYXJ0IFZhbiBBc3NjaGUgPGJhcnQudmFuYXNzY2hlQHNhbmRp
c2suY29tPgpEYXRlOiBUdWUsIDE4IEFwciAyMDE3IDEwOjExOjAyIC0wNzAwClN1YmplY3Q6IFtQ
QVRDSCAyLzJdIE1ha2UgX19zY3NpX3JlbW92ZV9kZXZpY2UgZ28gc3RyYWlnaHQgZnJvbSBCTE9D
S0VEIHRvIERFTAoKSWYgYSBkZXZpY2UgaXMgYmxvY2tlZCwgbWFrZSBfX3Njc2lfcmVtb3ZlX2Rl
dmljZSgpIGNhdXNlIGl0IHRvCnRyYW5zaXRpb24gdG8gdGhlIERFTCBzdGF0ZS4gVGhpcyBtZWFu
cyB0aGF0IGFsbCB0aGUgY29tbWFuZHMKaXNzdWVkIGluIC5zaHV0ZG93bigpIHdpbGwgZXJyb3Ig
aW4gdGhlIG1pZC1sYXllciwgdGh1cyBtYWtpbmcKdGhlIHJlbW92YWwgcHJvY2VlZCB3aXRob3V0
IGJlaW5nIHN0b3BwZWQuCgpUaGlzIHBhdGNoIGlzIGEgc2xpZ2h0bHkgbW9kaWZpZWQgdmVyc2lv
biBvZiBhIHBhdGNoIGZyb20gSmFtZXMKQm90dG9tbGV5LgoKU2lnbmVkLW9mZi1ieTogQmFydCBW
YW4gQXNzY2hlIDxiYXJ0LnZhbmFzc2NoZUBzYW5kaXNrLmNvbT4KQ2M6IEphbWVzIEJvdHRvbWxl
eSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT4KQ2M6IElzcmFlbCBSdWtz
aGluIDxpc3JhZWxyQG1lbGxhbm94LmNvbT4KQ2M6IE1heCBHdXJ0b3ZveSA8bWF4Z0BtZWxsYW5v
eC5jb20+CkNjOiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KQ2M6IEJlbmphbWluIEJs
b2NrIDxiYmxvY2tAbGludXgudm5ldC5pYm0uY29tPgotLS0KIGRyaXZlcnMvc2NzaS9zY3NpX2xp
Yi5jICAgfCAgMiArLQogZHJpdmVycy9zY3NpL3Njc2lfc3lzZnMuYyB8IDE5ICsrKysrKysrKysr
KysrKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2NzaV9saWIuYyBiL2RyaXZlcnMvc2NzaS9z
Y3NpX2xpYi5jCmluZGV4IGZmYTZlNjEyOTlhOS4uMzc2Y2QxZGExMDJjIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3Njc2kvc2NzaV9saWIuYworKysgYi9kcml2ZXJzL3Njc2kvc2NzaV9saWIuYwpAQCAt
MjYxMSw3ICsyNjExLDYgQEAgc2NzaV9kZXZpY2Vfc2V0X3N0YXRlKHN0cnVjdCBzY3NpX2Rldmlj
ZSAqc2RldiwgZW51bSBzY3NpX2RldmljZV9zdGF0ZSBzdGF0ZSkKIAkJY2FzZSBTREVWX1FVSUVT
Q0U6CiAJCWNhc2UgU0RFVl9PRkZMSU5FOgogCQljYXNlIFNERVZfVFJBTlNQT1JUX09GRkxJTkU6
Ci0JCWNhc2UgU0RFVl9CTE9DSzoKIAkJCWJyZWFrOwogCQlkZWZhdWx0OgogCQkJZ290byBpbGxl
Z2FsOwpAQCAtMjYyNSw2ICsyNjI0LDcgQEAgc2NzaV9kZXZpY2Vfc2V0X3N0YXRlKHN0cnVjdCBz
Y3NpX2RldmljZSAqc2RldiwgZW51bSBzY3NpX2RldmljZV9zdGF0ZSBzdGF0ZSkKIAkJY2FzZSBT
REVWX09GRkxJTkU6CiAJCWNhc2UgU0RFVl9UUkFOU1BPUlRfT0ZGTElORToKIAkJY2FzZSBTREVW
X0NBTkNFTDoKKwkJY2FzZSBTREVWX0JMT0NLOgogCQljYXNlIFNERVZfQ1JFQVRFRF9CTE9DSzoK
IAkJCWJyZWFrOwogCQlkZWZhdWx0OgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Njc2lfc3lz
ZnMuYyBiL2RyaXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMKaW5kZXggODJkZmUwN2IxZDQ3Li41YjAz
ZTU4YmRkNjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMKKysrIGIvZHJp
dmVycy9zY3NpL3Njc2lfc3lzZnMuYwpAQCAtMTI4MiwxNiArMTI4MiwyOSBAQCB2b2lkIF9fc2Nz
aV9yZW1vdmVfZGV2aWNlKHN0cnVjdCBzY3NpX2RldmljZSAqc2RldikKIAkJcmV0dXJuOwogCiAJ
aWYgKHNkZXYtPmlzX3Zpc2libGUpIHsKLQkJaWYgKHNjc2lfZGV2aWNlX3NldF9zdGF0ZShzZGV2
LCBTREVWX0NBTkNFTCkgIT0gMCkKLQkJCXJldHVybjsKKwkJLyoKKwkJICogSWYgYmxvY2tlZCwg
d2UgZ28gc3RyYWlnaHQgdG8gREVMIGFuZCByZXN0YXJ0IHRoZSBxdWV1ZSBzbworCQkgKiBhbnkg
Y29tbWFuZHMgaXNzdWVkIGR1cmluZyBkcml2ZXIgc2h1dGRvd24gKGxpa2Ugc3luYworCQkgKiBj
YWNoZSkgYXJlIGVycm9yZWQgaW1tZWRpYXRlbHkuCisJCSAqLworCQlpZiAoc2NzaV9kZXZpY2Vf
c2V0X3N0YXRlKHNkZXYsIFNERVZfQ0FOQ0VMKSAhPSAwKSB7CisJCQlpZiAoc2NzaV9kZXZpY2Vf
c2V0X3N0YXRlKHNkZXYsIFNERVZfREVMKSAhPSAwKQorCQkJCXJldHVybjsKKworCQkJc2NzaV9z
dGFydF9xdWV1ZShzZGV2KTsKKwkJCXNkZXZfcHJpbnRrKEtFUk5fREVCVUcsIHNkZXYsCisJCQkJ
ICAgICJDaGFuZ2VkIHN0YXRlIGZyb20gQkxPQ0tFRCB0byBERUxcbiIpOworCQl9CiAKIAkJYnNn
X3VucmVnaXN0ZXJfcXVldWUoc2Rldi0+cmVxdWVzdF9xdWV1ZSk7CiAJCWRldmljZV91bnJlZ2lz
dGVyKCZzZGV2LT5zZGV2X2Rldik7CiAJCXRyYW5zcG9ydF9yZW1vdmVfZGV2aWNlKGRldik7CiAJ
CXNjc2lfZGhfcmVtb3ZlX2RldmljZShzZGV2KTsKIAkJZGV2aWNlX2RlbChkZXYpOwotCX0gZWxz
ZQorCX0gZWxzZSB7CiAJCXB1dF9kZXZpY2UoJnNkZXYtPnNkZXZfZGV2KTsKKwkJc2NzaV9zdGFy
dF9xdWV1ZShzZGV2KTsKKwl9CiAKIAkvKgogCSAqIFN0b3AgYWNjZXB0aW5nIG5ldyByZXF1ZXN0
cyBhbmQgd2FpdCB1bnRpbCBhbGwgcXVldWVjb21tYW5kKCkgYW5kCi0tIAoyLjEyLjIKCg==

--_003_1492727247264212camelsandiskcom_--
