From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: Re: scst_vdisk: Resize-fsync() race fails IO
Date: Mon, 21 Mar 2016 16:22:38 +0100
Message-ID: <56F011BE.9030403@profitbricks.com>
References: <56EBEFAA.9040501@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070907000509030009050601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35976 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbcCUPWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 11:22:41 -0400
Received: by mail-wm0-f48.google.com with SMTP id r129so55138893wmr.1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2016 08:22:40 -0700 (PDT)
In-Reply-To: <56EBEFAA.9040501@profitbricks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Scst-devel <Scst-devel@lists.sourceforge.net>, Bart Van Assche <bart.vanassche@sandisk.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Christoph Hellwig <hch@infradead.org>

This is a multi-part message in MIME format.
--------------070907000509030009050601
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 18.03.2016 13:08, Sebastian Parschauer wrote:
> Hi,
> 
> we are live resizing LVM LVs below SCST/SRP but we only increase the size.
> 
> Writing to /sys/kernel/scst_tgt/devices/$DEV/resync_size with a new
> device size races against fsync() from the SRP initiator so that IO is
> failed. Resizing SCST devices only with reads/writes going on works.
> 
> With the vdisk_fileio handler this is quite sporadic but with
> vdisk_blockio it can be triggered immediately.
> 
> I'm attaching my LV resizing test script and the fsync() script run on
> the initiator on top of ib_srp devices.
> 
> I suspect an issue with usage of virt_dev->file_size in
> vdisk_synchronize_cache() at
> https://sourceforge.net/p/scst/svn/HEAD/tree/trunk/scst/src/dev_handlers/scst_vdisk.c#l1866.
> 
> Cheers,
> Sebastian
> 
> 
> === Details ===
> 
> Error in kernel log:
> 
> [69514.891904] sd 10:0:0:1: Capacity data has changed
> [69514.891962] end_request: I/O error, dev sdc, sector 0
> 
> fsync script output:
> 
> Traceback (most recent call last):
>   File "<string>", line 1, in <module>
> OSError: [Errno 5] Input/output error
> 

+CC: linux-scsi, hch

Hi SCSI developers,

I've debugged this further with a v4.5 kernel and full SCSI command
logging enabled on the initiator side. It seems to be a SCSI issue. SCSI
commands succeed but result 8000002 is reported to the upper driver
which seems to fail IO.

What does result 8000002 mean?

Please help me to fix the issue.

Thanks,
Sebastian

dmesg output of the IO error with SCSI debugging:

> [   84.450906] sd 6:0:0:1: [sdc] sd_open
> [   84.451008] sd 6:0:0:1: scsi_block_when_processing_errors: rtn: 1
> [   84.451084] sd 6:0:0:1: [sdc] tag#1 Send: scmd 0xffff880210357080
> [   84.451143] sd 6:0:0:1: [sdc] tag#1 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> [   84.456081] sd 6:0:0:1: [sdc] tag#0 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [   84.456209] sd 6:0:0:1: [sdc] tag#0 CDB: Read(10) 28 00 00 00 01 10 00 00 08 00
> [   84.456295] sd 6:0:0:1: [sdc] tag#0 scsi host busy 2 failed 0
> [   84.456374] sd 6:0:0:1: Notifying upper driver of completion (result 0)
> [   84.456438] sd 6:0:0:1: [sdc] tag#0 sd_done: completed 4096 of 4096 bytes
> [   84.456498] sd 6:0:0:1: [sdc] tag#0 8 sectors total, 4096 bytes done.
> [   84.456595] sd 6:0:0:1: Capacity data has changed
> [   84.456612] sd 6:0:0:1: [sdc] sd_setup_read_write_cmnd: block=280, count=8
> [   84.456616] sd 6:0:0:1: [sdc] block=280
> [   84.456620] sd 6:0:0:1: [sdc] reading 8/8 512 byte blocks.
> [   84.456628] sd 6:0:0:1: [sdc] tag#0 Send: scmd 0xffff8800ca41ed80
> [   84.456634] sd 6:0:0:1: [sdc] tag#0 CDB: Read(10) 28 00 00 00 01 18 00 00 08 00
> [   84.457003] sd 6:0:0:1: [sdc] tag#1 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [   84.457090] sd 6:0:0:1: [sdc] tag#1 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> [   84.457211] sd 6:0:0:1: [sdc] tag#1 Sense Key : Unit Attention [current] 
> [   84.457272] sd 6:0:0:1: [sdc] tag#1 Add. Sense: Capacity data has changed
> [   84.457331] sd 6:0:0:1: [sdc] tag#1 scsi host busy 2 failed 0
> [   84.457387] sd 6:0:0:1: Notifying upper driver of completion (result 8000002)
> [   84.457445] sd 6:0:0:1: [sdc] tag#1 sd_done: completed 0 of 0 bytes
> [   84.457503] sd 6:0:0:1: [sdc] tag#1 0 sectors total, 0 bytes done.
> [   84.457562] blk_update_request: I/O error, dev sdc, sector 0
> [   84.457637] sd 6:0:0:1: [sdc] tag#0 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [   84.457757] sd 6:0:0:1: [sdc] tag#0 CDB: Read(10) 28 00 00 00 01 18 00 00 08 00
> [   84.457842] sd 6:0:0:1: [sdc] tag#0 scsi host busy 1 failed 0
> [   84.457899] sd 6:0:0:1: Notifying upper driver of completion (result 0)
> [   84.457959] sd 6:0:0:1: [sdc] tag#0 sd_done: completed 4096 of 4096 bytes
> [   84.458019] sd 6:0:0:1: [sdc] tag#0 8 sectors total, 4096 bytes done.
> [   84.458111] sd 6:0:0:1: [sdc] sd_setup_read_write_cmnd: block=288, count=8
> [   84.458180] sd 6:0:0:1: [sdc] block=288

--------------070907000509030009050601
Content-Type: text/plain; charset=UTF-8;
 name="resize_vol1.sh.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="resize_vol1.sh.txt"

IyEvYmluL2Jhc2gKCnNldCAtZQojc2V0IC14CgpGSUxFMT0iL2Rldi9zdG9yYWdlL3ZvbDEi
CklOQz00Cgpkb19yZXNpemUoKSB7CiAgICBGSUxFPSQxCiAgICBERVY9YGJhc2VuYW1lICRG
SUxFYAogICAgZWNobyAiRklMRTogJEZJTEUiCiAgICBTSVpFPWBibG9ja2RldiAtLWdldHNp
emU2NCAkRklMRWAKICAgIGxldCAiU0laRSAvPSAoMTAyNCAqIDEwMjQpIgogICAgZWNobyAi
U0laRTogJFNJWkUiCiAgICBsZXQgIlNJWkUgKz0gSU5DIgogICAgZWNobyAiTkVXX1NJWkU6
ICRTSVpFIgogICAgbHZyZXNpemUgLUwgIiske0lOQ31NIiAkRklMRSA+L2Rldi9udWxsCiAg
ICBTSVpFPWBibG9ja2RldiAtLWdldHNpemU2NCAkRklMRWAKICAgIGxldCAiU0laRSAvPSAo
MTAyNCAqIDEwMjQpIgogICAgZWNobyAiU0VUX1NJWkU6ICRTSVpFIgogICAgZWNobyAxID4g
L3N5cy9rZXJuZWwvc2NzdF90Z3QvZGV2aWNlcy8kREVWL3Jlc3luY19zaXplCn0KCndoaWxl
IFsgMSBdOyBkbwogICAgZG9fcmVzaXplICRGSUxFMQpkb25lCg==
--------------070907000509030009050601
Content-Type: text/plain; charset=UTF-8;
 name="test_resize_fsync.sh.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="test_resize_fsync.sh.txt"

IyEvYmluL2Jhc2gKCiMgdGVzdCByZXNpemUgb24gc3RvcmFnZSB3aGlsZSB3ZSBkbyBmc3lu
YygpcyBhbGwgdGhlIHRpbWUKIyBvbiB0aGUgU1JQIGluaXRpYXRvcgoKREVWPS9kZXYvc2Rj
CgpSQz0wCndoaWxlIFsgJFJDIC1lcSAwIF07IGRvCiAgICBweXRob24gLWMgImltcG9ydCBv
czsgb3MuZnN5bmMob3Mub3BlbignJERFVicsIG9zLk9fUkRXUikpIgogICAgUkM9JD8KZG9u
ZQo=
--------------070907000509030009050601--
