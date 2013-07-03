From: Meelis Roos <mroos@linux.ee>
Subject: Re: sparc ESP SCSI error handling BUG+hang
Date: Wed, 3 Jul 2013 14:05:40 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1307031353170.24784@math.ut.ee>
References: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1304211357540.2145@math.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> I revived my Sun E3000 after its main disk died, reinstalled Debian and 
> after long apuse I am testing linux kernels again on it. In general it 
> works fine but I left the bad disk connected and sometimes it causes ESP 
> SCSI BUG in esp_free_lun_tag. Sometimes it just works.

I instrumented the esp code in 3.10 with copious printks and got a better
picture.

Target 0 is sda and it works, target 1 is sdb (usually does not spin up),
target 2 is sdc, probably broken. I specifically left sdb and sdc in the
machine to debug esp.

I have filtered out target 0 devug printk-s and added/left 1 and 2 there.

ESP alloc 1 means esp_alloc_lun_tag for target 1
ESP free 2 means esp_free_lun_tag for target 2

The pattern is that usually target 2 commands are tagged and are allocated and
freed correctly. But on some condition, find_and_prep_issuable_command decides
to clear tag in command entry because of AUTOSENSE flag, and after that,
esp_free_lun_tag sees the entry as untagged, instead of tagged, but its
non_tagged_cmd field is NULL and does not equal to the specified command entry,
which causes BUG and hang because it happens in interrupt context.

I got stuck in understanding autosense - why are there 2 invocations of
esp0: Doing auto-sense for tgt[2] lun[0]
line?

[  216.087864] sd 0:0:1:0: [sdb] Write Protect is off
[  216.087892] sd 0:0:1:0: [sdb] Mode Sense: 9f 00 10 08
[  216.087962] ESP alloc 1: tagged, lp=fffff800fc780000, tag=32,0
[  216.087968] ESP alloc 1: done
[  216.088002] ESP: tgt[1] lun[0] scsi_cmd [ 1a 00 08 00 04 00 ]
[  216.122992] ESP free 1: tag 32,0
[  216.123193] ESP alloc 1: tagged, lp=fffff800fc780000, tag=32,0
[  216.123200] ESP alloc 1: done
[  216.123234] ESP: tgt[1] lun[0] scsi_cmd [ 1a 00 08 00 20 00 ]
[  216.191894] ESP free 1: tag 32,0
[  216.192011] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  216.192805] ESP alloc 2: tagged, lp=fffff800fc3d7000, tag=32,0
[  216.192812] ESP alloc 2: done
[  216.192842] ESP: tgt[2] lun[0] scsi_cmd [ 00 00 00 00 00 00 ]
[  216.230179] esp0: Doing auto-sense for tgt[2] lun[0]
[  216.230367] ESP: find_and_prep_issuable_command (AUTOSENSE) zeroing tag in 2 (fffff800fb193bc0), lp=fffff800fc3d7000
[  216.230376] esp0: Doing auto-sense for tgt[2] lun[0]
[  216.230812] ESP free 2: untagged, lp=fffff800fc3d7000
[  216.230827] lp=fffff800fc3d7000, lp->non_tagged_cmd=          (null), ent=fffff800fb193bc0
[  216.230837] kernel BUG at drivers/scsi/esp_scsi.c:620!

(the line number is of course wrong, it's the second BUG inside esp_free_lun_tag)

-- 
Meelis Roos (mroos@linux.ee)
