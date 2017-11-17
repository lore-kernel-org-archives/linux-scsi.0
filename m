From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
Subject: Re: Seagate External SMR drive USB resets (XHCI transfer error, not
 timeout)
Date: Fri, 17 Nov 2017 17:19:00 -0500
Message-ID: <20171117171900.6bd47b90@Vantage.cJ>
References: <20171115232129.102a1122@Vantage.cJ>
        <Pine.LNX.4.44L0.1711161435280.1287-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/NYKNk7TjaIwTmK7+3Z4gGH4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zougloub.eu ([69.70.16.42]:33644 "EHLO zougloub.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936755AbdKQWR5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 17:17:57 -0500
In-Reply-To: <Pine.LNX.4.44L0.1711161435280.1287-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Jens <jens-bugzilla.kernel.org@spamfreemail.de>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

--MP_/NYKNk7TjaIwTmK7+3Z4gGH4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Thu, 16 Nov 2017 14:42:51 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 15 Nov 2017, J=C3=A9r=C3=B4me Carretero wrote:
>=20
> > I performed an usbmon capture extract, centered around the event
> > (there was a few hundred MBs written for this to happen):
> >=20
> >  Nov 15 22:16:33 Bidule kernel: usb 6-4.3.2.1: reset SuperSpeed USB
> >   device number 8 using xhci_hcd
> >=20
> > I can see that the computer is sending a write request, and sees a
> > -EPROTO in answer (capture in attachment), so scratch the timeout
> > issue (and actually when thinking about it, this matches what UAS
> > was saying, except that UAS was taking ages to recover).
> >=20
> > Looked for EPROTO in the usb code, and found a dynamic debug printf
> > in XHCI; after enabling it:
> >=20
> >  Nov 15 22:45:03 Bidule kernel: xhci_hcd 0000:07:00.0: Transfer
> > error for slot 13 ep 3 on endpoint Nov 15 22:45:03 Bidule kernel:
> > xhci_hcd 0000:07:00.0: Transfer error for slot 12 ep 3 on endpoint
> > Nov 15 22:45:03 Bidule kernel: usb 6-4.3.3.1: reset SuperSpeed USB
> > device number 9 using xhci_hcd Nov 15 22:45:03 Bidule kernel: usb
> > 6-4.3.2.1: reset SuperSpeed USB device number 8 using xhci_hcd
> >=20
> > First, I understand that a bad USB device could poison the kernel
> > log, but shouldn't that xhci_dbg() (and others eg. babble) be at
> > least an xhci_info() (I saw 2a9227a5)? =20
>=20
> I suspect that if every USB error got printed in the kernel log,
> people would be upset at how much useless information was added.

So it turns out that one of the 2 drives that produced most of these
errors died overnight (the kernel first reported failure at READ DMA
EXT, SMART seeing 6k Current_Pending_Sector / Offline_Uncorrectable,
then the drive just lost it and wouldn't even complete USB enumeration
now.

IMHO too much information is perhaps better than not enough, and I bet
that people would reconsider purchasing low-quality hardware if they
noticed these (unless they can happen for no reason).

>=20
> > Then... I don't know enough to attribute the issue the upstream USB
> > hub(s) or the drive endpoint not behaving properly, or the
> > kernel... what should I do with these messages? =20
>=20
> Here's the error:
>=20
> b5251480 0.505661 S Bo:6:008:2 -115 196608 =3D 540a2813 1a33dd99
> ab76840c bf72fc6b 60f9fcaf 4d61822c c007ff4e ab72d022 b5251480
> 0.506280 C Bo:6:008:2 -71 86016 >

Out of curiosity, which tool produced this condensed output?

> This means the kernel tried to write 196608 bytes to the drive.  After
> 86016 had been transferred, the drive did not reply correctly to the
> next output transaction, causing the kernel to perform a reset. =20
> That's what happened, according to the viewpoint of the xhci-hcd=20
> driver.
>=20
> In theory it's possible that the drive did respond correctly and the
> information get messed up on the USB cable or on the computer's end.

Wow, that sucks.
I had a mental image where the transactions used FEC and it would be
obviously possible to differentiate between cable/hub/endpoint errors.


> Since we can't see what signals were actually sent on the USB bus,
> there's no way to be certain.  But it seems most likely that the drive
> (or rather, its USB interface) was at fault.

I would speculate (with high confidence) that the drive itself is doing
unexpected stuff, because of that bugzilla issue showing that these SMR
drives also behave strangely when connected on SATA.

I have had in circulation 10 of these 8 TB SMR drives, 1 SATA and 9 USB,
and all of them are generating unexpected kernel logging to some
extent, when subject to write-intensive loads.
2 from 2015 and SMART says they're all good; the rest since 10 days
ago, one was DOA (very early SMART bad sectors) and tonight's failure
has an S/N consecutive to that first DOA one, which smells a little.


> > I'm still filling the drives, will perform a scrub after, to see if
> > the issue causes data loss... =20

To be continued... since it looks like there's no fundamental issue
with the kernel itself and this is turning into a rant on hardware,
I'll just direct follow-up e-mails to the ML only, tell me if you want
to stay in CC.


Thanks again,

--=20
J=C3=A9r=C3=B4me

--MP_/NYKNk7TjaIwTmK7+3Z4gGH4
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=smr-smart.log

=== START OF INFORMATION SECTION ===
Device Model:     ST8000DM004-2CX188
Serial Number:    XXXXXXXX
LU WWN Device Id: XXXXXXXXXXXXXXXXXX
Firmware Version: 0001
User Capacity:    8,001,563,222,016 bytes [8.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5425 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-3 T13/2161-D revision 5
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Nov 16 23:36:32 2017 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		(    0) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
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
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 951) minutes.
Conveyance self-test routine
recommended polling time: 	 (   2) minutes.
SCT capabilities: 	       (0x30a5)	SCT Status supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   058   049   006    Pre-fail  Always       -       179381080
  3 Spin_Up_Time            0x0003   093   093   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       38
  5 Reallocated_Sector_Ct   0x0033   099   099   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   074   060   045    Pre-fail  Always       -       23699800
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       189 (82 112 0)
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       38
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   084   084   000    Old_age   Always       -       16
188 Command_Timeout         0x0032   099   092   000    Old_age   Always       -       115965888471
189 High_Fly_Writes         0x003a   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0022   051   040   040    Old_age   Always   In_the_past 49 (Min/Max 37/50)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       66
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       55
194 Temperature_Celsius     0x0022   049   060   000    Old_age   Always       -       49 (0 19 0 0 0)
195 Hardware_ECC_Recovered  0x001a   083   065   000    Old_age   Always       -       179381080
197 Current_Pending_Sector  0x0012   081   081   000    Old_age   Always       -       6264
198 Offline_Uncorrectable   0x0010   081   081   000    Old_age   Offline      -       6264
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       129 (54 58 0)
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       5193420925
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       4503355540

SMART Error Log Version: 1
ATA Error Count: 16 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 16 occurred at disk power-on lifetime: 187 hours (7 days + 19 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 d5 80 ff ff ff 4f 00   4d+03:49:10.331  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:10.330  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:10.329  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:10.328  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:10.066  READ DMA EXT

Error 15 occurred at disk power-on lifetime: 187 hours (7 days + 19 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 d5 80 ff ff ff 4f 00   4d+03:49:03.920  READ DMA EXT
  25 d5 08 ff ff ff 4f 00   4d+03:49:03.907  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:03.899  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:03.635  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:49:03.633  READ DMA EXT

Error 14 occurred at disk power-on lifetime: 187 hours (7 days + 19 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 d5 80 ff ff ff 4f 00   4d+03:47:44.792  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:47:44.789  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:47:44.780  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:47:44.779  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   4d+03:47:44.756  READ DMA EXT

Error 13 occurred at disk power-on lifetime: 145 hours (6 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 d5 80 ff ff ff 4f 00   2d+10:36:05.555  READ DMA EXT
  25 d5 38 ff ff ff 4f 00   2d+10:36:05.548  READ DMA EXT
  25 d5 10 ff ff ff 4f 00   2d+10:36:05.547  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   2d+10:36:05.532  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   2d+10:36:05.479  READ DMA EXT

Error 12 occurred at disk power-on lifetime: 145 hours (6 days + 1 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  25 d5 80 ff ff ff 4f 00   2d+10:36:00.813  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   2d+10:36:00.800  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   2d+10:36:00.714  READ DMA EXT
  25 d5 80 ff ff ff 4f 00   2d+10:36:00.627  READ DMA EXT
  25 d5 80 00 4d 72 4c 00   2d+10:36:00.547  READ DMA EXT

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
If Selective self-test is pending on power-up, resume after 0 minute delay.


--MP_/NYKNk7TjaIwTmK7+3Z4gGH4--
