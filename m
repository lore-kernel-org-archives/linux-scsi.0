From: michaelc@cs.wisc.edu
Subject: fast fail improvements (take2)
Date: Tue, 19 Aug 2008 18:45:22 -0500
Message-ID: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbYHSXpm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:45:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

The following patches were made over scsi-misc. They are a resend
of this patchset
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
but I fixed up the bit setting per JamesS's comment,
made sure there were no merge conflicts with the current code
and fixed up the last patches that broke up the fast fail
bits in the block layer.

The patches are supposed to handle the following issues we
have been hitting with multipath.

1. We only have a choice of REQ_FASTFAIL or normal. Different
drivers like multipath only want transport errors (the
scsi dh modules can override for specific device errors), but
today if a LLD feels it should retry a error on the same
path it is overridden due to REQ_FASTFAIL failing all possibley
retrybale errors. This causes premature path failures
and controller switches which can be expensize.

2. When the fast fail tmo fires IO in the blocked queues
are not fast failed. They sit in the queue, so dm-multipath
has to wait for the dev_loss_tmo which is normally in minutes
where the fast io fail tmo is less than 10 seconds.

3. When drivers block the transport object, they end up
returning errors at different times because of the error value
they happened to select. And for these errors
we can use the same error value and implement the same
behavior across drivers so dm-multipath knows what
to expect without know what driver is being used.


------------------------------------------------------------
These first two patches fix #2, by making sure fc fails
blocked when the fast io fail timer runs.
0001-fc-class-unblock-target-after-calling-terminate-cal.patch
0002-fc-drivers-remove-scsi_target_unblock-calls-in-term.patch
They were acked by JamesS on the list, but I rediffed them and
fixed up the bit setting.


----------------------------------------------------------
The next patches fix #3.
0003-scsi-add-transport-host-byte-errors-v3.patch
0004-iscsi-class-libiscsi-and-qla4xxx-convert-to-new-tr.patch
0005-fc-class-Add-support-for-new-transport-errors.patch
0006-lpfc-start-to-use-new-trasnport-errors.patch
0007-qla2xxx-use-new-host-byte-transport-errors.patch
They build on the first two where we implemented the
same fast io fail tmo behavior for iscsi and fc.
For these patches I added two new host byte error
values. The transport classes and drivers can return these
instead of abusing the current ones. They allow the
fc and iscsi class to requeue IO until the fast io fail
or replacement_timeout timers fire.

The fc parts were acked by JamesS. The iscsi parts are ok.
The qla2xxx patch is just missing a review by Andrew.

----------------------------------------------------
The last two patches fix #1.
0008-block-separate-failfast-into-multiple-bits.patch
0009-scsi-modify-scsi-to-handle-new-fail-fast-flags.patch

They do not have to be merged with the above patches, but I
tested them together and combined they fix a lot of issues users
have reported.

In these patches I just split up FASTFAIL into a driver,
device and transport request so the lower levels do
not have to faill all errors quickly.



