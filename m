From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Wed, 22 Dec 2004 11:26:56 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE07501278@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-class: urn:content-classes:message
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On my system I have a Qlogic 2310 driver running on a 2.6.9 kernel. The =
fc_transport=20
directory in sysfs looks like=20

ls -ll /sys/class/fc_transport/
total 0
drwxr-xr-x   6 root root 0 Dec 16 13:59 .
drwxr-xr-x  20 root root 0 Dec 15 14:31 ..
drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:0:0
drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:1:0
drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:2:0
drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:3:0 =20

The patch addresses only this format. So please disregard the patch, and =
sorry about the confusion.

Ramesh.



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On Behalf Of christophe varoqui
Sent: Tuesday, December 21, 2004 5:26 PM
To: device-mapper development
Cc: linux-raid@vger.kernel.org; =
linux-hotplug-devel@lists.sourceforge.net; linux-scsi@vger.kernel.org
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1

Le mercredi 22 d?embre 2004 =E0 02:09 +0100, christophe varoqui a =
=E9crit :
> Le mardi 21 d?embre 2004 =E0 14:02 -0800, Caushik, Ramesh a =E9crit :
> > The devinfo.c file in the multipath-tools-0.4.1 appears to have a =
typo
> > in the code to get the node_name attr in the fc_transport sysfs =
entry.
> > Path below should fix it. BTW why does a failure to get a node_name
> > attribute, result in failure of multipath discovery (because devinfo
> > returns failure)even if the "group_by_node_name" policy is not used =
?
> > Can't we just NULL out the tgt_node_name string in the sysfs_devinfo
> > routine and fail the group_by_node_name routine if that policy was
> > chosen ? That is what happened in my case. Multipath discovery =
failed
> > due to above reason even though node_name grouping was not =
specified.=20
> >=20
> You are absolutely right.
>=20
> I was aware that introducing that FC-ism would break for iSCSI and =
other
> transports. I just thought I'll get that right in a next release =
because
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
-> =
../../../devices/pci0000:00/0000:00:09.0/0000:03:04.0/host2/target2:0:0
-r--r--r--    1 root     root         4096 Dec 14 16:26 node_name
-r--r--r--    1 root     root         4096 Dec 14 16:26 port_id
-r--r--r--    1 root     root         4096 Dec 14 16:26 port_name

This is with Qlogic hardware, but I'm not aware of HBA driver specifics
in the area. If there is, I'm all for resolving the delta at the device
driver level.

> regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
