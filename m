From: Klaus Lichtenwalder <k.lichtenwalder@computer.org>
Subject: oops in scsi with pcmcia 152x_cs and yamaha burner (2.4.19)
Date: 31 Aug 2002 11:01:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1030784507.15360.104.camel@tintin>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-ByJ+tHRC4Rn4xr9y3DZS"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-ByJ+tHRC4Rn4xr9y3DZS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I get the following (repeatable) oops on a standard kernel while trying
to burn a cd with the pcmcia attached scsi burner:

ksymoops 2.4.6 on i686 2.4.19freeswan.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.19freeswan/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

ccb5d619
*pde =3D 08bf4067
Oops: 0000
CPU:    0
EIP:    0010:[<ccb5d619>]    Tainted: P=20
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00013002
eax: 00000000   ebx: c3eedc00   ecx: c9ebe000   edx: c1f19720
esi: c97d5400   edi: 00000000   ebp: c97d5400   esp: c7337ee8
ds: 0018   es: 0018   ss: 0018
Process scsi_eh_1 (pid: 3641, stackpage=3Dc7337000)
Stack: c7337f38 00003296 c3eedc00 ccb5d735 c3eedc00 00000000 00000000 00000=
000=20
       cc8cf4d0 cc8cf9d6 c3eedc00 cc8cf4d0 00000000 00000000 00000000 c7337=
f44=20
       c7337f44 ccb5d910 00000000 00000000 00000000 00000000 00000000 c7337=
f44=20
Call Trace:    [<ccb5d735>] [<cc8cf4d0>] [<cc8cf9d6>] [<cc8cf4d0>] [<ccb5d9=
10>]
  [<cc8cf5f0>] [<cc8d0225>] [<ccb63ae0>] [<cc8d082a>] [<c0108899>] [<c01070=
36>]
  [<cc8d0730>]
Code: 0f b6 50 1b 8b 14 95 bc 46 2a c0 8b ba a0 00 00 00 29 f8 8b=20


>>EIP; ccb5d619 <[aha152x_cs]show_command+19/120>   <=3D=3D=3D=3D=3D

>>ebx; c3eedc00 <_end+3c27744/c601b44>
>>ecx; c9ebe000 <_end+9bf7b44/c601b44>
>>edx; c1f19720 <_end+1c53264/c601b44>
>>esi; c97d5400 <_end+950ef44/c601b44>
>>ebp; c97d5400 <_end+950ef44/c601b44>
>>esp; c7337ee8 <_end+7071a2c/c601b44>

Trace; ccb5d735 <[aha152x_cs]show_queues+15/b0>
Trace; cc8cf4d0 <[scsi_mod]scsi_eh_done+0/50>
Trace; cc8cf9d6 <[scsi_mod]scsi_send_eh_cmnd+96/160>
Trace; cc8cf4d0 <[scsi_mod]scsi_eh_done+0/50>
Trace; ccb5d910 <[aha152x_cs]get_command+140/190>
Trace; cc8cf5f0 <[scsi_mod]scsi_eh_retry_command+70/80>
Trace; cc8d0225 <[scsi_mod]scsi_unjam_host+295/7a0>
Trace; ccb63ae0 <[slhc].rodata.end+a41/1f61>
Trace; cc8d082a <[scsi_mod]scsi_error_handler+fa/160>
Trace; c0108899 <reschedule+5/c>
Trace; c0107036 <kernel_thread+26/30>
Trace; cc8d0730 <[scsi_mod]scsi_error_handler+0/160>

Code;  ccb5d619 <[aha152x_cs]show_command+19/120>
00000000 <_EIP>:
Code;  ccb5d619 <[aha152x_cs]show_command+19/120>   <=3D=3D=3D=3D=3D
   0:   0f b6 50 1b               movzbl 0x1b(%eax),%edx   <=3D=3D=3D=3D=3D
Code;  ccb5d61d <[aha152x_cs]show_command+1d/120>
   4:   8b 14 95 bc 46 2a c0      mov    0xc02a46bc(,%edx,4),%edx
Code;  ccb5d624 <[aha152x_cs]show_command+24/120>
   b:   8b ba a0 00 00 00         mov    0xa0(%edx),%edi
Code;  ccb5d62a <[aha152x_cs]show_command+2a/120>
  11:   29 f8                     sub    %edi,%eax
Code;  ccb5d62c <[aha152x_cs]show_command+2c/120>
  13:   8b 00                     mov    (%eax),%eax


+++++++++++++++++++++++++

ver_linux gives:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
=20
Linux tintin 2.4.19freeswan #4 Sam Aug 24 12:55:14 CEST 2002 i686 unknown
=20
Gnu C                  2.96
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
modutils               2.4.13
e2fsprogs              1.27
reiserfsprogs          3.x.0j
pcmcia-cs              3.1.31
PPP                    2.4.1
isdn4k-utils           3.1pre1
Linux C Library        2.2.4
Dynamic linker (ldd)   2.2.4
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               2.0.11
Modules Loaded         elsa_cs hisax isdn isofs inflate_fs xircom_cb=20
xircom_tulip_cb sr_mod maestro lp parport_pc parport irtty irda serial
 ipt_REJECT ipt_LOG iptable_mangle iptable_nat ip_conntrack iptable_filter
 ip_tables ppp_synctty ppp_async ppp_generic slhc scanner usb-uhci usbcore=20
loop ide-cd cdrom ide-scsi scsi_mod rtc

If you need more information or further tests, pls get back to me.

Klaus
--=20
------------------------------------------------------------------------
 Klaus Lichtenwalder, Dipl. Inform.,       http://www.webforum.de/Klaus/
 Fax +49-(0)89-91072699                            Lichtenwalder@ACM.org
 NIC: KL2100, KL76-RIPE                     K.Lichtenwalder@Computer.org
 PGP Key fingerprint =3D 2658 EA97 E1A1 2680 5ECA  0036 80F5 F250 3CF8
C2C7

--=-ByJ+tHRC4Rn4xr9y3DZS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: Weitere Infos: siehe http://www.gnupg.org

iD8DBQA9cIX7gPXyUDz4wscRAhg+AJoCC+jua2Y+uK465TKfDU2sxfFBOQCfWnmX
89A4f+9VgyfsNwewugjg60s=
=s2gP
-----END PGP SIGNATURE-----

--=-ByJ+tHRC4Rn4xr9y3DZS--

