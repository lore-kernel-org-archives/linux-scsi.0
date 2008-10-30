From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: i/o error due to all path failure with rdac
Date: Thu, 30 Oct 2008 13:17:08 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BD9D049@cosmail01.lsi.com>
References: <49022078.6010700@datadirectnet.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BD3B893@cosmail01.lsi.com>
	<20081030173453.GB23948@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081030173453.GB23948@linux.vnet.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


I am running multipath-tools v0.4.8 (I just pulled from mainstream last w=
eek) and kernel version 2.6.27-rc7.

I am not seeing "queueing MODE_SELECT command", because this is online/of=
fline test.  When you offline the controller the luns are automatically t=
ransferred to alt controller.

Thanks
Babu Moger

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Mike Anderson
Sent: Thursday, October 30, 2008 12:35 PM
To: device-mapper development; Chandra Seetharaman
Cc: linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] i/o error due to all path failure with rdac

Moger, Babu <Babu.Moger@lsi.com> wrote:
>
> Hi,
>
>   I am running an online/offline test. I have two paths to the controll=
er. One is active and one is passive. When I fail (offline) the active pa=
th (sde 8:64), the Device mapper is failing passive path(sdf 8:80) as wel=
l leading to all path failure.  Any ideas or hints?
>

What version of multipath tools and kernel are you running? If this is a
newer kernel I would have expected to see "queueing MODE_SELECT command"
during failover.

> Here is output multipath -ll. I have only one lun.
>
> [root@localhost ~]# multipath -ll
> mpathie (3600a0b80000f6a7d0000cff048fed59c) dm-2 LSI,INF-01-00
> [size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D1 rdac][rw]
> \_ round-robin 0 [prio=3D2][enabled]
>  \_ 3:0:0:0 sde 8:64  [active][undef]
> \_ round-robin 0 [prio=3D1][enabled]
>  \_ 3:0:1:0 sdf 8:80  [active][undef]
>
>
> Here is the detailed log.
>
> Oct 24 16:50:50 localhost multipathd: sdf: rdac prio =3D 0
> Oct 24 16:51:06 localhost kernel: sd 3:0:0:0: [sde] Result: hostbyte=3D=
DID_BUS_BUSY driverbyte=3DDRIVER_OK,SUGGEST_OK
> Oct 24 16:51:06 localhost kernel: end_request: I/O error, dev sde, sect=
or 1047072
> Oct 24 16:51:06 localhost kernel: device-mapper: multipath: Failing pat=
h 8:64.
> Oct 24 16:51:06 localhost multipathd: mpathie: rr_weight =3D 2 (control=
ler setting)
> Oct 24 16:51:06 localhost multipathd: mpathie: pgfailback =3D 100 (cont=
roller setting)
> Oct 24 16:51:06 localhost multipathd: mpathie: no_path_retry =3D 10 (co=
ntroller setting)
> Oct 24 16:51:06 localhost multipathd: pg_timeout =3D NONE (internal def=
ault)
> Oct 24 16:51:06 localhost multipathd: 8:64: mark as failed
> Oct 24 16:51:06 localhost multipathd: uevent 'change' from '/block/dm-2=
'
> Oct 24 16:51:06 localhost multipathd: UDEV_LOG=3D3
> Oct 24 16:51:06 localhost multipathd: ACTION=3Dchange
> Oct 24 16:51:06 localhost multipathd: DEVPATH=3D/block/dm-2
> Oct 24 16:51:06 localhost multipathd: SUBSYSTEM=3Dblock
> Oct 24 16:51:06 localhost multipathd: DM_TARGET=3Dmultipath
> Oct 24 16:51:06 localhost multipathd: DM_ACTION=3DPATH_FAILED
> Oct 24 16:51:06 localhost multipathd: DM_SEQNUM=3D1
> Oct 24 16:51:06 localhost multipathd: DM_PATH=3D8:64
> Oct 24 16:51:06 localhost multipathd: DM_NR_VALID_PATHS=3D1
> Oct 24 16:51:06 localhost multipathd: DM_NAME=3Dmpathie
> Oct 24 16:51:06 localhost multipathd: DM_UUID=3Dmpath-3600a0b80000f6a7d=
0000cff048fed59c
> Oct 24 16:51:06 localhost multipathd: MAJOR=3D253
> Oct 24 16:51:06 localhost multipathd: MINOR=3D2
> Oct 24 16:51:06 localhost multipathd: DEVTYPE=3Ddisk
> Oct 24 16:51:06 localhost multipathd: SEQNUM=3D1254
> Oct 24 16:51:06 localhost multipathd: UDEVD_EVENT=3D1
> Oct 24 16:51:06 localhost multipathd: dm-2: add map (uevent)
> Oct 24 16:51:08 localhost kernel: device-mapper: multipath: Failing pat=
h 8:80.
> Oct 24 16:51:08 localhost multipathd: mpathie: devmap event #3
> Oct 24 16:51:08 localhost multipathd: mpathie: discover
> Oct 24 16:51:08 localhost multipathd: mpathie: rr_weight =3D 2 (control=
ler setting)
> Oct 24 16:51:08 localhost multipathd: mpathie: pgfailback =3D 100 (cont=
roller setting)
> Oct 24 16:51:08 localhost multipathd: mpathie: no_path_retry =3D 10 (co=
ntroller setting)
> Oct 24 16:51:08 localhost multipathd: pg_timeout =3D NONE (internal def=
ault)
> Oct 24 16:51:08 localhost multipathd: 8:80: mark as failed
> Oct 24 16:51:08 localhost multipathd: mpathie: Entering recovery mode: =
max_retries=3D10
> Oct 24 16:51:08 localhost multipathd: uevent 'change' from '/block/dm-2=
'
> Oct 24 16:51:08 localhost multipathd: UDEV_LOG=3D3
> Oct 24 16:51:08 localhost multipathd: ACTION=3Dchange
> Oct 24 16:51:08 localhost multipathd: DEVPATH=3D/block/dm-2
> Oct 24 16:51:08 localhost multipathd: SUBSYSTEM=3Dblock
> Oct 24 16:51:08 localhost multipathd: DM_TARGET=3Dmultipath
> Oct 24 16:51:08 localhost multipathd: DM_ACTION=3DPATH_FAILED
> Oct 24 16:51:08 localhost multipathd: DM_SEQNUM=3D2
> Oct 24 16:51:08 localhost multipathd: DM_PATH=3D8:80
> Oct 24 16:51:08 localhost multipathd: DM_NR_VALID_PATHS=3D0
> Oct 24 16:51:08 localhost multipathd: DM_NAME=3Dmpathie
> Oct 24 16:51:08 localhost multipathd: DM_UUID=3Dmpath-3600a0b80000f6a7d=
0000cff048fed59c
> Oct 24 16:51:08 localhost multipathd: MAJOR=3D253
> Oct 24 16:51:08 localhost multipathd: MINOR=3D2
> Oct 24 16:51:08 localhost multipathd: DEVTYPE=3Ddisk
> Oct 24 16:51:08 localhost multipathd: SEQNUM=3D1255
> Oct 24 16:51:08 localhost multipathd: UDEVD_EVENT=3D1
> Oct 24 16:51:08 localhost multipathd: dm-2: add map (uevent)
> Oct 24 16:51:36 localhost kernel:  rport-3:0-2: blocked FC remote port =
time out: removing target and saving binding
> Oct 24 16:51:36 localhost multipathd: sde: rdac checker reports path is=
 down
> Oct 24 16:51:36 localhost multipathd: sde: mask =3D 0x8
> Oct 24 16:51:36 localhost kernel: sd 3:0:0:0: [sde] Synchronizing SCSI =
cache
> Oct 24 16:51:36 localhost kernel: sd 3:0:0:0: [sde] Result: hostbyte=3D=
DID_NO_CONNECT driverbyte=3DDRIVER_OK,SUGGEST_OK
> Oct 24 16:51:36 localhost kernel: scsi 3:0:0:0: rdac: Detached
> Oct 24 16:51:36 localhost multipathd: uevent 'remove' from '/class/scsi=
_generic/sg5'
> Oct 24 16:51:36 localhost multipathd: UDEV_LOG=3D3
> Oct 24 16:51:36 localhost multipathd: ACTION=3Dremove
> Oct 24 16:51:36 localhost multipathd: DEVPATH=3D/class/scsi_generic/sg5
> Oct 24 16:51:36 localhost multipathd: SUBSYSTEM=3Dscsi_generic
> Oct 24 16:51:36 localhost multipathd: MAJOR=3D21
> Oct 24 16:51:36 localhost multipathd: MINOR=3D5
> Oct 24 16:51:36 localhost multipathd: PHYSDEVPATH=3D/devices/pci0000:00=
/0000:00:02.0/0000:06:00.3/0000:0b:01.0/host3/rport-3:0-2/target3:0:0/3:0=
:0:0
> Oct 24 16:51:36 localhost multipathd: PHYSDEVBUS=3Dscsi
> Oct 24 16:51:36 localhost multipathd: PHYSDEVDRIVER=3Dsd
> Oct 24 16:51:36 localhost multipathd: SEQNUM=3D1256
> Oct 24 16:51:36 localhost multipathd: UDEVD_EVENT=3D1
> Oct 24 16:51:36 localhost multipathd: DEVNAME=3D/dev/sg5
> Oct 24 16:51:36 localhost multipathd: uevent 'remove' from '/class/scsi=
_device/3:0:0:0'
> Oct 24 16:51:36 localhost multipathd: UDEV_LOG=3D3
> Oct 24 16:51:36 localhost kernel: device-mapper: multipath: Failing pat=
h 8:80.
> Oct 24 16:51:36 localhost multipathd: ACTION=3Dremove
> Oct 24 16:51:36 localhost UnixSmash4[9200]: 7:UnixSmash has experienced=
 a write failure.
>
> Thanks
> Babu Moger
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
