From: Dave Richards <drichards@mahinetworks.com>
Subject: FW: sym53c8xx_2 / Promise UltraTrak RM8000
Date: Fri, 28 Feb 2003 13:18:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <9D6D37E97A57D411BB7C00508BAE29C902D242EA@main.mahinetworks.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

According to Promise, the INQUIRY data format version 3 is correct.  See
bwlow.  Thus, the sym53c8xx/sym53c8xx_2 drivers are incorrect.  It's
possible that similiar bugs may exist in other SCSI HBA drivers; I have not
looked.

	Dave

-----Original Message-----
From: Victor Pacheo [mailto:victorp@promise.com]
Sent: Friday, February 28, 2003 8:58 AM
To: drichards@mahinetworks.com
Subject: RE: sym53c8xx_2 / Promise UltraTrak RM8000


Hi, Dave

This is the responce of our engineers:
The standard INQUIRY data format is as followes:

   | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
0  |P Qualifier| Device Class      |
1  |RMB|       Reserved(SCSI-1)    |
2  |  ISO  | ECMA      |   ANSI    |
3  |AEN|TIO|Res|Res|  Data Format  |
4  ....

Field description:
ANSI: ANSI version see the following tale
Data Format: Indicates the response format of the following standard
INQUIRY data. Interpreted in the same way as the ANSI version field.

Table of ANSI Version
Status |	Meaning
0h	 | The device supports the SCSI-1 standard
1h	 | The device supports the CCS
2h	 | The device supports SCSI-2
3h	 | The device supports SCSI-3

So, the Data format and ANSI should be the same 03h which means the
device support SCSI-3 Standard

Thanks


-----Original Message-----
From: Dave Richards [mailto:drichards@mahinetworks.com]
Sent: Wednesday, February 26, 2003 1:19 PM
To: Victor Pacheo
Subject: FW: sym53c8xx_2 / Promise UltraTrak RM8000


I sent the message below to the Linux folks yesterday.  I called
Promise's
tech support line this afternoon; they said I needed to e-mail you.

The fundemental question raised below has to do with the 4th byte
(offset 3)
of the data returned by the UltraTrak RM8000 in response to a SCSI
INQUIRY
command.  There is a hex dump of the response below.  The byte at offset
3
is 03 (indicating INQUIRY data format version 3), the SCSI driver is
expecting version 2, it has no knowledge of an INQUIRY data format
version
3.  Is there a SCSI standard which defines an INQUIRY data format
version 3?
I.e. is the RM8000 returning a value allowed via some version of the
spec?
I have no documentation for INQUIRY data format version 3.

	Thanks!

	Dave

-----Original Message-----
From: Dave Richards 
Sent: Tuesday, February 25, 2003 3:28 PM
To: 'linux-scsi@vger.kernel.org'
Subject: sym53c8xx_2 / Promise UltraTrak RM8000


Our IS folks have had problems with the Promise Tech. UltraTrak RM8000
under
2.4.20 kernel (and earlier versions).  I've diagnosed the problem, but I
am not
familiar enough with the SCSI specs to know who to blame.  So, here's
the
data and you can decide.

The following is a dump of the INQUIRY data returned by the RM8000:

00 00 03 03 3b 00 00 32 50 72 6f 6d 69 73 65 20 ....;..2Promise
34 20 44 69 73 6b 20 52 41 49 44 35 20 20 20 20 4 Disk RAID5
31 2e 31 30 39 38 30 33 31 36 31 32 00 00 00 00 1.1098031612....
00 00 00 00 00 00 00 00 0c 00 00 00 00 00 00 00 ................

The problem with this INQUIRY data (from the 8xx driver's perspective)
is
that the SCSI version is ANSI 3 and the INQUIRY data format is 3 (not
2).  I
changed sym_misc.c line 297: (2.4.20)

#if 0
        if (inq_version >= 2 && (inq_data[3] & 0xf) == 2) {
#else
        if (inq_version >= 2 && (inq_data[3] & 0xf) >= 2) {
#endif

This causes the Promise box to come up Fast-80 Wide16 (as it should).

So, whose bug is this?  Is it the sym53c8xx_2 driver for not recognizing
the
valid INQUIRY data format version 3, or is it Promise's for returning
the
invalid INQUIRY data format version 3?

	Dave
