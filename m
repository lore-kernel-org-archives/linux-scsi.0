From: V <viswesh.vichu@gmail.com>
Subject: Help needed for a SCSI hang (SATA drives)
Date: Mon, 6 Mar 2017 16:54:14 -0800
Message-ID: <CAF9xHmThNk7m5hK-R_JGD2KMhJkm-yaDgrW6CeMdfUtjjRzF3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1148d5d46d0a1a054a197367
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36558 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdCGAzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 19:55:50 -0500
Received: by mail-io0-f181.google.com with SMTP id l7so125924998ioe.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2017 16:54:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--001a1148d5d46d0a1a054a197367
Content-Type: text/plain; charset=UTF-8

Hi,

I am reaching out regarding a SCSI error handler issue, which we see
in our lab systems.

Environment: Ubuntu 4.4.0-31-generic

Issue: Write IOs are getting stuck in our system randomly. All drives
seen with the issue are all SATA drives.
Root cause: SCSI error handler is not woken up (or) it is up, but not
able to flush commands and hence the IOs get stuck. (as the requests
are not flushed out and host is not restarted)

We have 6 instances seen till now.

This is what we see.
1) As part of testing our drives, we start lot of read/writes, along
with some user space utilities running to check the drive health.
1) In our recent testing, we see lot of commands going through the
"abort scheduled" path. And we see that in between, for one of the
commands, the error handler is not woken up, and majority of
processes, which were writing, gets stalled.
2) We are still trying to figure out what is causing this much number
of abort? Is it usual? Are there some other debugs, which I could
enable to get more information? We know these are user space commands
which are being aborted, but not sure which exact command it is for
now.
3) I see the "abort scheduled" messages in almost all drives in all
systems, hence i dont believe it is a drive issue.
4) I checked the host_failed and host_busy variables, both are set to
1 in system 1. 2nd one is still alive, havent taken a crash dump yet.
5) All drives seen with the issue are SATA drives.
6) I have attached udevadm info of a drive which failed in system 2.

Thanks in advance,
Viswesh


Logs
-------
System 1

[371546.605736] sd 9:0:0:0: scsi_block_when_processing_errors: rtn: 1
[371546.606727] sd 9:0:0:0: scsi_block_when_processing_errors: rtn: 1
[371546.607721] sd 9:0:0:0: scsi_block_when_processing_errors: rtn: 1
[371546.618113] sd 9:0:0:0: [sg19] tag#20 abort scheduled
[371546.624039] sd 9:0:0:0: [sg19] tag#20 aborting command
[371546.624045] sd 9:0:0:0: [sg19] tag#20 cmd abort failed
[371546.624051] scsi host9: Waking error handler thread
[371546.624060] scsi host9: scsi_eh_9: waking up 0/1/1
[371546.624081] sd 9:0:0:0: [sg19] tag#20 scsi_eh_9: flush finish cmd
[371546.624095] scsi host9: waking up host to restart
[371546.624098] scsi host9: scsi_eh_9: sleeping


[371546.635314] sd 8:0:0:0: [sg17] tag#13 abort scheduled
[371546.640031] sd 8:0:0:0: [sg17] tag#13 aborting command
[371546.640037] sd 8:0:0:0: [sg17] tag#13 cmd abort failed
[371546.640043] scsi host8: Waking error handler thread
[371546.640078] scsi host8: scsi_eh_8: waking up 0/1/1
[371546.640098] sd 8:0:0:0: [sg17] tag#13 scsi_eh_8: flush finish cmd
[371546.640113] scsi host8: waking up host to restart
[371546.640117] scsi host8: scsi_eh_8: sleeping

[371546.657269] sd 6:0:0:0: [sg12] tag#1 abort scheduled
[371546.664034] sd 6:0:0:0: [sg12] tag#1 aborting command
[371546.664040] sd 6:0:0:0: [sg12] tag#1 cmd abort failed

Here we can see that, error handler is not woken up.  And the entire
IO subsystem goes for a toss.

[371777.594510] INFO: task md2_raid1:508 blocked for more than 120 seconds.
[371777.594571]      Not tainted 4.4.0-31-generic #50~14.04.1-Ubuntu
[371777.594613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[371777.594665] md2_raid1      D ffff883fed2afc78    0  508      2 0x00000000
[371777.594673]  ffff883fed2afc78 ffff881fef0e8000 ffff883fed21c4c0
ffff883fed2b0000
[371777.594678]  ffff883ff236e298 ffff883ff236e000 ffff883ff236e018
ffff883ff236e018

By enabling more scsi logs(in a different system), including LL, we
get some more info ( I have enabled the full scsi levels for all
categories and it is still running)


System 2

[405197.171574] sd 5:0:0:0: [sg3] sg_write: count=3D88
[405197.171577] sd 5:0:0:0: scsi_block_when_processing_errors: rtn: 1
[405197.171581] sd 5:0:0:0: [sg3] sg_common_write:  scsi
opcode=3D0x85, cmd_size=3D16
[405197.171583] sd 5:0:0:0: [sg3] sg_start_req: dxfer_len=3D512
[405197.171605] sd 5:0:0:0: [sg3] sg_link_reserve: size=3D512
[405197.171623] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
[405197.172648] sd 5:0:0:0: [sg3] sg_cmd_done: pack_id=3D0, res=3D0x0
[405197.172701] sd 5:0:0:0: [sg3] sg_poll: res=3D0x145
[405197.172710] sd 5:0:0:0: [sg3] sg_read: count=3D88
[405197.172716] sd 5:0:0:0: [sg3] sg_finish_rem_req: res_used=3D1
[405197.172721] sd 5:0:0:0: [sg3] sg_unlink_reserve: req->k_use_sg=3D1
[405197.172756] sd 5:0:0:0: [sg3] sg_write: count=3D88
[405197.172760] sd 5:0:0:0: scsi_block_when_processing_errors: rtn: 1
[405197.172764] sd 5:0:0:0: [sg3] sg_common_write:  scsi
opcode=3D0x85, cmd_size=3D16
[405197.172767] sd 5:0:0:0: [sg3] sg_start_req: dxfer_len=3D512
[405197.172774] sd 5:0:0:0: [sg3] sg_link_reserve: size=3D512
[405197.172793] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
[405197.173806] sd 5:0:0:0: [sg3] sg_cmd_done: pack_id=3D0, res=3D0x0
[405197.173829] sd 5:0:0:0: [sg3] sg_poll: res=3D0x145
[405197.173836] sd 5:0:0:0: [sg3] sg_read: count=3D88
[405197.173839] sd 5:0:0:0: [sg3] sg_finish_rem_req: res_used=3D1
[405197.173843] sd 5:0:0:0: [sg3] sg_unlink_reserve: req->k_use_sg=3D1
[405197.173893] sd 5:0:0:0: [sg3] sg_write: count=3D88
[405197.173896] sd 5:0:0:0: scsi_block_when_processing_errors: rtn: 1
[405197.173900] sd 5:0:0:0: [sg3] sg_common_write:  scsi
opcode=3D0x85, cmd_size=3D16
[405197.173903] sd 5:0:0:0: [sg3] sg_start_req: dxfer_len=3D0
[405197.173921] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104

[405197.174082] sd 5:0:0:0: [sg3] tag#5 abort scheduled
[405197.179372] sd 5:0:0:0: [sg3] tag#5 aborting command
[405197.179378] sd 5:0:0:0: [sg3] tag#5 cmd abort failed

[405257.225584] sd 5:0:0:0: [sg3] sg_poll: res=3D0x104
[405257.225599] sd 5:0:0:0: [sg3] sg_release
[405257.225617] sd 5:0:0:0: [sg3] sg_open: flags=3D0x8002

Error handler thread is not waken up here (or) i dont see flush
command trace (even if it is already woken up)

[405349.082863] INFO: task md2_raid1:484 blocked for more than 120 seconds
[405349.082922]      Not tainted 4.4.0-31-generic #50~14.04.1-Ubuntu
[405349.082964] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[405349.083016] md2_raid1      D ffff881feca2bc78    0  484      2 0x00000000

--001a1148d5d46d0a1a054a197367
Content-Type: application/octet-stream; name="udevadm_sdd_130.2"
Content-Disposition: attachment; filename="udevadm_sdd_130.2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_izytkooc1

ClVkZXZhZG0gaW5mbyBzdGFydHMgd2l0aCB0aGUgZGV2aWNlIHNwZWNpZmllZCBieSB0aGUgZGV2
cGF0aCBhbmQgdGhlbgp3YWxrcyB1cCB0aGUgY2hhaW4gb2YgcGFyZW50IGRldmljZXMuIEl0IHBy
aW50cyBmb3IgZXZlcnkgZGV2aWNlCmZvdW5kLCBhbGwgcG9zc2libGUgYXR0cmlidXRlcyBpbiB0
aGUgdWRldiBydWxlcyBrZXkgZm9ybWF0LgpBIHJ1bGUgdG8gbWF0Y2gsIGNhbiBiZSBjb21wb3Nl
ZCBieSB0aGUgYXR0cmlidXRlcyBvZiB0aGUgZGV2aWNlCmFuZCB0aGUgYXR0cmlidXRlcyBmcm9t
IG9uZSBzaW5nbGUgcGFyZW50IGRldmljZS4KCiAgbG9va2luZyBhdCBkZXZpY2UgJy9kZXZpY2Vz
L3BjaTAwMDA6MDAvMDAwMDowMDoxZi4yL2F0YTYvaG9zdDUvdGFyZ2V0NTowOjAvNTowOjA6MC9i
bG9jay9zZGQnOgogICAgS0VSTkVMPT0ic2RkIgogICAgU1VCU1lTVEVNPT0iYmxvY2siCiAgICBE
UklWRVI9PSIiCiAgICBBVFRSe3JvfT09IjAiCiAgICBBVFRSe3NpemV9PT0iMTk1MzUyNTE2OCIK
ICAgIEFUVFJ7c3RhdH09PSIgIDU5NDQxNiAgICAgICA1MyAgNTE0NjYzMiAgMjQwMzU4NCAgMTg0
MTY3MSAgMTE1MDc1NCAzMDgwNjQ0MSAxNTY0NTM2NCAgICAgICAgNiA3NDQ5MTcxMiAzMTE4NTQ3
NDAiCiAgICBBVFRSe3JhbmdlfT09IjE2IgogICAgQVRUUntkaXNjYXJkX2FsaWdubWVudH09PSIw
IgogICAgQVRUUntldmVudHN9PT0iIgogICAgQVRUUntleHRfcmFuZ2V9PT0iMjU2IgogICAgQVRU
UntldmVudHNfcG9sbF9tc2Vjc309PSItMSIKICAgIEFUVFJ7YWxpZ25tZW50X29mZnNldH09PSIw
IgogICAgQVRUUntpbmZsaWdodH09PSIgICAgICAgMCAgICAgICAgNiIKICAgIEFUVFJ7cmVtb3Zh
YmxlfT09IjAiCiAgICBBVFRSe2NhcGFiaWxpdHl9PT0iNTAiCiAgICBBVFRSe2V2ZW50c19hc3lu
Y309PSIiCgogIGxvb2tpbmcgYXQgcGFyZW50IGRldmljZSAnL2RldmljZXMvcGNpMDAwMDowMC8w
MDAwOjAwOjFmLjIvYXRhNi9ob3N0NS90YXJnZXQ1OjA6MC81OjA6MDowJzoKICAgIEtFUk5FTFM9
PSI1OjA6MDowIgogICAgU1VCU1lTVEVNUz09InNjc2kiCiAgICBEUklWRVJTPT0ic2QiCiAgICBB
VFRSU3tyZXZ9PT0iQTNVMCIKICAgIEFUVFJTe3R5cGV9PT0iMCIKICAgIEFUVFJTe3Njc2lfbGV2
ZWx9PT0iNiIKICAgIEFUVFJTe21vZGVsfT09IkhHU1QgSFRFNzIxMDEwQTkiCiAgICBBVFRSU3tz
dGF0ZX09PSJydW5uaW5nIgogICAgQVRUUlN7dW5sb2FkX2hlYWRzfT09IjAiCiAgICBBVFRSU3tx
dWV1ZV90eXBlfT09Im5vbmUiCiAgICBBVFRSU3tpb2RvbmVfY250fT09IjB4M2MyN2QyIgogICAg
QVRUUlN7aW9yZXF1ZXN0X2NudH09PSIweDNlNGMwOSIKICAgIEFUVFJTe3F1ZXVlX3JhbXBfdXBf
cGVyaW9kfT09IjEyMDAwMCIKICAgIEFUVFJTe2RldmljZV9idXN5fT09IjEiCiAgICBBVFRSU3tl
dnRfY2FwYWNpdHlfY2hhbmdlX3JlcG9ydGVkfT09IjAiCiAgICBBVFRSU3t0aW1lb3V0fT09IjMw
IgogICAgQVRUUlN7ZXZ0X21lZGlhX2NoYW5nZX09PSIwIgogICAgQVRUUlN7aW9lcnJfY250fT09
IjB4MTRiOSIKICAgIEFUVFJTe3F1ZXVlX2RlcHRofT09IjMxIgogICAgQVRUUlN7dmVuZG9yfT09
IkFUQSAgICAgIgogICAgQVRUUlN7ZXZ0X3NvZnRfdGhyZXNob2xkX3JlYWNoZWR9PT0iMCIKICAg
IEFUVFJTe2RldmljZV9ibG9ja2VkfT09IjEiCiAgICBBVFRSU3tldnRfbW9kZV9wYXJhbWV0ZXJf
Y2hhbmdlX3JlcG9ydGVkfT09IjAiCiAgICBBVFRSU3tldnRfbHVuX2NoYW5nZV9yZXBvcnRlZH09
PSIwIgogICAgQVRUUlN7ZXZ0X2lucXVpcnlfY2hhbmdlX3JlcG9ydGVkfT09IjAiCiAgICBBVFRS
U3tkaF9zdGF0ZX09PSJkZXRhY2hlZCIKICAgIEFUVFJTe2lvY291bnRlcmJpdHN9PT0iMzIiCiAg
ICBBVFRSU3tpbnF1aXJ5fT09IiIKICAgIEFUVFJTe3ZwZF9wZzgwfT09IiIKICAgIEFUVFJTe3Zw
ZF9wZzgzfT09IiIKICAgIEFUVFJTe2VoX3RpbWVvdXR9PT0iMTAiCgogIGxvb2tpbmcgYXQgcGFy
ZW50IGRldmljZSAnL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjFmLjIvYXRhNi9ob3N0NS90
YXJnZXQ1OjA6MCc6CiAgICBLRVJORUxTPT0idGFyZ2V0NTowOjAiCiAgICBTVUJTWVNURU1TPT0i
c2NzaSIKICAgIERSSVZFUlM9PSIiCgogIGxvb2tpbmcgYXQgcGFyZW50IGRldmljZSAnL2Rldmlj
ZXMvcGNpMDAwMDowMC8wMDAwOjAwOjFmLjIvYXRhNi9ob3N0NSc6CiAgICBLRVJORUxTPT0iaG9z
dDUiCiAgICBTVUJTWVNURU1TPT0ic2NzaSIKICAgIERSSVZFUlM9PSIiCgogIGxvb2tpbmcgYXQg
cGFyZW50IGRldmljZSAnL2RldmljZXMvcGNpMDAwMDowMC8wMDAwOjAwOjFmLjIvYXRhNic6CiAg
ICBLRVJORUxTPT0iYXRhNiIKICAgIFNVQlNZU1RFTVM9PSIiCiAgICBEUklWRVJTPT0iIgoKICBs
b29raW5nIGF0IHBhcmVudCBkZXZpY2UgJy9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxZi4y
JzoKICAgIEtFUk5FTFM9PSIwMDAwOjAwOjFmLjIiCiAgICBTVUJTWVNURU1TPT0icGNpIgogICAg
RFJJVkVSUz09ImFoY2kiCiAgICBBVFRSU3tpcnF9PT0iNDMiCiAgICBBVFRSU3tzdWJzeXN0ZW1f
dmVuZG9yfT09IjB4MTUyZCIKICAgIEFUVFJTe2Jyb2tlbl9wYXJpdHlfc3RhdHVzfT09IjAiCiAg
ICBBVFRSU3tjbGFzc309PSIweDAxMDYwMSIKICAgIEFUVFJTe2luZGV4fT09IjEiCiAgICBBVFRS
U3tsYWJlbH09PSJJbnRlbChSKSBDNjEwIHNlcmllcy9YOTkgY2hpcHNldCBTQVRBIENvbnRyb2xs
ZXIiCiAgICBBVFRSU3tkcml2ZXJfb3ZlcnJpZGV9PT0iKG51bGwpIgogICAgQVRUUlN7Y29uc2lz
dGVudF9kbWFfbWFza19iaXRzfT09IjY0IgogICAgQVRUUlN7ZG1hX21hc2tfYml0c309PSI2NCIK
ICAgIEFUVFJTe2xvY2FsX2NwdXN9PT0iMDAsM2ZmMDAzZmYiCiAgICBBVFRSU3tkZXZpY2V9PT0i
MHg4ZDAyIgogICAgQVRUUlN7ZW5hYmxlfT09IjEiCiAgICBBVFRSU3ttc2lfYnVzfT09IjEiCiAg
ICBBVFRSU3tsb2NhbF9jcHVsaXN0fT09IjAtOSwyMC0yOSIKICAgIEFUVFJTe3ZlbmRvcn09PSIw
eDgwODYiCiAgICBBVFRSU3tzdWJzeXN0ZW1fZGV2aWNlfT09IjB4ODlkNSIKICAgIEFUVFJTe251
bWFfbm9kZX09PSIwIgogICAgQVRUUlN7ZDNjb2xkX2FsbG93ZWR9PT0iMSIKCiAgbG9va2luZyBh
dCBwYXJlbnQgZGV2aWNlICcvZGV2aWNlcy9wY2kwMDAwOjAwJzoKICAgIEtFUk5FTFM9PSJwY2kw
MDAwOjAwIgogICAgU1VCU1lTVEVNUz09IiIKICAgIERSSVZFUlM9PSIiCgo=
--001a1148d5d46d0a1a054a197367--
