From: Mateusz.Blaszczyk@nask.pl
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Thu, 21 Oct 2004 11:28:30 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0410211123290.5705@boromir>
References: <Pine.LNX.4.44L0.0410181129520.1194-100000@ida.rowland.org>
Reply-To: Mateusz.Blaszczyk@nask.pl
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from boromix.nask.net.pl ([195.187.245.33]:61590 "EHLO
	boromix.nask.net.pl") by vger.kernel.org with ESMTP id S268961AbUJUJ24
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 05:28:56 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410181129520.1194-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net, linux-usb-users@lists.sourceforge.net, linux-usb-devel@lists.sourceforge.net

uOn , 18 Oct 2004, Alan Stern wrote:

> On Mon, 18 Oct 2004 Mateusz.Blaszczyk@nask.pl wrote:
>
> > Hi,

Hello!

> >
> > After successful write on USB DVD-R writer (HP-200j), system oops's=
 when unpluging USB device.
> > Same thing with 2.6.9-rc2mm1.
>
> Try applying this patch:
>
> http://marc.theaimsgroup.com/?l=3Dlinux-usb-devel&m=3D109744234829347=
&q=3Draw

Patch applied.
I have done the tests at still no good.
I connected and disconnected the writer a couple of times. WHen I didn'=
t
read/write on the CD there is no OOPS when disconnecting. But after rea=
ding CD
there was OOPS when disconnecting. See below. Decoded OOPS - see more b=
elow.

------------------------------------- OOOPS ---------------------------=
-----
Oct 21 10:02:05 localhost kernel: cfq: depth 4 reached, tagging now on
Oct 21 10:58:21 localhost kernel: usb 2-1: USB disconnect, address 2
Oct 21 10:58:28 localhost kernel: usb 1-1: new high speed USB device us=
ing address 3
Oct 21 10:58:29 localhost kernel: Initializing USB Mass Storage driver.=
=2E.
Oct 21 10:58:29 localhost kernel: scsi0 : SCSI emulation for USB Mass S=
torage devices
Oct 21 10:58:29 localhost kernel: usbcore: registered new driver usb-st=
orage
Oct 21 10:58:29 localhost kernel: USB Mass Storage support registered.
Oct 21 10:58:29 localhost kernel: usb-storage: device found at 3
Oct 21 10:58:29 localhost kernel: usb-storage: waiting for device to se=
ttle before scanning
Oct 21 10:58:34 localhost kernel:   Vendor: HP        Model: DVD Writer=
 200j   Rev: 1.06
Oct 21 10:58:34 localhost kernel:   Type:   CD-ROM                     =
        ANSI SCSI revision: 00
Oct 21 10:58:34 localhost kernel: Attached scsi generic sg0 at scsi0, c=
hannel 0, id 0, lun 0,  type 5
Oct 21 10:58:34 localhost kernel: usb-storage: device scan complete
Oct 21 10:58:35 localhost kernel: sr0: scsi-1 drive
Oct 21 10:58:35 localhost kernel: Attached scsi CD-ROM sr0 at scsi0, ch=
annel 0, id 0, lun 0
Oct 21 10:59:01 localhost kernel: usb 1-1: USB disconnect, address 3
Oct 21 10:59:45 localhost kernel: usb 1-1: new high speed USB device us=
ing address 4
Oct 21 10:59:45 localhost kernel: scsi1 : SCSI emulation for USB Mass S=
torage devices
Oct 21 10:59:45 localhost kernel: usb-storage: device found at 4
Oct 21 10:59:45 localhost kernel: usb-storage: waiting for device to se=
ttle before scanning
Oct 21 10:59:50 localhost kernel:   Vendor: HP        Model: DVD Writer=
 200j   Rev: 1.06
Oct 21 10:59:50 localhost kernel:   Type:   CD-ROM                     =
        ANSI SCSI revision: 00
Oct 21 10:59:50 localhost kernel: sr0: scsi3-mmc drive: 32x/32x writer =
cd/rw xa/form2 cdda tray
Oct 21 10:59:50 localhost kernel: Attached scsi CD-ROM sr0 at scsi1, ch=
annel 0, id 0, lun 0
Oct 21 10:59:50 localhost kernel: Attached scsi generic sg0 at scsi1, c=
hannel 0, id 0, lun 0,  type 5
Oct 21 10:59:50 localhost kernel: usb-storage: device scan complete
Oct 21 11:00:40 localhost kernel: cdrom: sr0: mmc-3 profile capable, cu=
rrent profile: 8h
Oct 21 11:00:40 localhost kernel: cdrom: sr0: mmc-3 profile capable, cu=
rrent profile: 8h
Oct 21 11:00:42 localhost kernel: ISO 9660 Extensions: Microsoft Joliet=
 Level 3
Oct 21 11:00:42 localhost kernel: ISOFS: changing to secondary root
Oct 21 11:01:26 localhost kernel: usb 1-1: USB disconnect, address 4
Oct 21 11:02:32 localhost kernel: usb 1-1: new high speed USB device us=
ing address 5
Oct 21 11:02:33 localhost kernel: scsi2 : SCSI emulation for USB Mass S=
torage devices
Oct 21 11:02:33 localhost kernel: usb-storage: device found at 5
Oct 21 11:02:33 localhost kernel: usb-storage: waiting for device to se=
ttle before scanning
Oct 21 11:02:38 localhost kernel:   Vendor: HP        Model: DVD Writer=
 200j   Rev: 1.06
Oct 21 11:02:38 localhost kernel:   Type:   CD-ROM                     =
        ANSI SCSI revision: 00
Oct 21 11:02:38 localhost kernel: sr0: scsi3-mmc drive: 32x/32x writer =
cd/rw xa/form2 cdda tray
Oct 21 11:02:38 localhost kernel: Attached scsi CD-ROM sr0 at scsi2, ch=
annel 0, id 0, lun 0
Oct 21 11:02:38 localhost kernel: Attached scsi generic sg0 at scsi2, c=
hannel 0, id 0, lun 0,  type 5
Oct 21 11:02:38 localhost kernel: usb-storage: device scan complete
Oct 21 11:02:46 localhost kernel: cdrom: sr0: mmc-3 profile capable, cu=
rrent profile: Ah
Oct 21 11:02:46 localhost kernel: cdrom: sr0: mmc-3 profile capable, cu=
rrent profile: Ah
Oct 21 11:02:48 localhost kernel: UDF-fs INFO UDF 0.9.8.1 (2004/29/09) =
Mounting volume 'LinuxUDF', timestamp 2004/09/21 16:52 (1078)
Oct 21 11:04:10 localhost kernel: cdrom: open failed.
Oct 21 11:04:27 localhost kernel: pktcdvd: writer pktcdvd0 unmapped
Oct 21 11:07:14 localhost kernel: cdrom: This disc doesn't have any tra=
cks I recognize!
Oct 21 11:08:00 localhost kernel: cdrom: This disc doesn't have any tra=
cks I recognize!
Oct 21 11:09:06 localhost kernel: usb 1-1: USB disconnect, address 5
Oct 21 11:09:06 localhost kernel:  target2:0:0: Illegal state transitio=
n <NULL>->cancel
Oct 21 11:09:06 localhost kernel: Badness in scsi_device_set_state at d=
rivers/scsi/scsi_lib.c:1713
Oct 21 11:09:07 localhost kernel:  [scsi_device_set_state+199/210] scsi=
_device_set_state+0xc7/0xd2
Oct 21 11:09:07 localhost kernel:  [scsi_device_cancel+38/257] scsi_dev=
ice_cancel+0x26/0x101
Oct 21 11:09:07 localhost kernel:  [scsi_device_cancel_cb+0/12] scsi_de=
vice_cancel_cb+0x0/0xc
Oct 21 11:09:07 localhost kernel:  [device_for_each_child+52/91] device=
_for_each_child+0x34/0x5b
Oct 21 11:09:07 localhost kernel:  [scsi_host_cancel+37/176] scsi_host_=
cancel+0x25/0xb0
Oct 21 11:09:07 localhost kernel:  [dput+27/569] dput+0x1b/0x239
Oct 21 11:09:07 localhost kernel:  [device_del+101/117] device_del+0x65=
/0x75
Oct 21 11:09:07 localhost kernel:  [scsi_remove_device+112/128] scsi_re=
move_device+0x70/0x80
Oct 21 11:09:07 localhost kernel:  [scsi_forget_host+112/140] scsi_forg=
et_host+0x70/0x8c
Oct 21 11:09:07 localhost kernel:  [scsi_remove_host+17/75] scsi_remove=
_host+0x11/0x4b
Oct 21 11:09:07 localhost kernel:  [pg0+268412400/1068979200] storage_d=
isconnect+0x6f/0x7e [usb_storage]
Oct 21 11:09:07 localhost kernel:  [usb_unbind_interface+51/94] usb_unb=
ind_interface+0x33/0x5e
Oct 21 11:09:07 localhost kernel:  [device_release_driver+60/70] device=
_release_driver+0x3c/0x46
Oct 21 11:09:07 localhost kernel:  [bus_remove_device+63/118] bus_remov=
e_device+0x3f/0x76
Oct 21 11:09:07 localhost kernel:  [device_del+86/117] device_del+0x56/=
0x75
Oct 21 11:09:07 localhost kernel:  [usb_disable_device+96/200] usb_disa=
ble_device+0x60/0xc8
Oct 21 11:09:07 localhost kernel:  [usb_disconnect+155/291] usb_disconn=
ect+0x9b/0x123
Oct 21 11:09:07 localhost kernel:  [hub_port_connect_change+96/795] hub=
_port_connect_change+0x60/0x31b
Oct 21 11:09:07 localhost kernel:  [hub_events+599/771] hub_events+0x25=
7/0x303
Oct 21 11:09:07 localhost kernel:  [prepare_to_wait+76/104] prepare_to_=
wait+0x4c/0x68
Oct 21 11:09:07 localhost kernel:  [hub_thread+0/242] hub_thread+0x0/0x=
f2
Oct 21 11:09:07 localhost kernel:  [hub_thread+30/242] hub_thread+0x1e/=
0xf2
Oct 21 11:09:07 localhost kernel:  [autoremove_wake_function+0/45] auto=
remove_wake_function+0x0/0x2d
Oct 21 11:09:07 localhost kernel:  [hub_thread+0/242] hub_thread+0x0/0x=
f2
Oct 21 11:09:07 localhost kernel:  [autoremove_wake_function+0/45] auto=
remove_wake_function+0x0/0x2d
Oct 21 11:09:07 localhost kernel:  [kernel_thread_helper+5/11] kernel_t=
hread_helper+0x5/0xb
Oct 21 11:09:07 localhost kernel: Unable to handle kernel NULL pointer =
dereference at virtual address 000000b0
Oct 21 11:09:07 localhost kernel:  printing eip:
Oct 21 11:09:07 localhost kernel: c0252893
Oct 21 11:09:07 localhost kernel: *pde =3D 00000000
Oct 21 11:09:07 localhost kernel: Oops: 0000 [#1]
Oct 21 11:09:07 localhost kernel: PREEMPT
Oct 21 11:09:07 localhost kernel: Modules linked in: udf isofs zlib_inf=
late sr_mod usb_storage nls_cp852 nls_iso8859_2 smbfs nls_base i830 pkt=
cdvd lp button processor ac battery ipt_REJECT ipt_pkttype ipt_LOG ipt_=
state ipt_multiport ipt_conntrack iptable_mangle ip_nat_irc ip_nat_tftp=
 ip_nat_ftp iptable_nat ip_conntrack_irc ip_conntrack_tftp ip_conntrack=
_ftp ip_conntrack iptable_filter ip_tables usbhid ipw2100 ieee80211 iee=
e80211_crypt 8139too mii crc32 hw_random intel_agp agpgart parport_pc p=
arport irtty_sir sir_dev pcspkr
Oct 21 11:09:07 localhost kernel: CPU:    0
Oct 21 11:09:07 localhost kernel: EIP:    0060:[scsi_device_cancel+81/2=
57]    Not tainted VLI
Oct 21 11:09:07 localhost kernel: EFLAGS: 00010006   (2.6.9-rc4mm1)
Oct 21 11:09:07 localhost kernel: EIP is at scsi_device_cancel+0x51/0x1=
01
Oct 21 11:09:07 localhost kernel: eax: 00000074   ebx: c03e6d68   ecx: =
00000001   edx: c03e6d78
Oct 21 11:09:07 localhost kernel: esi: cf482480   edi: c13d1e70   ebp: =
00000286   esp: c13d1e6c
Oct 21 11:09:07 localhost kernel: ds: 007b   es: 007b   ss: 0068
Oct 21 11:09:07 localhost kernel: Process khubd (pid: 145, threadinfo=3D=
c13d0000 task=3Dc12655a0)
Oct 21 11:09:07 localhost kernel: Stack: 00000000 c13d1e70 c13d1e70 cf4=
82604 cefbb0b4 c03e1008 c0252982 c023414f
Oct 21 11:09:07 localhost kernel:        c13d1ea4 cefbb000 d048e700 ce3=
432c0 cf4641c0 c02529b3 00000000 c8e06494
Oct 21 11:09:07 localhost kernel:        c0159d5c ce1361a8 cf482604 ce1=
36184 ce136184 cf482604 c02340fb ce136000
Oct 21 11:09:07 localhost kernel: Call Trace:
Oct 21 11:09:07 localhost kernel:  [scsi_device_cancel_cb+0/12] scsi_de=
vice_cancel_cb+0x0/0xc
Oct 21 11:09:07 localhost kernel:  [device_for_each_child+52/91] device=
_for_each_child+0x34/0x5b
Oct 21 11:09:07 localhost kernel:  [scsi_host_cancel+37/176] scsi_host_=
cancel+0x25/0xb0
Oct 21 11:09:07 localhost kernel:  [dput+27/569] dput+0x1b/0x239
Oct 21 11:09:07 localhost kernel:  [device_del+101/117] device_del+0x65=
/0x75
Oct 21 11:09:07 localhost kernel:  [scsi_remove_device+112/128] scsi_re=
move_device+0x70/0x80
Oct 21 11:09:07 localhost kernel:  [scsi_forget_host+112/140] scsi_forg=
et_host+0x70/0x8c
Oct 21 11:09:07 localhost kernel:  [scsi_remove_host+17/75] scsi_remove=
_host+0x11/0x4b
Oct 21 11:09:07 localhost kernel:  [pg0+268412400/1068979200] storage_d=
isconnect+0x6f/0x7e [usb_storage]
Oct 21 11:09:07 localhost kernel:  [usb_unbind_interface+51/94] usb_unb=
ind_interface+0x33/0x5e
Oct 21 11:09:07 localhost kernel:  [device_release_driver+60/70] device=
_release_driver+0x3c/0x46
Oct 21 11:09:07 localhost kernel:  [bus_remove_device+63/118] bus_remov=
e_device+0x3f/0x76
Oct 21 11:09:07 localhost kernel:  [device_del+86/117] device_del+0x56/=
0x75
Oct 21 11:09:07 localhost kernel:  [usb_disable_device+96/200] usb_disa=
ble_device+0x60/0xc8
Oct 21 11:09:07 localhost kernel:  [usb_disconnect+155/291] usb_disconn=
ect+0x9b/0x123
Oct 21 11:09:07 localhost kernel:  [hub_port_connect_change+96/795] hub=
_port_connect_change+0x60/0x31b
Oct 21 11:09:07 localhost kernel:  [hub_events+599/771] hub_events+0x25=
7/0x303
Oct 21 11:09:07 localhost kernel:  [prepare_to_wait+76/104] prepare_to_=
wait+0x4c/0x68
Oct 21 11:09:07 localhost kernel:  [hub_thread+0/242] hub_thread+0x0/0x=
f2
Oct 21 11:09:07 localhost kernel:  [hub_thread+30/242] hub_thread+0x1e/=
0xf2
Oct 21 11:09:07 localhost kernel:  [autoremove_wake_function+0/45] auto=
remove_wake_function+0x0/0x2d
Oct 21 11:09:07 localhost kernel:  [hub_thread+0/242] hub_thread+0x0/0x=
f2
Oct 21 11:09:07 localhost kernel:  [autoremove_wake_function+0/45] auto=
remove_wake_function+0x0/0x2d
Oct 21 11:09:07 localhost kernel:  [kernel_thread_helper+5/11] kernel_t=
hread_helper+0x5/0xb
Oct 21 11:09:07 localhost kernel: Code: 9c 5d fa b8 01 00 00 00 e8 b6 1=
c ec ff 8b 56 1c 8d 5a f0 8b 43 10 0f 18 00 90 8d 46 1c 39 c2 74 40 8b =
83 b8 00 00 00 85 c0 74 22 <83> 78 3c ff 74 1c 89 d8 e8 4e 16 00 00 85 =
c0 74 11 89 7b 18 8b
Oct 21 11:09:07 localhost kernel:  <6>note: khubd[145] exited with pree=
mpt_count 1
------------------------- END OF OOPS ---------------------------------=
-----

------------------------- DECODED OOPS --------------------------------=
---------
ksymoops 2.4.9 on i686 2.6.9-rc4mm1.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.9-rc4mm1/ (default)
     -m /boot/System.map-2.6.9-rc4mm1 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Oct 21 08:36:08 localhost kernel: cs: IO port probe 0x0a00-0x0aff: clea=
n.
Oct 21 11:09:07 localhost kernel: Unable to handle kernel NULL pointer =
dereference at virtual address 000000b0
Oct 21 11:09:07 localhost kernel: c0252893
Oct 21 11:09:07 localhost kernel: *pde =3D 00000000
Oct 21 11:09:07 localhost kernel: Oops: 0000 [#1]
Oct 21 11:09:07 localhost kernel: CPU:    0
Oct 21 11:09:07 localhost kernel: EIP:    0060:[scsi_device_cancel+81/2=
57]    Not tainted VLI
Oct 21 11:09:07 localhost kernel: EFLAGS: 00010006   (2.6.9-rc4mm1)
Oct 21 11:09:07 localhost kernel: eax: 00000074   ebx: c03e6d68   ecx: =
00000001   edx: c03e6d78
Oct 21 11:09:07 localhost kernel: esi: cf482480   edi: c13d1e70   ebp: =
00000286   esp: c13d1e6c
Oct 21 11:09:07 localhost kernel: ds: 007b   es: 007b   ss: 0068
Oct 21 11:09:07 localhost kernel: Stack: 00000000 c13d1e70 c13d1e70 cf4=
82604 cefbb0b4 c03e1008 c0252982 c023414f
Oct 21 11:09:07 localhost kernel:        c13d1ea4 cefbb000 d048e700 ce3=
432c0 cf4641c0 c02529b3 00000000 c8e06494
Oct 21 11:09:07 localhost kernel:        c0159d5c ce1361a8 cf482604 ce1=
36184 ce136184 cf482604 c02340fb ce136000
Oct 21 11:09:07 localhost kernel: Call Trace:
Warning (Oops_read): Code line not seen, dumping what data is available


>>ebx; c03e6d68 <vperfctrfs_type+8/20>
>>edx; c03e6d78 <vperfctrfs_type+18/20>
>>esi; cf482480 <pg0+eff9480/3fb75400>
>>edi; c13d1e70 <pg0+f48e70/3fb75400>
>>esp; c13d1e6c <pg0+f48e6c/3fb75400>

Oct 21 11:09:07 localhost kernel: Code: 9c 5d fa b8 01 00 00 00 e8 b6 1=
c ec ff 8b 56 1c 8d 5a f0 8b 43 10 0f 18 00 90 8d 46 1c 39 c2 74 40 8b =
83 b8 00 00 00 85 c0 74 22 <83> 78 3c ff 74 1c 89 d8 e8 4e 16 00 00 85 =
c0 74 11 89 7b 18 8b
Using defaults from ksymoops -t elf32-i386 -a i386


Code;  ffffffd5 <__kernel_rt_sigreturn+1b95/????>
00000000 <_EIP>:
Code;  ffffffd5 <__kernel_rt_sigreturn+1b95/????>
   0:   9c                        pushf
Code;  ffffffd6 <__kernel_rt_sigreturn+1b96/????>
   1:   5d                        pop    %ebp
Code;  ffffffd7 <__kernel_rt_sigreturn+1b97/????>
   2:   fa                        cli
Code;  ffffffd8 <__kernel_rt_sigreturn+1b98/????>
   3:   b8 01 00 00 00            mov    $0x1,%eax
Code;  ffffffdd <__kernel_rt_sigreturn+1b9d/????>
   8:   e8 b6 1c ec ff            call   ffec1cc3 <_EIP+0xffec1cc3>
Code;  ffffffe2 <__kernel_rt_sigreturn+1ba2/????>
   d:   8b 56 1c                  mov    0x1c(%esi),%edx
Code;  ffffffe5 <__kernel_rt_sigreturn+1ba5/????>
  10:   8d 5a f0                  lea    0xfffffff0(%edx),%ebx
Code;  ffffffe8 <__kernel_rt_sigreturn+1ba8/????>
  13:   8b 43 10                  mov    0x10(%ebx),%eax
Code;  ffffffeb <__kernel_rt_sigreturn+1bab/????>
  16:   0f 18 00                  prefetchnta (%eax)
Code;  ffffffee <__kernel_rt_sigreturn+1bae/????>
  19:   90                        nop
Code;  ffffffef <__kernel_rt_sigreturn+1baf/????>
  1a:   8d 46 1c                  lea    0x1c(%esi),%eax
Code;  fffffff2 <__kernel_rt_sigreturn+1bb2/????>
  1d:   39 c2                     cmp    %eax,%edx
Code;  fffffff4 <__kernel_rt_sigreturn+1bb4/????>
  1f:   74 40                     je     61 <_EIP+0x61>
Code;  fffffff6 <__kernel_rt_sigreturn+1bb6/????>
  21:   8b 83 b8 00 00 00         mov    0xb8(%ebx),%eax
Code;  fffffffc <__kernel_rt_sigreturn+1bbc/????>
  27:   85 c0                     test   %eax,%eax
Code;  fffffffe <__kernel_rt_sigreturn+1bbe/????>
  29:   74 22                     je     4d <_EIP+0x4d>
Code;  00000000 Before first symbol
  2b:   83 78 3c ff               cmpl   $0xffffffff,0x3c(%eax)
Code;  00000004 Before first symbol
  2f:   74 1c                     je     4d <_EIP+0x4d>
Code;  00000006 Before first symbol
  31:   89 d8                     mov    %ebx,%eax
Code;  00000008 Before first symbol
  33:   e8 4e 16 00 00            call   1686 <_EIP+0x1686>
Code;  0000000d Before first symbol
  38:   85 c0                     test   %eax,%eax
Code;  0000000f Before first symbol
  3a:   74 11                     je     4d <_EIP+0x4d>
Code;  00000011 Before first symbol
  3c:   89 7b 18                  mov    %edi,0x18(%ebx)
Code;  00000014 Before first symbol
  3f:   8b                        .byte 0x8b


2 warnings and 1 error issued.  Results may not be reliable.
--------------------------------- END OF DECODED OOPS -----------------=
---------


>
> Alan Stern
>

-mat

--=20
Pozdrowienia,Regards,Cheers,Gr=FC=DFe,A plus!,
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
