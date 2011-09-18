From: Chris Boot <bootc@bootc.net>
Subject: Re: iommu_iova leak [inside 3w-9xxx]
Date: Sun, 18 Sep 2011 13:06:48 +0100
Message-ID: <B4A636AC-B127-42DD-BC8C-419D07A83FBD@bootc.net>
References: <4E734467.3040703@bootc.net> <1316256305.24257.25.camel@shinybook.infradead.org> <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net> <3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net> <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1250.3)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHtARFHfxpU1JKu4092ZshvhsrRY-hx_pfnL3_+T32B3ncgWvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>, lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17 Sep 2011, at 20:22, adam radford wrote:
> On Sat, Sep 17, 2011 at 7:29 AM, Chris Boot <bootc@bootc.net> wrote:
>> On 17 Sep 2011, at 12:57, Chris Boot wrote:
>>> On 17 Sep 2011, at 11:45, Woodhouse, David wrote:
>>>> I suppose it's vaguely possible that we're leaking them in such a way
>>>> that they remain on the rbtree, perhaps if the deferred unmap is never
>>>> actually happening... but I think it's a whole lot more likely that the
>>>> PCI driver is just never bothering to unmap the pages it maps.
> 
> If you think 3w-9xxx is not unmapping pages it maps, please re-run with
> CONFIG_PCI_DMA_DEBUG=y

Adam,

I installed a fresh Debian system on a SATA disk connected to the built-in SATA controller, then played with loading/unloading the 3w-9xxx module and doing a few basic things. Without even prodding very much, I got this result:

[ 1142.363173] ------------[ cut here ]------------
[ 1142.368507] WARNING: at lib/dma-debug.c:697 dma_debug_device_change+0x172/0x1a6()
[ 1142.377162] Hardware name: S1200BTL
[ 1142.381193] pci 0000:01:00.0: DMA-API: device driver has pending DMA allocations while released from device [count=37]
[ 1142.381194] One of leaked entries details: [device address=0x00000000fff9a000] [size=4096 bytes] [mapped with DMA_TO_DEVICE] [mapped as scather-gather]
[ 1142.381195] Modules linked in: ext3 jbd nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc loop snd_pcm snd_timer i2c_i801 ftdi_sio i2c_core snd soundcore snd_page_alloc usbserial joydev pcspkr evdev video button processor ext4 mbcache jbd2 crc16 dm_mod usbhid sg hid sd_mod crc_t10dif 3w_9xxx(-) ahci libahci libata scsi_mod ehci_hcd e1000e usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
[ 1142.381209] Pid: 4532, comm: rmmod Not tainted 3.1.0-rc6+ #1
[ 1142.381210] Call Trace:
[ 1142.381214]  [<ffffffff81047fe2>] warn_slowpath_common+0x7e/0x96
[ 1142.381216]  [<ffffffff8104808e>] warn_slowpath_fmt+0x41/0x43
[ 1142.381219]  [<ffffffff810407b9>] ? try_to_wake_up+0x195/0x1a7
[ 1142.381221]  [<ffffffff811c3470>] dma_debug_device_change+0x172/0x1a6
[ 1142.381225]  [<ffffffff81359db1>] notifier_call_chain.isra.0+0x33/0x60
[ 1142.381228]  [<ffffffff81066819>] __blocking_notifier_call_chain+0x46/0x5b
[ 1142.381230]  [<ffffffff8106683d>] blocking_notifier_call_chain+0xf/0x11
[ 1142.381232]  [<ffffffff812530df>] __device_release_driver+0xc5/0xca
[ 1142.381234]  [<ffffffff81253738>] driver_detach+0x7d/0xa5
[ 1142.381236]  [<ffffffff81252f75>] bus_remove_driver+0xb2/0xd5
[ 1142.381238]  [<ffffffff81253dae>] driver_unregister+0x65/0x6f
[ 1142.381241]  [<ffffffff811cb6f8>] pci_unregister_driver+0x3e/0x9f
[ 1142.381245]  [<ffffffffa012f811>] ? twa_probe+0x725/0x725 [3w_9xxx]
[ 1142.381247]  [<ffffffffa012f821>] twa_exit+0x10/0x7ef [3w_9xxx]
[ 1142.381250]  [<ffffffff81077a79>] sys_delete_module+0x1d4/0x248
[ 1142.381252]  [<ffffffff8135bf52>] system_call_fastpath+0x16/0x1b
[ 1142.381253] ---[ end trace 1b2f66e73df1e7d3 ]---
[ 1142.381254] Mapped at:
[ 1142.381255]  [<ffffffff811c35b1>] debug_dma_map_sg+0x3b/0x140
[ 1142.381256]  [<ffffffffa00cb0db>] scsi_dma_map+0x9b/0xb7 [scsi_mod]
[ 1142.381260]  [<ffffffffa012c675>] twa_scsiop_execute_scsi+0x141/0x3a5 [3w_9xxx]
[ 1142.381263]  [<ffffffffa012ce3b>] twa_scsi_queue+0xd6/0x16a [3w_9xxx]
[ 1142.381265]  [<ffffffffa00c4620>] scsi_dispatch_cmd+0x192/0x236 [scsi_mod]

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net
