From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [announce] scsi_id release 0.2
Date: Fri, 5 Dec 2003 15:18:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031205151810.A8891@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:34504 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S264867AbTLEXSX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 18:18:23 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

Version 0.2 of scsi_id is available at:

http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.2.tar.gz

scsi_id is a program to generate a SCSI unique identifier for a given SCSI
device.

It is primarily for use with udev callout config entries. It can also be
used for automatic multi-path configuration or device mapper
configuration.

Requires:

- Linux kernel 2.6

- libsysfs 0.3.0

To use with udev, in short:

Run scsi_id to dump determine the id, for example, for sda, run:

	/sbin/scsi_id -s /block/sda

Take the resulting value (including white space) and use it as the ID in a
udev CALLOUT entry, an example /etc/udev/udev.rules entry for one of
my disk drives:

CALLOUT, BUS="scsi", PROGRAM="/sbin/scsi_id", ID="200609487340c78ac", NAME="diskf1"

Major changes since the last release:

	- builds under udev and klibc (I'll post udev/Makefile changes I
	  needed to get the build to work), does not build properly for
	  udev without klibc because of sysfsutils include paths issue

	- fix a bug with config file options parsing not allocating space

	- added a man page

Full list of changes:

	* Add a man page.

	* Set and use variables that might be passed down when
	  built under udev (with or without klibc), don't set LDFLAGS or
	  STRIP.

	* scsi_id.c, scsi_id.h: Fix a bad bug - when parsing file options,
	  no space was allocated for the creation of the new argv[]
	  strings.

	* scsi_id.c: Catch too long a line in the config file.

	* scsi_id.h: Add u8 typedef to avoid ummm scsi.h kernel header
	  problem when built with klibc.

	* scsi_id.h: Add define of makedev() if built with klibc.

	* scsi_id.c: reset optind to 1 since klibc does not work if it is
	  reset to zero.

	* scsi_id.c: remove fflush() as it is not needed, and is not
	  supported by klibc.

	* scsi_serial.c: Make the functions do_scsi_page0_inquiry and
	  do_scsi_page80_inquiry static.

	* scsi_id.c: Don't use syslog LOG_PID, as it is not supported by
	  klibc.

	* scsi_id.c, scsi_serial.c: Hack - change include path to libsysfs
	  if built under klibc.

	* Makefile: Use "override" for CFLAGS so we can pass CFLAGS values
	  down when built with udev

	* scsi_id.c, Makefile: Use SCSI_ID_VERSION instead of VERSION.

	* scsi_id.c: Remove getopt_long (long option names), as there
	  is no support for that in klibc.

	* scsi_id.c: Patch from Brian King <brking@us.ibm.com>: check
	  result of setting model, not vendor in per_dev_options.

	* scsi_id.c, scsi_serial.c: Use new and correct path to libsysfs.h.

	* scsi_id.h: Fix scsi_id.h so var args in macros works ok with
	  older gcc.

Please email me any questions, comments or patches.

Thanks!

-- Patrick Mansfield
