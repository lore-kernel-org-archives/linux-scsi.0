From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH][REPOST] FC Transport support for vports based on NPIV
Date: Fri, 27 Apr 2007 12:34:04 -0400
Message-ID: <1177691644.26084.11.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61737 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbXD0PQr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2007 11:16:47 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3RFGkIa026260
	for <linux-scsi@vger.kernel.org>; Fri, 27 Apr 2007 08:16:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The repost does not change anything. It simply updates the patch so
it can be applied cleanly after the "make all rports wait dev_loss_tmo"
patch which was just posted.

------

This patch provides support for FC virtual ports based on NPIV.
For information on the interfaces and design, please read the
Documentation/scsi/scsi_fc_transport.txt file enclosed within
the patch.

The RFC was originally posted here:
http://marc.info/?l=linux-scsi&m=117226959918393&w=2

Changes from the initial RFC:
- Bug fix: needed a transport_class_unregister() for the vport class
- Create a symlink to the vport in the shost device if it is not the
    parent of the vport.
- Made symbolic name writable so it can be set after creation
- Made the temporary fc_vport_identifiers struct private to the
transport.
- Deleted the vport_id field from the vport. I couldn't find any good
  use for it (and symname is a good replacement).
- Made the vport_state and vport_last_state "private" attributes.
  Added the fc_vport_set_state() helper function to manage state
  transitions
- Updated vport_create() to allow a vport to be created in a disabled
  state.
- Added INITIALIZING and FAILED vport states
- Added VPCERR_xxx defines for errors to be returned from vport_create()
- Created a Documentation/scsi/scsi_fc_transport.txt file that describes
  the interfaces and expected LLDD behaviors. 

-- james


Signed-off-by: James Smart <James.Smart@emulex.com>



