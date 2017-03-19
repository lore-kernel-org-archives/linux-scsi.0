From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] libsas: fix "sysfs group not found" warnings at port
 teardown time
Date: Sun, 19 Mar 2017 08:44:38 -0400
Message-ID: <20170319124437.GA15094@linux-x5ow.site>
References: <20150520230012.15322.1013.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751213AbdCSMos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Mar 2017 08:44:48 -0400
Content-Disposition: inline
In-Reply-To: <20150520230012.15322.1013.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James.Bottomley@HansenPartnership.com, hch@lst.de, luis.henriques@canonical.com, Praveen Murali <pmurali@logicube.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, May 20, 2015 at 07:00:53PM -0400, Dan Williams wrote:
> Praveen reports:
> 
>     After some debugging this is what I have found
> 
>     sas_phye_loss_of_signal gets triggered on phy_event from mvsas
>         sas_phye_loss_of_signal calls sas_deform_port
>              sas_deform_port posts a DISCE_DESTRUCT event (sas_unregister_domain_devices-> sas_unregister_dev)
>              sas_deform_port calls sas_port_delete
>                      sas_port_delete calls sas_port_delete_link
>                              sysfs_remove_group: kobject 'port-X:Y'
>                      sas_port_delete calls device_del
>                              sysfs_remove_group: kobject 'port-X:Y'
> 
>     sas_destruct_devices gets triggered for the destruct event (DISCE_DESTRUCT)
>         sas_destruct_devices calls sas_rphy_delete
>             sas_rphy_delete calls scsi_remove_device
>                  scsi_remove_device calls __scsi_remove_device
>                          __scsi_remove_device calls bsg_unregister_queue
>                                  bsg_unregister_queue -> device_unregister -> device_del -> sysfs_remove_group: kobject 'X:0:0:0'
> 
>     Since X:0:0:0 falls under port-X:Y (which got deleted during
>     sas_port_delete), this call results in the warning. All the later
>     warnings in the dmesg output I sent earlier are trying to delete objects
>     under port-X:Y. Since port-X:Y got recursively deleted, all these calls
>     result in warnings. Since, the PHY and DISC events are processed in two
>     different work queues (and one triggers the other), is there any way
>     other than checking if the object exists in sysfs (in device_del) before
>     deleting?
> 
>     ------------[ cut here ]------------
>     WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:219 device_del+0x40/0x1c0()
>     sysfs group ffffffff818b97e0 not found for kobject '2:0:4:0'
>     [..]
>     CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: P        W  O  3.16.7-ckt9-logicube-ng.3 #1
>     Hardware name: To be filled by O.E.M. To be filled by O.E.M./VT6085, BIOS 4.6.5 01/23/2015
>     Workqueue: scsi_wq_2 sas_destruct_devices [libsas]
>      0000000000000009 ffffffff8151cd18 ffff88011b35bcd8 ffffffff810687b7
>      ffff88011a661400 ffff88011b35bd28 ffff8800c6e5e968 ffff880000028810
>      ffff8800c89f2c00 ffffffff8106881c ffffffff81733b68 0000000000000028
>     Call Trace:
>      [<ffffffff8151cd18>] ? dump_stack+0x41/0x51
>      [<ffffffff810687b7>] ? warn_slowpath_common+0x77/0x90
>      [<ffffffff8106881c>] ? warn_slowpath_fmt+0x4c/0x50
>      [<ffffffff813ad2d0>] ? device_del+0x40/0x1c0
>      [<ffffffff813ad46a>] ? device_unregister+0x1a/0x70
>      [<ffffffff812a535e>] ? bsg_unregister_queue+0x5e/0xb0
>      [<ffffffffa00781a9>] ? __scsi_remove_device+0xa9/0xd0 [scsi_mod]
> 
> It appears we've always been double deleting the devices below sas_port,
> but recent sysfs changes now exposes this problem.  Libsas should delete
> all the devices from rphy down before deleting the parent port.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Praveen Murali <pmurali@logicube.com>
> Tested-by: Praveen Murali <pmurali@logicube.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Hi Dan,

JFYI it looks like your patch doesn't completely solve the problem. I can
still trigger this with the following one-liner:

echo 1 > /sys/module/isci/drivers/pci\:isci/0000\:03\:00.0/remove

It's the 'power' sysfs attribute and it happens for SAS port, end_device and
phy.

And as I've seen a report for lpfc as well, I _think_ it is a generic problem
with the SCSI transport classes, not just libsas. Or it could be
scsi_transport_sas and scsi_transport_fc doing nasty things and abuse the
transport class interface.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
