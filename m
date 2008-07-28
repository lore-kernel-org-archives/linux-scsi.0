From: greg@enjellic.com
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Mon, 28 Jul 2008 15:40:34 -0500
Message-ID: <200807282040.m6SKeY9Q013406@wind.enjellic.com>
References: <andrew.vasquez@qlogic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([209.243.13.15]:55925 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYG1UlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 16:41:11 -0400
In-Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
       "Re: Poisoning of Linux initiators on SCST reboot." (Jul 25,  6:45am)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, stf_xl@wp.pl, vst@vlnb.net

On Jul 25,  6:45am, Andrew Vasquez wrote:
} Subject: Re: Poisoning of Linux initiators on SCST reboot.

Good afternoon to everyone, hope your week is starting out well.

First off thanks to Andrew for the very helpful reply.  Hopefully this
mail will provide additional information which is helpful in getting
to the bottom of these issues.

> On Thu, 24 Jul 2008, greg@enjellic.com wrote:

> > When the SCST target server reboots the initiator times out the remote
> > port and places it into 'unknown' state.  The qla2xxx driver,
> > according to the source code, maintains the previous rport state in
> > driver internal data.

> Ok, thanks for the detailed description of the problem...

> > The 2462 card in the target on boot logs into the fabric with an
> > initiator role, I'm assuming in support of BIOS based SAN booting. The
> > client initiator picks up on this and re-activates the rport as being
> > in an INITIATOR role.

> Yes, BIOS would FLOGI into the switch...  RSCN received on initiator
> side, and the role registered for the rport would have been migrated
> from target->initiator... (Step 1)

Vlad and Stanislaw had suggested disabling SAN based booting on the
cards as a solution to the problem.  It would seem you agree this is
the culprit with respect to the client initiator seeing the target in
an initiator role.

We currently have the BIOS disabled on the 2462 card in the target
box.  We also have 'Selective SAN boot' disabled and we do not see any
other options which may be relevant to keeping the card from issueing
a FLOGI into the fabric on power up.

We've also had a go round with the scli utility and didn't see
anything in there which would shutdown this behavior.  So Andrew let
us know if we are missing something with respect to how the card's
behavior can be modified in this respect.

It doesn't address the rport behavior but may be useful to others who
pick up on this thread in the future.

.. [ things deleted ] ...

> then at step-2, the same process during fc_remote_port_add() (since
> the transition to target is again deferred to rolechg()), then during
> rolechg() I'd expect the transport would fall into the 'else if' here:
> 
>         spin_lock_irqsave(shost->host_lock, flags);
>         if (roles & FC_PORT_ROLE_FCP_TARGET) {
>                 if (rport->scsi_target_id == -1) {
>                         rport->scsi_target_id = fc_host->next_target_id++;
>                         create = 1;
>                 } else if (!(rport->roles & FC_PORT_ROLE_FCP_TARGET))
>                         create = 1;
> 
> Hmm, but that doesn't seem to be the case here...
> 
> Let's start with the driver logs, just I get full picture of at least
> what's happending with qla2xxx at the wire-side.

Thanks for your continued interest in following up on this Andrew.

We executed a full test cycle starting from a freshly rebooted client
and server.

Initiator client is stock 2.6.26 freshly downloaded from kernel.org.
The client module was loaded with the option to enable extended
debugging information.

SCST target code and ismp_mod driver is from the current head of the
1.0.0.x branch in SVN.

Annotations were injected in the logs with the logger utility.  A
search for the **** string will find the annotations, ie. target
reboot etc.

SCSI host 4 is being used to access the target which is undergoing the
reboot test.  PWWN of the target is 210000e08b8665b5.

---------------------------------------------------------------------------
Jul 28 14:39:00 init-test syslogd 1.4.1: restart.
Jul 28 14:40:01 init-test crond[4312]: (root) CMD (/usr/lib/sa/sa1 1 1)
Jul 28 14:40:49 init-test kernel: QLogic Fibre Channel HBA Driver: 8.02.01-k4-debug
Jul 28 14:40:49 init-test kernel: ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Found an ISP2432, irq 16, iobase 0xf8858000
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Configuring PCI space...
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Configure NVRAM parameters...
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Verifying loaded RISC code...
Jul 28 14:40:49 init-test kernel: scsi(4): **** Load RISC code ****
Jul 28 14:40:49 init-test kernel: firmware: requesting ql2400_fw.bin
Jul 28 14:40:49 init-test kernel: scsi(4): Verifying Checksum of loaded RISC code.
Jul 28 14:40:49 init-test kernel: scsi(4): Checksum OK, start firmware.
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Allocated (64 KB) for EFT...
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: Allocated (1413 KB) for firmware dump...
Jul 28 14:40:49 init-test kernel: scsi(4): Issue init firmware.
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: MSI-X: Unsupported ISP2432 (0x2, 0x482).
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: MSI: Enabled.
Jul 28 14:40:49 init-test kernel: DEBUG: detect hba 4 at address = f7bda33c
Jul 28 14:40:49 init-test kernel: scsi4 : qla2xxx
Jul 28 14:40:49 init-test kernel: scsi(4): Asynchronous LIP RESET (f7f7).
Jul 28 14:40:49 init-test kernel: qla2xxx 0000:04:00.0: LIP reset occured (f7f7).
Jul 28 14:40:50 init-test kernel: scsi(4): Asynchronous P2P MODE received.
Jul 28 14:40:50 init-test kernel: scsi(4): Asynchronous LOOP UP (4 Gbps).
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.0: LOOP UP detected (4 Gbps).
Jul 28 14:40:50 init-test kernel: scsi(4): Asynchronous PORT UPDATE.
Jul 28 14:40:50 init-test kernel: scsi(4): Port database changed ffff 0006 0000.
Jul 28 14:40:50 init-test kernel: scsi(4): qla2x00_reset_marker()
Jul 28 14:40:50 init-test kernel: scsi(4): qla2x00_loop_resync()
Jul 28 14:40:50 init-test kernel: scsi(4): F/W Ready - OK 
Jul 28 14:40:50 init-test kernel: scsi(4): fw_state=3 curr time=3052.
Jul 28 14:40:50 init-test kernel: scsi(4): Configure loop -- dpc flags =0x40800e0
Jul 28 14:40:50 init-test kernel: scsi(4): RSCN queue entry[0] = [00/000000].
Jul 28 14:40:50 init-test kernel: scsi(4): device_resync: rscn overflow.
Jul 28 14:40:50 init-test kernel: scsi(4): RHBA exiting normally.
Jul 28 14:40:50 init-test kernel: scsi(4): RPA failed, rejected request:
Jul 28 14:40:50 init-test kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Jul 28 14:40:50 init-test kernel: --------------------------------------------------------------
Jul 28 14:40:50 init-test kernel: 01  00  00  00  fa  10  00  00  80  01  00  00  00  09  00  00
Jul 28 14:40:50 init-test kernel: scsi(4): RFT_ID exiting normally.
Jul 28 14:40:50 init-test kernel: scsi(4): RFF_ID exiting normally.
Jul 28 14:40:50 init-test kernel: scsi(4): RNN_ID exiting normally.
Jul 28 14:40:50 init-test kernel: scsi(4): RSNN_NN exiting normally.
Jul 28 14:40:50 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b8665b5 pn 210000e08b8665b5 portid=d60400.
Jul 28 14:40:50 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b9db189 pn 210000e08b9db189 portid=d61d00.
Jul 28 14:40:50 init-test kernel: scsi(4): GPSC ext entry - fpn 21c7000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:40:50 init-test kernel: scsi(4): GPSC ext entry - fpn 218a000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:40:50 init-test kernel: scsi(4): device wrap (d61d00)
Jul 28 14:40:50 init-test kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port d60400.
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.0: iIDMA adjusted to 2 GB/s on 210000e08b8665b5.
Jul 28 14:40:50 init-test kernel: scsi(4): LOOP READY
Jul 28 14:40:50 init-test kernel: scsi(4): qla2x00_loop_resync - end
Jul 28 14:40:50 init-test kernel: scsi 4:0:0:0: Direct-Access     SCST_BIO ia_3:bbfs2_ndsu   096 PQ: 0 ANSI: 4
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] 2147483648 512-byte hardware sectors (1099512 MB)
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.0: 
Jul 28 14:40:50 init-test kernel:  QLogic Fibre Channel HBA Driver: 8.02.01-k4-debug
Jul 28 14:40:50 init-test kernel:   QLogic QLE2462 - PCI-Express to 4Gb FC, Dual Channel
Jul 28 14:40:50 init-test kernel:   ISP2432: PCIe (2.5GT/s x4) @ 0000:04:00.0 hdma-, host#=4, fw=4.04.00 [IP] [84XX] 
Jul 28 14:40:50 init-test kernel: ACPI: PCI Interrupt 0000:04:00.1[B] -> GSI 17 (level, low) -> IRQ 17
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: Found an ISP2432, irq 17, iobase 0xf8b4a000
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] Write Protect is off
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: Configuring PCI space...
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] 2147483648 512-byte hardware sectors (1099512 MB)
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] Write Protect is off
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jul 28 14:40:50 init-test kernel:  sdc: sdc1
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: [sdc] Attached SCSI disk
Jul 28 14:40:50 init-test kernel: sd 4:0:0:0: Attached scsi generic sg3 type 0
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: Configure NVRAM parameters...
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: Verifying loaded RISC code...
Jul 28 14:40:50 init-test kernel: scsi(5): **** Load RISC code ****
Jul 28 14:40:50 init-test kernel: scsi(5): Verifying Checksum of loaded RISC code.
Jul 28 14:40:50 init-test kernel: scsi(5): Checksum OK, start firmware.
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: Allocated (64 KB) for EFT...
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: Allocated (1413 KB) for firmware dump...
Jul 28 14:40:50 init-test kernel: scsi(5): Issue init firmware.
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: MSI-X: Unsupported ISP2432 (0x2, 0x482).
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: MSI: Enabled.
Jul 28 14:40:50 init-test kernel: DEBUG: detect hba 5 at address = f7be033c
Jul 28 14:40:50 init-test kernel: scsi5 : qla2xxx
Jul 28 14:40:50 init-test kernel: scsi(5): Asynchronous LIP RESET (f7f7).
Jul 28 14:40:50 init-test kernel: qla2xxx 0000:04:00.1: LIP reset occured (f7f7).
Jul 28 14:40:51 init-test kernel: scsi(5): qla2x00_reset_marker()
Jul 28 14:40:51 init-test kernel: scsi(5): qla2x00_loop_resync()
Jul 28 14:40:52 init-test kernel: scsi(5): Asynchronous P2P MODE received.
Jul 28 14:40:52 init-test kernel: scsi(5): Asynchronous LOOP UP (4 Gbps).
Jul 28 14:40:52 init-test kernel: qla2xxx 0000:04:00.1: LOOP UP detected (4 Gbps).
Jul 28 14:40:52 init-test kernel: scsi(5): Asynchronous PORT UPDATE.
Jul 28 14:40:52 init-test kernel: scsi(5): Port database changed ffff 0006 0000.
Jul 28 14:40:52 init-test kernel: scsi(5): F/W Ready - OK 
Jul 28 14:40:52 init-test kernel: scsi(5): fw_state=3 curr time=331a.
Jul 28 14:40:52 init-test kernel: scsi(5): Configure loop -- dpc flags =0x40800e1
Jul 28 14:40:52 init-test kernel: scsi(5): RSCN queue entry[0] = [00/000000].
Jul 28 14:40:52 init-test kernel: scsi(5): device_resync: rscn overflow.
Jul 28 14:40:52 init-test kernel: scsi(5): RHBA exiting normally.
Jul 28 14:40:52 init-test kernel: scsi(5): RPA failed, rejected request:
Jul 28 14:40:52 init-test kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Jul 28 14:40:52 init-test kernel: --------------------------------------------------------------
Jul 28 14:40:52 init-test kernel: 01  00  00  00  fa  10  00  00  80  01  00  00  00  09  00  00
Jul 28 14:40:52 init-test kernel: scsi(5): RFT_ID exiting normally.
Jul 28 14:40:52 init-test kernel: scsi(5): RFF_ID exiting normally.
Jul 28 14:40:52 init-test kernel: scsi(5): RNN_ID exiting normally.
Jul 28 14:40:52 init-test kernel: scsi(5): RSNN_NN exiting normally.
Jul 28 14:40:52 init-test kernel: scsi(5): GID_PT entry - nn 200100e08ba7c394 pn 210100e08ba7c394 portid=6c0700.
Jul 28 14:40:52 init-test kernel: scsi(5): GID_PT entry - nn 200000e08b059b49 pn 210000e08b059b49 portid=6c0e00.
Jul 28 14:40:52 init-test kernel: scsi(5): GID_PT entry - nn 200100e08bbee923 pn 210100e08bbee923 portid=6c0f00.
Jul 28 14:40:52 init-test kernel: scsi(5): GID_PT entry - nn 200100e08bbdb189 pn 210100e08bbdb189 portid=cd0e00.
Jul 28 14:40:52 init-test kernel: scsi(5): GPSC ext entry - fpn 204f000dec2e62c0 speeds=0000 speed=4000.
Jul 28 14:40:52 init-test kernel: scsi(5): GPSC ext entry - fpn 2006000dec2e62c0 speeds=0000 speed=1000.
Jul 28 14:40:52 init-test kernel: scsi(5): GPSC ext entry - fpn 2050000dec2e62c0 speeds=0000 speed=4000.
Jul 28 14:40:52 init-test kernel: scsi(5): GPSC ext entry - fpn 21ca000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:40:52 init-test kernel: scsi(5): device wrap (cd0e00)
Jul 28 14:40:53 init-test kernel: scsi(5): Trying Fabric Login w/loop id 0x0081 for port 6c0700.
Jul 28 14:40:53 init-test kernel: qla2xxx 0000:04:00.1: iIDMA adjusted to 2 GB/s on 210100e08ba7c394.
Jul 28 14:40:53 init-test kernel: scsi(5): Trying Fabric Login w/loop id 0x0082 for port 6c0e00.
Jul 28 14:40:53 init-test kernel: scsi 5:0:0:0: Direct-Access     SCST_BIO r1_3:bbfs2_ndsu   096 PQ: 0 ANSI: 4
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] 2147483648 512-byte hardware sectors (1099512 MB)
Jul 28 14:40:53 init-test kernel: scsi(5): Trying Fabric Login w/loop id 0x0083 for port 6c0f00.
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] Write Protect is off
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jul 28 14:40:53 init-test kernel: qla2xxx 0000:04:00.1: iIDMA adjusted to 2 GB/s on 210100e08bbee923.
Jul 28 14:40:53 init-test kernel: scsi(5): LOOP READY
Jul 28 14:40:53 init-test kernel: scsi(5): qla2x00_loop_resync - end
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] 2147483648 512-byte hardware sectors (1099512 MB)
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] Write Protect is off
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jul 28 14:40:53 init-test kernel:  sdd:<6>qla2xxx 0000:04:00.1: 
Jul 28 14:40:53 init-test kernel:  QLogic Fibre Channel HBA Driver: 8.02.01-k4-debug
Jul 28 14:40:53 init-test kernel:   QLogic QLE2462 - PCI-Express to 4Gb FC, Dual Channel
Jul 28 14:40:53 init-test kernel:   ISP2432: PCIe (2.5GT/s x4) @ 0000:04:00.1 hdma-, host#=5, fw=4.04.00 [IP] [84XX] 
Jul 28 14:40:53 init-test kernel:  sdd1
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: [sdd] Attached SCSI disk
Jul 28 14:40:53 init-test kernel: sd 5:0:0:0: Attached scsi generic sg4 type 0
Jul 28 14:40:53 init-test kernel: scsi(5): qla2x00_reset_marker()
Jul 28 14:41:55 init-test wettstei: **** Rebooting SCST arget.
Jul 28 14:42:35 init-test kernel: scsi(4): Asynchronous RSCR UPDATE.
Jul 28 14:42:35 init-test kernel: scsi(4): RSCN database changed -- 00d6 0400 0000.
Jul 28 14:42:35 init-test kernel: scsi(4): qla2x00_loop_resync()
Jul 28 14:42:35 init-test kernel: scsi(4): F/W Ready - OK 
Jul 28 14:42:35 init-test kernel: scsi(4): fw_state=3 curr time=9718.
Jul 28 14:42:35 init-test kernel: scsi(4): Configure loop -- dpc flags =0xa0
Jul 28 14:42:35 init-test kernel: scsi(4): RSCN queue entry[0] = [00/d60400].
Jul 28 14:42:35 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b9db189 pn 210000e08b9db189 portid=d61d00.
Jul 28 14:42:35 init-test kernel: scsi(4): GPSC ext entry - fpn 218a000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:42:35 init-test kernel: scsi(4): device wrap (d61d00)
Jul 28 14:42:35 init-test kernel: scsi(4): LOOP READY
Jul 28 14:42:35 init-test kernel: scsi(4): qla2x00_loop_resync - end
Jul 28 14:42:35 init-test kernel: scsi(4): fcport-0 - port retry count: 29 remaining
Jul 28 14:42:36 init-test kernel: scsi(4): fcport-0 - port retry count: 28 remaining
Jul 28 14:42:37 init-test kernel: scsi(4): fcport-0 - port retry count: 27 remaining
Jul 28 14:42:38 init-test kernel: scsi(4): fcport-0 - port retry count: 26 remaining
Jul 28 14:42:39 init-test kernel: scsi(4): fcport-0 - port retry count: 25 remaining
Jul 28 14:42:40 init-test kernel: scsi(4): fcport-0 - port retry count: 24 remaining
Jul 28 14:42:41 init-test kernel: scsi(4): fcport-0 - port retry count: 23 remaining
Jul 28 14:42:42 init-test kernel: scsi(4): fcport-0 - port retry count: 22 remaining
Jul 28 14:42:43 init-test kernel: scsi(4): fcport-0 - port retry count: 21 remaining
Jul 28 14:42:44 init-test kernel: scsi(4): fcport-0 - port retry count: 20 remaining
Jul 28 14:42:45 init-test kernel: scsi(4): fcport-0 - port retry count: 19 remaining
Jul 28 14:42:46 init-test kernel: scsi(4): fcport-0 - port retry count: 18 remaining
Jul 28 14:42:47 init-test kernel: scsi(4): fcport-0 - port retry count: 17 remaining
Jul 28 14:42:48 init-test kernel: scsi(4): fcport-0 - port retry count: 16 remaining
Jul 28 14:42:49 init-test kernel: scsi(4): fcport-0 - port retry count: 15 remaining
Jul 28 14:42:50 init-test kernel: scsi(4): fcport-0 - port retry count: 14 remaining
Jul 28 14:42:51 init-test kernel: scsi(4): fcport-0 - port retry count: 13 remaining
Jul 28 14:42:52 init-test kernel: scsi(4): fcport-0 - port retry count: 12 remaining
Jul 28 14:42:53 init-test kernel: scsi(4): fcport-0 - port retry count: 11 remaining
Jul 28 14:42:54 init-test kernel: scsi(4): fcport-0 - port retry count: 10 remaining
Jul 28 14:42:55 init-test kernel: scsi(4): fcport-0 - port retry count: 9 remaining
Jul 28 14:42:56 init-test kernel: scsi(4): fcport-0 - port retry count: 8 remaining
Jul 28 14:42:57 init-test kernel: scsi(4): fcport-0 - port retry count: 7 remaining
Jul 28 14:42:58 init-test kernel: scsi(4): fcport-0 - port retry count: 6 remaining
Jul 28 14:42:59 init-test kernel: scsi(4): fcport-0 - port retry count: 5 remaining
Jul 28 14:43:00 init-test kernel: scsi(4): fcport-0 - port retry count: 4 remaining
Jul 28 14:43:01 init-test kernel: scsi(4): fcport-0 - port retry count: 3 remaining
Jul 28 14:43:02 init-test kernel: scsi(4): fcport-0 - port retry count: 2 remaining
Jul 28 14:43:03 init-test kernel: scsi(4): fcport-0 - port retry count: 1 remaining
Jul 28 14:43:04 init-test kernel: scsi(4): fcport-0 - port retry count: 0 remaining
Jul 28 14:43:10 init-test kernel:  rport-4:0-0: blocked FC remote port time out: removing target and saving binding
Jul 28 14:43:10 init-test kernel: sd 4:0:0:0: [sdc] Synchronizing SCSI cache
Jul 28 14:43:10 init-test kernel: sd 4:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Jul 28 14:43:16 init-test kernel: scsi(4): Asynchronous RSCR UPDATE.
Jul 28 14:43:16 init-test kernel: scsi(4): RSCN database changed -- 00d6 0400 0000.
Jul 28 14:43:16 init-test kernel: scsi(4): qla2x00_loop_resync()
Jul 28 14:43:16 init-test kernel: scsi(4): F/W Ready - OK 
Jul 28 14:43:16 init-test kernel: scsi(4): fw_state=3 curr time=bf65.
Jul 28 14:43:16 init-test kernel: scsi(4): Configure loop -- dpc flags =0xa0
Jul 28 14:43:16 init-test kernel: scsi(4): RSCN queue entry[1] = [00/d60400].
Jul 28 14:43:16 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b8665b5 pn 210000e08b8665b5 portid=d60400.
Jul 28 14:43:16 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b9db189 pn 210000e08b9db189 portid=d61d00.
Jul 28 14:43:16 init-test kernel: scsi(4): GPSC ext entry - fpn 21c7000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:43:16 init-test kernel: scsi(4): GPSC ext entry - fpn 218a000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:43:16 init-test kernel: scsi(4): device wrap (d61d00)
Jul 28 14:43:16 init-test kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port d60400.
Jul 28 14:43:16 init-test kernel: qla2xxx 0000:04:00.0: iIDMA adjusted to 2 GB/s on 210000e08b8665b5.
Jul 28 14:43:16 init-test kernel: scsi(4): LOOP READY
Jul 28 14:43:16 init-test kernel: scsi(4): qla2x00_loop_resync - end
Jul 28 14:43:38 init-test kernel: scsi(4): Asynchronous PORT UPDATE ignored 0081/0004/0600.
Jul 28 14:43:38 init-test kernel: scsi(4): Asynchronous PORT UPDATE ignored 0081/0004/0600.
Jul 28 14:45:49 init-test wettstei: **** Loading isp_mod driver on target.
Jul 28 14:46:18 init-test kernel: scsi(4): Asynchronous RSCR UPDATE.
Jul 28 14:46:18 init-test kernel: scsi(4): RSCN database changed -- 00d6 0400 0000.
Jul 28 14:46:18 init-test kernel: scsi(4): qla2x00_loop_resync()
Jul 28 14:46:18 init-test kernel: scsi(4): F/W Ready - OK 
Jul 28 14:46:18 init-test kernel: scsi(4): fw_state=3 curr time=170a3.
Jul 28 14:46:18 init-test kernel: scsi(4): Configure loop -- dpc flags =0xa0
Jul 28 14:46:18 init-test kernel: scsi(4): RSCN queue entry[2] = [00/d60400].
Jul 28 14:46:18 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b9db189 pn 210000e08b9db189 portid=d61d00.
Jul 28 14:46:18 init-test kernel: scsi(4): GPSC ext entry - fpn 218a000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:46:18 init-test kernel: scsi(4): device wrap (d61d00)
Jul 28 14:46:18 init-test kernel: scsi(4): LOOP READY
Jul 28 14:46:18 init-test kernel: scsi(4): qla2x00_loop_resync - end
Jul 28 14:46:45 init-test wettstei: **** Enabling target mode in isp_mod driver on target.
Jul 28 14:46:53 init-test kernel:  rport-4:0-0: blocked FC remote port time out: removing target and saving binding
Jul 28 14:47:10 init-test kernel: scsi(4): Asynchronous RSCR UPDATE.
Jul 28 14:47:10 init-test kernel: scsi(4): RSCN database changed -- 00d6 0400 0000.
Jul 28 14:47:10 init-test kernel: scsi(4): qla2x00_loop_resync()
Jul 28 14:47:10 init-test kernel: scsi(4): F/W Ready - OK 
Jul 28 14:47:10 init-test kernel: scsi(4): fw_state=3 curr time=1a43a.
Jul 28 14:47:10 init-test kernel: scsi(4): Configure loop -- dpc flags =0xa0
Jul 28 14:47:10 init-test kernel: scsi(4): RSCN queue entry[3] = [00/d60400].
Jul 28 14:47:10 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b8665b5 pn 210000e08b8665b5 portid=d60400.
Jul 28 14:47:10 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b9db189 pn 210000e08b9db189 portid=d61d00.
Jul 28 14:47:10 init-test kernel: scsi(4): GPSC ext entry - fpn 21c7000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:47:10 init-test kernel: scsi(4): GPSC ext entry - fpn 218a000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:47:10 init-test kernel: scsi(4): device wrap (d61d00)
Jul 28 14:47:10 init-test kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port d60400.
Jul 28 14:47:10 init-test kernel: qla2xxx 0000:04:00.0: iIDMA adjusted to 2 GB/s on 210000e08b8665b5.
Jul 28 14:47:10 init-test kernel: scsi(4): LOOP READY
Jul 28 14:47:10 init-test kernel: scsi(4): qla2x00_loop_resync - end
Jul 28 14:48:00 init-test wettstei: **** Activating LIP.
Jul 28 14:48:19 init-test kernel: scsi(4): Asynchronous LIP RESET (f7f7).
Jul 28 14:48:19 init-test kernel: qla2xxx 0000:04:00.0: LIP reset occured (f7f7).
Jul 28 14:48:19 init-test kernel: scsi(4): qla2x00_reset_marker()
Jul 28 14:48:19 init-test kernel: scsi(4): Asynchronous P2P MODE received.
Jul 28 14:48:19 init-test kernel: scsi(4): Asynchronous PORT UPDATE.
Jul 28 14:48:19 init-test kernel: scsi(4): Port database changed ffff 0006 0000.
Jul 28 14:48:19 init-test kernel: scsi(4): qla2x00_reset_marker()
Jul 28 14:48:19 init-test kernel: scsi(4): qla2x00_loop_resync()
Jul 28 14:48:19 init-test kernel: scsi(4): F/W Ready - OK 
Jul 28 14:48:19 init-test kernel: scsi(4): fw_state=3 curr time=1e71d.
Jul 28 14:48:19 init-test kernel: scsi(4): Configure loop -- dpc flags =0x4080060
Jul 28 14:48:19 init-test kernel: scsi(4): RSCN queue entry[4] = [00/000000].
Jul 28 14:48:19 init-test kernel: scsi(4): device_resync: rscn overflow.
Jul 28 14:48:19 init-test kernel: scsi(4): RHBA exiting normally.
Jul 28 14:48:19 init-test kernel: scsi(4): RPA failed, rejected request:
Jul 28 14:48:19 init-test kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Jul 28 14:48:19 init-test kernel: --------------------------------------------------------------
Jul 28 14:48:19 init-test kernel: 01  00  00  00  fa  10  00  00  80  01  00  00  00  09  00  00
Jul 28 14:48:19 init-test kernel: scsi(4): RFT_ID exiting normally.
Jul 28 14:48:19 init-test kernel: scsi(4): RFF_ID exiting normally.
Jul 28 14:48:19 init-test kernel: scsi(4): RNN_ID exiting normally.
Jul 28 14:48:19 init-test kernel: scsi(4): RSNN_NN exiting normally.
Jul 28 14:48:19 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b8665b5 pn 210000e08b8665b5 portid=d60400.
Jul 28 14:48:19 init-test kernel: scsi(4): GID_PT entry - nn 200000e08b9db189 pn 210000e08b9db189 portid=d61d00.
Jul 28 14:48:19 init-test kernel: scsi(4): GPSC ext entry - fpn 21c7000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:48:19 init-test kernel: scsi(4): GPSC ext entry - fpn 218a000dbd5c2d40 speeds=0000 speed=4000.
Jul 28 14:48:19 init-test kernel: scsi(4): device wrap (d61d00)
Jul 28 14:48:19 init-test kernel: scsi(4): Trying Fabric Login w/loop id 0x0081 for port d60400.
Jul 28 14:48:19 init-test kernel: qla2xxx 0000:04:00.0: iIDMA adjusted to 2 GB/s on 210000e08b8665b5.
Jul 28 14:48:19 init-test kernel: scsi(4): LOOP READY
Jul 28 14:48:19 init-test kernel: scsi(4): qla2x00_loop_resync - end
Jul 28 14:48:54 init-test kernel:  rport-4:0-0: blocked FC remote port time out: no longer a FCP target, removing starget
---------------------------------------------------------------------------

> Thanks, AV

Hopefully the above information is useful.  Let me know if additional
information or testing is needed.

Have a good evening.

}-- End of excerpt from Andrew Vasquez

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Given a choice between a complex, difficult-to-understand,
 disconcerting explanation and a simplistic, comforting one, many
 prefer simplistic comfort if it's remotely plausible, especially if it
 involves blaming someone else for their problems."
                                -- Bob Lewis
                                   _Infoworld_
