From: michaelc@cs.wisc.edu
Subject: fast fail improvements (take 2)
Date: Tue, 19 Aug 2008 18:18:56 -0500
Message-ID: <1219187946-4897-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38111 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYHSXTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:19:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

The following patches were made over scsi-misc, and are basically
a resend of this patchset:
http://marc.info/?l=linux-scsi&m=121263014808604&w=2
http://marc.info/?l=linux-scsi&m=121263014908607&w=2
http://marc.info/?l=linux-scsi&m=121263014908610&w=2
http://marc.info/?l=linux-scsi&m=121263015008613&w=2
http://marc.info/?l=linux-scsi&m=121263015108620&w=2
http://marc.info/?l=linux-scsi&m=121263015008616&w=2
http://marc.info/?l=linux-scsi&m=121263015208626&w=2
http://marc.info/?l=linux-scsi&m=121263015108623&w=2 
and this one
http://marc.info/?l=linux-scsi&m=121583046130743&w=2
but I handled James's comment and fixed up
the patches that split up the fast fail bits.

The first two patches
0001-fc-class-unblock-target-after-calling-terminate-cal.patch
0002-fc-drivers-remove-scsi_target_unblock-calls-in-term.patch
have been reviewed and acked by JamesS and are safe enough
for scsi-misc. These are the same patches are here
http://marc.info/?l=linux-scsi&m=121583046130743&w=2
but I fixed up the state setting per JamesS's comment.


The next patches are safe enough for scsi-misc.
0003-scsi-add-transport-host-byte-errors-v3.patch
0004-iscsi-class-libiscsi-and-qla4xxx-convert-to-new-tr.patch
0005-fc-class-Add-support-for-new-transport-errors.patch
0006-lpfc-start-to-use-new-trasnport-errors.patch
0007-qla2xxx-use-new-host-byte-transport-errors.patch
The fc class ones was reviewed and Acked by JamesS.
The iscsi ones are ok. The qlogic one is just missing
a review and ACK.


The patches above can go in without the bottom two. But
eventually something like these two would be helpful,
so if they are not mergable then hopefully we can
figure something out that is better.

These patches split up the req and  bio fastfail into
multiple bits, so the upper layer can only ask that certain
types of errors be failed:
0008-block-separate-failfast-into-multiple-bits.patch
0009-scsi-modify-scsi-to-handle-new-fail-fast-flags.patch



