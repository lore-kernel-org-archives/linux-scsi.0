From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Fri, 3 Dec 2010 09:39:44 -0700
Message-ID: <201012030939.44858.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <201012012329.54944.thomas@fjellstrom.ca> <201012020249.00367.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201012020249.00367.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On December 2, 2010, Thomas Fjellstrom wrote:
> On December 1, 2010, Thomas Fjellstrom wrote:
> > On November 17, 2010, you wrote:
> > > On 11/17/2010 08:53 AM, Thomas Fjellstrom wrote:
> > > [snip]
> > > 
> > > > Still no fatal errors, but the problem is still happening regularly.
> > > > It causes a pause in disk io of a couple seconds at least. Really
> > > > quite annoying.
> > > > 
> > > > One thing thats got me wondering, is could this be a power issue?
> > > > It almost seems like (from the messages) that a single drive (any
> > > > drive) is freaking out, and returning an error that probably
> > > > shouldn't happen (no CHS 0?), which could mean the drive is
> > > > underpowered and the firmware is flipping out. I'm not entirely
> > > > sure. The system has a 750w decent quality Antec power supply. The
> > > > total power use of the system shouldn't come over half that (phenom
> > > > II x4 810 cpu, gigabyte ma790fxtud5p mb, low profile nvidia 9400GS
> > > > gpu, 8 sata hdds, 3 fans, etc). I'm mostly sure the 12v rails are
> > > > spread out evenly, but I have yet to make absolutely sure.
> > 
> > Made absolute sure. I had been worrying that I was overloading one of the
> > rails on the PSU, but it turns out that it isn't a multi 12v rail PSU
> > after all. The box and advertising says it is, but the electronics
> > inside all say its a single 12v rail device.
> > 
> > > [snip]
> > > 
> > > After the mvsas update in 2.6.35 this started happening to me as well;
> > > at least its better than the previous state - not working.. ;-)
> > > However, after rolling a new 2.6.35 with the following fix that is
> > > queued up for the upcoming 2.6.35 and 2.6.36 stable releases, they
> > > seem to have dissapeared - 3 days and counting.
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blo
> > > b_ pl
> > > ain;f=queue-2.6.33/libsas-fix-ncq-mixing-with-non-ncq.patch;h=b6d7c9209
> > > 4 d95 ad67a3b23c2e09c25d4fbd0f46b;hb=HEAD
> > > 
> > > The fix is queued up for the next 2.6.36 and 2.6.35 stable
> > > point-releases.
> > 
> > Ahah. I wonder how I missed that when I first read it. I'll have to give
> > the stable .36 kernel a try. Thanks!
> 
> No fix so far:
> 
> [ 2539.040104] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
> mvi=ffff880222f00000 task=ffff88018b3e2980 slot=ffff880222f265d0
> slot_idx=x2 [ 2539.040118] drivers/scsi/mvsas/mv_sas.c
> 1632:mvs_query_task:rc= 5 [ 2539.040154] drivers/scsi/mvsas/mv_sas.c
> 2083:port 7 ctrl sts=0x89800. [ 2539.040163] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 7 irq sts = 0x1001001 [ 2539.040176] drivers/scsi/mvsas/mv_sas.c
> 2111:phy7 Unplug Notice [ 2539.050220] drivers/scsi/mvsas/mv_sas.c
> 2083:port 7 ctrl sts=0x199800. [ 2539.050229] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 7 irq sts = 0x1001081 [ 2539.071157] drivers/scsi/mvsas/mv_sas.c
> 2083:port 7 ctrl sts=0x199800. [ 2539.071165] drivers/scsi/mvsas/mv_sas.c
> 2085:Port 7 irq sts = 0x10000 [ 2539.071173] drivers/scsi/mvsas/mv_sas.c
> 2138:notify plug in on phy[7] [ 2539.081142] drivers/scsi/mvsas/mv_sas.c
> 1224:port 7 attach dev info is 5000002 [ 2539.081142]
> drivers/scsi/mvsas/mv_sas.c 1226:port 7 attach sas addr is 7 [
> 2539.081142] drivers/scsi/mvsas/mv_sas.c 378:phy 7 byte dmaded.
> [ 2541.270047] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
> device[5]:rc= 0 [ 2541.270066] ata14: translated ATA stat/err 0x01/04 to
> SCSI SK/ASC/ASCQ 0xb/00/00 [ 2541.270926] ata14: status=0x01 { Error }
> [ 2541.271747] ata14: error=0x04 { DriveStatusError }
> 
> That appeared after about 42 minutes of uptime.

So after about 32 hours of uptime theres been 36 separate events. Each spits
out similar messages as above, and each comes with a noticeable pause while
the drive is reset.

There are a number of possible reasons that I'm still having issues:
 - I managed to mess up the git checkout
 - My problem isn't related to the fix
 - The fix doesn't cover all cases of the problem it meant to fix

I'm not certain which of them it is, I'd be more inclined to think I messed up
the checkout, as I did patch something in, but the patches were completely
unrelated and shouldn't have affected the scsi or ata systems at all. At this
point I'm just grasping at straws.

In case my card is somehow different than expected, I'll paste the lspci info
for it: (AOC-SASLP-MV8)

04:00.0 SCSI storage controller: Marvell Technology Group Ltd. MV64460/64461/64462 System Controller, Revision B (rev 01)
        Subsystem: Super Micro Computer Inc Device 0500
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 2: I/O ports at df00 [size=128]
        Region 4: Memory at fdef0000 (64-bit, non-prefetchable) [size=64K]
        [virtual] Expansion ROM at fdd00000 [disabled] [size=256K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 2048 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <256ns, L1 unlimited
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100 v1] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
        Kernel driver in use: mvsas

Its installed in a Phenom II X4 810 based system with a 790FX/SB750 chipset,
8G DDR3 1333 RAM, 6 1TB Seagate 7200.12 SATAII drives connected to the
card via sas->sata breakout cables, and a couple 4 drive SATA hotswap bays.
There are also two Seagate 7200.12 500G drives hooked up to the motherboard
SATA controller. The system is powered via an Antec Neopower Blue 650W PSU
which is probably only half loaded. System also has a discreet gfx card, but its
a low end, low profile, fanless card that takes up next to no power.

I'm still willing to help test any fixes for the mvsas driver on this card.

Thank you.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
