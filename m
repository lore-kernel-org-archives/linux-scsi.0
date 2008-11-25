From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Devices going offline on Adaptec 29320 using driver AIC79XX
	after messages "Attempting to queue an ABORT message:CDB"
Date: Tue, 25 Nov 2008 15:53:51 -0600
Message-ID: <1227650031.3415.31.camel@localhost.localdomain>
References: <CA39D769C8FE694788CE376026984BAB0117D222@ILEXC1U01.ndc.lucent.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40891 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYKYVx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2008 16:53:57 -0500
In-Reply-To: <CA39D769C8FE694788CE376026984BAB0117D222@ILEXC1U01.ndc.lucent.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rhine, Jay (Jay)" <jrhine@alcatel-lucent.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-11-25 at 14:54 -0600, Rhine, Jay (Jay) wrote:
> Folks,
> 
> 	I'm having a problem with the devices on my Adaptec 29320 cards.
> My best guess is this a bug in the AIC79XX (and possible AIX7XXX) device
> driver, possibly releated to SMP.  However, I'm not really sure how to
> determine if that is really the case.  I've previosly posted this
> message 
> to the linux-kernel mailing list, but I think it got lost in the many
> messages on that list.  This problem has been really causing me havoc.  
> I would really appreciate any help / suggestions with this.
> 
> 	Here's the scenario. I have an IBM System X 3400 server with 3
> Adaptec SCSI Cards - Adaptec 29320LPE PCIe Ultra320 SCSI adapter,
> Adaptec 29320ALP PCIx Ultra320 SCSI adapter, and Adaptec 2944 Ultra SCSI
> adapter (as well as some other cards unrelated to this problem - an LSI
> SAS Card, Emulex Fiber Channel Card, an Intel SATA Controller, and an
> Intel 4 Port Ethernet card).  The system has 2 Intel E5405 2.00GHz
> Quad-Core processors.  I'm running Centos 5.2.  This system is running
> in SMP mode.  I've seen this problem on the most recent Centos5.2
> kernels, 2.6.18-92.1.18.el5PAE, 2.6.18-92.1.17.el5PAE and 
> 2.6.18-92.1.13.el5PAE.  I've also tried this on vanilla kernels 2.6.27 
> and 2.6.28-rc5 with the same result.  The logs in this email are from 
> the 2.6.18-92.1.13.el5PAE kernel (but they look the same on the other 
> kernels).
> 
> 	Currently I have 8 SCSI hard drives connected to each Adaptec
> 29320 (one is PCIx and one is PCIe).  I find that after using these
> devices for a while (usually when doing massive data transfers), I will
> see the following message (fuller details below):
> 
> Nov 5 20:06:11 xxx kernel: sd 32:0:1:0: Attempting to queue an ABORT
> message:CDB: 0x28 0x0 0x5 0x8b 0x89 0xf8 0x0 0x0
> 0x2 0x0
> Nov 5 20:06:11 xxx kernel: scsi32: At time of recovery, card was not
> paused
> Nov 5 20:06:11 xxx kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins
> <<<<<<<<<<<<<<<<
> 
> This would occur, in succession, for each device on the SCSI bus.
> Usually, the first time I saw this, the devices would recover after a
> few minutes.  The second time I see it, one or both of the buses would
> go down (I do belive, but I'm not 100% positive on this, that sometimes
> only one of the two SCSI buses will go down.)
> 
> Now, after this has occurred, I found that it was impossible to recover
> the drives (even hours afterward) by doing:
> 
> echo "scsi remove-single-device X 0 Y 0" > /proc/scsi/scsi
> echo "scsi add-single-device X 0 Y 0" > /proc/scsi/scsi
> 
> I would in fact get the same error message in the logs after running the
> add-single-device. However, if I removed the module and reprobed, as
> follows, everything would come up fine and I could access the devices
> again:
> 
> rmmod aic79xx
> modprobe 
> 
> This morning, I had another issue releted to this driver / controllers.
> When I checked the server this morning, it had Kernel Paniced with
> references to the AIC79XX driver!  Checking the logs, this occured an
> hour or so after the devices went offline during a copy test I was
> running.  I managed to screan capture the part of the panic on the
> screen via the built in "Remote Supervisor Adapter".  I've copied the
> text of the stack trace here (minus the addresses).  Note, that the
> panic seems to have occurred as a result of the AIC79XX driver handling
> an interrupt.
> 
> i8042_panic_blink
> panic
> die
> do_page_fault
> do_page_fault
> scrup
> do_page_fault
> error_code
> ahd_done [aic79xx]
> printk
> ahd_flush_quotfifo [aic79xx]
> ahd_search_qinfifo [aic79xx]
> find_busiest_group
> ahd_abort_scbs [aic79xx] 
> ahd_handle_devreset [aic79xx]
> ahd_handle_scsiint [aic79xx]
> ahd_linux_isr [aic79xx]
> handle_IRQ_event
> __do_IRQ
> do_IRQ
> common_interrupt
> mwait_idle
> cpu_idle

I'd guess that's because the sequencer sent a complete message for a
task that wasn't pending ... but that's only a guess; there are quite a
few places in the done routine it could panic.

> One other interesting piece of information is that this same error
> message showed up on my other adaptec card (with the Sun Storedge A1000
> connected to it).
> 
> Nov 6 04:09:01 xxx kernel: sd 6:0:5:0: Attempting to queue an ABORT
> message
> Nov 6 04:09:01 xxx kernel: CDB: 0x28 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x8 0x0
> Nov 6 04:09:01 xxx kernel: scsi6: At time of recovery, card was not
> paused
> 
> Note, that I do not even currently have the right utilities to set this
> array up, so it is not being used. It is not mounted, and nothing is
> copying data from it.
> 
> The fact that both SCSI buses have this same issue, and that remove and
> reprobing the module will fix the problem makes me suspect the kernel
> driver.  Also, seeing this same message on a different driver, but one
> that probably share much of the same codebase, points me in this
> direction.
> 
> I have found one message on this list (from 2 year ago) which sounds
> like a similiar problem, but has not responses:
> http://marc.info/?l=linux-kernel&m=116593449901940&w=2
> 
> Previously, I've asked a similiar question on the CentOS 5.2 Hardware
> forum, but have not seen any responses.  Since this may be driver
> related, I decided to ask this question here as well. 
> 
> http://www.centos.org/modules/newbb/viewtopic.php?topic_id=17134&forum=3
> 9
> 
> I appreciate and help / suggestion people may have.  Also, if anyone can
> better decipher what this error message really means that would be
> helpful.
> 
> Thanks!
> 
> Jay
> 
> System and Log Details follow,
> 
> System kernel details- "Uname -a":
> Linux xxx 2.6.18-92.1.13.el5PAE #1 SMP Wed Sep 24 20:07:49 EDT 2008 i686
> i6 i386 GNU/Linux
> 
> Here are the details of the cards on startup:
> 
> # cat /var/log/messages | grep -i adaptec
> Nov 3 10:28:48 xxxxxxxxxx kernel: scsi6 : Adaptec AIC7XXX EISA/VLB/PCI
> SCSI HBA DRIVER, Rev 7.0
> Nov 3 10:28:48 xxxxxxxxxx kernel: <Adaptec 2944 Ultra SCSI adapter>
> Nov 3 10:28:50 xxxxxxxxxx kernel: scsi8 : Adaptec AIC79XX PCI-X SCSI HBA
> DRIVER, Rev 3.0
> Nov 3 10:28:50 xxxxxxxxxx kernel: <Adaptec 29320LPE PCIe Ultra320 SCSI
> adapter>
> Nov 3 10:28:50 xxxxxxxxxx kernel: scsi9 : Adaptec AIC79XX PCI-X SCSI HBA
> DRIVER, Rev 3.0
> Nov 3 10:28:50 xxxxxxxxxx kernel: <Adaptec 29320ALP PCIx Ultra320 SCSI
> adapter>
> 
> # lspci | grep -i adaptec
> 05:04.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)
> 08:01.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)
> 1c:01.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
> 
> # After setting the iu parameter to 0 in all of my drives, you can see
> the speed reduce to U160 from U320
> echo 0 > "/sys/class/spi_transport/target${PCI_TARGET}\:0\:$i/iu"

That's actually not such a good idea: The IU transfer mode of SPI has
far better data integrity than the simple parity check of non-IU.  If
you want to down grade to u160, just

echo 12.5 > "/sys/class/spi_transport/target${PCI_TARGET}\:0\:$i/period"

> Nov 6 07:52:22 xxx kernel: target34:0:1: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:22 xxx kernel: target34:0:2: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:22 xxx kernel: target34:0:3: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:22 xxx kernel: target34:0:4: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:22 xxx kernel: target34:0:5: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:22 xxx kernel: target34:0:6: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:22 xxx kernel: target34:0:8: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:24 xxx kernel: target34:0:15: FAST-160 WIDE SCSI 320.0 MB/s
> DT IU QAS RDSTRM RTI WRFLOW PCOMP (6.25 ns, offset 63)
> Nov 6 07:52:25 xxx kernel: target34:0:8: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> Nov 6 07:52:25 xxx kernel: target34:0:6: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> Nov 6 07:52:25 xxx kernel: target34:0:5: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> Nov 6 07:52:25 xxx kernel: target34:0:15: FAST-80 WIDE SCSI 160.0 MB/s
> DT (12.5 ns, offset 63)
> Nov 6 07:52:26 xxx kernel: target34:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> Nov 6 07:52:26 xxx kernel: target34:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> Nov 6 07:52:26 xxx kernel: target34:0:4: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> Nov 6 07:52:26 xxx kernel: target34:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT
> (12.5 ns, offset 63)
> 
> # Here is a pretty complete snapshot of the error messages for one SCSI
> drive, note that this test has started at 13:21, so the first errors
> does not occur for nearly 7 hours.
> 
> # Here's the first message in the logs for 32:0:1:0 (note this is
> originaly scsi9, but has been renamed by removing and adding back the
> kernel module 
> # This will repeat for the other 7 devices on the SCSI bus
> Nov 5 20:06:11 xxx kernel: sd 32:0:1:0: Attempting to queue an ABORT
> message:CDB: 0x28 0x0 0x5 0x8b 0x89 0xf8 0x0 0x0
> 0x2 0x0
> Nov 5 20:06:11 xxx kernel: scsi32: At time of recovery, card was not
> paused
> Nov 5 20:06:11 xxx kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins
> <<<<<<<<<<<<<<<<<
> Nov 5 20:06:11 xxx kernel: scsi32: Dumping Card State at program address
> 0x215 Mode 0x11
> Nov 5 20:06:11 xxx kernel: Card was paused
> Nov 5 20:06:11 xxx kernel: INTSTAT[0x0] SELOID[0x4] SELID[0x10]
> HS_MAILBOX[0x0]
> Nov 5 20:06:11 xxx kernel: INTCTL[0xc0] SEQINTSTAT[0x0] SAVED_MODE[0x11]
> DFFSTAT[0x19]
> Nov 5 20:06:11 xxx kernel: SCSISIGI[0x64] SCSIPHASE[0x0] SCSIBUS[0x0]
> LASTPHASE[0x60]
> Nov 5 20:06:11 xxx kernel: SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
> SEQINTCTL[0x0]
> Nov 5 20:06:11 xxx kernel: SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4]
> QFREEZE_COUNT[0xf]
> 
> Nov 5 20:06:11 xxx kernel: KERNEL_QFREEZE_COUNT[0xf]
> MK_MESSAGE_SCB[0xff00]
> Nov 5 20:06:11 xxx kernel: MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0]
> SSTAT1[0x8]
> Nov 5 20:06:11 xxx kernel: SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
> SIMODE1[0xac]
> Nov 5 20:06:11 xxx kernel: LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
> LQOSTAT0[0x0]
> Nov 5 20:06:11 xxx kernel: LQOSTAT1[0x0] LQOSTAT2[0x0]
> Nov 5 20:06:11 xxx kernel:
> Nov 5 20:06:11 xxx kernel: SCB Count = 32 CMDS_PENDING = 26 LASTSCB 0x6
> CURRSCB 0x16 NEXTSCB 0xff00
> Nov 5 20:06:11 xxx kernel: qinstart = 33233 qinfifonext = 33233
> Nov 5 20:06:11 xxx kernel: QINFIFO:
> Nov 5 20:06:11 xxx kernel: WAITING_TID_QUEUES:
> Nov 5 20:06:11 xxx kernel: 1 ( 0x14 0x15 0xd 0x12 )
> Nov 5 20:06:11 xxx kernel: 5 ( 0x10 0x8 0x6 0x1a )
> Nov 5 20:06:11 xxx kernel: 6 ( 0x1f 0x0 0x9 0x11 )
> Nov 5 20:06:11 xxx kernel: 8 ( 0x1 0xc 0x2 0x3 )
> Nov 5 20:06:11 xxx kernel: 3 ( 0xe 0x17 0xb )
> Nov 5 20:06:11 xxx kernel: 15 ( 0x4 0x1b 0xa 0x18 )
> Nov 5 20:06:11 xxx kernel: 4 ( 0x13 0x19 )
> Nov 5 20:06:11 xxx kernel: Pending list:
> Nov 5 20:06:11 xxx kernel: 24 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0xf7]
> Nov 5 20:06:11 xxx kernel: 10 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0xf7]
> Nov 5 20:06:11 xxx kernel: 11 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x37]
> Nov 5 20:06:11 xxx kernel: 23 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x37]
> Nov 5 20:06:11 xxx kernel: 3 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x87]
> Nov 5 20:06:11 xxx kernel: 2 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x87]
> Nov 5 20:06:11 xxx kernel: 17 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x67]
> Nov 5 20:06:11 xxx kernel: 9 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x67]
> Nov 5 20:06:11 xxx kernel: 26 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x57]
> Nov 5 20:06:11 xxx kernel: 6 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x57]
> Nov 5 20:06:11 xxx kernel: 18 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x17]
> Nov 5 20:06:11 xxx kernel: 25 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x47]
> Nov 5 20:06:11 xxx kernel: 19 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x47]
> Nov 5 20:06:11 xxx kernel: 13 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x17]
> Nov 5 20:06:11 xxx kernel: 27 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0xf7]
> Nov 5 20:06:11 xxx kernel: 4 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0xf7]
> Nov 5 20:06:11 xxx kernel: 14 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x37]
> Nov 5 20:06:11 xxx kernel: 12 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x87]
> Nov 5 20:06:11 xxx kernel: 1 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x87]
> Nov 5 20:06:11 xxx kernel: 0 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x67]
> Nov 5 20:06:11 xxx kernel: 31 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x67]
> Nov 5 20:06:11 xxx kernel: 8 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x57]
> Nov 5 20:06:11 xxx kernel: 16 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x57]
> Nov 5 20:06:11 xxx kernel: 21 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x17]
> Nov 5 20:06:11 xxx kernel: 20 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x17]
> Nov 5 20:06:11 xxx kernel: 22 FIFO_USE[0x0] SCB_CONTROL[0x60]
> SCB_SCSIID[0x47]
> Nov 5 20:06:11 xxx kernel: Total 26
> Nov 5 20:06:11 xxx kernel: Kernel Free SCB list: 5 7 15 30 29 28
> Nov 5 20:06:11 xxx kernel: Sequencer Complete DMA-inprog list:
> Nov 5 20:06:11 xxx kernel: Sequencer Complete list:
> Nov 5 20:06:11 xxx kernel: Sequencer DMA-Up and Complete list:
> Nov 5 20:06:11 xxx kernel: Sequencer On QFreeze and Complete list:
> Nov 5 20:06:11 xxx kernel:
> Nov 5 20:06:11 xxx kernel:
> Nov 5 20:06:11 xxx kernel: scsi32: FIFO0 Free, LONGJMP == 0x8254, SCB
> 0x0
> Nov 5 20:06:11 xxx kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0]
> DFSTATUS[0x89]
> Nov 5 20:06:11 xxx kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0]
> DFFSXFRCTL[0x0]
> Nov 5 20:06:11 xxx kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00,
> SHCNT = 0x0
> Nov 5 20:06:11 xxx kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
> Nov 5 20:06:11 xxx kernel:
> Nov 5 20:06:11 xxx kernel: scsi32: FIFO1 Active, LONGJMP == 0x81f2, SCB
> 0x16
> Nov 5 20:06:11 xxx kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8]
> DFSTATUS[0x89]
> Nov 5 20:06:11 xxx kernel: SG_CACHE_SHADOW[0x3] SG_STATE[0x0]
> DFFSXFRCTL[0x0]
> Nov 5 20:06:11 xxx kernel: SOFFCNT[0x0] MDFFSTAT[0x14] SHADDR =
> 0x024e4c000, SHCNT = 0x0
> Nov 5 20:06:11 xxx kernel: HADDR = 0x024e4c000, HCNT = 0x0 CCSGCTL[0x10]
> Nov 5 20:06:11 xxx kernel: LQIN: 0x8 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> Nov 5 20:06:11 xxx kernel: scsi32: LQISTATE = 0x0, LQOSTATE = 0x0,
> OPTIONMODE = 0x52
> Nov 5 20:06:11 xxx kernel: scsi32: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x2
> Nov 5 20:06:11 xxx kernel: scsi32: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> Nov 5 20:06:11 xxx kernel: SIMODE0[0xc]
> Nov 5 20:06:11 xxx kernel: CCSCBCTL[0x4]
> Nov 5 20:06:11 xxx kernel: scsi32: REG0 == 0x5, SINDEX = 0x120, DINDEX =
> 0x120
> Nov 5 20:06:11 xxx kernel: scsi32: SCBPTR == 0x16, SCB_NEXT == 0x13,
> SCB_NEXT2 == 0x14
> Nov 5 20:06:11 xxx kernel: CDB 28 0 6 80 1 89
> Nov 5 20:06:11 xxx kernel: STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> Nov 5 20:06:11 xxx kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
> >>>>>>>>>>>>>>>>>>

The slight problem here is that no-one has a sequencer manual which
tells us what all this means.  However, it's completely normal since the
driver has a dump_card_state() call in the abort routine.

Why the abort was called in the first place is anyone's guess, but it
probably came from a command timing out.   The timeout could either be a
sequencer error or simply a normal problem because you're hammering the
device hard and it took longer to get to the command to process.

You can test this latter quite easily by doubling the command timeouts:

echo 60 > /sys/class/scsi_disk/*/device/timeout

And seeing if the trouble occurs with the same frequency.  If it does,
there's likely some sequencer issue;  if the frequency decreases, it's
device related and you can probably throttle the device by reducing the
queue depth to avoid the situation.

James


