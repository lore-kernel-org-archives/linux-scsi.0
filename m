From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: failover does not work with rdac device handler
Date: Tue, 7 Oct 2008 12:34:01 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45BBBD142@cosmail01.lsi.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF36@AUSX3MPC128.aus.amer.dell.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BB4E86E@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBC908@cosmail01.lsi.com>
	,<1223081419.14830.585.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BB949D3@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBCCF2@cosmail01.lsi.com>
	<1223322817.14830.593.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBCD31@cosmail01.lsi.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BBBCE37@cosmail01.lsi.com>
	<1223345074.14830.601.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1223345074.14830.601.camel@chandra-ubuntu>
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
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hi Chandra,

I have both good news and bad news with this patch.

Good news is failover is happening (I am not seeing the earlier message "=
Cannot failover device because scsi_dh_rdac was not loaded").

Bad news is, I am seeing the below soft-panic.

  Oct  7 12:50:15 localhost kernel: BUG: unable to handle kernel NULL poi=
nter dereference at 0000000000000238
Oct  7 12:50:15 localhost kernel: IP: [<ffffffffa038e283>] rdac_bus_detac=
h+0xd/0x9a [scsi_dh_rdac]
Oct  7 12:50:15 localhost kernel: PGD 0
Oct  7 12:50:15 localhost kernel: Oops: 0000 [1] SMP
Oct  7 12:50:15 localhost kernel: CPU 3
Oct  7 12:50:15 localhost kernel: Modules linked in: ipt_REJECT xt_tcpudp=
 iptable_filter ip_tables x_tables bridge stp autofs4 i2c_dev i2c_core hi=
dp rfcomm l2cap bluetooth sunrpc dm_round_robin scsi_dh_rdac dm_multipath=
 scsi_dh sbs sbshc battery acpi_memhotplug ac ipv6 parport_pc lp parport =
joydev sg bnx2 ide_cd_mod cdrom button rtc_cmos dcdbas serio_raw rtc_core=
 i5000_edac shpchp edac_core rtc_lib pcspkr dm_snapshot dm_zero dm_mirror=
 dm_log dm_mod lpfc qla2xxx scsi_transport_fc ata_piix libata megaraid_sa=
s sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: mic=
rocode]
Oct  7 12:50:15 localhost kernel: Pid: 683, comm: fc_wq_3 Not tainted 2.6=
.27-rc7-babu #2
Oct  7 12:50:15 localhost kernel: RIP: 0010:[<ffffffffa038e283>]  [<fffff=
fffa038e283>] rdac_bus_detach+0xd/0x9a [scsi_dh_rdac]
Oct  7 12:50:15 localhost kernel: RSP: 0018:ffff88007d4b3cd0  EFLAGS: 000=
10282
Oct  7 12:50:15 localhost kernel: RAX: 0000000000000000 RBX: ffff88007d4b=
3730 RCX: ffffffff00007530
Oct  7 12:50:15 localhost kernel: RDX: 0000000000000000 RSI: 000000000000=
0040 RDI: ffff88007d4b3730
Oct  7 12:50:15 localhost kernel: RBP: ffffffffa0376000 R08: ffff88007d54=
ef50 R09: ffff88007fb79090
Oct  7 12:50:15 localhost kernel: R10: 0000000000000000 R11: ffffffff802f=
a1f5 R12: 0000000000000002
Oct  7 12:50:15 localhost kernel: R13: ffff88007db97920 R14: 000000000000=
0002 R15: ffff88007db97920
Oct  7 12:50:15 localhost kernel: FS:  0000000000000000(0000) GS:ffff8800=
7f005640(0000) knlGS:0000000000000000
Oct  7 12:50:15 localhost kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000=
008005003b
Oct  7 12:50:15 localhost kernel: CR2: 0000000000000238 CR3: 000000000020=
1000 CR4: 00000000000006e0
Oct  7 12:50:15 localhost kernel: DR0: 0000000000000000 DR1: 000000000000=
0000 DR2: 0000000000000000
Oct  7 12:50:15 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff=
0ff0 DR7: 0000000000000400
Oct  7 12:50:15 localhost kernel: Process fc_wq_3 (pid: 683, threadinfo f=
fff88007d4b2000, task ffff88007f1f88d0)
Oct  7 12:50:15 localhost kernel: Stack:  ffff88007db97920 ffff88007b0e1c=
08 ffffffffa0376000 ffffffffa0376029
Oct  7 12:50:15 localhost kernel:  ffff88007d54ef50 ffff88007c45f4b0 ffff=
88007b0e1c00 ffffffff8031e383
Oct  7 12:50:15 localhost kernel:  ffff88007db97800 ffff88007db97800 ffff=
88007db97920 ffffffffa0376443
Oct  7 12:50:15 localhost kernel: Call Trace:
Oct  7 12:50:15 localhost kernel:  [<ffffffffa0376000>] ? scsi_dh_release=
+0x0/0x2e [scsi_dh]
Oct  7 12:50:15 localhost kernel:  [<ffffffffa0376029>] ? scsi_dh_release=
+0x29/0x2e [scsi_dh]
Oct  7 12:50:15 localhost kernel:  [<ffffffff8031e383>] ? kref_put+0x41/0=
x4c
Oct  7 12:50:15 localhost kernel:  [<ffffffffa0376443>] ? scsi_dh_notifie=
r+0x73/0x7a [scsi_dh]
Oct  7 12:50:15 localhost kernel:  [<ffffffff80483885>] ? notifier_call_c=
hain+0x29/0x4c
Oct  7 12:50:15 localhost kernel:  [<ffffffff80249a4c>] ? __blocking_noti=
fier_call_chain+0x48/0x62
Oct  7 12:50:15 localhost kernel:  [<ffffffff80396099>] ? device_del+0x15=
0/0x178
Oct  7 12:50:15 localhost kernel:  [<ffffffffa0074f2e>] ? __scsi_remove_d=
evice+0x3a/0x7a [scsi_mod]
Oct  7 12:50:15 localhost kernel:  [<ffffffffa0074f8f>] ? scsi_remove_dev=
ice+0x21/0x2e [scsi_mod]
Oct  7 12:50:15 localhost kernel:  [<ffffffffa0075021>] ? __scsi_remove_t=
arget+0x85/0xc3 [scsi_mod]
Oct  7 12:50:15 localhost kernel:  [<ffffffffa00750a4>] ? __remove_child+=
0x0/0x1a [scsi_mod]
Oct  7 12:50:16 localhost kernel:  [<ffffffffa00750ba>] ? __remove_child+=
0x16/0x1a [scsi_mod]
Oct  7 12:50:16 localhost kernel:  [<ffffffff80395955>] ? device_for_each=
_child+0x22/0x4d
Oct  7 12:50:16 localhost kernel:  [<ffffffffa0075099>] ? scsi_remove_tar=
get+0x3a/0x45 [scsi_mod]
Oct  7 12:50:16 localhost kernel:  [<ffffffffa00fd7b9>] ? fc_starget_dele=
te+0x0/0x64 [scsi_transport_fc]
Oct  7 12:50:16 localhost kernel:  [<ffffffff802439e4>] ? run_workqueue+0=
x7a/0x102
Oct  7 12:50:16 localhost kernel:  [<ffffffff802442dc>] ? worker_thread+0=
xd5/0xe0
Oct  7 12:50:16 localhost kernel:  [<ffffffff80246a8e>] ? autoremove_wake=
_function+0x0/0x2e
Oct  7 12:50:16 localhost kernel:  [<ffffffff80244207>] ? worker_thread+0=
x0/0xe0
Oct  7 12:50:16 localhost multipathd: mpath2: load table [0 20971520 mult=
ipath 0 1 rdac 2 1 round-robin 0 2 1 8:80 300 8:176 300 round-robin 0 1 1=
 8:224 100]
Oct  7 12:50:16 localhost kernel:  [<ffffffff80246960>] ? kthread+0x47/0x=
73
Oct  7 12:50:16 localhost kernel:  [<ffffffff80230fc3>] ? schedule_tail+0=
x28/0x60
Oct  7 12:50:16 localhost kernel:  [<ffffffff8020cd49>] ? child_rip+0xa/0=
x11
Oct  7 12:50:16 localhost kernel:  [<ffffffff80246919>] ? kthread+0x0/0x7=
3
Oct  7 12:50:16 localhost kernel:  [<ffffffff8020cd3f>] ? child_rip+0x0/0=
x11
Oct  7 12:50:16 localhost kernel:
Oct  7 12:50:16 localhost kernel:
Oct  7 12:50:16 localhost kernel: Code: a0 31 c0 e8 8e 80 ea df c6 43 0d =
02 eb 08 a8 01 74 04 c6 43 0d 01 5b 5d 44 89 e0 41 5c c3 55 53 48 89 fb 4=
8 83 ec 08 48 8b 47 08 <48> 8b b8 38 02 00 00 e8 e0 30 0f e0 48 89 c6 48 =
8b 43 08 48 8b
Oct  7 12:50:16 localhost kernel: RIP  [<ffffffffa038e283>] rdac_bus_deta=
ch+0xd/0x9a [scsi_dh_rdac]
Oct  7 12:50:16 localhost kernel:  RSP <ffff88007d4b3cd0>
Oct  7 12:50:16 localhost kernel: CR2: 0000000000000238
Oct  7 12:50:16 localhost kernel: ---[ end trace 9be4f9e6c2a759cf ]---

-------------------------------------------------------------------------

Your patch did not compile straight away (on scsi_dh.c). I had to do some=
 changes. I did few changes with the knowledge I had. Correct me if there=
 is anything wrong.
Here is the patch.


--- scsi_dh.c   2008-10-07 10:25:40.000000000 -0500
+++ linux-2.6.27-rc7-babu/drivers/scsi/device_handler/scsi_dh.c 2008-10-0=
7 12:13:19.000000000 -0500
@@ -148,17 +148,35 @@
 static int scsi_dh_handler_attach(struct scsi_device *sdev,
                                  struct scsi_device_handler *scsi_dh)
 {
+
        int err =3D 0;

-       if (sdev->scsi_dh_data) {
+       if (sdev->scsi_dh_data){
                if (sdev->scsi_dh_data->scsi_dh !=3D scsi_dh)
                        err =3D -EBUSY;
-       } else if (scsi_dh->attach)
-               err =3D scsi_dh->attach(sdev);
+               else
+                       kref_get (&sdev->scsi_dh_data->kref);
+       } else if (scsi_dh->attach){
+               err =3D scsi_dh->attach (sdev);
+               if (!err)
+                       kref_init (&sdev->scsi_dh_data->kref);
+       }

        return err;
 }

+static void scsi_dh_release(struct kref *kref)
+{
+       struct scsi_dh_data *scsi_dh_data;
+       struct scsi_device *sdev;
+       scsi_dh_data =3D container_of(kref, struct scsi_dh_data, kref);
+       sdev =3D container_of(&scsi_dh_data, struct scsi_device, scsi_dh_=
data);
+
+       if (scsi_dh_data->scsi_dh && scsi_dh_data->scsi_dh->detach)
+               scsi_dh_data->scsi_dh->detach(sdev);
+}
+
+
 /*
  * scsi_dh_handler_detach - Detach a device handler from a device
  * @sdev - SCSI device the device handler should be detached from
@@ -175,12 +193,7 @@

        if (scsi_dh && scsi_dh !=3D sdev->scsi_dh_data->scsi_dh)
                return;
-
-       if (!scsi_dh)
-               scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
-
-       if (scsi_dh && scsi_dh->detach)
-               scsi_dh->detach(sdev);
+       kref_put(&sdev->scsi_dh_data->kref, scsi_dh_release);
 }

 /*



PS:  Yes. You are right. With linux-2.6.27-rc8 sources, I am not seeing t=
he dh_state in sysfs filesystem. That is the reason I reverted back to li=
nux-2.6.27-rc7.

Thanks
Babu Moger

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
Sent: Monday, October 06, 2008 9:05 PM
To: Moger, Babu
Cc: device-mapper development; linux-scsi@vger.kernel.org
Subject: RE: [dm-devel] failover does not work with rdac device handler

Hi,

Can you try the attached patch.

chandra
PS: I see a problem (not related to this patch) that the dh_state file
is not getting recreated, still working on it.

-------------

Keep a reference count of attaches, so that same number of detaches are a=
llowed.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc8-git5.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.27-rc8-git5/drivers/scsi/device_handler/scsi_dh.c
@@ -153,12 +153,26 @@ static int scsi_dh_handler_attach(struct
        if (sdev->scsi_dh_data) {
                if (sdev->scsi_dh_data->scsi_dh !=3D scsi_dh)
                        err =3D -EBUSY;
-       } else if (scsi_dh->attach)
+               else
+                       kref_get(&sdev->scsi_dh_data.kref);
+       } else if (scsi_dh->attach) {
                err =3D scsi_dh->attach(sdev);
+               if (!err)
+                       kref_init(&sdev->scsi_dh_data.kref);
+       }

        return err;
 }

+static void scsi_dh_release(struct *kref kref)
+{
+       struct scsi_dh_data *scsi_dh_data;
+       scsi_dh_data =3D container_of(kref, struct scsi_dh_data, kref);
+
+       if (scsi_dh_data->scsi_dh && scsi_dh_data->scsi_dh->detach)
+               scsi_dh_data->scsi_dh->detach(sdev);
+}
+
 /*
  * scsi_dh_handler_detach - Detach a device handler from a device
  * @sdev - SCSI device the device handler should be detached from
@@ -176,11 +190,7 @@ static void scsi_dh_handler_detach(struc
        if (scsi_dh && scsi_dh !=3D sdev->scsi_dh_data->scsi_dh)
                return;

-       if (!scsi_dh)
-               scsi_dh =3D sdev->scsi_dh_data->scsi_dh;
-
-       if (scsi_dh && scsi_dh->detach)
-               scsi_dh->detach(sdev);
+       kref_put(&sdev->scsi_dh_data.kref, scsi_dh_release);
 }

 /*
Index: linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.27-rc8-git5.orig/include/scsi/scsi_device.h
+++ linux-2.6.27-rc8-git5/include/scsi/scsi_device.h
@@ -191,6 +191,7 @@ struct scsi_device_handler {

 struct scsi_dh_data {
        struct scsi_device_handler *scsi_dh;
+       struct kref kref;
        char buf[0];
 };
