From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Open-FCoE Re-architecture Status
Date: Mon, 12 May 2008 17:47:23 -0700
Message-ID: <10A7D0016239E24092DEF05CCC582E43039F5DA0@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbYEMAsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 20:48:12 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: devel@open-fcoe.org

Hello everybody,

	After a lot of planning and designing we've started to
reorganize the Open-FCoE kernel code. The organization will be as
discussed previously. We're converting our OpenFC subsystem into libfc-
a FC assist library. Refer to
http://open-fcoe.org/openfc/images/open-fcoe_layers_overview.jpeg for a
block diagram of the desired libfc end result. 

	We've made good progress and I'd like to share what we've done
as well as provide a git URL so that others can look at where we're at
now. Overall, I think that all of the developers working on the
re-architecture are happy with these changes. They make sense and we've
really been able to hack out a lot of redundancy and unnecessary code
which will make this code/project a lot easier to maintain in the long
run. There is still plenty of work to be done, so we are not claiming
completeness even in the areas listed below.

	The major changes that we've made so far are-

1) fcoe is now the LLD to SCSI and registers as a transport for
scsi_transport_fc.
	- Previously we had an openfc layer between SCSI and fcoe.
openfc is essentially being converted to libfc and a big step towards
that effort is the creation of the Scsi_Host and fc_function_template in
fcoe, not in openfc.
	* Look at fcoe_create_interface() within
drivers/scsi/fcoe/fcoe_if.c.

2) The new Exchange Manager (EM) interfaces are in place.
	- We've changed our EM to work with our fc_transport_template.
They're currently only used a little, but over the next few weeks we
will migrate to using them exclusively.
	* Look at include/scsi/libfc/libfc.h
	* Look at drivers/scsi/libfc/fc_exch.c

3) Massive consolidation of per-instance structures.
	- We're converging to fc_lport as the main per-instance
structure. We've moved our openfc_softc, fc_local_port and fcs_state
structures into fc_lport. Through this we've consolidated some fields
and will need to do more.
	* Look at include/scsi/libfc/libfc.h

4) Reorganization.
	- include/scsi/fc/ - FC specification header files.
	- include/scsi/libfc/ - libfc header files.
	- drivers/scsi/libfc/ - The libfc implementation.
	- drivers/scsi/fcoe/ - The fcoe implementation.

5) fc_transport_template
	- This is the structure of function pointers that determines who
does what between the fcoe LLD and libfc. This is implemented and being
initialized, but not used yet.
	* Look at include/scsi/libfc/libfc.h

6) fc_frame as a sk_buff
	* Look at include/scsi/libfc/fc_frame.h
	* Look at drivers/scsi/libfc/fc_frame.c

7) General cleanup of unnecessary code
	- This includes the removal of function pointers that were only
ever set to one function implementation and the removal of the inner and
outer port concepts.


	Kernel code URL-

git://open-fcoe.org/rearch/open-fcoe-upstream


	Userspace code URL (no changes yet)-

git://open-fcoe.org/rearch/open-fcoe


	Things to keep in mind if viewing the code-

1) The code is a bit sloppy. We're focusing on the heavy lifting and a
polish phase will be needed later.

2) We've broken the code. The goal is to never put patches in that break
the tree, but we've broken it once or twice inadvertently, so if you
pull and test the tree, please keep that in mind.

3) We're mostly testing against a FC fabric and aren't focusing on the
SW target.

4) We currently haven't changed any kernel/userspace APIs so there is no
need to re-pull the application repository (open-fcoe) now. However, I
imagine we will be making changes there as we want to remove as many
ioctl()s as possible and replace them with sysfs reads/writes, so if you
really want to play with what we're doing you'll need to monitor both
repositories.

	After we're happy with our re-architecture, we'll roll all of
the contributions into one big patch and apply it to our primary
development tree on www.Open-FCoE.org.

	As per usual, any comments are welcome.

Thanks,

//Rob, Vasu, Chris, Steve, Yi
Open-FCoE
