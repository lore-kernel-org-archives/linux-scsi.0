From: Dave Richards <drichards@mahinetworks.com>
Subject: sym53c8xx_2 / Promise UltraTrak RM8000
Date: Tue, 25 Feb 2003 15:27:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <9D6D37E97A57D411BB7C00508BAE29C902D242C8@main.mahinetworks.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Our IS folks have had problems with the Promise Tech. UltraTrak RM8000 under
2.4.20 (and earlier versions).  I've diagnosed the problem, but I am not
familiar enough with the SCSI specs to know who to blame.  So, here's the
data and you can decide.

The following is a dump of the INQUIRY data returned by the RM8000:

00 00 03 03 3b 00 00 32 50 72 6f 6d 69 73 65 20 ....;..2Promise
34 20 44 69 73 6b 20 52 41 49 44 35 20 20 20 20 4 Disk RAID5
31 2e 31 30 39 38 30 33 31 36 31 32 00 00 00 00 1.1098031612....
00 00 00 00 00 00 00 00 0c 00 00 00 00 00 00 00 ................

The problem with this INQUIRY data (from the 8xx driver's perspective) is
that the SCSI version is ANSI 3 and the INQUIRY data format is 3 (not 2).  I
changed sym_misc.c line 297: (2.4.20)

#if 0
        if (inq_version >= 2 && (inq_data[3] & 0xf) == 2) {
#else
        if (inq_version >= 2 && (inq_data[3] & 0xf) >= 2) {
#endif

This causes the Promise box to come up Fast-80 Wide16 (as it should).

So, whose bug is this?  Is it the sym53c8xx_2 driver for not recognizing the
valid INQUIRY data format version 3, or is it Promise's for returning the
invalid INQUIRY data format version 3?

	Dave
