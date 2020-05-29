Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21D4C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 20:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5A39208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 20:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgE2UxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 16:53:20 -0400
Received: from smtp.infotech.no ([82.134.31.41]:33351 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgE2UxT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 16:53:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 88A4D20418F;
        Fri, 29 May 2020 22:53:16 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CCo19YGkQ4v6; Fri, 29 May 2020 22:53:13 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 3262320415B;
        Fri, 29 May 2020 22:53:11 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCHv4 0/5] scsi: use xarray for devices and targets
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200529134730.146573-1-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <fd8dbf08-51b1-ec2b-2901-dcbfa821ae7b@interlog.com>
Date:   Fri, 29 May 2020 16:53:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529134730.146573-1-hare@suse.de>
Content-Type: multipart/mixed;
 boundary="------------1402A358FBE37270DC58CB86"
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------1402A358FBE37270DC58CB86
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2020-05-29 9:47 a.m., Hannes Reinecke wrote:
> Hi all,
> 
> based on the ideas from Doug Gilbert here's now my take on using
> xarrays for devices and targets.
> It revolves around two ideas:
> 
>   - The scsi target 'channel' and 'id' numbers are never ever used
>     to the full 32 bit range; channels are well below 10, and no
>     driver is using more than 16 bits for the id. So we can reduce
>     the type of 'channel' and 'id' to 16 bits, and use the 32 bit
>     value 'channel << 16 | id' as the index into the target xarray.
>   - Most SCSI targets are only using the first 32 bits of the 64 bit
>     LUN structure. So there we can use the LUN number as the index into
>     the xarray; larger LUN numbers won't fit, so we'll allocate a
>     separate index for those. For these device lookup won't be as
>     efficient, but one can argue that we're running into scalability
>     issues long before that.
> 
> With these changes we can implement an efficient lookup mechanism,
> devolving into direct lookup for most cases.
> And iteration over devices should be as efficient as the current,
> list-based, approach.
> 
> It also removes the current duality between host-based and
> target-based device lists; now all devices are listed per target,
> and a full iteration would need to iterate first over all targets
> and then over all devices per target.
> 
> As usual, comments and reviews are welcome
> 
> Changes to v1:
> - Fixup __scsi_iterate_devices()
> - Include reviews from Johannes
> - Minor fixes
> - Include comments from Doug
> 
> Changes to v2:
> - Reshuffle hunks as per suggestion from Johannes
> 
> Changes to v3:
> - Use GFP_ATOMIC instead of GFP_KERNEL
> - Fixup target iteration as reported by Doug Gilbert
> - Update scsi_error to make use of the new iterators
> 
> Hannes Reinecke (5):
>    scsi: convert target lookup to xarray
>    target_core_pscsi: use __scsi_device_lookup()
>    scsi: move target device list to xarray
>    scsi: remove direct device lookup per host
>    scsi_error: use xarray lookup instead of wrappers
> 
>   drivers/scsi/hosts.c               |   4 +-
>   drivers/scsi/scsi.c                | 151 +++++++++++++++++++++++++++++--------
>   drivers/scsi/scsi_error.c          |  35 +++++----
>   drivers/scsi/scsi_lib.c            |   9 +--
>   drivers/scsi/scsi_priv.h           |   2 +
>   drivers/scsi/scsi_scan.c           |  73 +++++++++---------
>   drivers/scsi/scsi_sysfs.c          |  48 ++++++++----
>   drivers/target/target_core_pscsi.c |   8 +-
>   include/scsi/scsi_device.h         |  32 +++++---
>   include/scsi/scsi_host.h           |   5 +-
>   10 files changed, 243 insertions(+), 124 deletions(-)
> 

Hannes,
I'm pretty sure this one was happening yesterday, around about the same
number of sdev_s (i.e. sg791). The missing 0:0:1:0, 0:0:2:0, etc
distracted me. That is now fixed. See attached.

It was executing an rmmod at the time in the tst_sdebug_modpr_rmmod.sh
script. Just checked my logs from yesterday. It blew up at the same spot
in the code (but after /dev/sg971):

...
2020-05-28T20:44:31.543998-04:00 xtwo70 kernel: scsi 11:0:8:8: Attached scsi 
generic sg969 type 9
2020-05-28T20:44:31.545999-04:00 xtwo70 kernel: scsi 11:0:8:9: Attached scsi 
generic sg970 type 9
2020-05-28T20:44:31.558008-04:00 xtwo70 kernel: scsi 11:0:8:10: Attached scsi 
generic sg971 type 9
2020-05-28T20:44:45.660126-04:00 xtwo70 kernel: [UFW BLOCK] IN=enp0s31f6 OUT= 
MAC=54:e1:ad:36:d8:55:00:15:99:30:1d:2b:08:00 SRC=192.168.48.94 
DST=192.168.48.23 LEN=224 TOS=0x00 PREC=0x00 TTL=64 ID=34650 PROTO=UDP SPT=161 
DPT=48409 LEN=204
2020-05-28T20:44:45.692021-04:00 xtwo70 kernel: [UFW BLOCK] IN=enp0s31f6 OUT= 
MAC=54:e1:ad:36:d8:55:00:15:99:e9:97:99:08:00 SRC=192.168.48.55 
DST=192.168.48.23 LEN=258 TOS=0x00 PREC=0x00 TTL=64 ID=60034 PROTO=UDP SPT=161 
DPT=48409 LEN=238
2020-05-28T20:44:46.660191-04:00 xtwo70 kernel: [UFW BLOCK] IN=enp0s31f6 OUT= 
MAC=54:e1:ad:36:d8:55:00:15:99:e9:97:99:08:00 SRC=192.168.48.55 
DST=192.168.48.23 LEN=258 TOS=0x00 PREC=0x00 TTL=64 ID=60290 PROTO=UDP SPT=161 
DPT=48409 LEN=238
2020-05-28T20:44:46.660273-04:00 xtwo70 kernel: [UFW BLOCK] IN=enp0s31f6 OUT= 
MAC=54:e1:ad:36:d8:55:00:15:99:30:1d:2b:08:00 SRC=192.168.48.94 
DST=192.168.48.23 LEN=224 TOS=0x00 PREC=0x00 TTL=64 ID=34651 PROTO=UDP SPT=161 
DPT=48409 LEN=204
2020-05-28T20:46:46.306581-04:00 xtwo70 systemd-resolved[1953]: Server returned 
error NXDOMAIN, mitigating potential DNS violation DVE-2018-0001, retrying 
transaction with reduced feature level UDP.
2020-05-28T20:47:05.776485-04:00 xtwo70 kernel: BUG: unable to handle page fault 
for address: ffff8881327c6868
2020-05-28T20:47:05.776504-04:00 xtwo70 kernel: #PF: supervisor read access in 
kernel mode
2020-05-28T20:47:05.776506-04:00 xtwo70 kernel: #PF: error_code(0x0000) - 
not-present page
2020-05-28T20:47:05.776507-04:00 xtwo70 kernel: PGD 3c01067 P4D 3c01067 PUD 
22f031067 PMD 22ee9d067 PTE 800ffffecd839060
2020-05-28T20:47:05.776509-04:00 xtwo70 kernel: Oops: 0000 [#1] PREEMPT SMP 
DEBUG_PAGEALLOC PTI
2020-05-28T20:47:05.776510-04:00 xtwo70 kernel: CPU: 2 PID: 4647 Comm: rmmod Not 
tainted 5.7.0-rc1+ #74
2020-05-28T20:47:05.776511-04:00 xtwo70 kernel: Hardware name: LENOVO 
20K5S27Q02/20K5S27Q02, BIOS R0IET60W (1.38 ) 12/19/2019
2020-05-28T20:47:05.776512-04:00 xtwo70 kernel: RIP: 0010:xas_start+0x2a/0x1c0
2020-05-28T20:47:05.776513-04:00 xtwo70 kernel: Code: 41 55 41 54 55 53 48 8b 47 
18 48 89 fb 48 89 c2 83 e2 03 0f 84 8d 00 00 00 48 3d 05 c0 ff ff 76 06 48 83 fa 
02 74 50 4c 8b 2b <49> 8b 6d 50 e8 fd 2f c2 ff 85 c0 49 89 ec 74 0d 80 3d ef f0 
e4 00
2020-05-28T20:47:05.776514-04:00 xtwo70 kernel: RSP: 0000:ffffc900005bbc90 
EFLAGS: 00010013
2020-05-28T20:47:05.776514-04:00 xtwo70 kernel: RAX: 0000000000000003 RBX: 
ffffc900005bbd00 RCX: 00000000ceb8764a
2020-05-28T20:47:05.776515-04:00 xtwo70 kernel: RDX: 0000000000000003 RSI: 
ffffffffffffffff RDI: ffffc900005bbd00
2020-05-28T20:47:05.776516-04:00 xtwo70 kernel: RBP: ffffc900005bbd00 R08: 
000000008830cd27 R09: 0000000000000001
2020-05-28T20:47:05.776517-04:00 xtwo70 kernel: R10: 0000000000000001 R11: 
0000000000000003 R12: 0000000000000003
2020-05-28T20:47:05.776518-04:00 xtwo70 kernel: R13: ffff8881327c6818 R14: 
0000000000000040 R15: ffff88814020f020
2020-05-28T20:47:05.776519-04:00 xtwo70 kernel: FS:  00007f1361c6f540(0000) 
GS:ffff888226000000(0000) knlGS:0000000000000000
2020-05-28T20:47:05.776520-04:00 xtwo70 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
2020-05-28T20:47:05.776521-04:00 xtwo70 kernel: CR2: ffff8881327c6868 CR3: 
000000012f48e003 CR4: 00000000003606e0
2020-05-28T20:47:05.776522-04:00 xtwo70 kernel: Call Trace:
2020-05-28T20:47:05.776523-04:00 xtwo70 kernel: xas_load+0xa/0x50
2020-05-28T20:47:05.776524-04:00 xtwo70 kernel: xas_find+0x274/0x2c0
2020-05-28T20:47:05.776525-04:00 xtwo70 kernel: xa_find_after+0x163/0x1f0
2020-05-28T20:47:05.776526-04:00 xtwo70 kernel: scsi_forget_host+0xd2/0x129
2020-05-28T20:47:05.776527-04:00 xtwo70 kernel: scsi_remove_host+0x78/0x120
2020-05-28T20:47:05.776528-04:00 xtwo70 kernel: sdebug_driver_remove+0x3b/0x90 
[scsi_debug]
2020-05-28T20:47:05.776528-04:00 xtwo70 kernel: 
device_release_driver_internal+0xdf/0x1c0
2020-05-28T20:47:05.776529-04:00 xtwo70 kernel: bus_remove_device+0xe4/0x120
2020-05-28T20:47:05.776530-04:00 xtwo70 kernel: device_del+0x174/0x3c0
2020-05-28T20:47:05.776531-04:00 xtwo70 kernel: device_unregister+0x9/0x20
2020-05-28T20:47:05.776532-04:00 xtwo70 kernel: sdebug_do_remove_host+0xc0/0xe0 
[scsi_debug]
2020-05-28T20:47:05.776533-04:00 xtwo70 kernel: scsi_debug_exit+0x21/0xc5b 
[scsi_debug]
2020-05-28T20:47:05.776534-04:00 xtwo70 kernel: __x64_sys_delete_module+0x18f/0x230
2020-05-28T20:47:05.776535-04:00 xtwo70 kernel: ? lockdep_hardirqs_off+0x79/0xd0
2020-05-28T20:47:05.776537-04:00 xtwo70 kernel: ? trace_hardirqs_off_thunk+0x1a/0x1c
2020-05-28T20:47:05.776538-04:00 xtwo70 kernel: do_syscall_64+0x4b/0x1c0
2020-05-28T20:47:05.776539-04:00 xtwo70 kernel: entry_SYSCALL_64_after_hw

--------------1402A358FBE37270DC58CB86
Content-Type: text/plain; charset=UTF-8;
 name="oops.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="oops.txt"

MjAyMC0wNS0yOVQxNjoyNjoxNy42NzA5OTYtMDQ6MDAgeHR3bzcwIGtlcm5lbDogc2NzaSAx
MTowOjU6MTA6IEF0dGFjaGVkIHNjc2kgZ2VuZXJpYyBzZzc5MSB0eXBlIDkKMjAyMC0wNS0y
OVQxNjoyNjoxNy43ODUxMDItMDQ6MDAgeHR3bzcwIGtlcm5lbDogc2NzaSAwOjA6MDowOiBQ
b3dlci1vbiBvciBkZXZpY2UgcmVzZXQgb2NjdXJyZWQKMjAyMC0wNS0yOVQxNjoyNjoxNy43
OTcxNDQtMDQ6MDAgeHR3bzcwIGtlcm5lbDogc2NzaSAwOjA6MDoxOiBQb3dlci1vbiBvciBk
ZXZpY2UgcmVzZXQgb2NjdXJyZWQKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc2MDYtMDQ6MDAg
eHR3bzcwIGtlcm5lbDogQlVHOiB1bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9yIGFk
ZHJlc3M6IGZmZmY4ODgxNWMyMDY4NjgKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc2MzMtMDQ6
MDAgeHR3bzcwIGtlcm5lbDogI1BGOiBzdXBlcnZpc29yIHJlYWQgYWNjZXNzIGluIGtlcm5l
bCBtb2RlCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NjM1LTA0OjAwIHh0d283MCBrZXJuZWw6
ICNQRjogZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQgcGFnZQoyMDIwLTA1LTI5
VDE2OjI2OjE4LjI3NzY0MC0wNDowMCB4dHdvNzAga2VybmVsOiBQR0QgM2MwMTA2NyBQNEQg
M2MwMTA2NyBQVUQgMjJlZTMwMDY3IFBNRCAyMmVkNGUwNjcgUFRFIDgwMGZmZmZlYTNkZjkw
NjAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc2NTUtMDQ6MDAgeHR3bzcwIGtlcm5lbDogT29w
czogMDAwMCBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQyBQVEkKMjAyMC0wNS0y
OVQxNjoyNjoxOC4yNzc2NzEtMDQ6MDAgeHR3bzcwIGtlcm5lbDogQ1BVOiAwIFBJRDogNjc0
MiBDb21tOiBybW1vZCBOb3QgdGFpbnRlZCA1LjcuMC1yYzErICM3NQoyMDIwLTA1LTI5VDE2
OjI2OjE4LjI3NzY3Mi0wNDowMCB4dHdvNzAga2VybmVsOiBIYXJkd2FyZSBuYW1lOiBMRU5P
Vk8gMjBLNVMyN1EwMi8yMEs1UzI3UTAyLCBCSU9TIFIwSUVUNjFXICgxLjM5ICkgMDQvMjAv
MjAyMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY3My0wNDowMCB4dHdvNzAga2VybmVsOiBS
SVA6IDAwMTA6eGFzX3N0YXJ0KzB4MmEvMHgxYzAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc2
NzQtMDQ6MDAgeHR3bzcwIGtlcm5lbDogQ29kZTogNDEgNTUgNDEgNTQgNTUgNTMgNDggOGIg
NDcgMTggNDggODkgZmIgNDggODkgYzIgODMgZTIgMDMgMGYgODQgOGQgMDAgMDAgMDAgNDgg
M2QgMDUgYzAgZmYgZmYgNzYgMDYgNDggODMgZmEgMDIgNzQgNTAgNGMgOGIgMmIgPDQ5PiA4
YiA2ZCA1MCBlOCBmZCAyZiBjMiBmZiA4NSBjMCA0OSA4OSBlYyA3NCAwZCA4MCAzZCBlZiBm
MCBlNCAwMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY3NS0wNDowMCB4dHdvNzAga2VybmVs
OiBSU1A6IDAwMTg6ZmZmZmM5MDAwMTlkZmM5MCBFRkxBR1M6IDAwMDEwMDEzCjIwMjAtMDUt
MjlUMTY6MjY6MTguMjc3Njc2LTA0OjAwIHh0d283MCBrZXJuZWw6IFJBWDogMDAwMDAwMDAw
MDAwMDAwMyBSQlg6IGZmZmZjOTAwMDE5ZGZkMDAgUkNYOiAwMDAwMDAwMDRhMjc2NTdiCjIw
MjAtMDUtMjlUMTY6MjY6MTguMjc3Njc2LTA0OjAwIHh0d283MCBrZXJuZWw6IFJEWDogMDAw
MDAwMDAwMDAwMDAwMyBSU0k6IGZmZmZmZmZmZmZmZmZmZmYgUkRJOiBmZmZmYzkwMDAxOWRm
ZDAwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3Njc3LTA0OjAwIHh0d283MCBrZXJuZWw6IFJC
UDogZmZmZmM5MDAwMTlkZmQwMCBSMDg6IDAwMDAwMDAwMTg3N2I2YjYgUjA5OiAwMDAwMDAw
MDAwMDAwMDAxCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3Njc5LTA0OjAwIHh0d283MCBrZXJu
ZWw6IFIxMDogMDAwMDAwMDAwMDAwMDAwMSBSMTE6IDAwMDAwMDAwMDAwMDAwMDMgUjEyOiAw
MDAwMDAwMDAwMDAwMDAzCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3Njc5LTA0OjAwIHh0d283
MCBrZXJuZWw6IFIxMzogZmZmZjg4ODE1YzIwNjgxOCBSMTQ6IDAwMDAwMDAwMDAwMDAwNDAg
UjE1OiBmZmZmODg4MTVhZjU0MDIwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NjgwLTA0OjAw
IHh0d283MCBrZXJuZWw6IEZTOiAgMDAwMDdmYmZiYjU4YjU0MCgwMDAwKSBHUzpmZmZmODg4
MjI1ODAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKMjAyMC0wNS0yOVQxNjoy
NjoxOC4yNzc2ODEtMDQ6MDAgeHR3bzcwIGtlcm5lbDogQ1M6ICAwMDEwIERTOiAwMDAwIEVT
OiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY4
MS0wNDowMCB4dHdvNzAga2VybmVsOiBDUjI6IGZmZmY4ODgxNWMyMDY4NjggQ1IzOiAwMDAw
MDAwMTQxYTVhMDA2IENSNDogMDAwMDAwMDAwMDM2MDZmMAoyMDIwLTA1LTI5VDE2OjI2OjE4
LjI3NzY4Mi0wNDowMCB4dHdvNzAga2VybmVsOiBDYWxsIFRyYWNlOgoyMDIwLTA1LTI5VDE2
OjI2OjE4LjI3NzY4My0wNDowMCB4dHdvNzAga2VybmVsOiB4YXNfbG9hZCsweGEvMHg1MAoy
MDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY4My0wNDowMCB4dHdvNzAga2VybmVsOiB4YXNfZmlu
ZCsweDI3NC8weDJjMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY4NC0wNDowMCB4dHdvNzAg
a2VybmVsOiB4YV9maW5kX2FmdGVyKzB4MTYzLzB4MWYwCjIwMjAtMDUtMjlUMTY6MjY6MTgu
Mjc3Njg5LTA0OjAwIHh0d283MCBrZXJuZWw6IHNjc2lfZm9yZ2V0X2hvc3QrMHhkMi8weDEy
OQoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY5MC0wNDowMCB4dHdvNzAga2VybmVsOiBzY3Np
X3JlbW92ZV9ob3N0KzB4NzkvMHgxMjAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc2OTMtMDQ6
MDAgeHR3bzcwIGtlcm5lbDogc2RlYnVnX2RyaXZlcl9yZW1vdmUrMHgzYi8weGEwIFtzY3Np
X2RlYnVnXQoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3NzY5NC0wNDowMCB4dHdvNzAga2VybmVs
OiBkZXZpY2VfcmVsZWFzZV9kcml2ZXJfaW50ZXJuYWwrMHhkZi8weDFjMAoyMDIwLTA1LTI5
VDE2OjI2OjE4LjI3NzY5Ni0wNDowMCB4dHdvNzAga2VybmVsOiBidXNfcmVtb3ZlX2Rldmlj
ZSsweGU0LzB4MTIwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3Njk3LTA0OjAwIHh0d283MCBr
ZXJuZWw6IGRldmljZV9kZWwrMHgxNzQvMHgzYzAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3
MDAtMDQ6MDAgeHR3bzcwIGtlcm5lbDogZGV2aWNlX3VucmVnaXN0ZXIrMHg5LzB4MjAKMjAy
MC0wNS0yOVQxNjoyNjoxOC4yNzc3MDAtMDQ6MDAgeHR3bzcwIGtlcm5lbDogc2RlYnVnX2Rv
X3JlbW92ZV9ob3N0KzB4YzAvMHhlMCBbc2NzaV9kZWJ1Z10KMjAyMC0wNS0yOVQxNjoyNjox
OC4yNzc3MDEtMDQ6MDAgeHR3bzcwIGtlcm5lbDogc2NzaV9kZWJ1Z19leGl0KzB4MjEvMHhh
ODcgW3Njc2lfZGVidWddCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzA2LTA0OjAwIHh0d283
MCBrZXJuZWw6IF9feDY0X3N5c19kZWxldGVfbW9kdWxlKzB4MThmLzB4MjMwCjIwMjAtMDUt
MjlUMTY6MjY6MTguMjc3NzEyLTA0OjAwIHh0d283MCBrZXJuZWw6ID8gbG9ja2RlcF9oYXJk
aXJxc19vZmYrMHg3OS8weGQwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzE1LTA0OjAwIHh0
d283MCBrZXJuZWw6ID8gdHJhY2VfaGFyZGlycXNfb2ZmX3RodW5rKzB4MWEvMHgxYwoyMDIw
LTA1LTI5VDE2OjI2OjE4LjI3NzcyMS0wNDowMCB4dHdvNzAga2VybmVsOiBkb19zeXNjYWxs
XzY0KzB4NGIvMHgxYzAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3MjUtMDQ6MDAgeHR3bzcw
IGtlcm5lbDogZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDkvMHhiMwoyMDIw
LTA1LTI5VDE2OjI2OjE4LjI3NzcyOC0wNDowMCB4dHdvNzAga2VybmVsOiBSSVA6IDAwMzM6
MHg3ZmJmYmI2ZDdhM2IKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3MzItMDQ6MDAgeHR3bzcw
IGtlcm5lbDogQ29kZTogNzMgMDEgYzMgNDggOGIgMGQgNTUgODQgMGMgMDAgZjcgZDggNjQg
ODkgMDEgNDggODMgYzggZmYgYzMgNjYgMmUgMGYgMWYgODQgMDAgMDAgMDAgMDAgMDAgOTAg
ZjMgMGYgMWUgZmEgYjggYjAgMDAgMDAgMDAgMGYgMDUgPDQ4PiAzZCAwMSBmMCBmZiBmZiA3
MyAwMSBjMyA0OCA4YiAwZCAyNSA4NCAwYyAwMCBmNyBkOCA2NCA4OSAwMSA0OAoyMDIwLTA1
LTI5VDE2OjI2OjE4LjI3NzczNS0wNDowMCB4dHdvNzAga2VybmVsOiBSU1A6IDAwMmI6MDAw
MDdmZmRlMjMxZDlmOCBFRkxBR1M6IDAwMDAwMjA2IE9SSUdfUkFYOiAwMDAwMDAwMDAwMDAw
MGIwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzM2LTA0OjAwIHh0d283MCBrZXJuZWw6IFJB
WDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDA1NTliOGUzMWY3NTAgUkNYOiAwMDAwN2Zi
ZmJiNmQ3YTNiCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzM2LTA0OjAwIHh0d283MCBrZXJu
ZWw6IFJEWDogMDAwMDAwMDAwMDAwMDAwYSBSU0k6IDAwMDAwMDAwMDAwMDA4MDAgUkRJOiAw
MDAwNTU5YjhlMzFmN2I4CjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzY1LTA0OjAwIHh0d283
MCBrZXJuZWw6IFJCUDogMDAwMDdmZmRlMjMxZGE1OCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAg
UjA5OiAwMDAwMDAwMDAwMDAwMDAwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzY2LTA0OjAw
IHh0d283MCBrZXJuZWw6IFIxMDogMDAwMDdmYmZiYjc1M2FjMCBSMTE6IDAwMDAwMDAwMDAw
MDAyMDYgUjEyOiAwMDAwN2ZmZGUyMzFkYzMwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzY3
LTA0OjAwIHh0d283MCBrZXJuZWw6IFIxMzogMDAwMDdmZmRlMjMxZThiMCBSMTQ6IDAwMDA1
NTliOGUzMWYyYTAgUjE1OiAwMDAwNTU5YjhlMzFmNzUwCjIwMjAtMDUtMjlUMTY6MjY6MTgu
Mjc3NzY3LTA0OjAwIHh0d283MCBrZXJuZWw6IE1vZHVsZXMgbGlua2VkIGluOiBzY3NpX2Rl
YnVnKC0pIHNnIG5ldGNvbnNvbGUgY29uZmlnZnMgcmZjb21tIGhpZF9nZW5lcmljIGhpZHAg
aGlkIGZ1c2UgaW50ZWxfcmFwbF9tc3IgY21hYyBhZl9hbGcgYm5lcCBpd2xtdm0gaW50ZWxf
cmFwbF9jb21tb24gbWFjODAyMTEgeDg2X3BrZ190ZW1wX3RoZXJtYWwgaW50ZWxfcG93ZXJj
bGFtcCBjb3JldGVtcCBrdm1faW50ZWwgc25kX2hkYV9jb2RlY19oZG1pIHNuZF9oZGFfY29k
ZWNfcmVhbHRlayBzbmRfaGRhX2NvZGVjX2dlbmVyaWMgbGliYXJjNCBpd2x3aWZpIGt2bSBz
bmRfc2VxX2R1bW15IHNuZF9zZXFfb3NzIGk5MTUgc25kX3NlcV9taWRpIHNuZF9yYXdtaWRp
IHNuZF9zZXFfbWlkaV9ldmVudCBpcnFieXBhc3MgY3JjdDEwZGlmX3BjbG11bCBzbmRfc2Vx
IGdoYXNoX2NsbXVsbmlfaW50ZWwgc25kX2hkYV9pbnRlbCBjZmc4MDIxMSBhZXNuaV9pbnRl
bCBlZmlfcHN0b3JlIHNuZF9pbnRlbF9kc3BjZmcgY3J5cHRvX3NpbWQgc25kX2hkYV9jb2Rl
YyBzbmRfaHdkZXAgc25kX2hkYV9jb3JlIGJ0dXNiIGJ0cnRsIGNyeXB0ZCBidGJjbSBidGlu
dGVsIGJsdWV0b290aCBnbHVlX2hlbHBlciBubHNfaXNvODg1OV8xIG5sc19jcDQzNyB2ZmF0
IGludGVsX2NzdGF0ZSBmYXQgZHJtX2ttc19oZWxwZXIgaW50ZWxfdW5jb3JlIHRpX3VzYl8z
NDEwXzUwNTIgbWVpX21lIHVzYnNlcmlhbCBzbmRfcGNtIG1tY19ibG9jayBpbnB1dF9sZWRz
IGpveWRldiBpbnRlbF9yYXBsX3BlcmYgdGhpbmtwYWRfYWNwaSBtb3VzZWRldiBtZWkgZWNk
aF9nZW5lcmljIHNlcmlvX3JhdyBzeXNjb3B5YXJlYSBlY2MgZWZpdmFycyBudnJhbSBzeXNm
aWxscmVjdCBzbmRfc2VxX2RldmljZSBsZWR0cmlnX2F1ZGlvIHN5c2ltZ2JsdCBmYl9zeXNf
Zm9wcyBzbmRfdGltZXIgaW50ZWxfZ3R0IGludGVsX3hoY2lfdXNiX3JvbGVfc3dpdGNoIGky
Y19hbGdvX2JpdCByb2xlcyBpbnRlbF9wY2hfdGhlcm1hbCBzbmQgc291bmRjb3JlCjIwMjAt
MDUtMjlUMTY6MjY6MTguMjc3NzY5LTA0OjAwIHh0d283MCBrZXJuZWw6IHJma2lsbCBldmRl
diB2aWRlbyBtYWNfaGlkIG5mX2xvZ19pcHY2IGlwNnRfUkVKRUNUIG5mX3JlamVjdF9pcHY2
IHh0X2hsIGlwNnRfcnQgbmZfbG9nX2lwdjQgbmZfbG9nX2NvbW1vbiBpcHRfUkVKRUNUIG5m
X3JlamVjdF9pcHY0IHh0X0xPRyB4dF9saW1pdCB4dF9hZGRydHlwZSB4dF90Y3B1ZHAgeHRf
Y29ubnRyYWNrIG5mX2Nvbm50cmFjayBuZl9kZWZyYWdfaXB2NiBuZl9kZWZyYWdfaXB2NCBs
aWJjcmMzMmMgZHJtIGlwNnRhYmxlX2ZpbHRlciBpcDZfdGFibGVzIHBhcnBvcnRfcGMgcHBk
ZXYgaXB0YWJsZV9maWx0ZXIgbHAgcGFycG9ydCBkcm1fcGFuZWxfb3JpZW50YXRpb25fcXVp
cmtzIGFncGdhcnQgZWZpdmFyZnMgaXBfdGFibGVzIHhfdGFibGVzIGF1dG9mczQgcnRzeF9w
Y2lfc2RtbWMgbW1jX2NvcmUgeGhjaV9wY2kgeGhjaV9oY2QgdXNiY29yZSBlMTAwMGUgbnZt
ZSBpMmNfaTgwMSBpbnRlbF9scHNzX3BjaSBudm1lX2NvcmUgaW50ZWxfbHBzcyBydHN4X3Bj
aSBpZG1hNjQgY3JjMzJfcGNsbXVsIHZpcnRfZG1hIHVzYl9jb21tb24gW2xhc3QgdW5sb2Fk
ZWQ6IHNjc2lfZGVidWddCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzcwLTA0OjAwIHh0d283
MCBrZXJuZWw6IENSMjogZmZmZjg4ODE1YzIwNjg2OAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3
Nzc3MC0wNDowMCB4dHdvNzAga2VybmVsOiAtLS1bIGVuZCB0cmFjZSBlNjc2MjlhODA2ODY5
YTY0IF0tLS0KMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3NzEtMDQ6MDAgeHR3bzcwIGtlcm5l
bDogUklQOiAwMDEwOnhhc19zdGFydCsweDJhLzB4MWMwCjIwMjAtMDUtMjlUMTY6MjY6MTgu
Mjc3NzcxLTA0OjAwIHh0d283MCBrZXJuZWw6IENvZGU6IDQxIDU1IDQxIDU0IDU1IDUzIDQ4
IDhiIDQ3IDE4IDQ4IDg5IGZiIDQ4IDg5IGMyIDgzIGUyIDAzIDBmIDg0IDhkIDAwIDAwIDAw
IDQ4IDNkIDA1IGMwIGZmIGZmIDc2IDA2IDQ4IDgzIGZhIDAyIDc0IDUwIDRjIDhiIDJiIDw0
OT4gOGIgNmQgNTAgZTggZmQgMmYgYzIgZmYgODUgYzAgNDkgODkgZWMgNzQgMGQgODAgM2Qg
ZWYgZjAgZTQgMDAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3NzItMDQ6MDAgeHR3bzcwIGtl
cm5lbDogUlNQOiAwMDE4OmZmZmZjOTAwMDE5ZGZjOTAgRUZMQUdTOiAwMDAxMDAxMwoyMDIw
LTA1LTI5VDE2OjI2OjE4LjI3Nzc3Mi0wNDowMCB4dHdvNzAga2VybmVsOiBSQVg6IDAwMDAw
MDAwMDAwMDAwMDMgUkJYOiBmZmZmYzkwMDAxOWRmZDAwIFJDWDogMDAwMDAwMDA0YTI3NjU3
YgoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc3My0wNDowMCB4dHdvNzAga2VybmVsOiBSRFg6
IDAwMDAwMDAwMDAwMDAwMDMgUlNJOiBmZmZmZmZmZmZmZmZmZmZmIFJESTogZmZmZmM5MDAw
MTlkZmQwMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc3NC0wNDowMCB4dHdvNzAga2VybmVs
OiBSQlA6IGZmZmZjOTAwMDE5ZGZkMDAgUjA4OiAwMDAwMDAwMDE4NzdiNmI2IFIwOTogMDAw
MDAwMDAwMDAwMDAwMQoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc3NC0wNDowMCB4dHdvNzAg
a2VybmVsOiBSMTA6IDAwMDAwMDAwMDAwMDAwMDEgUjExOiAwMDAwMDAwMDAwMDAwMDAzIFIx
MjogMDAwMDAwMDAwMDAwMDAwMwoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc3NS0wNDowMCB4
dHdvNzAga2VybmVsOiBSMTM6IGZmZmY4ODgxNWMyMDY4MTggUjE0OiAwMDAwMDAwMDAwMDAw
MDQwIFIxNTogZmZmZjg4ODE1YWY1NDAyMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc3NS0w
NDowMCB4dHdvNzAga2VybmVsOiBGUzogIDAwMDA3ZmJmYmI1OGI1NDAoMDAwMCkgR1M6ZmZm
Zjg4ODIyNTgwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCjIwMjAtMDUtMjlU
MTY6MjY6MTguMjc3Nzc2LTA0OjAwIHh0d283MCBrZXJuZWw6IENTOiAgMDAxMCBEUzogMDAw
MCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKMjAyMC0wNS0yOVQxNjoyNjoxOC4y
Nzc3NzctMDQ6MDAgeHR3bzcwIGtlcm5lbDogQ1IyOiBmZmZmODg4MTVjMjA2ODY4IENSMzog
MDAwMDAwMDE0MWE1YTAwNiBDUjQ6IDAwMDAwMDAwMDAzNjA2ZjAKMjAyMC0wNS0yOVQxNjoy
NjoxOC4yNzc3NzctMDQ6MDAgeHR3bzcwIGtlcm5lbDogQlVHOiBzbGVlcGluZyBmdW5jdGlv
biBjYWxsZWQgZnJvbSBpbnZhbGlkIGNvbnRleHQgYXQgaW5jbHVkZS9saW51eC9wZXJjcHUt
cndzZW0uaDo0OQoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc3OC0wNDowMCB4dHdvNzAga2Vy
bmVsOiBpbl9hdG9taWMoKTogMSwgaXJxc19kaXNhYmxlZCgpOiAxLCBub25fYmxvY2s6IDAs
IHBpZDogNjc0MiwgbmFtZTogcm1tb2QKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3NzgtMDQ6
MDAgeHR3bzcwIGtlcm5lbDogSU5GTzogbG9ja2RlcCBpcyB0dXJuZWQgb2ZmLgoyMDIwLTA1
LTI5VDE2OjI2OjE4LjI3Nzc3OS0wNDowMCB4dHdvNzAga2VybmVsOiBpcnEgZXZlbnQgc3Rh
bXA6IDMxMTUzOAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4MC0wNDowMCB4dHdvNzAga2Vy
bmVsOiBoYXJkaXJxcyBsYXN0ICBlbmFibGVkIGF0ICgzMTE1MzcpOiBbPGZmZmZmZmZmODEy
NWQyZDA+XSBrZnJlZSsweDFiMC8weDMxMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4MC0w
NDowMCB4dHdvNzAga2VybmVsOiBoYXJkaXJxcyBsYXN0IGRpc2FibGVkIGF0ICgzMTE1Mzgp
OiBbPGZmZmZmZmZmODE4YjhiZTE+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MTEvMHg4
MAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4MS0wNDowMCB4dHdvNzAga2VybmVsOiBzb2Z0
aXJxcyBsYXN0ICBlbmFibGVkIGF0ICgzMTA0ODIpOiBbPGZmZmZmZmZmODFjMDAzOWQ+XSBf
X2RvX3NvZnRpcnErMHgzOWQvMHg0YTQKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3ODItMDQ6
MDAgeHR3bzcwIGtlcm5lbDogc29mdGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoMzEwNDczKTog
WzxmZmZmZmZmZjgxMDZlN2U3Pl0gaXJxX2V4aXQrMHhiNy8weGQwCjIwMjAtMDUtMjlUMTY6
MjY6MTguMjc3NzgyLTA0OjAwIHh0d283MCBrZXJuZWw6IFByZWVtcHRpb24gZGlzYWJsZWQg
YXQ6CjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3NzgzLTA0OjAwIHh0d283MCBrZXJuZWw6IFs8
MDAwMDAwMDAwMDAwMDAwMD5dIDB4MAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4NC0wNDow
MCB4dHdvNzAga2VybmVsOiBDUFU6IDAgUElEOiA2NzQyIENvbW06IHJtbW9kIFRhaW50ZWQ6
IEcgICAgICBEICAgICAgICAgICA1LjcuMC1yYzErICM3NQoyMDIwLTA1LTI5VDE2OjI2OjE4
LjI3Nzc4NC0wNDowMCB4dHdvNzAga2VybmVsOiBIYXJkd2FyZSBuYW1lOiBMRU5PVk8gMjBL
NVMyN1EwMi8yMEs1UzI3UTAyLCBCSU9TIFIwSUVUNjFXICgxLjM5ICkgMDQvMjAvMjAyMAoy
MDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4NS0wNDowMCB4dHdvNzAga2VybmVsOiBDYWxsIFRy
YWNlOgoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4NS0wNDowMCB4dHdvNzAga2VybmVsOiBk
dW1wX3N0YWNrKzB4NzEvMHhhMAoyMDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4Ni0wNDowMCB4
dHdvNzAga2VybmVsOiBfX19taWdodF9zbGVlcC5jb2xkKzB4ZjcvMHgxMGIKMjAyMC0wNS0y
OVQxNjoyNjoxOC4yNzc3ODctMDQ6MDAgeHR3bzcwIGtlcm5lbDogZXhpdF9zaWduYWxzKzB4
MmIvMHgzOTAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3ODctMDQ6MDAgeHR3bzcwIGtlcm5l
bDogZG9fZXhpdCsweGFmLzB4YjgwCjIwMjAtMDUtMjlUMTY6MjY6MTguMjc3Nzg4LTA0OjAw
IHh0d283MCBrZXJuZWw6ID8gdHJhY2VfaGFyZGlycXNfb2ZmX3RodW5rKzB4MWEvMHgxYwoy
MDIwLTA1LTI5VDE2OjI2OjE4LjI3Nzc4OS0wNDowMCB4dHdvNzAga2VybmVsOiByZXdpbmRf
c3RhY2tfZG9fZXhpdCsweDE3LzB4MjAKMjAyMC0wNS0yOVQxNjoyNjoxOC4yNzc3ODktMDQ6
MDAgeHR3bzcwIGtlcm5lbDogbm90ZTogcm1tb2RbNjc0Ml0gZXhpdGVkIHdpdGggcHJlZW1w
dF9jb3VudCAxCjIwMjAtMDUtMjlUMTY6MjY6MjIuNTI1MTAzLTA0OjAwIHh0d283MCBrZXJu
ZWw6IHN5c3RlbWRbMV06IHN5c3RlbWQtam91cm5hbGQtZGV2LWxvZy5zb2NrZXQ6IEZhaWxl
ZCB0byBxdWV1ZSBzZXJ2aWNlIHN0YXJ0dXAgam9iIChNYXliZSB0aGUgc2VydmljZSBmaWxl
IGlzIG1pc3Npbmcgb3Igbm90IGEgbm9uLXRlbXBsYXRlIHVuaXQ/KTogVW5pdCBzeXN0ZW1k
LWpvdXJuYWxkLnNlcnZpY2UgaXMgbWFza2VkLgoyMDIwLTA1LTI5VDE2OjI2OjIyLjUyNjUy
MC0wNDowMCB4dHdvNzAga2VybmVsOiBzeXN0ZW1kWzFdOiBzeXN0ZW1kLWpvdXJuYWxkLWRl
di1sb2cuc29ja2V0OiBGYWlsZWQgd2l0aCByZXN1bHQgJ3Jlc291cmNlcycuCjIwMjAtMDUt
MjlUMTY6MjY6MjIuNTMzMDU2LTA0OjAwIHh0d283MCBrZXJuZWw6IHN5c3RlbWRbMV06IHBh
Y2thZ2VraXQuc2VydmljZTogU3VjY2VlZGVkLgo=
--------------1402A358FBE37270DC58CB86--
