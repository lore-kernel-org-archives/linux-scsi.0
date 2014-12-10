From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: UAS crash with Apricorn USB3 SATA bridge
Date: Wed, 10 Dec 2014 02:29:29 -0800
Message-ID: <20141210102929.GA21944@birch.djwong.org>
References: <20141209193116.GA25163@birch.djwong.org>
 <548801F8.8080207@redhat.com>
 <20141210090458.GA21955@birch.djwong.org>
 <20141210101514.GB21955@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39334 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaLJK3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2014 05:29:43 -0500
Content-Disposition: inline
In-Reply-To: <20141210101514.GB21955@birch.djwong.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

On Wed, Dec 10, 2014 at 02:15:14AM -0800, Darrick J. Wong wrote:
> On Wed, Dec 10, 2014 at 01:04:58AM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 10, 2014 at 09:19:04AM +0100, Hans de Goede wrote:
> > > Hi,
> > > 
> > > On 09-12-14 20:31, Darrick J. Wong wrote:
> > > >Hi,
> > > >
> > > >I have an Apricorn USB 3 disk dongle thing that claims to support UAS.
> > > >However, the kernel crashes when I plug it in[1].
> > > 
> > > Yes there are some known issues with uas error handling which are fixed
> > > in 3.18, can you try with a 3.18 kernel please ?
> > 
> > The crash pic was from 3.18.0, blk_mq disabled.  I'll work on getting a fuller
> > dmesg output.  Looking at the code, it looks like we end up in
> > queue_bulk_sg_tx() with a sg list that is shorter than num_sgs, so we fall off
> > the end.
> > 
> > (Alas it's now 1am here, so I'm going to bed. :/ )
> 
> Eh, nuts to sleeping.  dmesg produces this:
> 
> [  231.128074] usbcore: registered new interface driver usb-storage
> [  231.133822] usbcore: registered new interface driver uas
> [  252.121353] usb 2-4: new SuperSpeed USB device number 2 using xhci_hcd
> [  252.136927] scsi host6: uas
> [  252.141679] scsi 6:0:0:0: Direct-Access     Apricorn                  0128 PQ: 0 ANSI: 6
> [  252.145433] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [  252.145525] sd 6:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> [  252.145527] sd 6:0:0:0: [sdc] 4096-byte physical blocks
> [  252.145891] sd 6:0:0:0: [sdc] Write Protect is off
> [  252.145973] sd 6:0:0:0: [sdc] No Caching mode page found
> [  252.145975] sd 6:0:0:0: [sdc] Assuming drive cache: write through

Huh.  4096-byte physical blocks??  That drive is /not/ a 4k sector drive.
Here's what the kernel said when I plugged in the other ("Plugable" brand) UAS
bridge[1]:

[   32.466870] usb 2-4: new SuperSpeed USB device number 2 using xhci_hcd
[   32.498996] usbcore: registered new interface driver usb-storage
[   37.660963] scsi host6: uas
[   37.661193] usbcore: registered new interface driver uas
[   37.661292] queue_bulk_sg_tx: num=1 sg=ffff880447764500 addr=45af41000 len=0 pagelink=ffffea00116bd042
[   37.661550] queue_bulk_sg_tx: num=1 sg=ffff8804483fb600 addr=45af41000 len=0 pagelink=ffffea00116bd042
[   37.661744] scsi 6:0:0:0: Direct-Access     Plugable USB3-SATA-UASP1  0    PQ: 0 ANSI: 6
[   37.661865] queue_bulk_sg_tx: num=1 sg=ffff8804483fba00 addr=45af41000 len=0 pagelink=ffffea00116bd042
[   37.662053] queue_bulk_sg_tx: num=1 sg=ffff8804483fba00 addr=45af41000 len=0 pagelink=ffffea00116bd042
[   37.662294] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=45af41000 len=0 pagelink=ffffea00116bd042
[   37.662488] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=45b6ab000 len=0 pagelink=ffffea00116daac2
[   37.663041] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   37.663138] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=44897c000 len=0 pagelink=ffffea0011225f02
[   37.664420] sd 6:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   37.664599] queue_bulk_sg_tx: num=1 sg=ffff880447764400 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.664833] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.665022] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.665255] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.665421] sd 6:0:0:0: [sdc] Write Protect is off
[   37.665532] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0a00 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.665735] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0a00 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.665877] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.666003] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1700 addr=4587a8e00 len=0 pagelink=ffffea001161ea02
[   37.666293] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1700 addr=45b5c0000 len=0 pagelink=ffffea00116d7002
[   37.670190] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1600 addr=44897c000 len=0 pagelink=ffffea0011225f02
[   37.676364] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.681800] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.687125] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.692335] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.697451] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.702429] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.707312] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=457692000 len=0 pagelink=ffffea00115da482
[   37.712109] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=448b56000 len=0 pagelink=ffffea001122d582
[   38.077805] queue_bulk_sg_tx: num=1 sg=ffff8800371f2900 addr=45b55c000 len=0 pagelink=ffffea00116d5702
[   38.084416] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0e00 addr=45ac31000 len=0 pagelink=ffffea00116b0c42
[   38.091107] queue_bulk_sg_tx: num=1 sg=ffff880456804800 addr=45b1d8000 len=0 pagelink=ffffea00116c7602
[   38.097794] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=4577f0000 len=0 pagelink=ffffea00115dfc02
[   38.104336] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=457a58000 len=0 pagelink=ffffea00115e9602
[   38.134057] queue_bulk_sg_tx: num=1 sg=ffff88045b9e1200 addr=44727b000 len=0 pagelink=ffffea00111c9ec2
[   38.140514] queue_bulk_sg_tx: num=1 sg=ffff880456804f00 addr=4574d6000 len=0 pagelink=ffffea00115d3582
[   38.146793] queue_bulk_sg_tx: num=1 sg=ffff88045b9e0900 addr=45c49a000 len=0 pagelink=ffffea0011712682
[   38.153256] queue_bulk_sg_tx: num=1 sg=ffff880456805200 addr=4475f4000 len=0 pagelink=ffffea00111d7d02
[   38.156858]  sdc: sdc1 sdc2 sdc3
[   38.162992] queue_bulk_sg_tx: num=1 sg=ffff880447765100 addr=4482a2000 len=0 pagelink=ffffea001120a882
[   38.168410] queue_bulk_sg_tx: num=1 sg=ffff88008ab87400 addr=45ac2d000 len=0 pagelink=ffffea00116b0b42

(Sorry for the noise, this really is the last email for tonight.)

--D

[1] lsusb output: http://djwong.org/docs/plugable.txt

> [  252.171739] queue_bulk_sg_tx: num=4294967295 sg=ffff8804584e0b00 addr=          (null) len=0 pagelink=116b8882
> [  252.173706] queue_bulk_sg_tx: num=4294967295 sg=          (null), ABORT
> <KABOOM>
> 
> I wrote in a printk to spit out num_sgs and some of the sg data right before
> the sg_next() call.  Looks like num_sgs is originally zero?  I then patched
> the code to break early if num_sgs == 0:
> 
> 		/* Calculate length for next transfer --
> 		 * Are we done queueing all the TRBs for this sg entry?
> 		 */
> 		this_sg_len -= trb_buff_len;
> printk(KERN_ERR "%s: num=%u sg=%p addr=%lx len=%u pagelink=%lx\n", __func__, num_sgs, sg, addr, this_sg_len, sg->page_link);
> 		if (this_sg_len == 0) {
> if (num_sgs == 0) {
> printk(KERN_ERR "%s: breaking early, no sgs??\n", __func__);
> break;
> }
> 			--num_sgs;
> 			if (num_sgs == 0)
> 				break;
> 			sg = sg_next(sg);
> 			addr = (u64) sg_dma_address(sg);
> 			this_sg_len = sg_dma_len(sg);
> 
> This produced this log[1] which I've excerpted here:
> 
> [   96.944791] usb 2-4: new SuperSpeed USB device number 2 using xhci_hcd
> [   96.972881] usbcore: registered new interface driver usb-storage
> [  128.315902] scsi host6: uas
> [  128.318605] usbcore: registered new interface driver uas
> [  128.318691] queue_bulk_sg_tx: num=1 sg=ffff88044650ed00 addr=446958000 len=0 pagelink=ffffea00111a5602
> [  128.318960] queue_bulk_sg_tx: num=1 sg=ffff880457a03300 addr=446958000 len=0 pagelink=ffffea00111a5602
> [  128.321144] scsi 6:0:0:0: Direct-Access     Apricorn                  0128 PQ: 0 ANSI: 6
> [  128.321165] queue_bulk_sg_tx: num=1 sg=ffff880457a03300 addr=45cbb1000 len=0 pagelink=ffffea001172ec42
> [  128.323714] queue_bulk_sg_tx: num=1 sg=ffff880457a02100 addr=447738000 len=0 pagelink=ffffea00111dce02
> [  128.326233] queue_bulk_sg_tx: num=1 sg=ffff880457a02600 addr=45a4c8000 len=0 pagelink=ffffea0011693202
> [  128.329157] sd 6:0:0:0: Attached scsi generic sg2 type 0
> [  128.331328] queue_bulk_sg_tx: num=1 sg=ffff88045795ce00 addr=456ad7000 len=0 pagelink=ffffea00115ab5c2
> [  128.331428] sd 6:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> [  128.331431] sd 6:0:0:0: [sdc] 4096-byte physical blocks
> [  128.331448] queue_bulk_sg_tx: num=1 sg=ffff880457a02100 addr=456ad7000 len=0 pagelink=ffffea00115ab5c2
> [  128.333772] queue_bulk_sg_tx: num=1 sg=ffff880457a03300 addr=44649e000 len=0 pagelink=ffffea0011192782
> [  128.336191] queue_bulk_sg_tx: num=1 sg=ffff880457a02700 addr=45683b000 len=0 pagelink=ffffea00115a0ec2
> [  128.338561] queue_bulk_sg_tx: num=1 sg=ffff880457a02600 addr=37355000 len=0 pagelink=ffffea0000dcd542
> [  128.340979] queue_bulk_sg_tx: num=1 sg=ffff880457a02c00 addr=8a8e3000 len=0 pagelink=ffffea00022a38c2
> [  128.343246] sd 6:0:0:0: [sdc] Write Protect is off
> [  128.343263] queue_bulk_sg_tx: num=1 sg=ffff880457a02400 addr=8a8e2000 len=0 pagelink=ffffea00022a3882
> [  128.345461] sd 6:0:0:0: [sdc] No Caching mode page found
> [  128.345463] sd 6:0:0:0: [sdc] Assuming drive cache: write through
> [  128.345475] queue_bulk_sg_tx: num=1 sg=ffff880457a02000 addr=45ba6ba00 len=0 pagelink=ffffea00116e9ac2
> [  128.347752] queue_bulk_sg_tx: num=1 sg=ffff880457a02000 addr=8ab21000 len=0 pagelink=ffffea00022ac842
> [  128.352127] queue_bulk_sg_tx: num=1 sg=ffff880457a02c00 addr=8637f000 len=0 pagelink=ffffea000218dfc2
> [  128.354225] queue_bulk_sg_tx: num=1 sg=ffff880457a02600 addr=8637e000 len=0 pagelink=ffffea000218df82
> [  128.356278] queue_bulk_sg_tx: num=1 sg=ffff880457a02700 addr=8a8b7000 len=0 pagelink=ffffea00022a2dc2
> [  128.358325] queue_bulk_sg_tx: num=1 sg=ffff880457a03300 addr=8a8b6000 len=0 pagelink=ffffea00022a2d82
> [  128.360450] queue_bulk_sg_tx: num=1 sg=ffff880457a02100 addr=8a8b1000 len=0 pagelink=ffffea00022a2c42
> [  128.362443] queue_bulk_sg_tx: num=1 sg=ffff880457a02100 addr=8a8b0000 len=0 pagelink=ffffea00022a2c02
> [  128.364448] queue_bulk_sg_tx: num=1 sg=ffff880457a03300 addr=84d55000 len=0 pagelink=ffffea0002135542
> [  128.366488] queue_bulk_sg_tx: num=1 sg=ffff880457a02700 addr=84d54000 len=0 pagelink=ffffea0002135502
> [  128.368545] queue_bulk_sg_tx: num=1 sg=ffff880457a02600 addr=863bd000 len=0 pagelink=ffffea000218ef42
> [  128.732280] queue_bulk_sg_tx: num=1 sg=ffff880457a02600 addr=37182000 len=0 pagelink=ffffea0000dc6082
> [  128.734945] queue_bulk_sg_tx: num=1 sg=ffff880457a02600 addr=3718200d len=499 pagelink=ffffea0000dc6082
> [  128.737631] queue_bulk_sg_tx: num=0 sg=ffff880457a02600 addr=0 len=0 pagelink=ffffea0000dc6082
> [  128.740150] queue_bulk_sg_tx: breaking early, no sgs??
> [  128.742665] usb 2-4: check_trb_math - ep 0x8b - Miscalculated number of TRBs, -1 left
> [  159.618522] sd 6:0:0:0: [sdc] uas_eh_abort_handler 0 tag 1 inflight: IN 
> [  159.620287] sd 6:0:0:0: [sdc] CDB: 
> [  159.622016] Read(10): 28 00 00 00 00 0f 00 00 00 00
> [  159.624014] scsi host6: uas_eh_bus_reset_handler start
> [  159.728110] usb 2-4: reset SuperSpeed USB device number 2 using xhci_hcd
> 
> In the full log, you can at time 192.488278 that we got all jammed up in the sd
> probe trying to read a disklabel off the drive.  I'm suspicious of those last
> two queue_bulk_sg_tx printks since it seems awfully coincidental that it gets
> called twice, once with a sane looking addr and length, then again with the
> same sg and page_link yet the addr and num_sgs have become zero.
> 
> (Ok, now I'm really going to bed.)
> 
> --D
> 
> [1] http://djwong.org/docs/bad2.txt
> > 
> > --D
> > 
> > > 
> > > Note that the device will likely still not work, but it should no
> > > longer crash things. When running 3.18 please collect the output of
> > > "dmesg" after plugging in the drive and send that to me, then we'll see
> > > if we can get it to work from there.
> > > 
> > > Regards,
> > > 
> > > Hans
