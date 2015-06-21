From: Hannes Reinecke <hare@suse.de>
Subject: Re: [for 4.1 PATCH resend] libsas: fix "sysfs group not found" warnings
 at port teardown time
Date: Sun, 21 Jun 2015 16:27:02 +0200
Message-ID: <5586C9B6.1020706@suse.de>
References: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150618032204.29990.87007.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, JBottomley@odin.com, hch@lst.de
Cc: Praveen Murali <pmurali@logicube.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/18/2015 05:22 AM, Dan Williams wrote:
> Praveen reports:
>=20
>     After some debugging this is what I have found
>=20
>     sas_phye_loss_of_signal gets triggered on phy_event from mvsas
>         sas_phye_loss_of_signal calls sas_deform_port
>              sas_deform_port posts a DISCE_DESTRUCT event (sas_unregi=
ster_domain_devices-> sas_unregister_dev)
>              sas_deform_port calls sas_port_delete
>                      sas_port_delete calls sas_port_delete_link
>                              sysfs_remove_group: kobject 'port-X:Y'
>                      sas_port_delete calls device_del
>                              sysfs_remove_group: kobject 'port-X:Y'
>=20
>     sas_destruct_devices gets triggered for the destruct event (DISCE=
_DESTRUCT)
>         sas_destruct_devices calls sas_rphy_delete
>             sas_rphy_delete calls scsi_remove_device
>                  scsi_remove_device calls __scsi_remove_device
>                          __scsi_remove_device calls bsg_unregister_qu=
eue
>                                  bsg_unregister_queue -> device_unreg=
ister -> device_del -> sysfs_remove_group: kobject 'X:0:0:0'
>=20
>     Since X:0:0:0 falls under port-X:Y (which got deleted during
>     sas_port_delete), this call results in the warning. All the later
>     warnings in the dmesg output I sent earlier are trying to delete =
objects
>     under port-X:Y. Since port-X:Y got recursively deleted, all these=
 calls
>     result in warnings. Since, the PHY and DISC events are processed =
in two
>     different work queues (and one triggers the other), is there any =
way
>     other than checking if the object exists in sysfs (in device_del)=
 before
>     deleting?
>=20
>     WARNING: CPU: 2 PID: 6 at fs/sysfs/group.c:219 device_del+0x40/0x=
1c0()
>     sysfs group ffffffff818b97e0 not found for kobject '2:0:4:0'
>     [..]
>     CPU: 2 PID: 6 Comm: kworker/u8:0 Tainted: P        W  O  3.16.7-c=
kt9-logicube-ng.3 #1
>     Hardware name: To be filled by O.E.M. To be filled by O.E.M./VT60=
85, BIOS 4.6.5 01/23/2015
>     Workqueue: scsi_wq_2 sas_destruct_devices [libsas]
>      0000000000000009 ffffffff8151cd18 ffff88011b35bcd8 ffffffff81068=
7b7
>      ffff88011a661400 ffff88011b35bd28 ffff8800c6e5e968 ffff880000028=
810
>      ffff8800c89f2c00 ffffffff8106881c ffffffff81733b68 0000000000000=
028
>     Call Trace:
>      [<ffffffff8151cd18>] ? dump_stack+0x41/0x51
>      [<ffffffff810687b7>] ? warn_slowpath_common+0x77/0x90
>      [<ffffffff8106881c>] ? warn_slowpath_fmt+0x4c/0x50
>      [<ffffffff813ad2d0>] ? device_del+0x40/0x1c0
>      [<ffffffff813ad46a>] ? device_unregister+0x1a/0x70
>      [<ffffffff812a535e>] ? bsg_unregister_queue+0x5e/0xb0
>      [<ffffffffa00781a9>] ? __scsi_remove_device+0xa9/0xd0 [scsi_mod]
>=20
> It appears we've always been double deleting the devices below sas_po=
rt,
> but recent sysfs changes now exposes this problem.  Libsas should del=
ete
> all the devices from rphy down before deleting the parent port.
>=20
> Cc: <stable@vger.kernel.org>
> Reported-by: Praveen Murali <pmurali@logicube.com>
> Tested-by: Praveen Murali <pmurali@logicube.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
