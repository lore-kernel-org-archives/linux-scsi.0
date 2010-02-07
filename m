From: =?ISO-8859-15?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: change the timeout of long-duration operations
Date: Sun, 07 Feb 2010 11:29:17 +0100
Message-ID: <4B6E95FD.4080206@stud.tu-ilmenau.de>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:36499 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0BGKzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2010 05:55:45 -0500
Received: from [10.10.10.23] (erft-5d80cc84.pool.mediaWays.net [93.128.204.132])
	(authenticated bits=0)
	by wega.rz.tu-ilmenau.de (8.12.11/8.12.11/Debian-3) with ESMTP id o17ATGd4012322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 7 Feb 2010 11:29:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Folks,

I have written some userspace code that talks to SG via SG_IO, issuing
SCSI-ATA-Passthru commands.  Upon commands that take long as f.e. the
ATA-Command SecurityEraseUnit, I get strange behaviour.  Seems like the
SCSI-Subsystem does not recognize that this special command can take
long time till completion.  It returns after the timeout (which I'd lik=
e
to be able to reconfigure), but obviously does not set the sense data
accordingly (my debug output should show up if the sense contained any
errors, but it didn't).  It only logs correctly to syslog.  The hardwar=
e
driver used was AHCI on a JMicron 20363.

Question:  Is there a way to disable/change the kernel command timeouts=
,
for those few ATA-Commands that won't return for a long period of time?

=46ollowing is some syslog showing briefly what happened:
=46eb  7 10:37:07 dobbelherz kernel: ata10: SATA link up 3.0 Gbps (SSta=
tus
123 SControl 300)
=46eb  7 10:37:07 dobbelherz kernel: ata10.00: ATA-7: SAMSUNG HD103UJ,
1AA01112, max UDMA7
=46eb  7 10:37:07 dobbelherz kernel: ata10.00: 1953525168 sectors, mult=
i
0: LBA48 NCQ (depth 31/32), AA
=46eb  7 10:37:07 dobbelherz kernel: ata10.00: configured for UDMA/133
=46eb  7 10:37:07 dobbelherz kernel: scsi 9:0:0:0: Direct-Access   =20
ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
=46eb  7 10:37:07 dobbelherz kernel: sd 9:0:0:0: Attached scsi generic =
sg4
type 0
=46eb  7 10:37:07 dobbelherz kernel: sd 9:0:0:0: [sdd] 1953525168 512-b=
yte
logical blocks: (1.00 TB/931 GiB)
=46eb  7 10:37:07 dobbelherz kernel: sd 9:0:0:0: [sdd] Write Protect is=
 off
=46eb  7 10:37:07 dobbelherz kernel: sd 9:0:0:0: [sdd] Mode Sense: 00 3=
a 00 00
=46eb  7 10:37:07 dobbelherz kernel: sd 9:0:0:0: [sdd] Write cache:
enabled, read cache: enabled, doesn't support DPO or FUA
=46eb  7 10:37:07 dobbelherz kernel: sdd: unknown partition table
=46eb  7 10:37:07 dobbelherz kernel: sd 9:0:0:0: [sdd] Attached SCSI di=
sk
=46eb  7 10:38:05 dobbelherz kernel: ata10.00: exception Emask 0x0 SAct
0x0 SErr 0x0 action 0x6 frozen
=46eb  7 10:38:05 dobbelherz kernel: ata10.00: failed command: SECURITY
ERASE UNIT
=46eb  7 10:38:05 dobbelherz kernel: ata10.00: cmd
f4/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 out
=46eb  7 10:38:05 dobbelherz kernel: res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
=46eb  7 10:38:05 dobbelherz kernel: ata10.00: status: { DRDY }
=46eb  7 10:38:05 dobbelherz kernel: ata10: hard resetting link
=46eb  7 10:38:15 dobbelherz kernel: ata10: softreset failed (device no=
t
ready)
=46eb  7 10:38:15 dobbelherz kernel: ata10: hard resetting link
=46eb  7 10:38:25 dobbelherz kernel: ata10: softreset failed (device no=
t
ready)
=46eb  7 10:38:25 dobbelherz kernel: ata10: hard resetting link
=46eb  7 10:38:35 dobbelherz kernel: ata10: link is slow to respond,
please be patient (ready=3D0)
=46eb  7 10:39:00 dobbelherz kernel: ata10: softreset failed (device no=
t
ready)
=46eb  7 10:39:00 dobbelherz kernel: ata10: limiting SATA link speed to
1.5 Gbps
=46eb  7 10:39:00 dobbelherz kernel: ata10: hard resetting link
=46eb  7 10:39:05 dobbelherz kernel: ata10: softreset failed (device no=
t
ready)
=46eb  7 10:39:05 dobbelherz kernel: ata10: reset failed, giving up
=46eb  7 10:39:05 dobbelherz kernel: ata10.00: disabled
=46eb  7 10:39:05 dobbelherz kernel: ata10: EH complete
--> at this point obviously a SCSI_INQUIRY returned bad data, else my
program would have sent ATA_IDENTIFY_DEVICE instead of SCSI_READ_CAPACI=
TY.
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] READ CAPACITY(16=
)
failed
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] Result:
hostbyte=3D0x04 driverbyte=3D0x00
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] Sense not availa=
ble.
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] READ CAPACITY fa=
iled
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] Result:
hostbyte=3D0x04 driverbyte=3D0x00
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] Sense not availa=
ble.
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] Asking for cache
data failed
=46eb  7 10:39:05 dobbelherz kernel: sd 9:0:0:0: [sdd] Assuming drive
cache: write through
=46eb  7 10:39:05 dobbelherz kernel: sdd: detected capacity change from
1000204886016 to 0

All the best,
Stefan H=FCbner
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
