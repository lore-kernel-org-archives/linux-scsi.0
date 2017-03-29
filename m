From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] scsi: sas: flush destruct workqueue on device
 unregister
Date: Wed, 29 Mar 2017 14:26:31 +0200
Message-ID: <20170329122630.GD9183@linux-x5ow.site>
References: <cover.1490775958.git.jthumshirn@suse.de>
 <9580eaf323f5da17dcace9e32b22a1df4099961d.1490775958.git.jthumshirn@suse.de>
 <02778435-6c67-0ac9-2faa-03ebb7934477@huawei.com>
 <20170329112922.GB9183@linux-x5ow.site>
 <343ddf8b-70e0-32f8-6ab8-31479729f827@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932132AbdC2M0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 08:26:35 -0400
Content-Disposition: inline
In-Reply-To: <343ddf8b-70e0-32f8-6ab8-31479729f827@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, Dan Williams <dan.j.williams@intel.com>, Jack Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

On Wed, Mar 29, 2017 at 12:53:28PM +0100, John Garry wrote:
> On 29/03/2017 12:29, Johannes Thumshirn wrote:
> >On Wed, Mar 29, 2017 at 12:15:44PM +0100, John Garry wrote:
> >>On 29/03/2017 10:41, Johannes Thumshirn wrote:
> >>>In the advent of an SAS device unregister we have to wait for all destruct
> >>>works to be done to not accidently delay deletion of a SAS rphy or it's
> >>>children to the point when we're removing the SCSI or SAS hosts.
> >>>
> >>>Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> >>>---
> >>>drivers/scsi/libsas/sas_discover.c | 4 ++++
> >>>1 file changed, 4 insertions(+)
> >>>
> >>>diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> >>>index 60de662..75b18f1 100644
> >>>--- a/drivers/scsi/libsas/sas_discover.c
> >>>+++ b/drivers/scsi/libsas/sas_discover.c
> >>>@@ -382,9 +382,13 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
> >>>	}
> >>>
> >>>	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
> >>>+		struct sas_discovery *disc = &dev->port->disc;
> >>>+		struct sas_work *sw = &disc->disc_work[DISCE_DESTRUCT].work;
> >>>+
> >>>		sas_rphy_unlink(dev->rphy);
> >>>		list_move_tail(&dev->disco_list_node, &port->destroy_list);
> >>>		sas_discover_event(dev->port, DISCE_DESTRUCT);
> >>>+		flush_work(&sw->work);
> >>
> >>I quickly tested plugging out the expander and we never get past this call
> >>to flush - a hang results:
> >
> >Can you activat lockdep so we can see which lock it is that we're blocking on?
> >
> 
> I have it on:
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> 
> >It's most likely in sas_unregister_common_dev() but this function takes two spin
> >locks, port->dev_list_lock and ha->lock.
> >
> 
> We can see from the callstack I provided that we're working in workqueue
> scsi_wq_0 and trying to flush that same queue.

Aaahh, now I get what's happening (with some kicks^Whelp from Hannes I admit).

The sas_unregister_dev() comes from the work queued by notify_phy_event(). So this patch must be
replaced by (untested):

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index cdbb293..e1e6492 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -375,6 +375,7 @@ void sas_remove_children(struct device *dev)
  */
 void sas_remove_host(struct Scsi_Host *shost)
 {
+       scsi_flush_work(shost);
        sas_remove_children(&shost->shost_gendev);
 }
 EXPORT_SYMBOL(sas_remove_host);

John, mind giving that one a shot in your test setup as well?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
