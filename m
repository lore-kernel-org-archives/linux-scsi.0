From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Wed, 22 Dec 2004 02:26:12 +0100
Message-ID: <1103678772.6030.11.camel@zezette>
References: <EA4DC661A6353747A2E5C0DE8792DDDE074BF47E@orsmsx404.amr.corp.intel.com>
	 <1103677780.6030.4.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1103677780.6030.4.camel@zezette>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Le mercredi 22 d?embre 2004 =C3=A0 02:09 +0100, christophe varoqui a =C3=
=A9crit :
> Le mardi 21 d?embre 2004 =C3=A0 14:02 -0800, Caushik, Ramesh a =C3=A9=
crit :
> > The devinfo.c file in the multipath-tools-0.4.1 appears to have a t=
ypo
> > in the code to get the node_name attr in the fc_transport sysfs ent=
ry.
> > Path below should fix it. BTW why does a failure to get a node_name
> > attribute, result in failure of multipath discovery (because devinf=
o
> > returns failure)even if the "group_by_node_name" policy is not used=
 ?
> > Can't we just NULL out the tgt_node_name string in the sysfs_devinf=
o
> > routine and fail the group_by_node_name routine if that policy was
> > chosen ? That is what happened in my case. Multipath discovery fail=
ed
> > due to above reason even though node_name grouping was not specifie=
d.=20
> >=20
> You are absolutely right.
>=20
> I was aware that introducing that FC-ism would break for iSCSI and ot=
her
> transports. I just thought I'll get that right in a next release beca=
use
> I wasn't aware someone was using the thing in such an "exotic"
> environment.
>=20
> I would gladly get a description of your topology, by the way.
> It would help to get it right in the future.
>=20
> Anyway, I'll fix that for 0.4.2
>=20
That response was for the premature exit when the FC-ism is out of
place.

Concerning the patch itself, I don't see the problem it adresses :

[root@cl039 multipath]# ll /sys/class/fc_transport/
total 0
drwxr-xr-x    2 root     root            0 Dec 14 16:26 target2:0:0
drwxr-xr-x    2 root     root            0 Dec 14 16:26 target2:0:1
drwxr-xr-x    2 root     root            0 Dec 14 16:26 target2:0:2
drwxr-xr-x    2 root     root            0 Dec 14 16:27 target2:0:3
drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:0
drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:1
drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:2
drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:3

[root@cl039 multipath]# ll /sys/class/fc_transport/target2\:0\:0
total 0
lrwxrwxrwx    1 root     root            0 Dec 14 16:26 device
-> ../../../devices/pci0000:00/0000:00:09.0/0000:03:04.0/host2/target2:=
0:0
-r--r--r--    1 root     root         4096 Dec 14 16:26 node_name
-r--r--r--    1 root     root         4096 Dec 14 16:26 port_id
-r--r--r--    1 root     root         4096 Dec 14 16:26 port_name

This is with Qlogic hardware, but I'm not aware of HBA driver specifics
in the area. If there is, I'm all for resolving the delta at the device
driver level.

> regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
