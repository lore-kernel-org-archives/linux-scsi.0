From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/8] Adding support to FCoE transport
Date: Thu, 23 Dec 2010 21:18:21 -0800
Message-ID: <1293167901.4676.459.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2295 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0LXFSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:18:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, yi.zou@intel.com, michaelc@cs.wisc.edu

** These are Yi's patches with checkpatch corrections to 
enable submission of my follow-on patches. **

"As to follow the thread about the RFC patch initially from Bhanu:

http://marc.info/?l=linux-scsi&m=129227626410508&w=2

Here is a set of patches that I cut out for the purpose of kind of proof of
concept thing to seek comments from the community about it this makes or not.
I understand this is the end of the year and I was hoping to get this out
earlier.

The idea was what I described in the above linked thread, we can add a thin
layer of fcoe transport to libfcoe and make existing fcoe.ko as the default
fcoe transport provider, so all vendor specific fcoe hba and plug in as their
own fcoe hba driver, at the same time, we can keep the common user space
interface in libfcoe module parameters for all related sysfs entry points to
continue use the Open-FCoE's fcoe-utils utility tools with full support to DCB
as well.

These patches are touch tested, I did some basic i/o using the converted
fcoe.ko, I was going to take Bhanu's last patch to show case the use of this
but did not get time to do it, but you get the idea. The match() function of
the fcoe_transport() will be vendor specific as it's the vendor driver's job
to check if it wants to support FCoE on the given netdev interface, which may
be by getting the pci device vendor and id info. from the associated pci dev
of that netdev object.

At this point, they are just RFCs, I expect there will be more changes needed
if we are moving forward towards this direction, e.g., I think many codes in
fcoe.c may also be used by any transport provider so can be moved into libfcoe
module as well, and some of the structures in "fcoe.h" may have to moved into the
include/scsi/libfcoe.h in case other vendor drivers want to make use of them."

Bhanu Prakash Gollapudi (8):
  libfcoe: move logging macros into the local libfcoe.h header file
  libfcoe: add fcoe_transport structure defines to
    include/scsi/libfcoe.h
  libfcoe: add implementation to support fcoe transport
  libfcoe: rename libfcoe.c to libfcoe_fip.c for the coming
    libfcoe_transport.c
  libfcoe: remove libfcoe.c, use the same libfcoe_fip.c instead
  libfcoe: include libfcoe_transport.c into kernel libfcoe module
  fcoe: prepare fcoe for using fcoe transport
  fcoe: convert fcoe.ko to become an fcoe transport provider driver

 drivers/scsi/fcoe/Makefile            |    2 +
 drivers/scsi/fcoe/fcoe.c              |  193 +--
 drivers/scsi/fcoe/libfcoe.c           |   22 +-
 drivers/scsi/fcoe/libfcoe.h           |   31 +
 drivers/scsi/fcoe/libfcoe_fip.c       | 2682 +++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/libfcoe_transport.c |  421 ++++++
 include/scsi/libfcoe.h                |   37 +
 7 files changed, 3246 insertions(+), 142 deletions(-)
 create mode 100644 drivers/scsi/fcoe/libfcoe.h
 create mode 100644 drivers/scsi/fcoe/libfcoe_fip.c
 create mode 100644 drivers/scsi/fcoe/libfcoe_transport.c




