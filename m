From: Stephen Cameron <steve.cameron@hp.com>
Subject: Re: [PATCH] scsi host cleanup 3/3 (driver changes)
Date: Thu, 10 Oct 2002 09:01:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021010090157.A990@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:

> If you read my previous post on this patch I indicated that few of the
> driver changes I was only able to compile test ( block/cciss_scsi.c,
> scsi/53c700.c, scsi/pcmcia/*, scsi/wd33c93.c). The changes to the
> drivers are to remove the old interfaces and possibly extra NULL inits
> of struct members. These changes will need to be ok'd by there
> respective maintainers.

I tried out these patches with 2.5.40 and the cciss driver.
Looks ok to me.

When I did "echo engage scsi > /proc/driver/cciss/cciss0" to 
make the cciss driver register with the scsi subsystem, I got
what you see below.  However, I also got the same thing when 
trying 2.5.40 without the patches, so I don't think the patches
are the problem.

When I tried 2.5.41 without the patches, the problem below was
gone.

And, despite all this, it always appeared to work anyway. 
My tape drive appeared, and I could always do i/o to it.

-- steve

dmesg output follows:

cciss0: No device changes detected.
scsi0 : cciss0
  Vendor: COMPAQ    Model: SDT-10000         Rev: 1.14
  Type:   Sequential-Access                  ANSI SCSI revision: 02
Debug: sleeping function called from illegal context at slab.c:1374
ce275de0 c01195e6 c0320bc0 c0326282 0000055e c1287080 c013c15f c0326282 
       0000055e c1336324 c1330c00 00000000 ce275e4c 00000286 00000286 cfc32974 
       cf37e000 00000000 cfffb080 d0800000 00001000 ce274000 00001000 c013a199 
Call Trace:
 [<c01195e6>]__might_sleep+0x56/0x5d
 [<c013c15f>]kmalloc+0x4f/0x330
 [<c013a199>]get_vm_area+0x29/0x140
 [<c013a4fb>]__vmalloc+0x3b/0x120
 [<c013a5f6>]vmalloc+0x16/0x20
 [<c029837e>]sg_init+0xbe/0x160
 [<c0288280>]scsi_register_host+0x130/0x200
 [<c025a5b6>]cciss_engage_scsi+0x136/0x150
 [<c025a8da>]cciss_proc_write+0x8a/0xb0
 [<c015ca9f>]open_namei+0x37f/0x4e0
 [<c013bcf2>]free_block+0x192/0x2c0
 [<c017bf21>]proc_file_write+0x31/0x40
 [<c014d316>]vfs_write+0xb6/0x180
 [<c014c94f>]filp_close+0x10f/0x120
 [<c014c94f>]filp_close+0x10f/0x120
 [<c014d44a>]sys_write+0x2a/0x40
 [<c01078af>]syscall_call+0x7/0xb

bad: scheduling while atomic!
ce275ce8 c0116b9d c0320a20 c03c0590 ce275d0c c01170a1 c12b5800 00000000 
       ce274000 ce275dd4 ce275dd8 ce275d68 c011749a 00000000 cfcb1080 c0117080 
       00000000 00000000 c0117196 c03c0588 00000003 00000001 cfcb1080 c0117080 
Call Trace:
 [<c0116b9d>]schedule+0x3d/0x4c0
 [<c01170a1>]default_wake_function+0x21/0x40
 [<c011749a>]wait_for_completion+0x12a/0x1e0
 [<c0117080>]default_wake_function+0x0/0x40
 [<c0117196>]__wake_up+0x66/0xb0
 [<c0117080>]default_wake_function+0x0/0x40
 [<c012d5a1>]call_usermodehelper+0x101/0x110
 [<c012d470>]__call_usermodehelper+0x0/0x30
 [<c013bcf2>]free_block+0x192/0x2c0
 [<c012d470>]__call_usermodehelper+0x0/0x30
 [<c021ed84>]dev_hotplug+0x1a4/0x230
 [<c021edd7>]dev_hotplug+0x1f7/0x230
 [<c021babd>]device_attach+0x2d/0x40
 [<c021be84>]device_register+0x194/0x270
 [<c029874f>]sg_attach+0x2cf/0x380
 [<c02882ca>]scsi_register_host+0x17a/0x200
 [<c025a5b6>]cciss_engage_scsi+0x136/0x150
 [<c025a8da>]cciss_proc_write+0x8a/0xb0
 [<c015ca9f>]open_namei+0x37f/0x4e0
 [<c013bcf2>]free_block+0x192/0x2c0
 [<c017bf21>]proc_file_write+0x31/0x40
 [<c014d316>]vfs_write+0xb6/0x180
 [<c014c94f>]filp_close+0x10f/0x120
 [<c014c94f>]filp_close+0x10f/0x120
 [<c014d44a>]sys_write+0x2a/0x40
 [<c01078af>]syscall_call+0x7/0xb

Attached scsi tape st0 at scsi0, channel 0, id 0, lun 0
st0: try direct i/o: yes, max page reachable by HBA 65532
