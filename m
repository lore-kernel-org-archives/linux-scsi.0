From: Greg KH <greg@kroah.com>
Subject: Re: oops on usb storage device disconnect with 2.6.14-rc1
Date: Sun, 18 Sep 2005 15:34:15 -0700
Message-ID: <20050918223415.GA9437@kroah.com>
References: <20050915190338.GA6807@kroah.com> <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org> <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave> <1126818483.4821.60.camel@mulgrave> <20050915221946.GA28441@us.ibm.com> <1126823917.4821.70.camel@mulgrave> <1127003717.4794.10.camel@mulgrave> <1127073920.4847.34.camel@mulgrave> <20050918220126.GA6317@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20050918220126.GA6317@kroah.com>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 18, 2005 at 03:01:26PM -0700, Greg KH wrote:
> On Sun, Sep 18, 2005 at 03:05:20PM -0500, James Bottomley wrote:
> > On Sat, 2005-09-17 at 19:35 -0500, James Bottomley wrote:
> > > The attached should be that patch with the race window closed.
> > 
> > There's a big oops in this one (and there was when greg tested it).  The
> > state checker is reversed (it's checking !scsi_host_set_state() for
> > indicating a problem ... of course, the return is 0 on success or
> > error).  I've corrected this; Greg, could you retest? 
> 
> Should I apply any additional patches too?  Or just this one will
> suffice?

Seems to not oops on removal anymore, but I can't rmmod usb-storage
anymore.  SysRq-T output below of possibly relevant processes.

thanks,

greg k-h


[  390.334608] kblockd/0     S C03FA2F0     0    77      5           112     7 (L-TLB)
[  390.334664] d6ebbf40 d6fc5a70 c03d93e0 c03fa2f0 d19a4c64 c03fa260 00000000 00000096 
[  390.334700]        d6ca7e34 d6fc5070 000041f4 4f2930e3 0000004e d6fc5a70 d6fc5b98 00000286 
[  390.334746]        d6ca7da0 d6f37ea8 c0258490 c0129c09 00000000 d6ebbf6c 00000000 d6f37eb8 
[  390.334792] Call Trace:
[  390.334888]  [<c0258490>] blk_unplug_work+0x0/0x10
[  390.334918]  [<c0129c09>] worker_thread+0x229/0x260
[  390.334956]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.334987]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.335018]  [<c01299e0>] worker_thread+0x0/0x260
[  390.335301]  [<c012db19>] kthread+0xa9/0xf0
[  390.335331]  [<c012da70>] kthread+0x0/0xf0
[  390.335356]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.335407] pdflush       S D6FDA550     0   112      5           113    77 (L-TLB)
[  390.335463] d6efbf78 d6fc5570 c03d93e0 d6fda550 c03d9410 00000002 d6fda550 d6efbf68 
[  390.335501]        d6fc5570 d6fc5070 000006ff ab42be82 00000002 d6fc5570 d6fc5698 d6efbfa8 
[  390.335543]        d6efbf9c d6efa000 c0141620 c0141509 d6efa000 d6efa000 d6f9ff74 00000000 
[  390.335588] Call Trace:
[  390.335617]  [<c0141620>] pdflush+0x0/0x30
[  390.335643]  [<c0141509>] __pdflush+0x79/0x190
[  390.335669]  [<c0141646>] pdflush+0x26/0x30
[  390.335699]  [<c0141620>] pdflush+0x0/0x30
[  390.335720]  [<c012db19>] kthread+0xa9/0xf0
[  390.335747]  [<c012da70>] kthread+0x0/0xf0
[  390.335771]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.335816] pdflush       S 00000400     0   113      5           115   112 (L-TLB)
[  390.335870] d6efdf78 d6fc5070 c03d93e0 00000400 00000000 00000000 00000000 00000000 
[  390.335902]        00000000 00000005 00002e27 f3f1df78 00000059 d6fc5070 d6fc5198 d6efdfa8 
[  390.336243]        d6efdf9c d6efc000 c0141620 c0141509 00000000 d6efc000 d6f9ff74 00000000 
[  390.336289] Call Trace:
[  390.336320]  [<c0141620>] pdflush+0x0/0x30
[  390.336344]  [<c0141509>] __pdflush+0x79/0x190
[  390.336369]  [<c0141646>] pdflush+0x26/0x30
[  390.336398]  [<c0141620>] pdflush+0x0/0x30
[  390.336419]  [<c012db19>] kthread+0xa9/0xf0
[  390.336447]  [<c012da70>] kthread+0x0/0xf0
[  390.336471]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.336518] aio/0         S 00000002     0   115      5           706   113 (L-TLB)
[  390.336575] d6c01f40 d6fdaa50 c03d9410 00000002 00000000 ab76da12 00000002 00004fa7 
[  390.336609]        00000000 d6fdaa50 00001a15 ab7796b9 00000002 d6f44590 d6f446b8 d6c00000 
[  390.336647]        00000000 00010000 00000000 c0129c09 00000011 d6c01f6c 00000000 d6f37858 
[  390.336685] Call Trace:
[  390.336714]  [<c0129c09>] worker_thread+0x229/0x260
[  390.336751]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.336781]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.336812]  [<c01299e0>] worker_thread+0x0/0x260
[  390.336836]  [<c012db19>] kthread+0xa9/0xf0
[  390.336864]  [<c012da70>] kthread+0x0/0xf0
[  390.336888]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.336932] kswapd0       S C033A760     0   114      1           743     5 (L-TLB)
[  390.336987] d6efff80 d6f44a90 c03d93e0 c033a760 c01239c0 c033a760 d6efe000 c0334418 
[  390.337024]        d6fd42f8 c011bcc5 0000efca abcb3a68 00000002 d6f44a90 d6f44bb8 d6efe000 
[  390.337062]        00000000 c033b634 c033b260 c0146d45 c0307f9d 00000000 d6f44a90 00000000 
[  390.337101] Call Trace:
[  390.337120]  [<c01239c0>] switch_uid+0x40/0x60
[  390.337146]  [<c011bcc5>] daemonize+0x1d5/0x250
[  390.337180]  [<c0146d45>] kswapd+0x115/0x120
[  390.337210]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.337242]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.337271]  [<c0146c30>] kswapd+0x0/0x120
[  390.337296]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.337340] kseriod       S C034D048     0   706      5          1217   115 (L-TLB)
[  390.337396] d6c27f60 d6f44090 c03d93e0 c034d048 d6c27f8c c012df40 d6c26000 c0251aed 
[  390.337432]        c034d048 c0251a90 00004dd7 a9736cf6 00000003 d6f44090 d6f441b8 d6c26000 
[  390.337471]        d6c27f8c c012df40 d6c26000 c023801d d6f9fe18 00000000 d6f44090 c012df40 
[  390.337511] Call Trace:
[  390.337532]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.337559]  [<c0251aed>] driver_register+0x3d/0x50
[  390.337586]  [<c0251a90>] klist_devices_get+0x0/0x10
[  390.337616]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.337642]  [<c023801d>] serio_thread+0xad/0x120
[  390.337671]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.337702]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.337734]  [<c0237f70>] serio_thread+0x0/0x120
[  390.337757]  [<c012db19>] kthread+0xa9/0xf0
[  390.337783]  [<c012da70>] kthread+0x0/0xf0
[  390.337808]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.337852] kjournald     S 00000032     0   743      1           772   114 (L-TLB)
[  390.337906] d6ce3f58 d6c95ab0 c03d93e0 00000032 00000000 6bcc439f 00000000 00000296 
[  390.337939]        00000001 d6ce3f58 00002db8 2e223dd0 00000058 d6c95ab0 d6c95bd8 00000000 
[  390.337976]        d6cb7aa0 00000001 d6cb7ae4 c01a9bd9 00000000 00000005 d6fd2a30 d6c95ab0 
[  390.338014] Call Trace:
[  390.338044]  [<c01a9bd9>] kjournald+0x379/0x380
[  390.338082]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.338115]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.338144]  [<c0102f62>] ret_from_fork+0x6/0x14
[  390.338170]  [<c01a9850>] commit_timeout+0x0/0x10
[  390.338196]  [<c01a9860>] kjournald+0x0/0x380
[  390.338221]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.338266] udevd         S 00000000     0   772      1          1778   743 (NOTLB)
[  390.338322] d6479eac d640f0d0 c03d93e0 00000000 000000d0 00000001 00000000 00000000 
[  390.338353]        00000000 00000001 0000ebb3 7385c3a6 0000004f d640f0d0 d640f1f8 00000000 
[  390.338389]        7fffffff 00000007 00000000 c02efea1 d6cbe200 d6479f3c c02885b1 d6bff0a0 
[  390.338434] Call Trace:
[  390.338464]  [<c02efea1>] schedule_timeout+0xa1/0xb0
[  390.338495]  [<c02885b1>] datagram_poll+0xe1/0xf0
[  390.338526]  [<c0281520>] sock_poll+0x20/0x30
[  390.338559]  [<c016c220>] do_select+0x280/0x2c0
[  390.338604]  [<c016bdc0>] __pollwait+0x0/0xd0
[  390.338632]  [<c016c5b8>] sys_select+0x318/0x450
[  390.338670]  [<c011dc05>] sys_waitpid+0x25/0x29
[  390.338698]  [<c0103059>] syscall_call+0x7/0xb
[  390.339920] khubd         S 0000001A     0  1217      5          5557   706 (L-TLB)
[  390.340945] d65fdf5c d656a070 c03d9410 0000001a 00000100 dc19a852 0000001a 0002fee8 
[  390.340981]        00000000 d656a070 0000435a dc19a852 0000001a d6abd550 d6abd678 d65fc000 
[  390.341019]        d65fc000 d65fdf80 d65fdf8c d7841e3a 000057bf d6415e0c 00000000 d6abd550 
[  390.341059] Call Trace:
[  390.341099]  [<d7841e3a>] hub_thread+0xea/0x120 [usbcore]
[  390.343386]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.343426]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.343463]  [<d7841d50>] hub_thread+0x0/0x120 [usbcore]
[  390.343854]  [<c012db19>] kthread+0xa9/0xf0
[  390.343884]  [<c012da70>] kthread+0x0/0xf0
[  390.343909]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.344418] kjournald     S 00000001     0  1778      1          5124   772 (L-TLB)
[  390.345452] d5e59f58 d6b35070 c03d93e0 00000001 d6b5d704 c010513e c0103a26 00000000 
[  390.345491]        d5e59fa4 00000000 00005ec2 4beee643 00000055 d6b35070 d6b35198 00000000 
[  390.345529]        d6b5d6c0 00000001 d6b5d704 c01a9bd9 00000000 00000005 00000008 d6b35070 
[  390.345695] Call Trace:
[  390.346187]  [<c010513e>] do_IRQ+0x1e/0x30
[  390.346219]  [<c0103a26>] common_interrupt+0x1a/0x20
[  390.346253]  [<c01a9bd9>] kjournald+0x379/0x380
[  390.346288]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.346321]  [<c012df40>] autoremove_wake_function+0x0/0x60
[  390.346351]  [<c0102f62>] ret_from_fork+0x6/0x14
[  390.346377]  [<c01a9850>] commit_timeout+0x0/0x10
[  390.346403]  [<c01a9860>] kjournald+0x0/0x380
[  390.346429]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.351800] scsi_eh_0     S 00000010     0  5557      5                1217 (L-TLB)
[  390.352081] d5907f50 d6b69590 c03d93e0 00000010 80b05cad 0000593e a361faff 00000000 
[  390.352119]        4fa02c17 d6b35a70 00000126 d5dd9f69 0000001a d6b69590 d6b696b8 d5907fa8 
[  390.352158]        d5906000 00000296 d6b69590 c02f0601 d5907fb0 00000000 00000001 d6b69590 
[  390.352196] Call Trace:
[  390.352223]  [<c02f0601>] __down_interruptible+0x71/0xf2
[  390.352256]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.352292]  [<d814b1e0>] scsi_error_handler+0x0/0x120 [scsi_mod]
[  390.352934]  [<c02ef1b3>] __down_failed_interruptible+0x7/0xc
[  390.352970]  [<d814b826>] .text.lock.scsi_error+0x3b/0x45 [scsi_mod]
[  390.353085]  [<c012db19>] kthread+0xa9/0xf0
[  390.353117]  [<c012da70>] kthread+0x0/0xf0
[  390.353141]  [<c0101379>] kernel_thread_helper+0x5/0xc
[  390.353173] usb-storage   D 0000001A     0  5558      1          7015  5462 (L-TLB)
[  390.353214] d59d9ed8 d6b69590 c03d9410 0000001a d61726c0 d5dd86e7 0000001a 0000057e 
[  390.353249]        00000000 d6b69590 0000111e d5dd93e9 0000001a d6713ab0 d6713bd8 d59d8000 
[  390.353287]        c03ec58c d59d9ef4 d59d9f2c c02ef83e 00000000 d6713ab0 c0116fc0 00000000 
[  390.353326] Call Trace:
[  390.353352]  [<c02ef83e>] wait_for_completion+0x6e/0xa0
[  390.353380]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.353411]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.353439]  [<c011677d>] wake_up_process+0x1d/0x20
[  390.353465]  [<c012dd51>] kthread_stop+0x51/0x7a
[  390.353489]  [<c01170b7>] __wake_up_locked+0x27/0x30
[  390.353518]  [<d814781c>] scsi_host_dev_release+0x8c/0xa0 [scsi_mod]
[  390.353637]  [<c01c4b69>] kobject_cleanup+0xa9/0xb0
[  390.353671]  [<c01c4b70>] kobject_release+0x0/0x10
[  390.353698]  [<c01c55a5>] kref_put+0x45/0x90
[  390.353727]  [<c01c4b9f>] kobject_put+0x1f/0x30
[  390.353752]  [<c01c4b70>] kobject_release+0x0/0x10
[  390.353778]  [<d8160103>] usb_stor_control_thread+0x153/0x1b0 [usb_storage]
[  390.353891]  [<c0102f62>] ret_from_fork+0x6/0x14
[  390.353917]  [<d815ffb0>] usb_stor_control_thread+0x0/0x1b0 [usb_storage]
[  390.354013]  [<d815ffb0>] usb_stor_control_thread+0x0/0x1b0 [usb_storage]
[  390.354103]  [<c0101379>] kernel_thread_helper+0x5/0xc
  390.355561] rmmod         D CE0FBED8     0  9411   5435                     (NOTLB)
[  390.355585] ce0fbef4 d63440d0 c03d93e0 ce0fbed8 00000286 d816ffec 00000003 d816fff4 
[  390.355605]        c034d948 d61e7a90 00006352 7005c59d 0000004f d63440d0 d63441f8 ce0fa000 
[  390.355629]        d816e770 ce0fbf10 ce0fbf48 c02ef83e 00000000 d63440d0 c0116fc0 00000000 
[  390.355652] Call Trace:
[  390.355668]  [<c02ef83e>] wait_for_completion+0x6e/0xa0
[  390.355685]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.355701]  [<c01c4b9f>] kobject_put+0x1f/0x30
[  390.355719]  [<c0116fc0>] default_wake_function+0x0/0x20
[  390.355737]  [<d8168de0>] usb_stor_exit+0x0/0x2c [usb_storage]
[  390.355810]  [<d8168de0>] usb_stor_exit+0x0/0x2c [usb_storage]
[  390.355865]  [<d8168dfb>] usb_stor_exit+0x1b/0x2c [usb_storage]
[  390.355918]  [<c01330b6>] sys_delete_module+0x1a6/0x1e0
[  390.355950]  [<c014d510>] sys_munmap+0x50/0x80
[  390.355968]  [<c0103059>] syscall_call+0x7/0xb


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
