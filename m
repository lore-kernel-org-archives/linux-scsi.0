From: michaelc@cs.wisc.edu
Subject: block and scsi fail fast fixes
Date: Wed,  4 Jun 2008 20:41:39 -0500
Message-ID: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbYFEBlv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2008 21:41:51 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m551fogc013328
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jun 2008 21:41:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org

The following patches fix two problems I have been seeing in Red Hat
bugzillas. The patches are made over scsi-misc, but except for
0006-block-and-drivers-separate-failfast-into-multiple-b.patch
they could also apply over scsi-rc-fixes or linus's tree.
0006-block-and-drivers-separate-failfast-into-multiple-b.patch has a patch
to convert the scsi dh modules so that is why it does not apply to
the other kernels.

The first problem is that when a transport problem is detected and
the classes/drivers block the scsi_devices, there is IO in the driver
and IO in the scsi_device queues. For fibre we have the fast IO fail
tmo infrastructure to allow us to get IO in the driver up to multipath,
but IO in the queues remains until the dev_loss_tmo fires. The
difference between the timers can be minutes, so it looks like hang to
the application. iSCSI has something similar to FC's fast io fail
tmo, but it is called the replacment timeout. With this we will fail
all IO that is in the driver or queued or any incoming IO.

The first 5 patches try to provide common behavior:
0001-scsi-add-transport-host-byte-errors-v2.patch
0002-iscsi-class-libiscsi-and-qla4xxx-convert-to-new-tr.patch
0003-fc-class-Add-support-for-new-transport-errors.patch
0004-qla2xxx-use-new-host-byte-transport-errors.patch
0005-lpfc-start-to-use-new-trasnport-errors.patch

Basically, when we block a device we fail IO with DID_TRANSPORT_DISRUPTED.
When the fast io transport timer fires we fail IO with DID_TRANSPORT_FAILFAST.

I converted qla2xxx and tried to convert lpfc (I was not sure about
some of the errors). zfcp and mpt need to be converted, but it looked
like they would be ok with the patches below. I could only test qla2xxx
and lpfc though.


The second problem is that multipath is not really good at handling a lot
of errors. It just retries all errors on a different path, so for transport
errors it makes a lot of sense to send them up to us pretty quickly. But
device errors or driver errors or weird ones inbetween the scsi layer is
better at handling them because the multipath layer does not know anything
about scsi details.

The patches:
0006-block-and-drivers-separate-failfast-into-multiple-b.patch
0007-scsi-Support-fail-fast-bits.patch

are really simple and just break up the FAILFAST bits into device, driver
and transport bits, so the upper layer can ask the lower layers to only
fail fast certain types of errors. For multipath we only set the transport
fail fast bit, and I thought in the future maybe something like RAID
would set the device failfast error and not want transport errors failed
fast to it.



