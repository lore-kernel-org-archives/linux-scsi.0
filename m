From: Gioele Barabucci <dev@gioelebarabucci.com>
Subject: [IDE-SCSI]problems with ioctl CDROM_DRIVE_STATUS
Date: Mon, 22 Apr 2002 19:35:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204221935.14365.dev@gioelebarabucci.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

this simple piece of code

#define ALREADY_OPEN (ioctl(cdfd, CDROM_DRIVE_STATUS) == CDS_TRAY_OPEN)
int main() {
	int cdfd;
	int eject_or_close;

	cdfd = open("/dev/cdrom", O_RDONLY | O_NONBLOCK);
	eject_or_close =
	    ALREADY_OPEN ? CDROMCLOSETRAY : CDROMEJECT;
	ioctl(cdfd, eject_or_close);
	close(cdfd);

	return 0;
}

does not work because the ioctl always returns CDS_TRAY_OPEN, also when the 
tray is closed!

details:
kernel version: 2.4.18 vanilla
modules loaded:
  ide-scsi                7280   0 (autoclean)
  sr_mod                 12848   0 (autoclean)
  scsi_mod               50560   2 (autoclean) [ide-scsi sr_mod]
  cdrom                  26880   0 (autoclean) [sr_mod]

$ cat /proc/ide/drivers
ide-scsi version 0.9
ide-disk version 1.10

files in /proc/ide/ide1/hdd:

capacity:
2147483647

driver:
ide-scsi version 0.9

identify:
8580 0000 0000 0000 0000 0000 0000 0000
0000 0000 3456 4f32 3139 3834 3931 3733
3838 3130 3032 3130 0000 1e78 0000 563a
3030 332e 3031 4944 452d 4344 2020 5265
5772 6974 6162 6c65 2d32 7832 7836 2020
2020 2020 2020 2020 2020 2020 2020 0000
0000 0b00 0000 0200 0200 0002 0000 0000
0000 0000 0000 0000 0000 0000 0007 0203
0001 007f 007f 00d0 007f 0000 0000 0000
0000 0000 0000 0000 0000 0000 0000 0000
[ other 23 lines of zeroes ]

media:
cdrom

model:
IDE-CD ReWritable-2x2x6

settings:
name                    value           min             max             mode
----                    -----           ---             ---             ----
bios_cyl                0               0               1023            rw
bios_head               0               0               255             rw
bios_sect               0               0               63              rw
current_speed           33              0               69              rw
ide_scsi                0               0               1               rw
init_speed              33              0               69              rw
io_32bit                0               0               3               rw
keepsettings            0               0               1               rw
log                     0               0               1               rw
nice1                   1               0               1               rw
number                  3               0               3               rw
pio_mode                write-only      0               255             w
slow                    0               0               1               rw
transform               1               0               3               rw
unmaskirq               0               0               1               rw
using_dma               1               0               1               rw

