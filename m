From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: BUG: broken support on discard (max_discard_bytes) with uas
Date: Wed, 23 Mar 2016 14:37:02 +0000
Message-ID: <CAGnHSEnH+cMchSATJ6Gevv=VGL-kXo+cCSf_uoMixph7D5SYMQ@mail.gmail.com>
References: <CAGnHSE=d1thgCRf8YORQ2TxMdyWZ53ojcFqm8=DN_WCe30VLxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:32930 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbcCWOhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2016 10:37:04 -0400
In-Reply-To: <CAGnHSE=d1thgCRf8YORQ2TxMdyWZ53ojcFqm8=DN_WCe30VLxA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

It seems like this is because the uas driver queues the UNMAP commands.

After some test I am no longer sure that it has nothing to do with my
hardware at all. Still I have doubt on the uas driver. Like, is
queuing UNMAP commands the right thing to do? Or is the uas driver
wrongly queuing too many commands for my device in general?

When in XHCI mode, my device reports a queue depth of 14 in the sysfs
file. However, in my further tests, it seems if I specify a `--step`
of around 8 times larger than the discard_max_bytes set, it will
trigger the "Unknown
event condition 34, HC probably busted" xhci_hcd error. Also the
number of "uas_eh_abort_handler" errors increases with the multiple
(when it's 8 times, there will only be one or two of that), this is
what makes me think that the problem comes with queuing (along with
the fact that this is not an issue with the BOT driver).

If it's lower than that (e.g. 2 times - 7 times), it seems some queued
UNMAP commands are rejected by my device, but the xhci_hcd error will
not be triggered.

On 12 March 2016 at 09:41, Tom Yan <tom.ty89@gmail.com> wrote:
> So I have a USB-SATA bridge that supports translating SCSI UNMAP to
> ATA DSM/TRIM (JMicron JMS 567). I am using it with a 240GB SSD.
>
> I confirmed that it is NOT a hardware issue. The feature works like a
> charm with `sg_unmap` and uas:
>
> [tom@localhost ~]$ sudo sg_unmap -vvvv -l 0 -n 468862128 /dev/sdc
> found bsg_major=250
> open /dev/sdc with flags=0x802
>     unmap cdb: 42 00 00 00 00 00 00 00 18 00
>     unmap parameter list:
> 00 16 00 10 00 00 00 00  00 00 00 00 00 00 00 00
> 1b f2 44 b0 00 00 00 00
>       duration=39386 ms
>
> (Random-filled with `shred` before that and checked with `hexdump`
> afterwards as well)
>
> and with `blkdiscard` and usb-storage (u quirk):
>
> [tom@localhost ~]$ sudo blkdiscard -v /dev/sdc
> /dev/sdc: Discarded 240057409536 bytes from the offset 0
>
> [tom@localhost ~]$ journalctl -f
> -- Logs begin at Tue 2016-02-16 21:53:03 HKT. --
> ...
> Mar 12 16:52:51 localhost sudo[429]:      tom : TTY=pts/1 ;
> PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v /dev/sdc
> Mar 12 16:52:51 localhost sudo[429]: pam_unix(sudo:session): session
> opened for user root by (uid=0)
> Mar 12 16:52:56 localhost sudo[429]: pam_unix(sudo:session): session
> closed for user root
> ^C
>
> [tom@localhost ~]$ lsusb.py -i | grep sdc
>    2-1.6:1.0      (IF) 08:06:50 2EPs (Mass Storage:SCSI:Bulk-Only)
> usb-storage host7 (sdc)
>
> However, if I do it with uas, UNLESS I run `blkdiscard` with a
> `--step` set to a value equal to or less than
> /sys/block/sdc/queue/discard_max_bytes, it will either fail quickly or
> get stalled.
>
> With EHCI, it will fail in a short while and the behaviour is
> apparently constant:
>
> Mar 12 17:23:45 localhost sudo[435]:      tom : TTY=pts/1 ;
> PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v /dev/sdc
> Mar 12 17:23:45 localhost sudo[435]: pam_unix(sudo:session): session
> opened for user root by (uid=0)
> Mar 12 17:23:46 localhost kernel: usb 2-1.6: stat urb: no pending cmd
> for uas-tag 34566
> Mar 12 17:23:49 localhost kernel: usb 2-1.6: stat urb: status -71
> Mar 12 17:23:49 localhost sudo[435]: pam_unix(sudo:session): session
> closed for user root
> Mar 12 17:23:49 localhost kernel: usb 2-1.6: USB disconnect, device number 8
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#0
> uas_zap_pending 0 uas-tag 1 inflight: CMD
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#0 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#13
> uas_zap_pending 0 uas-tag 14 inflight: CMD
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#13 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#0
> UNKNOWN(0x2003) Result: hostbyte=0x01 driverbyte=0x00
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#0 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:23:49 localhost kernel: blk_update_request: I/O error, dev
> sdc, sector 251658000
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#13
> UNKNOWN(0x2003) Result: hostbyte=0x01 driverbyte=0x00
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] tag#13 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:23:49 localhost kernel: blk_update_request: I/O error, dev
> sdc, sector 109051800
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] Synchronizing SCSI cache
> Mar 12 17:23:49 localhost kernel: sd 7:0:0:0: [sdc] Synchronize
> Cache(10) failed: Result: hostbyte=0x07 driverbyte=0x00
>
> With XHCI, it will usually get stalled but the behaviour (e.g. length
> of time, errors on kernel messages) can vary each time. But most of
> the times these are repeated:
>
> Mar 12 17:30:05 localhost sudo[417]:      tom : TTY=pts/1 ;
> PWD=/home/tom ; USER=root ; COMMAND=/usr/bin/blkdiscard -v /dev/sdc
> Mar 12 17:30:05 localhost sudo[417]: pam_unix(sudo:session): session
> opened for user root by (uid=0)
> Mar 12 17:30:06 localhost kernel: xhci_hcd 0000:00:14.0: ERROR Unknown
> event condition 34, HC probably busted
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#1
> uas_eh_abort_handler 0 uas-tag 2 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#1 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#0
> uas_eh_abort_handler 0 uas-tag 1 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#0 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#13
> uas_eh_abort_handler 0 uas-tag 14 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#13 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#12
> uas_eh_abort_handler 0 uas-tag 13 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#12 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#11
> uas_eh_abort_handler 0 uas-tag 12 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#11 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#10
> uas_eh_abort_handler 0 uas-tag 11 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#10 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#9
> uas_eh_abort_handler 0 uas-tag 10 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#9 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#8
> uas_eh_abort_handler 0 uas-tag 9 inflight: CMD OUT
> Mar 12 17:30:36 localhost kernel: sd 7:0:0:0: [sdc] tag#8 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#2
> uas_eh_abort_handler 0 uas-tag 3 inflight: CMD OUT
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#2 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: scsi host7: uas_eh_bus_reset_handler start
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#3
> uas_zap_pending 0 uas-tag 4 inflight: CMD
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#3 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#4
> uas_zap_pending 0 uas-tag 5 inflight: CMD
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#4 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#5
> uas_zap_pending 0 uas-tag 6 inflight: CMD
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#5 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#6
> uas_zap_pending 0 uas-tag 7 inflight: CMD
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#6 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#7
> uas_zap_pending 0 uas-tag 8 inflight: CMD
> Mar 12 17:30:37 localhost kernel: sd 7:0:0:0: [sdc] tag#7 CDB:
> opcode=0x42 42 00 00 00 00 00 00 00 18 00
> Mar 12 17:30:37 localhost kernel: usb 2-6: reset SuperSpeed USB device
> number 3 using xhci_hcd
> Mar 12 17:30:37 localhost kernel: scsi host7: uas_eh_bus_reset_handler success
> Mar 12 17:30:37 localhost kernel: xhci_hcd 0000:00:14.0: ERROR Unknown
> event condition 34, HC probably busted
> ...
>
> Also, since now the sysfs file "discard_max_bytes" is writeable; if I
> lower the value manually, the "threshold" (`--step` of `blkdiscard`)
> that triggers the failure is lowered accordingly too. This also
> indicates that it is a kernel issue rather than a hardware one.
>
> Attached are samples of full journal on how it fails respectively with
> EHCI and XHCI (same motherboard/controller, mode switched in UEFI
> settings).
