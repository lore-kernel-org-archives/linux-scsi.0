From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [patch 16/17] mptbase: reset ioc initiator during PCI resume
Date: Tue, 2 Oct 2007 16:06:25 -0700
Message-ID: <20071002230625.GA16003@tree.beaverton.ibm.com>
References: <200710022138.l92LcCeb023603@imap1.linux-foundation.org> <664A4EBB07F29743873A87CF62C26D70A0A78D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38005 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXJBXJI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 19:09:08 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l92N9756015314
	for <linux-scsi@vger.kernel.org>; Tue, 2 Oct 2007 19:09:07 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l92N93PA694004
	for <linux-scsi@vger.kernel.org>; Tue, 2 Oct 2007 19:09:07 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l92N93nM013464
	for <linux-scsi@vger.kernel.org>; Tue, 2 Oct 2007 19:09:03 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70A0A78D@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Oct 02, 2007 at 04:51:48PM -0600, Moore, Eric wrote:

> I replied to this thread a couple times last week, and no response from
> Darrick.   I doubt this is required becase the MESSAGE_UNIT_RESET is
> issued from inside mpt_do_ioc_recovery.  I need some logs with debug
> enabled.   Darrick did you see my email?

Yep.  Replied to it, too.  Apparently it never got to you, so I've
attached it below.

--D

---------------------

On Thu, Sep 20, 2007 at 07:06:35PM -0600, Moore, Eric wrote:
> Darrick - MESSAGE_UNIT_RESET is already issued from inside
> mpt_do_ioc_recovery(), so you don't need to send this in advance of
> that.    YOu will find that occuring from the function MakeIocReady.
> Anyways... would it be possible for you to enable debug logging so I can
> see what problem your having?   I suggest MPT_DEBUG and MPT_DEBUG_INIT.
> If its possible for you to manually load mptbase, that way you can set
> the command line option. 

I took a look at MakeIocReady(), and this section caught my eye:

/* Is it already READY? */
if (!statefault && (ioc_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_READY)
	return 0;

So I turned on a whole lot more debugging (mpt_debug_level=65535), and
caught this from the dhsprintk() just above that code snippet:

mptbase::MakeIocReady, ioc0 [raw] state=10000000

state=10000000 seems to correspond with MPI_IOC_STATE_READY, which means
that the adapter isn't getting reset because the chip claims to be
ready.  It doesn't seem to be ready, as demonstrated by the original error
message that I reported with the patch.  I'll append the log entries
pertaining to mpt to the end of this message.

--D

(Driver sign-on message if you were curious)

[  164.467481] Fusion MPT base driver 3.04.05
[  164.471706] Copyright (c) 1999-2007 LSI Logic Corporation
[  164.492483] Fusion MPT SAS Host driver 3.04.05
[  167.066482] ACPI: PCI Interrupt 0000:0c:03.0[A] -> <6>ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[  167.066534] mptbase: Initiating ioc0 bringup
[  167.761481] ioc0: LSISAS1064E B0: Capabilities={Initiator}
[  178.681050] scsi6 : ioc0: LSISAS1064E B0, FwRev=00060200h, Ports=1, MaxQ=511, IRQ=16
[  178.741821] scsi 6:0:0:0: Direct-Access     IBM-ESXS GNA073C3ESTT0Z N BH0C PQ: 0 ANSI: 5
[  178.816476] sd 6:0:0:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
[  178.825198] sd 6:0:0:0: [sda] Write Protect is off
[  178.830088] sd 6:0:0:0: [sda] Mode Sense: d3 00 10 08
[  178.831204] sd 6:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  178.845101] sd 6:0:0:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
[  178.853483] sd 6:0:0:0: [sda] Write Protect is off
[  178.858343] sd 6:0:0:0: [sda] Mode Sense: d3 00 10 08
[  178.859961] sd 6:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[  178.869069]  sda: sda1 sda2 sda3 sda4
[  178.877690] sd 6:0:0:0: [sda] Attached SCSI disk
[  178.912356] sd 6:0:0:0: Attached scsi generic sg0 type 0

(put system to sleep)

[  821.678155] mptbase: ioc0: pci-suspend: pdev=0xffff81003f64a000, slot=0000:01:00.0, Entering operating state [D3]
[  821.678195] mptbase: ioc0: Sending IOC reset(0x40)!
[  821.813585] mptbase: ioc0: WaitForDoorbell ACK (count=16)
[  821.814120] ACPI: PCI interrupt for device 0000:01:00.0 disabled

(wake system up)

[  891.307583] mptbase: ioc0: pci-resume: pdev=0xffff81003f64a000, slot=0000:01:00.0, Previous operating state [D3]
[  891.431146] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100000, writing 100107)
[  891.431174] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[  891.431179] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000
[  891.431182] mptbase: Initiating ioc0 recovery
[  891.431184] mptbase::MakeIocReady, ioc0 [raw] state=10000000
[  891.431187] mptbase: ioc0: Sending get IocFacts request req_sz=12 reply_sz=80
[  894.723823] mptbase: ioc0: WaitForDoorbell INT (cnt=412) howlong=5
[  894.723826] mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=412
[  894.723830] mptbase: ioc0: Sending get IocFacts request req_sz=12 reply_sz=80
[  894.731815] mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
[  894.731817] mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
[  894.739806] mptbase: ioc0: WaitForDoorbell ACK (count=0)
[  894.747799] mptbase: ioc0: WaitForDoorbell ACK (count=0)
[  894.755791] mptbase: ioc0: WaitForDoorbell ACK (count=0)
[  894.763781] mptbase: ioc0: WaitForDoorbell ACK (count=0)
[  894.763784] mptbase: ioc0: Handshake request frame (@ffff810028c81918) header
[  894.763786] mptbase: ioc0: HandShake request post done, WaitCnt=0
[  894.763789] mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
[  894.771775] mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
[  894.771778] mptbase: ioc0: WaitCnt=1 First handshake reply word=03000000
[  894.779766] mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
[  894.779769] mptbase: ioc0: Got Handshake reply:
[  894.779770] mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=1)
[  894.779772] mptbase: ioc0: HandShake reply count=1
[  894.779775] mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
<repeat>
