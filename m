From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: S3 with pata_via fails to resume, ide_via82Cxxx works
Date: Fri, 2 Jan 2009 22:13:53 +0100
Message-ID: <200901022213.53606.bzolnier@gmail.com>
References: <20081230185037.7ec94e94@neptune.home> <20081231201535.4d86c159@neptune.home> <20081231232412.173c87a7@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49617 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZABWdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 17:33:54 -0500
In-Reply-To: <20081231232412.173c87a7@neptune.home>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wednesday 31 December 2008, Bruno Pr=C3=A9mont wrote:
> On Wed, 31 December 2008 Bruno Pr=C3=A9mont wrote:
> > Unfortunately the re-discovery of the drive causes at least XFS to
> > error and shutdown its mounts :(
> >=20
> > Is it possible to block any access to the devices on the scanned po=
rt
> > until the scan has completed? Otherwise this renders rescanning
> > on port with mounted (e.g. /) partition to suicide...
> >=20
> > I also wonder why it took so long and there is that complaint about
> > lost interrupt + failure. Was there some operation in progress that
> > got "killed" by the scan?
>=20
> In addition after a second/third attempt with reboot in between as /
> is no more accessible I ended up with garbage in first sectors of the
> disc!
>=20
> That time I did:
>   cd /sys/class/ide_port/ide0/
>   sync; sleep 1; echo -n 1 > delete_devices; sleep 1; echo -n 1 > sca=
n
>  caused:
>   I/O error for sleep (unknown which one but my guess is it would be
>   the second).
> Previously I just did which only made XFS panic:
>   echo -n 1 > scan
>=20
> Matching kernel logs:
> Dec 31 20:21:59 venus [  246.114799] Probing IDE interface ide0...
> Dec 31 20:21:59 venus [  246.420137] hda: FUJITSU MHY2250BH, ATA DISK=
 drive
> Dec 31 20:22:00 venus [  246.780071] hda: host max PIO5 wanted PIO255=
(auto-tune) selected PIO4
> Dec 31 20:22:00 venus [  246.780621] hda: UDMA/100 mode selected
> Dec 31 20:22:19 venus [  266.100064] hda: dma_timer_expiry: DMA statu=
s (0x20)
> Dec 31 20:22:19 venus [  266.100388] hda: lost interrupt
> Dec 31 20:22:19 venus [  266.100588] hda: ide_dma_intr: bad DMA statu=
s (0x30)
> Dec 31 20:22:19 venus [  266.100886] hda: dma_intr: status=3D0x50 { D=
riveReady SeekComplete }
> Dec 31 20:22:19 venus [  266.101298] ide: failed opcode was: unknown
> Dec 31 20:22:19 venus [  266.454984] hda: max request size: 512KiB
> Dec 31 20:22:19 venus [  266.455254] hda: 488397168 sectors (250059 M=
B) w/8192KiB Cache, CHS=3D30401/255/63
> Dec 31 20:22:19 venus [  266.455972] hda: cache flushes supported
> Dec 31 20:22:19 venus [  266.493825] request_module: runaway loop mod=
probe binfmt-0000
> Dec 31 20:22:19 venus [  266.494218] request_module: runaway loop mod=
probe binfmt-0000
> Dec 31 20:22:19 venus [  266.494933] request_module: runaway loop mod=
probe binfmt-0000
> Dec 31 20:22:19 venus [  266.495294] request_module: runaway loop mod=
probe binfmt-0000
> Dec 31 20:22:19 venus [  266.496303] request_module: runaway loop mod=
probe binfmt-0000
> Dec 31 20:25:07 venus [  432.720055] INFO: task udevd:630 blocked for=
 more than 120 seconds.
> Dec 31 20:25:07 venus [  432.720308] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
> Dec 31 20:25:07 venus [  432.720637] udevd         D c0249ea0  2572  =
 630      1
> Dec 31 20:25:07 venus [  432.720867]  f6903e18 00000086 c024b74d c024=
9ea0 f6903e04 f70c2d80 f6903e0c c0249e9c
> Dec 31 20:25:07 venus [  432.721233]  f6903e50 f6d79818 f6903e58 f690=
3e20 c03e675e f6903e28 c01487d5 f6903e44
> Dec 31 20:25:07 venus [  432.721580]  c03e6a7f c01487a0 c17821b0 f690=
3e50 f6d79818 00000000 f6903e70 c01477b8
> Dec 31 20:25:07 venus [  432.721928] Call Trace:
> Dec 31 20:25:07 venus [  432.722036]  [<c024b74d>] ? __generic_unplug=
_device+0x1d/0x30
> Dec 31 20:25:07 venus [  432.722245]  [<c0249ea0>] ? blk_backing_dev_=
unplug+0x0/0x10
> Dec 31 20:25:07 venus [  432.722446]  [<c0249e9c>] ? blk_unplug+0xc/0=
x10
> Dec 31 20:25:07 venus [  432.722619]  [<c03e675e>] io_schedule+0xe/0x=
20
> Dec 31 20:25:07 venus [  432.722788]  [<c01487d5>] sync_page+0x35/0x4=
0
> Dec 31 20:25:07 venus [  432.722949]  [<c03e6a7f>] __wait_on_bit_lock=
+0x3f/0x70
> Dec 31 20:25:07 venus [  432.723135]  [<c01487a0>] ? sync_page+0x0/0x=
40
> Dec 31 20:25:07 venus [  432.723299]  [<c01477b8>] __lock_page+0x68/0=
x70
> Dec 31 20:25:07 venus [  432.730742]  [<c01315e0>] ? wake_bit_functio=
n+0x0/0x60
> Dec 31 20:25:07 venus [  432.738085]  [<c014783b>] find_lock_page+0x4=
b/0x60
> Dec 31 20:25:07 venus [  432.745577]  [<c0148b17>] filemap_fault+0x29=
7/0x3a0
> Dec 31 20:25:07 venus [  432.753061]  [<c025437e>] ? prio_tree_insert=
+0x1e/0x240
> Dec 31 20:25:07 venus [  432.760556]  [<c015548b>] __do_fault+0x3b/0x=
390
> Dec 31 20:25:07 venus [  432.767962]  [<c0152502>] ? vma_prio_tree_in=
sert+0x22/0x40
> Dec 31 20:25:07 venus [  432.775508]  [<c015907d>] ? vma_link+0x3d/0x=
50
> Dec 31 20:25:07 venus [  432.782967]  [<c0155eb5>] handle_mm_fault+0x=
e5/0x570
> Dec 31 20:25:07 venus [  432.790448]  [<c0116ac0>] ? do_page_fault+0x=
0/0x670
> Dec 31 20:25:07 venus [  432.797882]  [<c0116d2c>] do_page_fault+0x26=
c/0x670
> Dec 31 20:25:07 venus [  432.805292]  [<c0258985>] ? copy_to_user+0x3=
5/0x50
> Dec 31 20:25:07 venus [  432.812644]  [<c0116ac0>] ? do_page_fault+0x=
0/0x670
> Dec 31 20:25:07 venus [  432.819910]  [<c03e7a7a>] error_code+0x6a/0x=
70
> Dec 31 20:25:07 venus [  432.827132] INFO: task bash:1918 blocked for=
 more than 120 seconds.
> Dec 31 20:25:07 venus [  432.834416] "echo 0 > /proc/sys/kernel/hung_=
task_timeout_secs" disables this message.
> Dec 31 20:25:07 venus [  432.841880] bash          D f70081fc  2504  =
1918   1863
> Dec 31 20:25:07 venus [  432.849416]  f730ae4c 00000086 f7033fac f700=
81fc 00000000 f711db00 c011c3ab f730ae50
> Dec 31 20:25:07 venus [  432.857217]  7fffffff f730aed4 00000002 f730=
ae94 c03e68a5 c011bede 00000000 00000001
> Dec 31 20:25:07 venus [  432.865082]  00000003 f7008208 00000000 0000=
0082 f700a0a0 f730ae8c 00000082 00000000
> Dec 31 20:25:07 venus [  432.873032] Call Trace:
> Dec 31 20:25:07 venus [  432.880908]  [<c011c3ab>] ? default_wake_fun=
ction+0xb/0x10
> Dec 31 20:25:07 venus [  432.889004]  [<c03e68a5>] schedule_timeout+0=
x75/0xc0
> Dec 31 20:25:07 venus [  432.897171]  [<c011bede>] ? __wake_up_common=
+0x3e/0x70
> Dec 31 20:25:07 venus [  432.905391]  [<c03e63a3>] wait_for_common+0x=
93/0x110
> Dec 31 20:25:07 venus [  432.913587]  [<c011c3a0>] ? default_wake_fun=
ction+0x0/0x10
> Dec 31 20:25:07 venus [  432.921818]  [<c03e64b2>] wait_for_completio=
n+0x12/0x20
> Dec 31 20:25:07 venus [  432.930167]  [<c012de8b>] call_usermodehelpe=
r_exec+0xab/0xc0
> Dec 31 20:25:07 venus [  432.938491]  [<c012e0ce>] request_module+0x9=
e/0xe0
> Dec 31 20:25:07 venus [  432.946793]  [<c016e462>] search_binary_hand=
ler+0x192/0x1f0
> Dec 31 20:25:07 venus [  432.955084]  [<c016f613>] do_execve+0x163/0x=
1b0
> Dec 31 20:25:07 venus [  432.963311]  [<c010261e>] sys_execve+0x2e/0x=
60
> Dec 31 20:25:07 venus [  432.971452]  [<c0103b01>] sysenter_do_call+0=
x12/0x25
>=20
> I guess the binfmt-0000 is cause by XFS reading at wrong location on =
disc
> and kernel seeing random data as bin format signature.
>=20
>=20
> On reboot no more bootloader.
> hexdump with rescue system showed XFS magic in very first sector of t=
he
> disc, (rescuing the GPT worked - I assume parted used copy at end
> of disc) though the first partition also got corrupted.
>=20
> This looks like the scan is pretty dangerous in case anything has a
> reference to a disc/partition on the scanned channel :(

I'm really sorry to hear it but "delete_devices" / "scan" interfaces ar=
e
currently not ready for use on actively used devices (there are still s=
ome
locking issues with the core code that need to be addressed before this
can be allowed).

Even though HOWTO only mentions use for replacing devices (not rescanin=
g)
I admit that it should be more clear about the above:

=46rom: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: update warm-plug HOWTO

Reported-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide/warm-plug-howto.txt |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/Documentation/ide/warm-plug-howto.txt
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/Documentation/ide/warm-plug-howto.txt
+++ b/Documentation/ide/warm-plug-howto.txt
@@ -11,3 +11,8 @@ unplug old device(s) and plug new device
 # echo -n "1" > /sys/class/ide_port/idex/scan
=20
 done
+
+NOTE: please make sure that partitions are unmounted and that there ar=
e
+no other active references to devices before doing "delete_devices" st=
ep,
+also do not attempt "scan" step on devices currently in use -- otherwi=
se
+results may be unpredictable and lead to data loss if you're unlucky
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
