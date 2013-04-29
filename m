From: Florian Westphal <fw@strlen.de>
Subject: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
Date: Mon, 29 Apr 2013 17:26:39 +0200
Message-ID: <20130429152639.GG32324@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

After update to 3.8 dmesg is spammed with:

kernel: [ 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41
kernel: [ 280.272107] sd 8:0:0:0: [sda] Unhandled error code
kernel: [ 280.272110] sd 8:0:0:0: [sda]
kernel: [ 280.272112] Result: hostbyte=0x04 driverbyte=0x00
kernel: [ 280.272114] sd 8:0:0:0: [sda] CDB:
kernel: [ 280.272116] cdb[0]=0x41: 41 00 10 09 aa 22 00 00 08 00
kernel: [ 280.272123] end_request: I/O error, dev sda, sector 269068834
kernel: [ 280.272130] sda6: WRITE SAME failed. Manually zeroing.
[..]

This goes on and on.

I am not familiar with block layer or scsi drivers, so I don't know if this
is an issue with the 3w-xxxx driver or the block layer.

I've hacked around this by reverting "block: Make blkdev_issue_zeroout use WRITE SAME"
(579e8f3c7b2ecf7db91398d942d76457a3ddba21), as this hw doesn't support
write_same anyway.
