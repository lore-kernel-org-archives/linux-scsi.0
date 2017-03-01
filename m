From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 17:25:32 -0800
Message-ID: <20170228172532.280811ed@xeon-e3>
References: <20170227152955.1362aabb@xeon-e3>
        <20170227171931.30b9f619@xeon-e3>
        <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:34706 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbdCABdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 20:33:49 -0500
Received: by mail-pg0-f52.google.com with SMTP id p5so13581617pga.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 17:33:48 -0800 (PST)
In-Reply-To: <1488325732.11610.9.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>


> Let's concentrate on INQUIRY since that's the first command in the
> probe sequence.  I think it's completing successfully because your
> hyperv layer says it has 36 bytes of transfer and that's the size of a
> successful initial INQUIRY, so the fact that the code above would break
> stuff if the INQUIRY failed is orthogonal to the the current problem.

Right, that bodge only breaks some minor things likes scsiinfo commands.

> can you print out some of the DMA buffer in storvsc_on_io_completion()?
> 
> I think just the stor_pkt->vm_srb.cdb[0] (to identify the command
> completing) and byte 5 of the buffer will tell us what we need to know.
>  It's going to be complex to get byte 5, you'll need to do a
> kmap_atomic_pfn on request->payload->range.pfn_array[0] and then look
> at byte 5.  If that's zero it means there's some problem with hyperv
> writing to the pfn if it's 0x24 (expected value for an initial inquiry)
> we've got a problem somewhere in bio completion not copying the value
> back.

Here is another boot, this time went dumpster diving as you suggested
to get the request data.



diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2af63a80c7fa..a51d8eba6e04 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1059,6 +1059,21 @@ static void storvsc_on_io_completion(struct storvsc_device *stor_device,
 		vstor_packet->vm_srb.srb_status,
 		vstor_packet->vm_srb.data_transfer_length);
 
+	if (stor_pkt->vm_srb.cdb[0] == INQUIRY)	{
+		struct scsi_cmnd *cmd = request->cmd;
+		struct scatterlist *sg = scsi_sglist(cmd);
+		struct page *page = sg_page(sg);
+		void *vaddr = kmap_atomic(page);
+		
+		print_hex_dump(KERN_INFO,
+			       "inquiry data: ", DUMP_PREFIX_OFFSET,
+			       16, 1,
+			       vaddr, vstor_packet->vm_srb.data_transfer_length,
+			       false);
+
+		kunmap_atomic(page);
+	}
+
 	/*
 	 * The current SCSI handling on the host side does
 	 * not correctly handle:

Which results in:
...

[    1.225501] scsi host0: storvsc_host_t
[    1.234707] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.235517] scsi host1: storvsc_host_t
[    1.238037] inquiry data: 00000000: 00 23 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.256800] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.259430] inquiry data: 00000020: 00 00 00 00
[    1.261431] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 5
[    1.264080] hv_storvsc:  IO cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    1.267420] inquiry data: 00000000: 00 00 00 08 00 83 8f b0 b1 b2 ce cf
[    1.270759] hv_storvsc:  IO cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 52
[    1.275007] inquiry data: 00000000: 00 83 00 30 01 01 00 18 4d 53 46 54 20 20 20 20
[    1.277988] inquiry data: 00000010: 43 77 cc 85 5f 19 c2 46 ac 48 c7 33 b9 dd 2d 2a
[    1.281096] inquiry data: 00000020: 01 03 00 10 60 02 24 80 43 77 cc 85 5f 19 c7 33
[    1.284246] inquiry data: 00000030: b9 dd 2d 2a
[    1.306538] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.310621] inquiry data: 00000000: 00 92 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.316244] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.328151] random: fast init done
[    1.340184] inquiry data: 00000020: 00 00 00 00
[    1.342710] scsi 1:0:0:0: CD-ROM            Msft     Virtual DVD-ROM  1.0  PQ: 0 ANSI: 0
[    1.346023] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.352913] inquiry data: 00000000: 00 aa be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.356543] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.359996] inquiry data: 00000020: 00 00 00 00
[    1.361835] scsi host1: scsi scan: INQUIRY result too short (5), using 36
[    1.361888] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 16
[    1.362307] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.362308] inquiry data: 00000000: 00 23 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.362309] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.362309] inquiry data: 00000020: 00 00 00 00
[    1.377423] scsi 1:0:0:1: Direct-Access                                    PQ: 0 ANSI: 0
[    1.399208] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.402836] inquiry data: 00000000: 00 a3 be f1 5c 98 ff ff 00 00 00 00 00 00 00 00
[    1.406466] inquiry data: 00000010: 00 00 00 00 00 00 00 00 c0 30 66 f9 5c 98 ff ff
[    1.409766] inquiry data: 00000020: 00 00 00 00
[    1.412366] scsi 1:0:0:2: Direct-Access                                    PQ: 0 ANSI: 0
[    1.412456] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.418750] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.421624] inquiry data: 00000000: 00 92 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.424629] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.432565] inquiry data: 00000020: 00 00 00 00
[    1.433690] scsi 1:0:0:3: Direct-Access                                    PQ: 0 ANSI: 0
[    1.433751] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.433753] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.433753] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.433753] inquiry data: 00000020: 00 00 00 00
[    1.465775] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.468640] inquiry data: 00000000: 00 92 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.471717] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.474466] inquiry data: 00000020: 00 00 00 00
[    1.476624] scsi 1:0:0:4: Direct-Access                                    PQ: 0 ANSI: 0
[    1.476777] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.482802] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.485801] inquiry data: 00000000: 00 92 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.493743] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.495724] inquiry data: 00000020: 00 00 00 00
[    1.497451] scsi 1:0:0:5: Direct-Access                                    PQ: 0 ANSI: 0
[    1.497557] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.497558] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.497559] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.497559] inquiry data: 00000020: 00 00 00 00
[    1.529199] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.532055] inquiry data: 00000000: 00 a3 be f1 5c 98 ff ff 00 00 00 00 00 00 00 00
[    1.535076] inquiry data: 00000010: 00 00 00 00 00 00 00 00 c0 30 66 f9 5c 98 ff ff
[    1.537601] inquiry data: 00000020: 00 00 00 00
[    1.539463] scsi 1:0:0:6: Direct-Access                                    PQ: 0 ANSI: 0
[    1.539523] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.545625] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.549238] inquiry data: 00000000: 00 00 00 00 00 00 00 00 f0 64 02 89 ff ff ff ff
[    1.558838] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.561775] inquiry data: 00000020: 00 00 00 00
[    1.564193] scsi 1:0:0:7: Direct-Access                                    PQ: 0 ANSI: 0
[    1.564286] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.564287] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.564288] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.564288] inquiry data: 00000020: 00 00 00 00
[    1.591962] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.594803] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.597613] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.600483] inquiry data: 00000020: 00 00 00 00
[    1.602473] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.602979] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.605686] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.608562] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.612031] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.621398] inquiry data: 00000020: 00 00 00 00
[    1.623612] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.624081] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.627608] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.627608] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.627608] inquiry data: 00000020: 00 00 00 00
[    1.656428] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.659541] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.662333] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.665187] inquiry data: 00000020: 00 00 00 00
[    1.666998] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.670735] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.673517] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.677515] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.677515] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.677515] inquiry data: 00000020: 00 00 00 00
[    1.690656] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.694467] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.697643] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.700563] inquiry data: 00000020: 00 00 00 00
[    1.702595] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.702962] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.726145] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.729919] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.733720] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.736863] inquiry data: 00000020: 00 00 00 00
[    1.740093] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.740194] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.744076] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.744076] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.744076] inquiry data: 00000020: 00 00 00 00
[    1.772956] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.776953] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.779680] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.782218] inquiry data: 00000020: 00 00 00 00
[    1.784394] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.784626] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.792094] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.795247] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.797827] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.802734] inquiry data: 00000020: 00 00 00 00
[    1.819848] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.820240] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.823843] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.823843] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.823843] inquiry data: 00000020: 00 00 00 00
[    1.834404] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.834447] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.840676] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.843780] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.846374] inquiry data: 00000020: 00 00 00 00
[    1.863480] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.863527] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.863552] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.863553] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.863564] inquiry data: 00000020: 00 00 00 00
[    1.884017] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.884018] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.891512] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.903984] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.915662] inquiry data: 00000020: 00 00 00 00
[    1.917991] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.917998] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.924404] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.927723] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.930174] inquiry data: 00000020: 00 00 00 00
[    1.932514] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.932508] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.940019] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.956298] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.962475] inquiry data: 00000020: 00 00 00 00
[    1.965476] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.968215] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.971735] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.973634] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.975698] inquiry data: 00000020: 00 00 00 00
[    1.977125] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.979795] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    1.981025] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    1.982616] inquiry data: 00000020: 00 00 00 00
[    1.984502] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    1.984717] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.008517] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.011539] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.013973] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.016679] inquiry data: 00000020: 00 00 00 00
[    2.018610] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.018823] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.024671] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.027955] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.030679] inquiry data: 00000020: 00 00 00 00
[    2.033142] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.042496] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.056213] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.059225] inquiry data: 00000020: 00 00 00 00
[    2.060987] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.061371] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.086089] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.088962] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.091849] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.094272] inquiry data: 00000020: 00 00 00 00
[    2.096274] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.096535] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.100269] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.100269] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.100269] inquiry data: 00000020: 00 00 00 00
[    2.109952] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.112806] inquiry data: 00000000: 00 b3 be f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.121465] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.124358] inquiry data: 00000020: 00 00 00 00
[    2.126483] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.126840] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.134173] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.136972] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.140007] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.142548] inquiry data: 00000020: 00 00 00 00
[    2.152163] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.165698] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.169146] inquiry data: 00000000: 00 2d 34 f1 5c 98 ff ff f0 64 02 89 ff ff ff ff
[    2.169694] inquiry data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    2.169694] inquiry data: 00000020: 00 00 00 00
[    2.181106] hv_storvsc:  IO cmd 0xa0 0x0 0x0 scsi status 0x0 srb status 0x1 length 4096
[    2.184852] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x1 length 0
[    2.184927] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.185119] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x2 srb status 0x84 length 0
[    2.185170] hv_storvsc:  IO cmd 0x1a 0x0 0x2a scsi status 0x2 srb status 0x6 length 128
[    2.185189] sr 1:0:0:0: [sr0] scsi3-mmc drive: 0x/0x caddy
[    2.185190] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.185427] hv_storvsc:  IO cmd 0x4a 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    2.185471] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.185622] hv_storvsc:  IO cmd 0x4a 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    2.185666] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.185673] sd 1:0:0:1: Attached scsi generic sg2 type 0
[    2.185722] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.185816] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x2 srb status 0x84 length 0
[    2.185851] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    2.185853] sd 1:0:0:1: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[    2.185854] sd 1:0:0:1: [sdb] 0-byte physical blocks
[    2.185860] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
[    2.185865] sd 1:0:0:2: Attached scsi generic sg3 type 0
[    2.185979] sd 1:0:0:1: [sdb] Write Protect is off
[    2.186030] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x2 srb status 0x84 length 0
[    2.186038] hv_storvsc:  IO cmd 0x1a 0x0 0x8 scsi status 0x0 srb status 0x20 length 4
[    2.186247] sd 1:0:0:1: [sdb] Asking for cache data failed
[    2.186247] sd 1:0:0:1: [sdb] Assuming drive cache: write through
[    2.186603] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 4
[    2.186637] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.186686] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    2.186665] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
[    2.186685] hv_storvsc:  IO cmd 0x1a 0x0 0x8 scsi status 0x0 srb status 0x20 length 4
[    2.186771] sd 1:0:0:3: Attached scsi generic sg4 type 0
[    2.186849] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.186861] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.186965] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 0
[    2.187002] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
[    2.186990] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
[    2.186999] sd 1:0:0:4: Attached scsi generic sg5 type 0
[    2.187023] sd 1:0:0:3: [sdd] Sector size 0 reported, assuming 512.
[    2.187025] sd 1:0:0:3: [sdd] 1 512-byte logical blocks: (512 B/512 B)
[    2.187026] sd 1:0:0:3: [sdd] 0-byte physical blocks
[    2.187073] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
[    2.187054] sd 1:0:0:3: [sdd] Write Protect is off
[    2.187106] hv_storvsc:  IO cmd 0x1a 0x0 0x8 scsi status 0x0 srb status 0x20 length 4
[    2.187225] sd 1:0:0:3: [sdd] Asking for cache data failed
[    2.187226] sd 1:0:0:3: [sdd] Assuming drive cache: write through
[    2.187267] sd 1:0:0:5: Attached scsi generic sg6 type 0
[    2.187579] hv_storvsc:  IO cmd 0x4a 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    2.187613] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x2 srb status 0x84 length 0
[    2.187644] hv_storvsc:  IO cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.187645] inquiry data: 00000000: 05 80 00 02 1f 00 00 00 4d 73 66 74 20 20 20 20
[    2.187646] inquiry data: 00000010: 56 69 72 74 75 61 6c 20 44 56 44 2d 52 4f 4d 20
[    2.187646] inquiry data: 00000020: 31 2e 30 20
[    2.187751] sd 1:0:0:2: [sdc] Sector size 0 reported, assuming 512.
[    2.187695] sd 1:0:0:6: Attached scsi generic sg7 type 0
[    2.187754] sd 1:0:0:2: [sdc] 1 512-byte logical blocks: (512 B/512 B)
[    2.187762] sd 1:0:0:2: [sdc] 0-byte physical blocks
[    2.187786] hv_storvsc:  IO cmd 0x4a 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    2.187786] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x0 srb status 0x20 length 4
[    2.187746] hv_storvsc:  IO cmd 0x1a 0x0 0x3f scsi status 0x0 srb status 0x20 length 4
[    2.187790] hv_storvsc:  IO cmd 0x0 0x0 0x0 scsi status 0x2 srb status 0x84 length 0
[    2.187841] sd 1:0:0:2: [sdc] Write Protect is off
[    2.187796] hv_storvsc:  IO cmd 0x1a 0x0 0x8 scsi status 0x0 srb status 0x20 length 4
[    2.187799] hv_storvsc:  IO cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 6
[    2.187800] inquiry data: 00000000: 05 00 00 02 00 83
[    2.187893] sd 1:0:0:2: [sdc] Asking for cache data failed
[    2.187894] sd 1:0:0:2: [sdc] Assuming drive cache: write through
[    2.188016] hv_storvsc:  IO cmd 0x25 0x0 0x0 scsi status 0x0 srb status 0x20 length 8
** 812 printk messages dropped ** [    2.211818] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 881 printk messages dropped ** [    2.217316] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 671 printk messages dropped ** [    2.222495] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 136 printk messages dropped ** [    2.223813] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 477 printk messages dropped ** [    2.227906] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 768 printk messages dropped ** [    2.232439] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 length 512
** 389 printk messages dropped ** [    2.234770] hv_storvsc:  IO cmd 0x28 0x0 0x0 scsi status 0x0 srb status 0x20 lengt
