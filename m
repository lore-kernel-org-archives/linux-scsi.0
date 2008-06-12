From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Open-FCoE Second Re-Architecture Status
Date: Thu, 12 Jun 2008 08:55:00 -0700
Message-ID: <10A7D0016239E24092DEF05CCC582E4303E3D313@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbYFLPzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2008 11:55:48 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everybody,

	We're continuing to change the Open-FCoE code to better fit into
the kernel. We've made some more significant progress. I'd say the theme
of this update is code removal. Since we started the re-architecture
we've removed 4,205 lines of code.


	The major changes we've made since the last update are-

1) Removal of all ioctl()s
	- ioctl()s to the previously named openfc and fcoe modules have
been completely removed.
	- echo "ethX" > /sys/module/fcoe/create 
		Creates a fcoe instance for that device and starts
fabric login.
	- echo "ethX" > /sys/module/fcoe/destroy
		Removes the fcoe instance
	- fcconf userspace application no longer works at all
	- Attributes to scsi_host will be needed to re-enable this
application, but those changes are a lower priority than the overall
re-architecture.

2) Consolidation of fc_remote_port and fc_sess.
	- fc_sess has been removed and the fc_lport now just has a list
of fc_remote_ports.
	- This is a step towards use of the fc_rport provided by
scsi_transport_fc.

3) Removal of all events.
	- Previously had events queued and various listeners who would
drive state changes. It was all unnecessary and a bit too complicated.
Now all calls are direct.
	- This was a large reduction in code size.

4) Use of our new Exchange Manager (EM) API.
	- Previously we had added the new API; now we're mostly using
it.
	- There are a few areas in the code have not converted to the
new API and that work is underway.

5) Removal of CRC32 Slice-by-8 Algorithm.
	- This is an alternative CRC32 calculation method that uses a
larger polynomial table and is faster. 
	- We believe that we will need this algorithm for performance,
but have decided to make that change later after the basic libfc/FCoE
code is accepted into the kernel.

6) Userspace/Kernel Reduction.
	- Removal of /sys/class/openfc attributes
	- Removal of events from kernel to userspace

7) Caught up with the kernel.
	- Rebased to 2.6.26 scsi-rc-fixes tree.
	- Made necessary changes to remove device classes.


	Kernel code URL-

git://open-fcoe.org/rearch/open-fcoe-upstream


	Things to keep in mind if viewing the code-

1) The code is a bit sloppy. We're focusing on the heavy lifting and a
polish phase will be needed later.

2) We've broken the code. The goal is to never put patches in that break
the tree, but we've broken it once or twice inadvertently, so if you
pull and test the tree, please keep that in mind.

3) We're mostly testing against a FC fabric and aren't focusing on the
SW target. In fact, we now know there is a bug in the initiator that
causes problems in P2P connections.

4) fcconf is replaced with /sys/module/fcoe/create and
/sys/module/fcoe/destroy.

	After we're happy with our re-architecture, we'll roll all of
the contributions into one big patch and apply it to our primary
development tree on www.Open-FCoE.org.

	As per usual, any comments are welcome.

Thanks,

//Rob, Vasu, Chris, Steve, Yi
Open-FCoE
