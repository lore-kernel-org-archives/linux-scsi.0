From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 13:37:18 +0100
Message-ID: <1204634238.5997.5.camel@homer.simson.net>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	 <20080304085944.GG6704@kernel.dk>
	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080304093536.GH6704@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:

> Looks excellent to me, has a variant of this been tested as OK by the
> users reporting the regression?

K3b burning seems to be a nogo here.  This is git pulled this morning
though, so it's a somewhat different tree than previously tested fwtw.

[  136.440021] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
[  136.440043] ata1.01: cmd a0/00:00:00:00:00/00:00:00:00:00/b0 tag 0
[  136.440045]          cdb 51 00 00 00 00 00 00 00  02 00 00 00 00 00 00 00
[  136.440047]          res 58/00:02:00:02:00/00:00:00:00:00/b0 Emask 0x2 (HSM violation)
[  136.440053] ata1.01: status: { DRDY DRQ }
[  136.440086] ata1: soft resetting link
[  165.327627] ata1.01: qc timeout (cmd 0xa1)
[  165.327627] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[  165.327627] ata1.01: revalidation failed (errno=-5)
[  165.327627] ata1: failed to recover some devices, retrying in 5 secs
[  177.272373] ata1: port is slow to respond, please be patient (Status 0x80)
[  180.388879] ata1: device not ready (errno=-16), forcing hardreset
[  180.388879] ata1: soft resetting link
[  210.832471] ata1.01: qc timeout (cmd 0xa1)
[  210.832471] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[  210.832471] ata1.01: revalidation failed (errno=-5)
[  210.832471] ata1: failed to recover some devices, retrying in 5 secs
[  223.392899] ata1: port is slow to respond, please be patient (Status 0x80)
[  225.920376] ata1: device not ready (errno=-16), forcing hardreset
[  225.920376] ata1: soft resetting link
[  256.542565] ata1.01: qc timeout (cmd 0xa1)
[  256.542565] ata1.01: failed to IDENTIFY (I/O error, err_mask=0x4)
[  256.542565] ata1.01: revalidation failed (errno=-5)
[  256.542565] ata1.01: disabled
[  259.995199] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[  259.995214] ata1.00: revalidation failed (errno=-5)
[  259.995219] ata1: failed to recover some devices, retrying in 5 secs
[  265.047502] ata1: soft resetting link
[  262.397570] ata1.00: limited to UDMA/33 due to 40-wire cable
[  262.420039] ata1.00: configured for UDMA/33
[  262.420039] sr 0:0:1:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[  262.420039] sr 0:0:1:0: [sr0] Sense Key : Aborted Command [current] [descriptor]
[  262.420039] Descriptor sense data with sense descriptors (in hex):
[  262.420039]         72 0b 47 00 00 00 00 0e 09 0c 00 00 00 02 00 00 
[  262.420039]         00 02 00 00 b0 58 
[  262.420039] sr 0:0:1:0: [sr0] Add. Sense: Scsi parity error
[  262.420039] ata1: EH complete
[  262.420257] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[  262.420320] sd 0:0:0:0: [sda] Write Protect is off
[  262.420326] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  262.420390] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA



