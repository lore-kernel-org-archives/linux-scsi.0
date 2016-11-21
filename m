From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/2] hpsa: destroy sas transport properties before
 scsi_host
Date: Mon, 21 Nov 2016 15:14:41 +0100
Message-ID: <20161121141441.rljdubw2rcmrl43v@linux-x5ow.site>
References: <20161121140429.12788-1-mwilck@suse.de>
 <20161121140429.12788-3-mwilck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753075AbcKUOOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 09:14:44 -0500
Content-Disposition: inline
In-Reply-To: <20161121140429.12788-3-mwilck@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.de>
Cc: don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de

On Mon, Nov 21, 2016 at 03:04:29PM +0100, Martin Wilck wrote:
> Unloading the hpsa driver causes warnings
> 
> [ 1063.793652] WARNING: CPU: 1 PID: 4850 at ../fs/sysfs/group.c:237 device_del+0x54/0x240()
> [ 1063.793659] sysfs group ffffffff81cf21a0 not found for kobject 'port-2:0'
> 
> with two different stacks:
> 1)
> [ 1063.793774]  [<ffffffff81448af4>] device_del+0x54/0x240
> [ 1063.793780]  [<ffffffff8145178a>] transport_remove_classdev+0x4a/0x60
> [ 1063.793784]  [<ffffffff81451216>] attribute_container_device_trigger+0xa6/0xb0
> [ 1063.793802]  [<ffffffffa0105d46>] sas_port_delete+0x126/0x160 [scsi_transport_sas]
> [ 1063.793819]  [<ffffffffa036ebcc>] hpsa_free_sas_port+0x3c/0x70 [hpsa]
> 
> 2)
> [ 1063.797103]  [<ffffffff81448af4>] device_del+0x54/0x240
> [ 1063.797118]  [<ffffffffa0105d4e>] sas_port_delete+0x12e/0x160 [scsi_transport_sas]
> [ 1063.797134]  [<ffffffffa036ebcc>] hpsa_free_sas_port+0x3c/0x70 [hpsa]
> 
> This is caused by the fact that host device hostX is deleted before the
> SAS transport devices hostX/port-a:b.
> 
> This patch fixes this by reverting the order of device deletions.
> 
> References: bsc#1010946
> Signed-off-by: Martin Wilck <mwilck@suse.de>
> ---

With the References changed to the bug link like in patch 1/2 
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
