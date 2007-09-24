From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] mptbase: Reset ioc initiator during PCI resume
Date: Mon, 24 Sep 2007 12:45:33 -0700
Message-ID: <20070924194533.GA13359@tree.beaverton.ibm.com>
References: <20070920211014.GA24047@tree.beaverton.ibm.com> <664A4EBB07F29743873A87CF62C26D702A99DD@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43020 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbXIXTpV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2007 15:45:21 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D702A99DD@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, DL-MPTFusionLinux@lsi.com, "Support, Software" <support@lsi.com>, linux-kernel@vger.kernel.org

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
