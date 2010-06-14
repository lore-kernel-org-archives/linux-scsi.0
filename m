From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.34 PDC20268 PATA IO error loop makes system unusable
Date: Mon, 14 Jun 2010 09:43:28 +0200
Message-ID: <4C15DDA0.3020409@kernel.org>
References: <20100613154808.GA10408@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100613154808.GA10408@basil.fritz.box>
Sender: linux-ide-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Andi.

(cc'ing linux-scsi and quoting whole message)

On 06/13/2010 05:48 PM, Andi Kleen wrote:
> 
> Hi,
> 
> On 2.6.34:
> 
> While writing some data to an old PATA Maxtor disk connected to a
> PDC20268 Promise controller using the libata driver there were some
> IO errors.
> 
> After some time those resulted in a endless error message loop that
> made the system essentially unusable: (console was flooded and
> unusable, ssh was extremly slow etc.):
> 
> This does not exactly look like graceful error handling.
> 
> Excerpts from the log (full version available on request)
> 
> ata12.00: configured for UDMA/100
> ata12: EH complete
> ata12.00: configured for UDMA/100
> ata12: EH complete
> ata12.00: configured for UDMA/100
> ata12: EH complete
> ata12.00: configured for UDMA/100
> ata12: EH complete
> ata12.00: configured for UDMA/100
> ata12: EH complete
> ata12.00: configured for UDMA/100
> sd 11:0:0:0: [sdd] Unhandled sense code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 11:0:0:0: [sdd] Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 03 13 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
>        00 5b 23 bb 
> sd 11:0:0:0: [sdd] Add. Sense: Address mark not found for data field
> sd 11:0:0:0: [sdd] CDB: Read(10): 28 00 00 5b 23 4f 00 00 80 00
> ata12: EH complete
> ata12.00: limiting speed to UDMA/66:PIO4
> ata12: soft resetting link
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> sd 11:0:0:0: [sdd] Unhandled sense code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 11:0:0:0: [sdd] Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 03 13 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
>        00 5b 23 bb 
> sd 11:0:0:0: [sdd] Add. Sense: Address mark not found for data field
> sd 11:0:0:0: [sdd] CDB: Read(10): 28 00 00 5b 23 bb 00 00 04 00
> quiet_error: 10 callbacks suppressed
> ata12: EH complete
> EXT4-fs (dm-0): mounted filesystem with ordered data mode
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (dm-1): using internal journal
> EXT3-fs (dm-1): mounted filesystem with writeback data mode
> EXT4-fs (dm-2): mounted filesystem with ordered data mode
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> ata12: EH complete
> ata12.00: configured for UDMA/66
> 
> ...
> 
> sd 11:0:0:0: [sdd] Unhandled sense code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 11:0:0:0: [sdd] Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 03 13 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
>        00 5b 23 bb 
> sd 11:0:0:0: [sdd] Add. Sense: Address mark not found for data field
> sd 11:0:0:0: [sdd] CDB: Read(10): 28 00 00 5b 23 bb 00 00 04 00
> quiet_error: 10 callbacks suppressed
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> sd 11:0:0:0: [sdd] Unhandled sense code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 11:0:0:0: [sdd] Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>        72 03 13 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
>        00 5b 23 bb 
> sd 11:0:0:0: [sdd] Add. Sense: Address mark not found for data field
> sd 11:0:0:0: [sdd] CDB: Read(10): 28 00 00 5b 23 bb 00 00 04 00
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> ata12: EH complete
> ata12.00: configured for UDMA/33
> 
> 
> ... lots of similar messages until it goes down to PIO0 then some more errors ....
> 
> 
> ata12: soft resetting link
> ata12: soft resetting link
> ata12: link is slow to respond, please be patient (ready=0)
> ata12.00: qc timeout (cmd 0xec)
> ata12.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata12: link is slow to respond, please be patient (ready=0)
> ata12: soft resetting link
> ata12.00: disabled
> ata12: soft resetting link
> ata12: EH complete

At this point, the drive stopped responding and libata removed the
drive from the system.

> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 e7 08 00 01 00 00

As the device is gone, any command is immediately failed with
DID_BAD_TARGET.

> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> lost page write due to I/O error on sdd
> sd 11:0:0:0: [sdd] Unhandled error code
> 
> and finally and endless flood of 
> 
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 e8 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 e9 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 ea 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 eb 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 ec 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 ed 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 ee 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 ef 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 f0 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 f1 08 00 01 00 00
> sd 11:0:0:0: [sdd] Unhandled error code
> sd 11:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 11:0:0:0: [sdd] CDB: Write(10): 2a 00 00 e5 f2 08 00 01 00 00
> 
> same messages repeating forever, just with CDB changing occasionally.
> 
> ....
> 
> not stopping until I reset the box.

Did you have a lot of dirty pages?  It looks like upper layer is
trying to flush all the dirty buffers and SCSI is a tad bit too
verbose about failing each IO w/ DID_BAD_TARGET thus taking a very
long time if there are many to fail.

Thanks.

-- 
tejun
