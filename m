From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Date: Mon, 22 Dec 2008 14:32:00 +0200
Message-ID: <494F88C0.4070507@panasas.com>
References: <48876009.8010701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:6890 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994AbYLVMcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Dec 2008 07:32:08 -0500
In-Reply-To: <48876009.8010701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-s
Cc: linux-kernel <linux-kernel@vger.kernel.org>

OSD (Object-Based Storage Device) is a T10 SCSI command set that is designed
to provide efficient operation of input/output logical units that manage the
allocation, placement, and accessing of variable-size data-storage containers,
called objects. Objects are intended to contain operating system and application
constructs. Each object has associated attributes attached to it, which are
integral part of the object and provide metadata about the object. The standard
defines some common obligatory attributes, but user attributes can be added as
needed.

Whats new from last time:
- sitting in linux-next exposed some warnings in some ARCHs, (you guessed right
  printf of u64 types)
- Removed the user-mode osd_test application, this can be fetched from the
  out-of-tree git.
- Added implementation of, scsi-descriptor based, OSD sense buffer decoding.
  (See [PATCH 15/18])

The patches are cut over scsi-misc but apply cleanly over linus-2.6.28-rc9
and are intended for the 2.6.29 merge window.

To try out and run the library please visit
http://open-osd.org and follow the instructions there.

The submitted patchset is also available via git at:
   git://git.open-osd.org/linux-open-osd.git osd
   http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd

Or a compact out-of-tree repository that includes these patches 
plus some extras:
   git://git.open-osd.org/open-osd.git master
   http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary

here is the list of patches:

[PATCH 01/18] major.h: char-major number for OSD device driver
  Request for a new char-device major number

[PATCH 02/18] scsi: OSD_TYPE
  The OSD scsi type constant definition.

[PATCH 03/18] libosd: OSDv1 Headers
[PATCH 04/18] libosd: OSDv1 preliminary implementation
  Most basic, but usable library module (libosd.ko) including
  Kbuild file.

[PATCH 05/18] osd_uld: OSD scsi ULD
[PATCH 06/18] osd_uld: API for retrieving osd devices from Kernel
[PATCH 07/18] osd_ktests: Add basic OSD tests
  These patches add a scsi ULD for OSD type devices. Please see
  commit logs for details.

[PATCH 08/18] libosd: attributes Support
[PATCH 09/18] osd_ktests: Test Attribute lists
[PATCH 10/18] libosd: OSD Security processing stubs
[PATCH 12/18] libosd: Add Flush and List-objects support
[PATCH 12/18] libosd: Not implemented commands
[PATCH 13/18] libosd: OSD version 2 Support
[PATCH 14/18] libosd: OSDv2 auto detection
[PATCH 15/18] libosd: SCSI/OSD Sense decoding support
  Up to here this is a fairly complete body of work, to support
  both OSD1 and OSD2 targets. Main pieces that are still missing
  from the library at this point are: The OSD2 capabilities structure,
  do to lack of an OSD target that supports it, so it was never tested.
  And the absence of any OSD-security methods other then NO_SECURITY.
  These will come in future versions.

[PATCH 16/18] osd: Documentation for OSD library
  Some reading about OSD in general and further usability instructions.
  Please comment on anything missing from this document.

[PATCH 17/18] osd: Kconfig file for in-tree builds
[PATCH 18/18] scsi: Add osd library to build system
  The in-tree compilation is only enabled at the end of the patchset.
  Run your favorite configure-tool to enable the library and osd_uld
  compilation. Default is off.
  The patchset is however fully bisectable, and compilable from the beginning,
  (by applying these 2 patches first).

Boaz Harrosh
