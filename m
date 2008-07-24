From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 00/14] open-osd: OSD Initiator library for Linux
Date: Thu, 24 Jul 2008 20:30:35 +0300
Message-ID: <4888BC3B.1050406@panasas.com>
References: <48876009.8010701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20030 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbYGXRcQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:32:16 -0400
In-Reply-To: <48876009.8010701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@i>


Submitted for review and discussion, an in-kernel OSD initiator
library. Its main users are planned to be various OSD based file
systems and most importantly the pNFS-Objects Layout Driver.
 
To try out and run the library please visit
http://open-osd.org and follow the instructions there.

The submitted patchset is also available via git at:
   git://git.open-osd.org/open-osd.git osd-dev
   http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=osd-dev

Or a compact out-of-tree repository that includes sources 
and some extras:
   git://git.open-osd.org/osd-lib.git master
   http://git.open-osd.org/gitweb.cgi?p=osd-lib.git;a=summary

The submitted patches adds public header files to include/scsi/
for use by other subsystems. The source files and private headers 
are put at a new drivers/scsi/osd/ directory, with the privilege of
a separate Makefile and Kconfig.

here is the list of patches:

[PATCH 01/14] libosd: OSDv1 Headers
[PATCH 02/14] libosd: OSDv1 preliminary implementation
  Most basic, but usable library module (libosd.ko) including Makefile

[PATCH 03/14] osd_uld: OSD scsi ULD
[PATCH 04/14] osd_ktests: Add basic OSD tests
  The ULD and testing framework are orthogonal to the osd
  initiator library.  They are included in this patchset 
  mainly as a reference example for using the library
  and are not necessary candidates for inclusion into
  the kernel (although it will be very nice to have them
  there for everybody's benefit).  However, with out an OSD ULD,
  kernel users of the OSD initiator library (e.g. the pnfs-obj
  layout driver, or an OSD-based file system) will require
  an exported API function from the sg driver to be able to
  hook-up with the respective scsi_device.

[PATCH 05/14] libosd: attributes Support
[PATCH 06/14] osd_ktests: Test Attribute lists
  At this point there is enough functionality to be able to port IBM's OSDFS 
  project from sourceforge, to our initiator.
 
[PATCH 07/14] libosd: OSD Security processing stubs
[PATCH 08/14] libosd: Add Flush and List-objects support
[PATCH 09/14] libosd: Not implemented commands
[PATCH 10/14] libosd: OSD version 2 Support
[PATCH 11/14] osd_ktests: OSDv2 auto detection
  Misc additions and OSD2 support.

[PATCH 12/14] osd: Kconfig file for in-tree builds
[PATCH 13/14] osd: Documentation for OSD library
[PATCH 14/14] scsi: Add osd library to build system
  Up to the last patch it was only compilable from out-of-tree builds.
  Here a Kconfig is added and if enabled will be built from the Kernel
  Main Makefile.
 
Mostly missing from this body of work is the user-mode API and OSD 
functionality. We believe there are possible solutions for that, but this
is out of scope for this review. We would like to focus on the In-Kernel
API and users for now.

We invite everybody to comment, ask questions, and review the submitted
work and help us make it better, so it can be accepted into the Kernel.

Thanks
open-osd team


