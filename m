From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH v2] libsas: fix "sysfs group not found" warnings at port
 teardown time
Date: Thu, 21 May 2015 08:54:10 +0100
Message-ID: <20150521075410.GA2941@charon>
References: <20150520230012.15322.1013.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbbEUHyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 03:54:20 -0400
Content-Disposition: inline
In-Reply-To: <20150520230012.15322.1013.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: JBottomley@odin.com, hch@lst.de, Praveen Murali <pmurali@logicube.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, May 20, 2015 at 07:00:53PM -0400, Dan Williams wrote:
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
>     ------------[ cut here ]------------
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
> ---
>=20
> v2: drop the "---" separators that will confuse git-am.  Thanks Luis!
>=20

Awesome, thanks a lot!

Cheers,
--
Lu=EDs

>  drivers/scsi/libsas/sas_discover.c |    6 +++---
>  drivers/scsi/libsas/sas_port.c     |    1 -
>  2 files changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas=
/sas_discover.c
> index 60de66252fa2..a4db770fe8b0 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -362,11 +362,14 @@ static void sas_destruct_devices(struct work_st=
ruct *work)
>  	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
> =20
>  	list_for_each_entry_safe(dev, n, &port->destroy_list, disco_list_no=
de) {
> +		struct sas_port *sas_port =3D dev_to_sas_port(dev->rphy->dev.paren=
t);
> +
>  		list_del_init(&dev->disco_list_node);
> =20
>  		sas_remove_children(&dev->rphy->dev);
>  		sas_rphy_delete(dev->rphy);
>  		sas_unregister_common_dev(port, dev);
> +		sas_port_delete(sas_port);
>  	}
>  }
> =20
> @@ -400,9 +403,6 @@ void sas_unregister_domain_devices(struct asd_sas=
_port *port, int gone)
> =20
>  	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node=
)
>  		sas_unregister_dev(port, dev);
> -
> -	port->port->rphy =3D NULL;
> -
>  }
> =20
>  void sas_device_set_phy(struct domain_device *dev, struct sas_port *=
port)
> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas=
_port.c
> index d3c5297c6c89..9a25ae3a52a4 100644
> --- a/drivers/scsi/libsas/sas_port.c
> +++ b/drivers/scsi/libsas/sas_port.c
> @@ -219,7 +219,6 @@ void sas_deform_port(struct asd_sas_phy *phy, int=
 gone)
> =20
>  	if (port->num_phys =3D=3D 1) {
>  		sas_unregister_domain_devices(port, gone);
> -		sas_port_delete(port->port);
>  		port->port =3D NULL;
>  	} else {
>  		sas_port_delete_phy(port->port, phy->phy);
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
