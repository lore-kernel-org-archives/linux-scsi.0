From: Yves-Alexis Perez <corsac-vD43ovf/fd+sTnJN9+BGXg@public.gmane.org>
Subject: Page allocation failure (order 7) in UAS code
Date: Tue, 01 Mar 2016 10:42:41 +0100
Message-ID: <1456825361.17330.9.camel@corsac.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XvCZw6A1adpmOvkHyHfM"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--=-XvCZw6A1adpmOvkHyHfM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

[sorry if this is not the right point for reporting bugs, I took the email
addresses from MAINTAINERS but please point me to the correct place if need=
ed]

I have an external USB drive (Samsung M3), which apparently uses the UAS co=
de.
Starting with 4.4 (from Debian sid, I could retry with vanilla if needed), =
I
can't mount the drive anymore after a while (few hours/days uptime). Just
plugging the disk, I get page allocation failure in kernel logs:

Feb 22 10:57:56 scapa kernel: [26557.268872] usb 2-2: new SuperSpeed USB de=
vice number 3 using xhci_hcd
Feb 22 10:57:56 scapa kernel: [26557.285884] usb 2-2: New USB device found,=
 idVendor=3D04e8, idProduct=3D61b6
Feb 22 10:57:56 scapa kernel: [26557.285888] usb 2-2: New USB device string=
s: Mfr=3D1, Product=3D2, SerialNumber=3D3
Feb 22 10:57:56 scapa kernel: [26557.285891] usb 2-2: Product: Samsung M3 P=
ortable
Feb 22 10:57:56 scapa kernel: [26557.285893] usb 2-2: Manufacturer: Samsung=
 M3 Portable
Feb 22 10:57:56 scapa kernel: [26557.285895] usb 2-2: SerialNumber: 826C7DF=
B13000067
Feb 22 10:57:56 scapa kernel: [26557.293693] scsi host4: uas
Feb 22 10:57:56 scapa kernel: [26557.293707] kworker/0:0: page allocation f=
ailure: order:7, mode:0x2204020
Feb 22 10:57:56 scapa kernel: [26557.293711] CPU: 0 PID: 11015 Comm: kworke=
r/0:0 Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0W=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A04.4.0-1-amd64 #1 Debian 4.4.2-3~a.test
Feb 22 10:57:56 scapa kernel: [26557.293713] Hardware name: LENOVO 20CMCTO1=
WW/20CMCTO1WW, BIOS N10ET41W (1.20 ) 01/19/2016
Feb 22 10:57:56 scapa kernel: [26557.293724] Workqueue: usb_hub_wq hub_even=
t [usbcore]
Feb 22 10:57:56 scapa kernel: [26557.293727]=C2=A0=C2=A00000000000000000 00=
000000c0207f69 ffffffff812e7679 0000000002204020
Feb 22 10:57:56 scapa kernel: [26557.293730]=C2=A0=C2=A0ffffffff8116b23a 00=
000001c0207f69 0000000000000000 ffff88024dffbb20
Feb 22 10:57:56 scapa kernel: [26557.293733]=C2=A0=C2=A0ffffffff810b475e 00=
000001020c8220 00000000c0207f69 0000000000000046
Feb 22 10:57:56 scapa kernel: [26557.293736] Call Trace:
Feb 22 10:57:56 scapa kernel: [26557.293741]=C2=A0=C2=A0[<ffffffff812e7679>=
] ? dump_stack+0x40/0x57
Feb 22 10:57:56 scapa kernel: [26557.293745]=C2=A0=C2=A0[<ffffffff8116b23a>=
] ? warn_alloc_failed+0xfa/0x150
Feb 22 10:57:56 scapa kernel: [26557.293749]=C2=A0=C2=A0[<ffffffff810b475e>=
] ? __wake_up_common+0x4e/0x90
Feb 22 10:57:56 scapa kernel: [26557.293752]=C2=A0=C2=A0[<ffffffff8116e7d6>=
] ? __alloc_pages_nodemask+0x306/0xb70
Feb 22 10:57:56 scapa kernel: [26557.293757]=C2=A0=C2=A0[<ffffffff811ba191>=
] ? kmem_getpages+0x51/0xf0
Feb 22 10:57:56 scapa kernel: [26557.293759]=C2=A0=C2=A0[<ffffffff811bbe05>=
] ? fallback_alloc+0x145/0x1f0
Feb 22 10:57:56 scapa kernel: [26557.293765]=C2=A0=C2=A0[<ffffffff812bd908>=
] ? init_tag_map+0x38/0xb0
Feb 22 10:57:56 scapa kernel: [26557.293768]=C2=A0=C2=A0[<ffffffff811bd29f>=
] ? __kmalloc+0x17f/0x1c0
Feb 22 10:57:56 scapa kernel: [26557.293771]=C2=A0=C2=A0[<ffffffff812bd908>=
] ? init_tag_map+0x38/0xb0
Feb 22 10:57:56 scapa kernel: [26557.293774]=C2=A0=C2=A0[<ffffffff812bd9c0>=
] ? __blk_queue_init_tags+0x40/0x80
Feb 22 10:57:56 scapa kernel: [26557.293781]=C2=A0=C2=A0[<ffffffffa013445b>=
] ? scsi_add_host_with_dma+0x7b/0x2f0 [scsi_mod]
Feb 22 10:57:56 scapa kernel: [26557.293785]=C2=A0=C2=A0[<ffffffffa08783ba>=
] ? uas_probe+0x41a/0x560 [uas]
Feb 22 10:57:56 scapa kernel: [26557.293796]=C2=A0=C2=A0[<ffffffffa00d3c03>=
] ? usb_probe_interface+0x1b3/0x300 [usbcore]
Feb 22 10:57:56 scapa kernel: [26557.293801]=C2=A0=C2=A0[<ffffffff8140dbc2>=
] ? driver_probe_device+0x212/0x480
Feb 22 10:57:56 scapa kernel: [26557.293803]=C2=A0=C2=A0[<ffffffff8140deb0>=
] ? __driver_attach+0x80/0x80
Feb 22 10:57:56 scapa kernel: [26557.293806]=C2=A0=C2=A0[<ffffffff8140b8c2>=
] ? bus_for_each_drv+0x62/0xb0
Feb 22 10:57:56 scapa kernel: [26557.293809]=C2=A0=C2=A0[<ffffffff8140d8c8>=
] ? __device_attach+0xd8/0x160
Feb 22 10:57:56 scapa kernel: [26557.293811]=C2=A0=C2=A0[<ffffffff8140cbc7>=
] ? bus_probe_device+0x87/0xa0
Feb 22 10:57:56 scapa kernel: [26557.293814]=C2=A0=C2=A0[<ffffffff8140a8e5>=
] ? device_add+0x3f5/0x660
Feb 22 10:57:56 scapa kernel: [26557.293823]=C2=A0=C2=A0[<ffffffffa00d1c2b>=
] ? usb_set_configuration+0x51b/0x8f0 [usbcore]
Feb 22 10:57:56 scapa kernel: [26557.293835]=C2=A0=C2=A0[<ffffffffa00dbfa8>=
] ? generic_probe+0x28/0x80 [usbcore]
Feb 22 10:57:56 scapa kernel: [26557.293838]=C2=A0=C2=A0[<ffffffff8140dbc2>=
] ? driver_probe_device+0x212/0x480
Feb 22 10:57:56 scapa kernel: [26557.293840]=C2=A0=C2=A0[<ffffffff8140deb0>=
] ? __driver_attach+0x80/0x80
Feb 22 10:57:56 scapa kernel: [26557.293842]=C2=A0=C2=A0[<ffffffff8140b8c2>=
] ? bus_for_each_drv+0x62/0xb0
Feb 22 10:57:56 scapa kernel: [26557.293845]=C2=A0=C2=A0[<ffffffff8140d8c8>=
] ? __device_attach+0xd8/0x160
Feb 22 10:57:56 scapa kernel: [26557.293847]=C2=A0=C2=A0[<ffffffff8140cbc7>=
] ? bus_probe_device+0x87/0xa0
Feb 22 10:57:56 scapa kernel: [26557.293850]=C2=A0=C2=A0[<ffffffff8140a8e5>=
] ? device_add+0x3f5/0x660
Feb 22 10:57:56 scapa kernel: [26557.293857]=C2=A0=C2=A0[<ffffffffa00c7545>=
] ? usb_new_device+0x265/0x490 [usbcore]
Feb 22 10:57:56 scapa kernel: [26557.293864]=C2=A0=C2=A0[<ffffffffa00c96e3>=
] ? hub_event+0xfb3/0x14f0 [usbcore]
Feb 22 10:57:56 scapa kernel: [26557.293868]=C2=A0=C2=A0[<ffffffff8108d84f>=
] ? process_one_work+0x19f/0x3d0
Feb 22 10:57:56 scapa kernel: [26557.293871]=C2=A0=C2=A0[<ffffffff8108dacd>=
] ? worker_thread+0x4d/0x450
Feb 22 10:57:56 scapa kernel: [26557.293873]=C2=A0=C2=A0[<ffffffff8108da80>=
] ? process_one_work+0x3d0/0x3d0
Feb 22 10:57:56 scapa kernel: [26557.293876]=C2=A0=C2=A0[<ffffffff8109385d>=
] ? kthread+0xcd/0xf0
Feb 22 10:57:56 scapa kernel: [26557.293879]=C2=A0=C2=A0[<ffffffff81093790>=
] ? kthread_create_on_node+0x190/0x190
Feb 22 10:57:56 scapa kernel: [26557.293883]=C2=A0=C2=A0[<ffffffff81589c0f>=
] ? ret_from_fork+0x3f/0x70
Feb 22 10:57:56 scapa kernel: [26557.293886]=C2=A0=C2=A0[<ffffffff81093790>=
] ? kthread_create_on_node+0x190/0x190
Feb 22 10:57:56 scapa kernel: [26557.293888] Mem-Info:
Feb 22 10:57:56 scapa kernel: [26557.293892] active_anon:1100571 inactive_a=
non:668265 isolated_anon:0
Feb 22 10:57:56 scapa kernel: [26557.293892]=C2=A0=C2=A0active_file:76007 i=
nactive_file:57114 isolated_file:0
Feb 22 10:57:56 scapa kernel: [26557.293892]=C2=A0=C2=A0unevictable:22 dirt=
y:7 writeback:0 unstable:0
Feb 22 10:57:56 scapa kernel: [26557.293892]=C2=A0=C2=A0slab_reclaimable:37=
128 slab_unreclaimable:28425
Feb 22 10:57:56 scapa kernel: [26557.293892]=C2=A0=C2=A0mapped:51000 shmem:=
993293 pagetables:11591 bounce:0
Feb 22 10:57:56 scapa kernel: [26557.293892]=C2=A0=C2=A0free:40735 free_pcp=
:706 free_cma:0
Feb 22 10:57:56 scapa kernel: [26557.293898] Node 0 DMA32 free:64580kB min:=
3908kB low:4884kB high:5860kB active_anon:1473104kB inactive_anon:957504kB =
active_file:105844kB inactive_file:80920kB unevictable:88kB isolated(anon):=
0kB isolated(file):0kB present:2814324kB managed:2803768kB mlocked:88kB dir=
ty:12kB writeback:0kB mapped:72980kB shmem:1357128kB slab_reclaimable:50220=
kB slab_unreclaimable:37872kB kernel_stack:3040kB pagetables:16520kB unstab=
le:0kB bounce:0kB free_pcp:1256kB local_pcp:236kB free_cma:0kB writeback_tm=
p:0kB pages_scanned:0 all_unreclaimable? no
Feb 22 10:57:56 scapa kernel: [26557.293904] lowmem_reserve[]: 0 5214 5214 =
5214
Feb 22 10:57:56 scapa kernel: [26557.293908] Node 0 Normal free:98360kB min=
:7452kB low:9312kB high:11176kB active_anon:2929180kB inactive_anon:1715556=
kB active_file:198184kB inactive_file:147536kB unevictable:0kB isolated(ano=
n):0kB isolated(file):0kB present:5472256kB managed:5339884kB mlocked:34359=
738368kB dirty:16kB writeback:0kB mapped:131020kB shmem:2616044kB slab_recl=
aimable:98292kB slab_unreclaimable:75828kB kernel_stack:5600kB pagetables:2=
9844kB unstable:0kB bounce:0kB free_pcp:1568kB local_pcp:240kB free_cma:0kB=
 writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Feb 22 10:57:56 scapa kernel: [26557.293914] lowmem_reserve[]: 0 0 0 0
Feb 22 10:57:56 scapa kernel: [26557.293917] Node 0 DMA32: 6976*4kB (UE) 37=
58*8kB (UME) 358*16kB (UME) 16*32kB (UME) 0*64kB 0*128kB 0*256kB 0*512kB 0*=
1024kB 0*2048kB 0*4096kB =3D 64208kB
Feb 22 10:57:56 scapa kernel: [26557.293928] Node 0 Normal: 13439*4kB (UME)=
 5329*8kB (UME) 100*16kB (UE) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024k=
B 0*2048kB 0*4096kB =3D 97988kB
Feb 22 10:57:56 scapa kernel: [26557.293938] Node 0 hugepages_total=3D0 hug=
epages_free=3D0 hugepages_surp=3D0 hugepages_size=3D2048kB
Feb 22 10:57:56 scapa kernel: [26557.293940] 1127321 total pagecache pages
Feb 22 10:57:56 scapa kernel: [26557.293942] 830 pages in swap cache
Feb 22 10:57:56 scapa kernel: [26557.293944] Swap cache stats: add 35025, d=
elete 34195, find 288/383
Feb 22 10:57:56 scapa kernel: [26557.293945] Free swap=C2=A0=C2=A0=3D 30079=
72kB
Feb 22 10:57:56 scapa kernel: [26557.293946] Total swap =3D 3145724kB
Feb 22 10:57:56 scapa kernel: [26557.293948] 2071645 pages RAM
Feb 22 10:57:56 scapa kernel: [26557.293949] 0 pages HighMem/MovableOnly
Feb 22 10:57:56 scapa kernel: [26557.293950] 35732 pages reserved
Feb 22 10:57:56 scapa kernel: [26557.293951] 0 pages hwpoisoned
Feb 22 10:57:56 scapa kernel: [26557.295059] uas: probe of 2-2:1.0 failed w=
ith error -12

order 7 seems like a lot to allocate, let alone atomically.

If you need anything more, please ask.

Regards,
--=20
Yves-Alexis


--=-XvCZw6A1adpmOvkHyHfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJW1WQRAAoJEG3bU/KmdcClAaYIAKomPROwVUyGMY93inM1Bs5g
7yIIuf/BVxzbzxUe3SukpwBd5vi49ifu1LjCHHj6iC5PK7InYN0OtMo7arh29+WB
ae+fQY2p1Wkrnnm2QjsAv4gAfnEEXUjdowD1CsBoUGzRJ44xJiLnDotCqpAlqUaX
HmG1W6rChBbaFPh5JbA1FVIZ+iW5EaZQ/5ciRtMRYPr8x6E74yM/zMf/bBJa1TV9
D+U3uRpSDVjSfbA7m837zG2KVzM++whChDABymVS5qgT8bzMNyjyOqig09fMlCOY
4CytsEufkqTwbc3R5G30frPtO47gPJ3OD2LM6Xblf4nHbsr/fLjB99EqpLvdqtg=
=HCE1
-----END PGP SIGNATURE-----

--=-XvCZw6A1adpmOvkHyHfM--
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
