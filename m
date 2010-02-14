From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Patch for MVSAS
Date: Sun, 14 Feb 2010 11:00:27 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002141007420.4986@uplift.swm.pp.se>
References: <loom.20100210T002935-813@post.gmane.org>  <73e903671002110150h3c4ae0dcq17625f6d9b545bf4@mail.gmail.com> <1265914540.13197.57.camel@mulgrave.site>
 <6B62480106F2B34D8404CF2FDAA4D9EF71F637D6DB@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN-99D05D88-A0F3-0C58-BFB2-2F138E38F61D>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:50820 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0BNKA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2010 05:00:28 -0500
In-Reply-To: <6B62480106F2B34D8404CF2FDAA4D9EF71F637D6DB@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN-99D05D88-A0F3-0C58-BFB2-2F138E38F61D>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Orion Poplawski <orion@cora.nwra.com>, =?ISO-8859-15?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, "caspar@ketsers.dhs.org" <caspar@ketsers.dhs.org>

On Fri, 12 Feb 2010, Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech wrote:

> Hi,
> The attached patch contains the fixes for SATA hot plugging, hot plug in/out of drives (SAS/SATA) from Expander while IO is going on and tape issues.
> Try with attached patch and let me know the results.
> Note: I have tested with only 64xx chipset.

Hi, Srinivas!

First of all, all logs outputs I have put in 
<http://swm.pp.se/linux-scsi-feb14.txt>

I used the latest 2.6.32-13 ubuntu lucid 10.04 kernel and added your 
patches and booted the machine with no drives inserted. Then I 
hot-inserted drive after drive, where one drive gave me kernel errors in 
lib-ata (see above mentioned log). I then proceeded to do:

"mdadm --create /dev/md9 --chunk=128 --level=6 --raid-device=4 --size=2000000 --metadata=1.2 /dev/sd[bcde]"

That made mdadm go into D-state, accessing sdc (the oops:ed one). I 
unplugged sdc which made mdadm come out of D-state, ran the above line 
with "missing" instead of sdc, then my raid6 started sync:ing. I then put 
another drive in sdc slot which started without oops and then I as 
successfully able to add it to my test raid6. I then put that (I guess 
bad) drive in another drive slot (hotswapped) and the controller again 
gets the fits, so the error handling for whatever is wrong with that 
drive, could use some improvement.

Apart from that bad drive causing problems, the driver now seems to be in 
a much much better state. "smartctl -a" needs "-T permissive" on my 
WD20EADS drives, but it seems to be a bit coming and going, I don't really 
know the exact symptom. It seems to be initially, then after a while of 
trying it starts working without "-T permissive".

I rebooted the machine again (with only known good working disks but none 
plugged in) and hotplugged one drive, got the libata-core.c:5187 oops 
again. I now got the smartctl -a needing "-T permissive" on the WD20EADS 
drives again, but it cleared up after a few attempts.

I then rebooted again with all the drives plugged in and everything seemed 
to work fine. Tried some hot-remove and hot-plugging and didn't get any 
unexpected behaviour apart from more libata-core:5187 oops.

At no time did the machine crash or stopped responding (apart for 
processes in D-state that is). Great improvement! Good work!

I have the following hw (lspci -vvv)

02:00.0 SCSI storage controller: Marvell Technology Group Ltd. 
MV64460/64461/64462 System Controller, Revision B (rev 01)
 	Subsystem: Super Micro Computer Inc Device 0500
 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
 	Latency: 0, Cache Line Size: 32 bytes
 	Interrupt: pin A routed to IRQ 16
 	Region 2: I/O ports at bc00 [size=128]
 	Region 4: Memory at fe7f0000 (64-bit, non-prefetchable) [size=64K]
 	Expansion ROM at fe780000 [disabled] [size=256K]
 	Capabilities: [48] Power Management version 2
 		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
 		Address: 0000000000000000  Data: 0000
 	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
 			MaxPayload 128 bytes, MaxReadReq 2048 bytes
 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
 		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 <256ns, L1 unlimited
 			ClockPM- Suprise- LLActRep- BwNot-
 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
 		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
 	Capabilities: [100] Advanced Error Reporting <?>
 	Kernel driver in use: mvsas
 	Kernel modules: mvsas

------------------------------------------------------------------------------------

Example of output where I need -T permissive:

root@swmike-test:/var/log# smartctl -a /dev/sde
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY0701443
Firmware Version: 04.05G04
User Capacity:    2,000,398,934,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Feb 14 10:27:57 2010 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Values from ATA Return Descriptor are:
  00     09 0c 00 00 00 04 00 b0  00 3d 00 7e 40 40
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.

----------------------------------------------------------------------------------

And here it works.


root@swmike-test:/var/log# smartctl -T permissive -a /dev/sde
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY0701443
Firmware Version: 04.05G04
User Capacity:    2,000,398,934,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sun Feb 14 10:28:21 2010 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Values from ATA Return Descriptor are:
  00     09 0c 00 00 00 04 00 48  00 12 00 91 40 40
=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
 					was suspended by an interrupting 
command from host.
 					Auto Offline Data Collection: 
Enabled.
Self-test execution status:      (   0)	The previous self-test routine 
completed
 					without error or no self-test has 
ever
 					been run.
Total time to complete Offline
data collection: 		 (43800) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
 					Auto Offline data collection 
on/off support.
 					Suspend Offline collection upon 
new
 					command.
 					Offline surface scan supported.
 					Self-test supported.
 					Conveyance Self-test supported.
 					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
 					power-saving mode.
 					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
 					General Purpose Logging supported.
Short self-test routine
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
 					SCT Feature Control supported.
 					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always 
-       0
   3 Spin_Up_Time            0x0027   150   146   021    Pre-fail  Always 
-       9491
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always 
-       38
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always 
-       0
   7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always 
-       0
   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always 
-       10
  10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always 
-       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always 
-       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always 
-       34
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always 
-       26
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always 
-       134
194 Temperature_Celsius     0x0022   122   115   000    Old_age   Always 
-       30
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always 
-       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always 
-       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age   Offline 
-       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always 
-       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age   Offline 
-       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute 
delay.



-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
