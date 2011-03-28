From: Phil C <philc@impliedspaces.com>
Subject: pNFS Block layout issues / questions
Date: Mon, 28 Mar 2011 22:35:56 +0000 (UTC)
Message-ID: <loom.20110328T230906-552@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46200 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab1C1WkJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2011 18:40:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Q4L6S-00046m-Ip
	for linux-scsi@vger.kernel.org; Tue, 29 Mar 2011 00:40:04 +0200
Received: from jfdmzpr04-ext.jf.intel.com ([134.134.137.73])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2011 00:40:04 +0200
Received: from philc by jfdmzpr04-ext.jf.intel.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2011 00:40:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I was able to get the pNFS file-layout code functioning with 1 DS, and =
a MDS and
1 Client.  I need to get block layout working for a research project I =
am
working on, however have so far been unable to get this working.

I would very much appreciate help or suggestions (or a kick in the head=
 if I'm
doing something stupid).

I referenced the wiki pages on client and DS setup and referenced the t=
wo
threads I saw on this topic, however cannot get block-layout working. =20

Below I have shown the steps I have taken to try and get this working (=
sorry for
the long list). =20

I have also shown the testing and troubleshooting I have undertaken, an=
d the
results there-of.

Data Server: 192.168.1.2 MDS: 192.168.1.1 Client: 192.168.1.3

On Data-server(s) create folder with mkdir /pnfs=20

On Data-server(s) Edit /etc/exports.  Add the string:=20
   /pnfs  *(rw, sync,fsid=3D0,insecure,no_subtree_check,pnfs,no_root_sq=
uash)

On Data-server(s) type parted /dev/sdb=20
   (parted) mklabel gpt
   (parted) mklabel 1 <Provide ext4 file-system, and partition start an=
d end>
   (parted> print
   Model: ATA SSDSA2SH06=E2=80=A6 (scsi)
   Disk /dev/sdb: 64.0GB
   Sector size (logical/physical): 512B/512B
   Partition Table: gpt
   Number Start	   End		size	File system	Name	Flags
       1  1049kB  64.0GB       64.0GB	      ext4         1
=09
On Data-server(s) type mkfs.ext4 =E2=80=93b 4096 /dev/sdb1

On Data-server(s) type /etc/init.d/iptables stop

On Data-server(s) type /etc/init.d/tgtd start

On Data-server(s) type:
     tgtadm =E2=80=93lld iscsi =E2=80=93op new =E2=80=93mode target =E2=
=80=93tid 1 =E2=80=93T
iqn.2011-03.com.intel:openblock

On Data-server(s) type=20
  tgtadm =E2=80=93lld iscsi =E2=80=93mode logicalunit =E2=80=93op new =E2=
=80=93tid 1 =E2=80=93lun 1 =E2=80=93backing-store /dev/sdb1

On Data-server(s) type=20
   tgtadm =E2=80=93lld iscsi =E2=80=93mode target =E2=80=93op bind =E2=80=
=93tid 1 =E2=80=93initiator-address ALL

On Data-server(s) type tgtadm =E2=80=93lld iscsi =E2=80=93op show =E2=80=
=93mode target

On Data-server(s) type mount /dev/sdb1 /pnfs

On Data-server(s) type service nfs restart

On Data-server(s) cd to the ctl directory and type ./ctl =E2=80=93u &=20
   See: =E2=80=9CProcessing: MSG_VERS	: Version: 8

On MDS copy the spnfsd.conf file from pNFS_Packages/pnfs-nfs-utils/util=
s to
/etc/spnfsd.conf and edit it for 1 DS and the proper DS-Mount-Directory=
, DS1_IP,
and DS1_Root.
   [General]
   Verbosity =3D 1
   Stripe-size =3D 8192
   Dense-striping =3D 0
   Pipefs-Directory =3D /var/lib/nfs/rpc_pipefs
   DS-Mount-Directory =3D /spnfs
   [DataServers]
   NumDS =3D 1
   DS1_IP=3D	192.168.1.2
   DS1_PORT=3D	2049
   DS1_ROOT =3D /pnfs
   DS1_ID =3D 1

On MDS create the /spnfs/192.168.1.2 folder

On MDS edit /etc/exports and add below string:
   /	*(rw, sync,fsid=3D0,insecure,no_subtree_check,pnfs,no_root_squash)
  =20
On MDS type mount 192.168.1.2:/pnfs /spnfs/192.168.1.2
   See on the DS =E2=80=93 the ctl application prints out:
   Processing: MSG_VERS	:	Version: 	8

On MDS disable iptables with /etc/init.d/iptables stop

On MDS type service nfs restart =E2=80=93 See:
   Starting NFS services:	[	OK	]
   Starting NFS quotas:	[	OK	]
   Starting NFS daemon:	[	OK	]
   Starting NFS mountd:	[	OK	]
 =20
On MDS type modprobe nfsd to start the NFS daemon

On MDS type spnfsd to start service on MDS server. =20
   See recapitulation of /etc/spnfsd.conf=E2=80=99;=20
  =20
On the Client disable iptables with /etc/init.d/iptables stop

On the Client log onto the Data-Server iSCSI target by typing:
   iscsi =E2=80=93m discovery =E2=80=93t st =E2=80=93p 192.168.1.2 =E2=80=
=93l

On the Client start the blkmapd service by typing service blkmapd start

On the Client run /usr/sbin/blkmapd =E2=80=93f=20

On the Client mount MDS server by typing:
   mount =E2=80=93t nfs4 =E2=80=93o minorversion =3D1 192.168.1.1:/spnf=
s /mnt

TESTING:
On the Client generate some activity in /mnt (copy file from local clie=
nt disk
to /mnt)

On the Client cat /proc/self/mountstats and look for LAYOUT and see:
   nfsv4: bm0=3D0xfdffbfff,bm1=3D0x40f9be3e,acl=3D0x3,sessions,pnfs=3Dn=
ot configured
   LAYOUTGET:	0 0 0 0 0 0 0 0
   LAYTOUTCOMMIT: 0 0 0 0 0 0 0 0
   LAYOUTRETURN: 0 0 0 0 0 0 0 0

   On the Client I see in /mnt the file I copied
   On the MDS I see in /spnfs (note: not /spnfs/192.168.1.2) the file I=
 copied
from the Client
   On the MDS I see in /spnfs/192.168.1.2 a file called 2359299.1868952=
557
   On the DS I see in /pnfs a file called 2359299.1868952557

TROUBLESHOOTING:
Read the new-ish trouble shooting information on the wiki-page.

1 =E2=80=93 Ran more traffic and still see the same information from th=
e client=E2=80=99s=20
/proc/self/mountstats

2 =E2=80=93 Ran /usr/sbin/blkmapd =E2=80=93f on the Client and saw no o=
utput

3 =E2=80=93 Looked at /var/log/messages on all 3 machines. =20
   Saw nothing on either the MDS or the DS. =20
   On the Client I see the innocuous:=20
      =E2=80=9CFS-Cache: Loaded=E2=80=9D
      Registering the id_resolver key type
      FS-Cache: Netfs =E2=80=98nfs=E2=80=99 registered for caching

4 =E2=80=93 On the Client I ran =E2=80=98mount=E2=80=99 and see I have:
   192.168.1.1:/spnf on /mnt type nfs4 =20
(rw,minorversion=3D1,addr192.168.1.1,clientaddr=3D192.168.1.3)

<Note: no output from the running =E2=80=98/usr/sbin/blkmapd =E2=80=93f=
=E2=80=99 when I ran the mount
command>

5 =E2=80=93 On the Client I verified I have an iSCSI target attached.

6 =E2=80=93 On the Client I did an lsmod|grep bllock to see I had block=
layoutdriver
loaded and used by nfs and sunrpc

QUESTIONS:
1 =E2=80=93 do you see anything missing or wrong about my procedure?

2 =E2=80=93 The MDS mounts the DS using =E2=80=9Cmount 192.168.1.2:/pnf=
s /spnfs/192.168.1.2=E2=80=9D.=20
Does the MDS also/instead need to act as an iSCSI initiator and discove=
r/logon=20
to the DS iSCSI target?

3 =E2=80=93 from /proc/self/mountstats on the client I see I do NOT in =
fact have
pnfs=3DLAYOUT_BLOCK_VOLUEM so I assume we can suspect we do not have a =
pNFS mount.
 What does this mean and how can I address the issue?


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
