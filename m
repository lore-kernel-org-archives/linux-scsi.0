From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: UBSAN whinge in scsi_devinfo.c
Date: Tue, 17 May 2016 18:42:00 -0400
Message-ID: <8999.1463524920@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1463524920_1953P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--==_Exmh_1463524920_1953P
Content-Type: text/plain; charset=us-ascii

Seen at boot in a UBSAN-enabled kernel:

[    2.936388] ================================================================================
[    2.936392] UBSAN: Undefined behaviour in drivers/scsi/scsi_devinfo.c:457:21
[    2.936396] index 8 is out of range for type 'char [8]'

The code:

    452                 if (devinfo->compatible) {
    453                         /*
    454                          * Behave like the older version of get_device_flags.
    455                          */
    456                         if (memcmp(devinfo->vendor, vskip, vmax) ||
    457                                         devinfo->vendor[vmax])
    458                                 continue;
    459                         if (memcmp(devinfo->model, mskip, mmax) ||
    460                                         devinfo->model[mmax])
    461                                 continue;
    462                         return devinfo;

As near as I can tell, intentionally dereferencing past the end of the
vendor or model strings is well into "just happens to work" - and I'm
convinced this is actually buggy for entries that have 16-character
model identifiers, as the next field is an 'unsigned flags'.  And that's
going to fail miserably on a big-endian machine where the flags aren't
in the next byte that follows the 16 chars of model....

The entire splat:

[    2.936388] ================================================================================
[    2.936392] UBSAN: Undefined behaviour in drivers/scsi/scsi_devinfo.c:457:21
[    2.936396] index 8 is out of range for type 'char [8]'
[    2.936401] CPU: 0 PID: 98 Comm: kworker/u8:1 Not tainted 4.6.0-next-20160517-00001-gede618fce89c-dirty #279
[    2.936412] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
[    2.936424] Workqueue: events_unbound async_run_entry_fn
[    2.936432]  0000000000000000 00000000ce26f4e7 ffff8802236eba38 ffffffffaa690aea
[    2.936439]  ffff8802236eba50 00000000ce26f4e7 ffff8802236eba60 0000000000000008
[    2.936446]  ffff8802236eba50 ffffffffaa7087ad ffffffffabccafc0 ffff8802236ebaa8
[    2.936449] Call Trace:
[    2.936459]  [<ffffffffaa690aea>] dump_stack+0x7b/0xd1
[    2.936464]  [<ffffffffaa7087ad>] ubsan_epilogue+0xd/0x40
[    2.936468]  [<ffffffffaa708ec5>] __ubsan_handle_out_of_bounds+0x75/0xa0
[    2.936472]  [<ffffffffaa140038>] ? percpu_down_read_trylock+0xa8/0xb0
[    2.936478]  [<ffffffffaa8ef922>] scsi_dev_info_list_find+0x282/0x300
[    2.936482]  [<ffffffffaa8efa11>] scsi_get_device_flags_keyed+0x21/0xb0
[    2.936487]  [<ffffffffaa8eff90>] scsi_get_device_flags+0x10/0x20
[    2.936492]  [<ffffffffaa8e9032>] scsi_probe_and_add_lun+0x502/0x1200
[    2.936497]  [<ffffffffab077f27>] ? _raw_spin_unlock_irqrestore+0x87/0x90
[    2.936503]  [<ffffffffaa8ea9d1>] __scsi_add_device+0x121/0x150
[    2.936510]  [<ffffffffaa91c4f7>] ata_scsi_scan_host+0x127/0x240
[    2.936514]  [<ffffffffaa911baa>] async_port_probe+0x4a/0x90
[    2.936518]  [<ffffffffaa0f12b8>] async_run_entry_fn+0x68/0x1b0
[    2.936523]  [<ffffffffaa0e257f>] process_one_work+0x3bf/0xdb0
[    2.936526]  [<ffffffffaa0e24e9>] ? process_one_work+0x329/0xdb0
[    2.936531]  [<ffffffffaa0e32c1>] worker_thread+0x351/0xad0
[    2.936536]  [<ffffffffaa0e2f70>] ? process_one_work+0xdb0/0xdb0
[    2.936540]  [<ffffffffaa0ec1e2>] kthread+0x142/0x1b0
[    2.936549]  [<ffffffffab07897f>] ret_from_fork+0x1f/0x40
[    2.936553]  [<ffffffffaa0ec0a0>] ? kthread_create_on_node+0x280/0x280
[    2.936557] ================================================================================





--==_Exmh_1463524920_1953P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVzueOAdmEQWDXROgAQJHphAAoy4MCZAAkdhtq2A8FBpmGnXl0JPV2+ZS
Myrw9CnGzRKtbxDjbwBoSSpLQxicV/tP1DlVH6CUzQnfc012LYNtDCG5RsSxm2DE
VYWxniLOvqCRjVK5I1dpIzNSxDDEgGjq2pvr+d6dgLW+ghX86MxugbrM+XXxRaWm
p3Disz1mY6Y4f6QzbjnHA1h2D0ZdQ8+eCfRGRgzkpam/NzUA2oLOvoxDUFJ+igEG
SsZ5DjzWktzK17pHdc1GeK7NdIaA2Xm3U6Hx+EYXHqzypCJaCLQjwCEFEeghqh1Y
x9PhountwaqtETcfTOaoAirJn7br2EVkAW6CXGutEZudNohA6sfc52Jz/7OW8f/z
bNIUZCOQGLPmK2RR33oGZTeI1hZZer4RvW1Aj/LYCWXYS5Jgazu3TSh6MFqQ2R5J
UhqvOUYlMcFcn3mV2iQakhm2O/GFhyTVE5TtLVeR3ExrEAohOY7RyF9VHN/0zZCN
C4A3TzmJ4yaxSOyVxcvUDdn3S1cumv/bRcBcv4+6Z4VrRtE1sreWMIghirm0XCTk
v+8cZWY4uW8HU4UvqzuPniJ6N6Nw+ozdLTVNEgAFXUzTPvYlFMEetaaylMPuM6xL
XssCfk6yxSBXIG83n84Bnj92UJyu1u03qQwxJdcpjTmgqmgwEcahpKO8AyUo4YFE
gk+ZYtDzSL4=
=I79x
-----END PGP SIGNATURE-----

--==_Exmh_1463524920_1953P--
