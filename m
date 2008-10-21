From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [BUG] dm-mpath and scsi persistent reservation
Date: Tue, 21 Oct 2008 23:19:10 +0200
Message-ID: <20081021231910.0fdbeb75@plop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:54524 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbYJUW3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 18:29:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, alasdair.kergon@redhat.com
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hi,

the dm-mpath multipathing driver enqueues write ios returned by
the scsi layer with a "reservation conflict" error (on assymetric
storage controllers, like Clariion, where queue_if_no_path is enabled).

This is wrong, and a potent data-corrupter : wio sent to a reserved
scsi device should never be retried on this same device.

Can someone advise on a viable solution for this problem ? I
understand the Device Mapper being a block remapper, it is not expected
to receive scsi errors directly ... but maybe some kind of translation
might be acceptable. Or is there hope in the request-based remapper ?

Jens, James, Alasdair, ... as maintainers of the involved subsystems,
would you care to give some advise on the issue.

Regards,
cvaroqui
