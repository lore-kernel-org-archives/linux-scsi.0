From: michaelc@cs.wisc.edu
Subject: fc class: terminate callback fixes
Date: Fri, 11 Jul 2008 21:40:39 -0500
Message-ID: <1215830441-20259-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYGLCkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 22:40:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

This fixes the problems discussed in this thread:
http://marc.info/?l=linux-scsi&m=121573444523292&w=2
where we need to call scsi_target_unblock in the code
path where the terminate call back is used. The unblock calls is
need so that IO does not get stuck when removing the rport. And for
the fast IO fail case, I merged the patch to fast fail
IO so it does not bounce around between the queue
and driver and is returned to the upper layer quickly.
These patch then solve all the issues and fix the problem
for drivers that were not implementing the callback.

The patches were made over scsi-misc and the qlogic update
in that thread.



