From: Tejun Heo <tj@kernel.org>
Subject: Re: MD/RAID time out writing superblock
Date: Tue, 15 Sep 2009 07:23:21 +0900
Message-ID: <4AAEC259.5000106@kernel.org>
References: <4A950FA6.4020408@redhat.com> <200909071726.56432.tfjellstrom@shaw.ca> <4AADF4E2.9030407@kernel.org> <200909141513.33381.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200909141513.33381.tfjellstrom@shaw.ca>
Sender: linux-ide-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-kernel@vger.kernel.org, Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Thomas Fjellstrom wrote:
> Sure, I've attached the full dmesg from a full test I ran today (I couldn't 
> find the old log where that bit came from). I'm running 2.6.31-rc9 right now, 
> and will probably update to the final 31 release soonish. The test I ran 
> actually finished (dd if=/dev/sdc of=/dev/null bs=8M), whereas with earlier 
> kernels it was completely failing. Of course, I was actually trying to bring 
> up the md raid0 array (2x2TB), mount the filesystem, and copy the files off 
> before. mdraid is probably more sensitive to the end_request errors than dd 
> is.

[    2.056357] ata5: softreset failed (device not ready)
[    2.056412] ata5: applying SB600 PMP SRST workaround and retrying

The above two are expected.  It's a bug in SB600 controller being
worked around.

[    2.220160] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.269157] ata5.00: ATA-8: WDC WD20EADS-00R6B0, 01.00A01, max UDMA/133
[    2.269214] ata5.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.275112] ata5.00: configured for UDMA/133

All seem well.

[ 7089.781711] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[ 7089.781731] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[ 7089.781735]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

This is SMART ENABLE OPERATIONS and the command gets retried a lot of
times with the same result.

[32410.780251] ata5.00: status: { DRDY }
[32410.780262] ata5: hard resetting link
[32411.264544] ata5: softreset failed (device not ready)
[32411.264554] ata5: applying SB600 PMP SRST workaround and retrying
[32411.428072] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[32411.440112] ata5.00: configured for UDMA/33
[32411.440148] ata5: EH complete
[32452.781180] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[32452.781199] ata5.00: cmd b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
[32452.781202]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

Then, one SMART RETURN STATUS gets timed out.

[32464.106741] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[32464.106751] ata5.00: irq_stat 0x40000001
[32464.106769] ata5.00: cmd 25/00:08:00:88:e0/00:00:e8:00:00/e0 tag 0 dma 4096 in
[32464.106772]          res 41/04:00:00:88:e0/00:00:e8:00:00/e0 Emask 0x1 (device error)

Then, device fails READ_EXT.

[32510.730059] Descriptor sense data with sense descriptors (in hex):
[32510.730064]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[32510.730082]         e8 e0 88 00
[32510.730090] sd 5:0:0:0: [sdc] Add. Sense: No additional sense information
[32510.730098] end_request: I/O error, dev sdc, sector 3907028992
[32510.730106] Buffer I/O error on device sdc, logical block 488378624

After several retries, libata gives up and sd does too.

[32510.730142] ata5: EH complete
[32526.780076] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[32526.780097] ata5.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[32526.780100]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[32526.780107] ata5.00: status: { DRDY }
[32526.780119] ata5: hard resetting link
[32536.785177] ata5: softreset failed (device not ready)
[32536.785189] ata5: hard resetting link
[32546.789238] ata5: softreset failed (device not ready)
[32546.789249] ata5: hard resetting link
[32557.360064] ata5: link is slow to respond, please be patient (ready=0)
[32573.836192] ata5: softreset failed (device not ready)
[32573.836202] ata5: applying SB600 PMP SRST workaround and retrying
[32581.792026] ata5: softreset failed (device not ready)
[32581.792039] ata5: hard resetting link
[32587.000775] ata5: softreset failed (device not ready)
[32587.000784] ata5: reset failed, giving up
[32587.000790] ata5.00: disabled
[32587.000822] ata5: EH complete

Then, SMART ENABLE again, which now drives the drive off the limit and
it never comes back.

Does disabling whatever is issuing those SMART commands make any
difference?

Thanks.

-- 
tejun
