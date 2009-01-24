From: "Shi, Harris" <Harris.Shi@lsi.com>
Subject: RE: question on block-layer timeout change
Date: Sat, 24 Jan 2009 09:34:05 -0700
Message-ID: <3568BBCB98C00041A9E622952FD5F24EA15565CF@cosmail03.lsi.com>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com>
 <20081112072919.GB12192@linux.vnet.ibm.com>
 <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com>
 <20081114171823.GA16575@us.ibm.com>
 <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com>
 <4940F367.506@suse.de>
 <3568BBCB98C00041A9E622952FD5F24EA13B99A3@cosmail03.lsi.com>
 <4948AB47.6090505@suse.de>
 <3568BBCB98C00041A9E622952FD5F24EA13B9EB0@cosmail03.lsi.com>
 <20081218092339.GB812@linux.vnet.ibm.com> <4960EDE0.70007@cs.wisc.edu>
 <3568BBCB98C00041A9E622952FD5F24EA14A0697@cosmail03.lsi.com>
 <4965149F.7010808@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_3568BBCB98C00041A9E622952FD5F24EA15565CFcosmail03lsicom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:47959 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZAXQe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jan 2009 11:34:28 -0500
In-Reply-To: <4965149F.7010808@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "malahal@us.ibm.com" <malahal@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

--_002_3568BBCB98C00041A9E622952FD5F24EA15565CFcosmail03lsicom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Christie,=20

Sorry for the late response. I was off-track by other issues for a while. O=
n controller sysReboot, it actually did not send any asynchronous event/mes=
sage for iscsid to destroy the session. It simply went offline for a while =
and then back online. Now I was able to enable iscsid debug trace and captu=
re a log for your reference. My serial console was disconnected during the =
weekend for some reasons, whenever it's back online, I might try some more =
cases.=20

Thanks.
Harris

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu]=20
Sent: Wednesday, January 07, 2009 2:46 PM
To: Shi, Harris
Cc: Mike Anderson; Hannes Reinecke; malahal@us.ibm.com; SCSI development li=
st
Subject: Re: question on block-layer timeout change

Shi, Harris wrote:
> What we did is to sysReboot one controller while I/O is up and running, w=
e expected to have controller failover and did not explicitly run iscsiadm =
to logout the session in this case. Yes. We got the oop after conn error me=
ssage. If controller reboot resulted in session gone, that might explain we=
 had a kernel panic. However, MPP has been running on iscsi array for quite=
 a while on SLES10/REHL distribution, it's the first time we got hit by thi=
s kernel panic. That's why we had a some concerns on iscsi stack.=20
>=20

The failover should not have resulted in the session getting destroyed.=20
It might depend on what is in SLES though. In older tools if the chap=20
values changed (we logged in with one user/pass and the target no wants=20
diff values) or for some errors the initiator thought was fatal. For=20
this though you should have seen a error in logs indicating that we got=20
a fatal login error.

What does the portal return when you were rebooting it if the initiator=20
tries to log in? Look at the open-iscsi userspace tools in SLES. Is your=20
target returning a error values that=20
initiator.c:__check_iscsi_status_class() would destroy the session for?=20
Is it now changed upstream?

> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]=20
> Sent: Sunday, January 04, 2009 11:12 AM
> To: Mike Anderson
> Cc: Shi, Harris; Hannes Reinecke; malahal@us.ibm.com; SCSI development li=
st
> Subject: Re: question on block-layer timeout change
>=20
> Mike Anderson wrote:
>> Shi, Harris <Harris.Shi@lsi.com> wrote:
>>> Information from /var/log/messages:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> Dec 17 15:58:14 timon kernel: sd 6:0:0:2: [sdd] Sense Key : Recovered E=
rror [current]
>>> Dec 17 15:58:14 timon kernel: sd 6:0:0:2: [sdd] <<vendor>> ASC=3D0x95 A=
SCQ=3D0x1ASC=3D0x95 ASCQ=3D0x1
>>> Dec 17 15:58:25 timon kernel:  connection2:0: ping timeout of 15 secs e=
xpired, last rx 19237, last ping 20487, now 24237
>>> Dec 17 15:58:25 timon kernel:  connection2:0: detected conn error (1011=
)
>>> Dec 17 15:58:26 timon iscsid: Kernel reported iSCSI connection 2:0 erro=
r (1011) state (3)
>>>
>>>
>>>
>>> Information from Serial output:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>>> Oops: 0002 [#1] SMP
>>> last sysfs file: /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_m=
ap
>>> Modules linked in: radeon drm agpgart crc32c libcrc32c ib_iser rdma_cm =
ib_cm nfs iw_cm lockd ib_sa ib_mad nfs_acl ib_core i6
>>> IP: [<c011a274>] __ticket_spin_lock+0x8/0x19
>>> *pdpt =3D 00000000319fe001 *pde =3D 0000000000000000
>>> BUG: unable to handle kernel NULL pointer dereference at 00000086
>>> IP: [<c011a274>] __ticket_spin_lock+0x8/0x19
>>> *pdpt =3D 0000000000546001 *pde =3D 0000000000000000
>>>  ipv6 af_packet microcode fuse loop dm_mod mptctl e1000 iTCO_wdt sr_mod=
 video iTCO_vendor_support e752x_edac output shpchp ]
>>>
>>> Pid: 0, comm: swapper Not tainted (2.6.28-rc8-test-1-pae #1) PowerEdge =
2850
>>> EIP: 0060:[<c011a274>] EFLAGS: 00010086 CPU: 3
>>> EIP is at __ticket_spin_lock+0x8/0x19
>>> EAX: 00000086 EBX: f10f6380 ECX: f20b5400 EDX: 00000100
>>> ESI: f18223b0 EDI: 00000000 EBP: f38a5e78 ESP: f38a5e78
>>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>>> Process swapper (pid: 0, ti=3Df38a4000 task=3Df38a2fd0 task.ti=3Df38a40=
00)
>>> Stack:
>>>  f38a5e80 c0328e0f f38a5e98 f9298389 00000002 f10f6380 f18223b0 0000000=
0
>>>  f38a5ea4 f7e13396 f11b9300 f38a5eb0 c0212539 f11b9300 f38a5ed4 c02125f=
2
>>>  f18225b8 00000282 f389c000 f18224f4 00000100 f389c000 c0212573 f38a5f0=
8
>>> Call Trace:
>>>  [<c0328e0f>] ? _spin_lock+0x15/0x18
>>>  [<f9298389>] ? iscsi_eh_cmd_timed_out+0x24/0xb0 [libiscsi]
>>>  [<f7e13396>] ? scsi_times_out+0x35/0x61 [scsi_mod]
>>>  [<c0212539>] ? blk_rq_timed_out+0xc/0x46
>> I could not match my listing exactly with this output, but it appears th=
at
>> the session is NULL when we call into iscsi_eh_cmd_timed_out. An addr2li=
ne
>> would help verify the iscsi_eh_cmd_timed_out line.
>>
>> I added Mike C to the email cc for possible comments on the error messag=
es
>> displayed above and if that would lead to cleanup of structures referenc=
ed
>> in iscsi_eh_cmd_timed_out.
>>
>=20
> Sorry for the late reply. I have been on vacation.
>=20
> The iscsi error message just indicates that the initiator tried to send=20
> a iscsi ping and it did not get a response, so the initiator dropped the=
=20
> session. The error was reported as a generic connection error (1011) and=
=20
> when the error was fired the initiator was in the logged in / full=20
> feature phase (this basically means normal old use and nothing special).
>=20
> Due to the sles use and MPP driver, I am not sure what exactly is=20
> running, but for this code path the iscsi driver does this:
>=20
>          cls_session =3D starget_to_session(scsi_target(scmd->device));
>          session =3D cls_session->dd_data;
>=20
> to get the session in iscsi_eh_cmd_timed_out (we do this in all kernels=20
> do that has not changed).
>=20
> The session pointers are only changed when a session is destroyed, and=20
> that only happens if you do a logout of the session (iscsiadm -m ....=20
> -u), and at that time when the session is destroyed we should have=20
> flushed all IO.
>=20
> Are you guys doing a logout of the session with iscsiadm at this time?
>=20
> Does MPP clone commands and is it doing something with the command's=20
> pointers to the device?
>=20
> Another possibilty is that commands are not getting cleaned up=20
> correctly. When you see this "connection2:0: detected conn error=20
> (1011)", the driver is going to kill all outstadnding commands and and=20
> call scsi_done on them to requeue them with the scsi layer, so we should=
=20
> be getting any commands timed out after you see that message (maybe only=
=20
> in some race case where the session's commands are getting flushed at=20
> the exact same time the scsi eh was firing). There was no time stamp on=20
> the oops output but I doubt this happened. Did the oops happen after the=
=20
> conn error message though?


--_002_3568BBCB98C00041A9E622952FD5F24EA15565CFcosmail03lsicom_
Content-Type: text/plain; name="iscsid_debug_on.txt"
Content-Description: iscsid_debug_on.txt
Content-Disposition: attachment; filename="iscsid_debug_on.txt"; size=6791;
	creation-date="Sat, 24 Jan 2009 08:51:14 GMT";
	modification-date="Sat, 24 Jan 2009 08:51:21 GMT"
Content-Transfer-Encoding: base64

PX49fj1+PX49fj1+PX49fj1+PX49fj0gUHVUVFkgbG9nIDIwMDkuMDEuMjQgMDk6Mzc6MTUgPX49
fj1+PX49fj1+PX49fj1+PX49fj0NCg0KaXNjc2lkOiBwb2xsIHJlc3VsdCAxDQppc2NzaWQ6IGlu
IGN0bGRldl9oYW5kbGUNCmlzY3NpZDogaW4gbmxfcmVhZA0KaXNjc2lkOiBjdGxkZXZfaGFuZGxl
IGdvdCBldmVudCB0eXBlIDEwMg0KDQppc2NzaWQ6IGdldCBjb25uIGNvbnRleHQgMHg2ZDdiMzAN
CmlzY3NpZDogbWVzc2FnZSByZWFsIGxlbmd0aCBpcyA3MiBieXRlcywgcmVjdl9oYW5kbGUgMHg2
ZDk0MzANCmlzY3NpZDogaW4gbmxwYXlsb2FkX3JlYWQNCmlzY3NpZDogc2NoZWQgY29ubiBjb250
ZXh0IDB4NmQ3YjMwIGV2ZW50IDMsIHRtbyAwDQppc2NzaWQ6IHRocmVhZCAweDZkN2IzMCBzY2hl
ZHVsZTogZGVsYXkgMCBzdGF0ZSAzDQppc2NzaWQ6IGV4ZWMgdGhyZWFkIDAwNmQ3YjMwIGNhbGxi
YWNrDQppc2NzaWQ6IEtlcm5lbCByZXBvcnRlZCBpU0NTSSBjb25uZWN0aW9uIDE6MCBlcnJvciAo
MTAxMSkgc3RhdGUgKDMpDQppc2NzaWQ6IHB1dCBjb25uIGNvbnRleHQgMHg2ZDdiMzANCmlzY3Np
ZDogcmUtb3BlbmluZyBzZXNzaW9uIDEgKHJlb3Blbl9jbnQgMCkNCmlzY3NpZDogdGhyZWFkIDAw
NmQ1OWQwIGRlbGV0ZTogc3RhdGUgMw0KaXNjc2lkOiB0aHJlYWQgMDA2ZDVhMDggZGVsZXRlOiBz
dGF0ZSAzDQppc2NzaWQ6IGRpc2Nvbm5lY3RpbmcgY29ubiAweDZkMzUwOCwgZmQgNQ0KaXNjc2lk
OiBpbiBrc3RvcF9jb25uDQppc2NzaWQ6IGluIF9fa2lwY19jYWxsDQppc2NzaWQ6IGluIGt3cml0
ZXYNCkJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNl
IGF0IDAwMDAwMDAwMDAwMDAwYmENCklQOiBbPGZmZmZmZmZmODA0OWJkNWY+XSBfc3Bpbl9sb2Nr
KzB4NS8weDFiDQpQR0QgMjNkYzA2NyBQVUQgMjM4YzA2NyBQTUQgMCANCk9vcHM6IDAwMDIgWzFd
IFNNUCANCmxhc3Qgc3lzZnMgZmlsZTogL3N5cy9kZXZpY2VzL21wcHZpcnR1YWwvbXBwYWRhcHRl
cjAvaG9zdDYvdGFyZ2V0NjowOjAvNjowOjA6OC9ibG9jay9zZGovZGV2DQpDUFUgMCANCk1vZHVs
ZXMgbGlua2VkIGluOiBjcmMzMmMgbGliY3JjMzJjIHJhZGVvbiBkcm0gaXNjc2lfdGNwIGxpYmlz
Y3NpIHNjc2lfdHJhbnNwb3J0X2lzY3NpIG5mcyBsb2NrZCBuZnNfYWNsIHN1bnJwYyBtaWNyb2Nv
ZGUgaXB2NiBmdXNlIGxvb3AgZG1fbW9kIGRjZGJhcyhYKSBydGNfY21vcyBydGNfY29yZSBydGNf
bGliIGUxMDAwIHZpZGVvIG1wdGN0bCBvdXRwdXQgZmxvcHB5IGlUQ09fd2R0IGlUQ09fdmVuZG9y
X3N1cHBvcnQgZTc1MnhfZWRhYyBidXR0b24gcGNzcGtyIGVkYWNfY29yZSBzaHBjaHAgc3JfbW9k
IHBjaV9ob3RwbHVnIGNkcm9tIHVoY2lfaGNkIGVoY2lfaGNkIHVzYmNvcmUgbXBwVmhiYSBlZGQg
ZXh0MyBtYmNhY2hlIGpiZCBmYW4gaWRlX3BjaV9nZW5lcmljIHBpaXggaWRlX2NvcmUgYXRhX2dl
bmVyaWMgYXRhX3BpaXggbGliYXRhIGRvY2sgbXB0c3BpIG1wdHNjc2loIG1wdGJhc2Ugc2NzaV90
cmFuc3BvcnRfc3BpIHRoZXJtYWwgcHJvY2Vzc29yIHRoZXJtYWxfc3lzIGh3bW9uIG1wcFVwcGVy
IHNnIHNkX21vZCBjcmNfdDEwZGlmIHNjc2lfbW9kDQpTdXBwb3J0ZWQ6IFllcywgRXh0ZXJuYWwN
ClBpZDogOCwgY29tbToga2Jsb2NrZC8wIFRhaW50ZWQ6IEcgICAgICAgICAgMi42LjI3LjExLTEt
ZGVmYXVsdCAjMQ0KUklQOiAwMDEwOls8ZmZmZmZmZmY4MDQ5YmQ1Zj5dICBbPGZmZmZmZmZmODA0
OWJkNWY+XSBfc3Bpbl9sb2NrKzB4NS8weDFiDQpSU1A6IDAwMTg6ZmZmZmZmZmY4MGEzNmUzOCAg
RUZMQUdTOiAwMDAxMDA4Mg0KUkFYOiAwMDAwMDAwMDAwMDEwMDAwIFJCWDogMDAwMDAwMDAwMDAw
MDAwMiBSQ1g6IGZmZmY4ODAwMDcwYjJhMzgNClJEWDogZmZmZjg4MDAwMmMxNjAwMCBSU0k6IDAw
MDAwMDAwMDAwMDIwMDcgUkRJOiAwMDAwMDAwMDAwMDAwMGJhDQpSQlA6IGZmZmY4ODAwMDQ3MmEy
NDAgUjA4OiBmZmZmODgwMDA0NzJhNWEwIFIwOTogMDAwMDAwMDAwMDAwMDAwMA0KUjEwOiAwMDAw
MDAwMDAwMDAwMDAwIFIxMTogZmZmZjg4MDAwMTBkYzIyOCBSMTI6IDAwMDAwMDAwMDAwMDAwMDAN
ClIxMzogZmZmZjg4MDAwNTQ4MmRjOCBSMTQ6IGZmZmZmZmZmODBhMzZlZDAgUjE1OiBmZmZmODgw
MDA0NzJhNWI4DQpGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MDhjYWM4
MCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQpDUzogIDAwMTAgRFM6IDAwMTggRVM6IDAw
MTggQ1IwOiAwMDAwMDAwMDgwMDUwMDNiDQpDUjI6IDAwMDAwMDAwMDAwMDAwYmEgQ1IzOiAwMDAw
MDAwMDAyM2Q0MDAwIENSNDogMDAwMDAwMDAwMDAwMDZlMA0KRFIwOiAwMDAwMDAwMDAwMDAwMDAw
IERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwMDAwMDAwMDANCkRSMzogMDAwMDAw
MDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwDQpQ
cm9jZXNzIGtibG9ja2QvMCAocGlkOiA4LCB0aHJlYWRpbmZvIGZmZmY4ODAwMDg2MjgwMDAsIHRh
c2sgZmZmZjg4MDAwODYyNjIwMCkNClN0YWNrOiAgZmZmZmZmZmZhMDM3MTcyZiBmZmZmODgwMDA2
OGU1MzgwIGZmZmZmZmZmYTAwMDRmOTkgZmZmZjg4MDAwNzBiMjhmOA0KIGZmZmZmZmZmODAzM2U3
NzMgZmZmZjg4MDAwNzBiMjhmOCBmZmZmZmZmZjgwMzNlOTFhIDAwMDAwMDAwMDAwMDAyODINCiBm
ZmZmODgwMDA0NzJhMjQwIDAwMDAwMDAwMDAwMDAxMDAgZmZmZmZmZmY4MGFiNzY4MCBmZmZmZmZm
ZjgwMzNlODg3DQpDYWxsIFRyYWNlOg0KIFs8ZmZmZmZmZmZhMDM3MTcyZj5dIGlzY3NpX2VoX2Nt
ZF90aW1lZF9vdXQrMHgyMi8weGEzIFtsaWJpc2NzaV0NCiBbPGZmZmZmZmZmYTAwMDRmOTk+XSBz
Y3NpX3RpbWVzX291dCsweDQ2LzB4NzIgW3Njc2lfbW9kXQ0KIFs8ZmZmZmZmZmY4MDMzZTc3Mz5d
IGJsa19ycV90aW1lZF9vdXQrMHhlLzB4NGENCiBbPGZmZmZmZmZmODAzM2U5MWE+XSBibGtfcnFf
dGltZWRfb3V0X3RpbWVyKzB4OTMvMHgxMTkNCiBbPGZmZmZmZmZmODAyNDY1ZjA+XSBydW5fdGlt
ZXJfc29mdGlycSsweDE4ZC8weDIwNA0KIFs8ZmZmZmZmZmY4MDI0MmI0ZD5dIF9fZG9fc29mdGly
cSsweDdkLzB4MTA3DQogWzxmZmZmZmZmZjgwMjBkMmRjPl0gY2FsbF9zb2Z0aXJxKzB4MWMvMHgy
OA0KIFs8ZmZmZmZmZmY4MDIwZTU4Mz5dIGRvX3NvZnRpcnErMHgyYy8weDY4DQogWzxmZmZmZmZm
ZjgwMjQyODdhPl0gaXJxX2V4aXQrMHgzZi8weDg1DQogWzxmZmZmZmZmZjgwMjFiNGY4Pl0gc21w
X2FwaWNfdGltZXJfaW50ZXJydXB0KzB4OTUvMHhhZQ0KIFs8ZmZmZmZmZmY4MDIwY2NiNj5dIGFw
aWNfdGltZXJfaW50ZXJydXB0KzB4NjYvMHg3MA0KIFs8ZmZmZmZmZmY4MDQ5YmQ5OT5dIF9zcGlu
X3VubG9ja19pcnFyZXN0b3JlKzB4NS8weDYNCiBbPGZmZmZmZmZmYTAwMDZlZDE+XSBzY3NpX3F1
ZXVlX2luc2VydCsweDk0LzB4ZGEgW3Njc2lfbW9kXQ0KIFs8ZmZmZmZmZmZhMDAwMDkwYT5dIHNj
c2lfZGlzcGF0Y2hfY21kKzB4MWVjLzB4MjM1IFtzY3NpX21vZF0NCiBbPGZmZmZmZmZmYTAwMDVm
ZGE+XSBzY3NpX3JlcXVlc3RfZm4rMHgzOTEvMHg0ZDMgW3Njc2lfbW9kXQ0KIFs8ZmZmZmZmZmY4
MDMzYWQ1Mz5dIGdlbmVyaWNfdW5wbHVnX2RldmljZSsweDIxLzB4MmUNCiBbPGZmZmZmZmZmODAz
MzliMzk+XSBibGtfdW5wbHVnX3dvcmsrMHg1ZS8weDY1DQogWzxmZmZmZmZmZjgwMjRjZGY5Pl0g
cnVuX3dvcmtxdWV1ZSsweDdhLzB4MTAwDQogWzxmZmZmZmZmZjgwMjRjZjU3Pl0gd29ya2VyX3Ro
cmVhZCsweGQ4LzB4ZTcNCiBbPGZmZmZmZmZmODAyNGZmNjc+XSBrdGhyZWFkKzB4NDcvMHg3Mw0K
IFs8ZmZmZmZmZmY4MDIwY2Y3OT5dIGNoaWxkX3JpcCsweGEvMHgxMQ0KDQoNCkNvZGU6IGEyIGVj
IGZmIGMzIDljIDU4IGZhIDkwIDgxIDJmIDAwIDAwIDAwIDAxIDc0IDA1IGU4IGE3IGEyIGVjIGZm
IGMzIGZhIDkwIDgxIDJmIDAwIDAwIDAwIDAxIDc0IDA1IGU4IDk3IGEyIGVjIGZmIGMzIGI4IDAw
IDAwIDAxIDAwIDxmMD4gMGYgYzEgMDcgMGYgYjcgZDAgYzEgZTggMTAgMzkgYzIgNzQgMDcgZjMg
OTAgMGYgYjcgMTcgZWIgZjUgDQpSSVAgIFs8ZmZmZmZmZmY4MDQ5YmQ1Zj5dIF9zcGluX2xvY2sr
MHg1LzB4MWINCiBSU1AgPGZmZmZmZmZmODBhMzZlMzg+DQpDUjI6IDAwMDAwMDAwMDAwMDAwYmEN
Ci0tLVsgZW5kIHRyYWNlIDEzMzBkYTYxNjFlZjEyOGEgXS0tLQ0KS2VybmVsIHBhbmljIC0gbm90
IHN5bmNpbmc6IEFpZWUsIGtpbGxpbmcgaW50ZXJydXB0IGhhbmRsZXIhDQotLS0tLS0tLS0tLS1b
IGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCldBUk5JTkc6IGF0IGtlcm5lbC9zbXAuYzozMzEgc21w
X2NhbGxfZnVuY3Rpb25fbWFzaysweDMyLzB4MWVjKCkNCk1vZHVsZXMgbGlua2VkIGluOiBjcmMz
MmMgbGliY3JjMzJjIHJhZGVvbiBkcm0gaXNjc2lfdGNwIGxpYmlzY3NpIHNjc2lfdHJhbnNwb3J0
X2lzY3NpIG5mcyBsb2NrZCBuZnNfYWNsIHN1bnJwYyBtaWNyb2NvZGUgaXB2NiBmdXNlIGxvb3Ag
ZG1fbW9kIGRjZGJhcyhYKSBydGNfY21vcyBydGNfY29yZSBydGNfbGliIGUxMDAwIHZpZGVvIG1w
dGN0bCBvdXRwdXQgZmxvcHB5IGlUQ09fd2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgZTc1MnhfZWRh
YyBidXR0b24gcGNzcGtyIGVkYWNfY29yZSBzaHBjaHAgc3JfbW9kIHBjaV9ob3RwbHVnIGNkcm9t
IHVoY2lfaGNkIGVoY2lfaGNkIHVzYmNvcmUgbXBwVmhiYSBlZGQgZXh0MyBtYmNhY2hlIGpiZCBm
YW4gaWRlX3BjaV9nZW5lcmljIHBpaXggaWRlX2NvcmUgYXRhX2dlbmVyaWMgYXRhX3BpaXggbGli
YXRhIGRvY2sgbXB0c3BpIG1wdHNjc2loIG1wdGJhc2Ugc2NzaV90cmFuc3BvcnRfc3BpIHRoZXJt
YWwgcHJvY2Vzc29yIHRoZXJtYWxfc3lzIGh3bW9uIG1wcFVwcGVyIHNnIHNkX21vZCBjcmNfdDEw
ZGlmIHNjc2lfbW9kDQpTdXBwb3J0ZWQ6IFllcywgRXh0ZXJuYWwNClBpZDogOCwgY29tbToga2Js
b2NrZC8wIFRhaW50ZWQ6IEcgICAgICBEICAgMi42LjI3LjExLTEtZGVmYXVsdCAjMQ0KDQpDYWxs
IFRyYWNlOg0KIFs8ZmZmZmZmZmY4MDIwZGEyOT5dIHNob3dfdHJhY2VfbG9nX2x2bCsweDQxLzB4
NTgNCiBbPGZmZmZmZmZmODA0OTllYWY+XSBkdW1wX3N0YWNrKzB4NjkvMHg2Zg0KIFs8ZmZmZmZm
ZmY4MDIzZDliMj5dIHdhcm5fb25fc2xvd3BhdGgrMHg1MS8weDc3DQogWzxmZmZmZmZmZjgwMjVk
NjA5Pl0gc21wX2NhbGxfZnVuY3Rpb25fbWFzaysweDMyLzB4MWVjDQogWzxmZmZmZmZmZjgwMjVk
N2VjPl0gc21wX2NhbGxfZnVuY3Rpb24rMHgyOS8weDJlDQogWzxmZmZmZmZmZjgwMjFhMzRhPl0g
bmF0aXZlX3NtcF9zZW5kX3N0b3ArMHgxYS8weDI2DQogWzxmZmZmZmZmZjgwNDk5ZjcxPl0gcGFu
aWMrMHhiYy8weDE2OQ0KIFs8ZmZmZmZmZmY4MDI0MTI1Nj5dIGRvX2V4aXQrMHg2Ny8weDMyNQ0K
IFs8ZmZmZmZmZmY4MDQ5YzZkYz5dIG9vcHNfYmVnaW4rMHgwLzB4OTANCiBbPGZmZmZmZmZmODA0
OWU0MmU+XSBkb19wYWdlX2ZhdWx0KzB4NWZhLzB4NmNhDQogWzxmZmZmZmZmZjgwNDliZmI5Pl0g
ZXJyb3JfZXhpdCsweDAvMHg1MQ0KIFs8ZmZmZmZmZmY4MDQ5YmQ1Zj5dIF9zcGluX2xvY2srMHg1
LzB4MWINCiBbPGZmZmZmZmZmYTAzNzE3MmY+XSBpc2NzaV9laF9jbWRfdGltZWRfb3V0KzB4MjIv
MHhhMyBbbGliaXNjc2ldDQogWzxmZmZmZmZmZmEwMDA0Zjk5Pl0gc2NzaV90aW1lc19vdXQrMHg0
Ni8weDcyIFtzY3NpX21vZF0NCiBbPGZmZmZmZmZmODAzM2U3NzM+XSBibGtfcnFfdGltZWRfb3V0
KzB4ZS8weDRhDQogWzxmZmZmZmZmZjgwMzNlOTFhPl0gYmxrX3JxX3RpbWVkX291dF90aW1lcisw
eDkzLzB4MTE5DQogWzxmZmZmZmZmZjgwMjQ2NWYwPl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxOGQv
MHgyMDQNCiBbPGZmZmZmZmZmODAyNDJiNGQ+XSBfX2RvX3NvZnRpcnErMHg3ZC8weDEwNw0KIFs8
ZmZmZmZmZmY4MDIwZDJkYz5dIGNhbGxfc29mdGlycSsweDFjLzB4MjgNCiBbPGZmZmZmZmZmODAy
MGU1ODM+XSBkb19zb2Z0aXJxKzB4MmMvMHg2OA0KIFs8ZmZmZmZmZmY4MDI0Mjg3YT5dIGlycV9l
eGl0KzB4M2YvMHg4NQ0KIFs8ZmZmZmZmZmY4MDIxYjRmOD5dIHNtcF9hcGljX3RpbWVyX2ludGVy
cnVwdCsweDk1LzB4YWUNCiBbPGZmZmZmZmZmODAyMGNjYjY+XSBhcGljX3RpbWVyX2ludGVycnVw
dCsweDY2LzB4NzANCiBbPGZmZmZmZmZmODA0OWJkOTk+XSBfc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSsweDUvMHg2DQogWzxmZmZmZmZmZmEwMDA2ZWQxPl0gc2NzaV9xdWV1ZV9pbnNlcnQrMHg5NC8w
eGRhIFtzY3NpX21vZF0NCiBbPGZmZmZmZmZmYTAwMDA5MGE+XSBzY3NpX2Rpc3BhdGNoX2NtZCsw
eDFlYy8weDIzNSBbc2NzaV9tb2RdDQogWzxmZmZmZmZmZmEwMDA1ZmRhPl0gc2NzaV9yZXF1ZXN0
X2ZuKzB4MzkxLzB4NGQzIFtzY3NpX21vZF0NCiBbPGZmZmZmZmZmODAzM2FkNTM+XSBnZW5lcmlj
X3VucGx1Z19kZXZpY2UrMHgyMS8weDJlDQogWzxmZmZmZmZmZjgwMzM5YjM5Pl0gYmxrX3VucGx1
Z193b3JrKzB4NWUvMHg2NQ0KIFs8ZmZmZmZmZmY4MDI0Y2RmOT5dIHJ1bl93b3JrcXVldWUrMHg3
YS8weDEwMA0KIFs8ZmZmZmZmZmY4MDI0Y2Y1Nz5dIHdvcmtlcl90aHJlYWQrMHhkOC8weGU3DQog
WzxmZmZmZmZmZjgwMjRmZjY3Pl0ga3RocmVhZCsweDQ3LzB4NzMNCiBbPGZmZmZmZmZmODAyMGNm
Nzk+XSBjaGlsZF9yaXArMHhhLzB4MTENCg0KLS0tWyBlbmQgdHJhY2UgMTMzMGRhNjE2MWVmMTI4
YSBdLS0tDQo=

--_002_3568BBCB98C00041A9E622952FD5F24EA15565CFcosmail03lsicom_--
