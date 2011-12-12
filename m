From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Mon, 12 Dec 2011 13:39:46 +0100
Message-ID: <20111212123946.GA2307@osiris.boeblingen.de.ibm.com>
References: <1320057746.2964.1.camel@dabdike>
 <4EAE8A7E.8000504@ce.jp.nec.com>
 <20111031130004.GB4768@osiris.boeblingen.de.ibm.com>
 <20111103182548.GA12131@redhat.com>
 <20111104091936.GB2397@osiris.boeblingen.de.ibm.com>
 <4EBA49C2.1000704@suse.de>
 <20111110161008.GA15659@osiris.boeblingen.de.ibm.com>
 <20111117162919.GA3812@redhat.com>
 <20111129120047.GA2456@osiris.boeblingen.de.ibm.com>
 <20111129201803.GB6827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:41969 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1LLMj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2011 07:39:57 -0500
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Mon, 12 Dec 2011 12:39:53 -0000
Content-Disposition: inline
In-Reply-To: <20111129201803.GB6827@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>, gmuelas@de.ibm.com, dm-devel@redhat.com

On Tue, Nov 29, 2011 at 03:18:03PM -0500, Mike Snitzer wrote:
> On Tue, Nov 29 2011 at  7:00am -0500,
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > [ 4906.683654] Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
> 
> ...
> 
> > Gonzalo also tried 2.6.38.8 as suggested and ran into this one:
> > 
> > [  292.877936] ------------[ cut here ]------------
> > [  292.877939] Kernel BUG at 6b6b6b6b6b6b6b6d [verbose debug info unavailable]
> 
> Again, more poison.
> 
> Seems this test is causing us to fall on our face no matter what.
> Likely, best to leave this 2.6.38 blk_unplug crash to one side and
> continue focusing on latest upstream.

Sorry again, for taking so long to come back. This time however with good news:

With 3.2.0-rc4.00255.g77a7300 we were unable to reproduce any I/O stall or
user-after-free bugs even after nearly 3000 test iterations.

The only patches on top we have are:

two patches from Hannes:
http://www.spinics.net/lists/linux-scsi/msg55112.html
http://www.spinics.net/lists/linux-scsi/msg55413.html

and the patch below from Steffen:

Btw. James, any chance to get this one upstream soon? It should be in your
queue for quite some time already, IIRC.

Subject: [PATCH] zfcp: return early from slave_destroy if slave_alloc returned early

From: Steffen Maier <maier@linux.vnet.ibm.com>

zfcp_scsi_slave_destroy erroneously always tried to finish its task
even if the corresponding previous zfcp_scsi_slave_alloc returned
early. This can lead to kernel page faults on accessing uninitialized
fields of struct zfcp_scsi_dev in zfcp_erp_lun_shutdown_wait. Take the
port field of the struct to determine if slave_alloc returned early.

This zfcp bug is exposed by 4e6c82b (in turn fixing f7c9c6b to be
compatible with 21208ae) which can call slave_destroy for a
corresponding previous slave_alloc that did not finish.

This patch is based on James Bottomley's fix suggestion in
http://www.spinics.net/lists/linux-scsi/msg55449.html.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: <stable@kernel.org> #2.6.38+
---

 drivers/s390/scsi/zfcp_scsi.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2011-12-01 13:08:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2011-12-01 13:08:52.000000000 +0100
@@ -55,6 +55,10 @@ static void zfcp_scsi_slave_destroy(stru
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
+	/* if previous slave_alloc returned early, there is nothing to do */
+	if (!zfcp_sdev->port)
+		return;
+
 	zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
 	put_device(&zfcp_sdev->port->dev);
 }

