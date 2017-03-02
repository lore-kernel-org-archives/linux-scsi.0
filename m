From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 17:40:58 -0800
Message-ID: <20170301174058.383da142@xeon-e3>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
        <20170301075412.2e5f1e98@xeon-e3>
        <20170302000135.GA22886@lst.de>
        <20170302005615.GA23687@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33244 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbdCBBlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 20:41:40 -0500
Received: by mail-pg0-f44.google.com with SMTP id 25so26245313pgy.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 17:41:07 -0800 (PST)
In-Reply-To: <20170302005615.GA23687@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Thu, 2 Mar 2017 01:56:15 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Mar 02, 2017 at 01:01:35AM +0100, Christoph Hellwig wrote:
> > On Wed, Mar 01, 2017 at 07:54:12AM -0800, Stephen Hemminger wrote:  
> > > > 	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4  
> > > 
> > > It appears that is already in the code I am testing in linux-next...  
> > 
> > It's in -next now, but it wasn't at the time you reported the bug.
> > 
> > And it would sortof explain the bug if the INQUIRY data is correct
> > in the scatterlist, but we ignore it, given that scsi_probe_lun
> > ignores the result based on sense data.
> > 
> > Can you check what happens with the horrible hack below:  
> 
> Strike that - we're checking result later, so this can't be the case.
> 
> Now the other interesting thing is the memset in __scsi_exectute,
> which looks very suspicious.  Try the following please:
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3e32dc954c3c..22f4fb550561 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -253,7 +253,8 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	 * and prevent security leaks by zeroing out the excess data.
>  	 */
>  	if (unlikely(rq->resid_len > 0 && rq->resid_len <= bufflen))
> -		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
> +//		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
> +		printk_ratelimited("%s: got resid %d\n", __func__, rq->resid_len);
>  
>  	if (resid)
>  		*resid = rq->resid_len;


Still fails but does print resid on some of the later INQUIRY commands (not the initial one).

[    1.222728] scsi host0: storvsc_host_t
[    1.230120] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.235358] scsi host1: storvsc_host_t
[    1.238629] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1ef2
[    1.241127] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xf00 length 36
[    1.242422] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.242423] hv_storvsc:  payload size 288 count 1 offset 3328 len 36 pfn 0x1f112b
[    1.242425] hv_storvsc:  sg 0: phys 0x1f112b000 virt ffff905db112b000 offset 0xd00 length 36
[    1.242427] data: 00000000: 05 80 00 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.242427] data: 00000010: 56 69 72 74 75 61 6c 20 44 56 44 2d 52 4f 4d 20  Virtual DVD-ROM 
[    1.242428] data: 00000020: 31 2e 30 20                                      1.0 
[    1.242456] scsi 1:0:0:0: CD-ROM            Msft     Virtual DVD-ROM  1.0  PQ: 0 ANSI: 0
[    1.242705] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.242706] hv_storvsc:  payload size 288 count 1 offset 2816 len 36 pfn 0x1f112b
[    1.242707] hv_storvsc:  sg 0: phys 0x1f112b000 virt ffff905db112b000 offset 0xb00 length 36
[    1.242708] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.242709] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.242709] data: 00000020: 00 00 00 00                                      ....
[    1.242730] scsi host1: scsi scan: INQUIRY result too short (5), using 36
[    1.242732] scsi 1:0:0:1: Direct-Access                                    PQ: 0 ANSI: 0
[    1.242982] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.242983] hv_storvsc:  payload size 288 count 1 offset 768 len 36 pfn 0x1f1129
[    1.242984] hv_storvsc:  sg 0: phys 0x1f1129000 virt ffff905db1129000 offset 0x300 length 36
[    1.242985] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.242986] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.242986] data: 00000020: 00 00 00 00                                      ....
[    1.243003] scsi 1:0:0:2: Direct-Access                                    PQ: 0 ANSI: 0
[    1.244180] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.244181] hv_storvsc:  payload size 288 count 1 offset 2048 len 36 pfn 0x1f1128
[    1.244181] hv_storvsc:  sg 0: phys 0x1f1128000 virt ffff905db1128000 offset 0x800 length 36
[    1.244182] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.244183] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.244183] data: 00000020: 00 00 00 00                                      ....
[    1.244202] scsi 1:0:0:3: Direct-Access                                    PQ: 0 ANSI: 0
[    1.244463] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.244463] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1129
[    1.244464] hv_storvsc:  sg 0: phys 0x1f1129000 virt ffff905db1129000 offset 0xa00 length 36
[    1.244465] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.244465] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.244466] data: 00000020: 00 00 00 00                                      ....
[    1.244481] scsi 1:0:0:4: Direct-Access                                    PQ: 0 ANSI: 0
[    1.247017] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.247018] hv_storvsc:  payload size 288 count 1 offset 256 len 36 pfn 0x1f112b
[    1.247019] hv_storvsc:  sg 0: phys 0x1f112b000 virt ffff905db112b000 offset 0x100 length 36
[    1.247021] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.247021] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.247021] data: 00000020: 00 00 00 00                                      ....
[    1.247051] scsi 1:0:0:5: Direct-Access                                    PQ: 0 ANSI: 0
[    1.247359] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.247372] hv_storvsc:  payload size 288 count 1 offset 768 len 36 pfn 0x1f112a
[    1.247379] hv_storvsc:  sg 0: phys 0x1f112a000 virt ffff905db112a000 offset 0x300 length 36
[    1.247391] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.247395] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.247402] data: 00000020: 00 00 00 00                                      ....
[    1.247429] scsi 1:0:0:6: Direct-Access                                    PQ: 0 ANSI: 0
[    1.247758] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x20 length 36
[    1.247758] hv_storvsc:  payload size 288 count 1 offset 1792 len 36 pfn 0x1f1129
[    1.247768] hv_storvsc:  sg 0: phys 0x1f1129000 virt ffff905db1129000 offset 0x700 length 36
[    1.247780] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.247781] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.247785] data: 00000020: 00 00 00 00                                      ....
[    1.247816] scsi 1:0:0:7: Direct-Access                                    PQ: 0 ANSI: 0
[    1.248097] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.248107] hv_storvsc:  payload size 288 count 1 offset 2048 len 36 pfn 0x1f112a
[    1.248107] hv_storvsc:  sg 0: phys 0x1f112a000 virt ffff905db112a000 offset 0x800 length 36
[    1.248120] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.248120] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    1.248130] data: 00000020: 31 2e 30 20                                      1.0 
[    1.284189] random: fast init done
[    1.594553] data: 00000000: 00 00 05 02 1f 00 00 02 4d 73 66 74 20 20 20 20  ........Msft    
[    1.598356] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    1.602223] data: 00000020: 31 2e 30 20                                      1.0 
[    1.605926] scsi 0:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 5
[    1.609761] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    1.610084] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.610085] hv_storvsc:  payload size 288 count 1 offset 2816 len 36 pfn 0x1f1277
[    1.610086] hv_storvsc:  sg 0: phys 0x1f1277000 virt ffff905db1277000 offset 0xb00 length 36
[    1.610088] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.610088] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    1.610089] data: 00000020: 31 2e 30 20                                      1.0 
[    1.661738] hv_storvsc:  payload size 288 count 1 offset 0 len 255 pfn 0x1e3ba3
[    1.665438] hv_storvsc:  sg 0: phys 0x1e3ba3000 virt ffff905da3ba3000 offset 0x0 length 255
[    1.682175] data: 00000000: 00 00 00 08 00 83 8f b0 b1 b2 ce cf 00 00 00 00  ................
[    1.683345] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.684363] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.692286] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.700453] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.708273] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.722436] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.739042] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.743325] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.747207] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.749977] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.754361] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.758723] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.776717] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.779593] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.783032] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00     ...............
[    1.787586] scsi_execute got resid 243
[    1.790063] hv_storvsc: INQUIRY cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 52
[    1.790333] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.790334] hv_storvsc:  payload size 288 count 1 offset 2816 len 36 pfn 0x1f1277
[    1.790336] hv_storvsc:  sg 0: phys 0x1f1277000 virt ffff905db1277000 offset 0xb00 length 36
[    1.790337] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.790338] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    1.790338] data: 00000020: 31 2e 30 20                                      1.0 
[    1.841715] hv_storvsc:  payload size 288 count 1 offset 0 len 255 pfn 0x1e3ba4
[    1.845524] hv_storvsc:  sg 0: phys 0x1e3ba4000 virt ffff905da3ba4000 offset 0x0 length 255
[    1.849966] data: 00000000: 00 83 00 30 01 01 00 18 4d 53 46 54 20 20 20 20  ...0....MSFT    
[    1.854428] data: 00000010: 43 77 cc 85 5f 19 c2 46 ac 48 c7 33 b9 dd 2d 2a  Cw.._..F.H.3..-*
[    1.857536] data: 00000020: 01 03 00 10 60 02 24 80 43 77 cc 85 5f 19 c7 33  ....`.$.Cw.._..3
[    1.861291] data: 00000030: b9 dd 2d 2a 00 00 00 00 00 00 00 00 00 00 00 00  ..-*............
[    1.865966] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.870546] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.901408] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.905671] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.910371] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.915072] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.935337] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.937999] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.941651] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.946651] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.951226] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    1.956304] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00     ...............
[    1.961435] scsi_execute got resid 203
[    1.964343] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    1.981642] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    1.986109] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    1.991274] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    1.999081] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.004044] data: 00000020: 31 2e 30 20                                      1.0 
[    2.009208] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.024655] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.028036] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.043219] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.049037] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.054207] data: 00000020: 31 2e 30 20                                      1.0 
[    2.065676] scsi_execute got resid 4080
[    2.069949] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.069959] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.069982] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.069983] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.069983] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.069988] data: 00000020: 31 2e 30 20                                      1.0 
[    2.102616] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.106612] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.106612] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.106612] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.106612] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.106612] data: 00000020: 31 2e 30 20                                      1.0 
[    2.141413] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.146437] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.151053] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.167892] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.172929] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.178172] data: 00000020: 31 2e 30 20                                      1.0 
[    2.183231] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.187227] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.187227] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.187227] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.187227] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.187227] data: 00000020: 31 2e 30 20                                      1.0 
[    2.225692] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.230942] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.251916] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.257345] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.262948] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.265758] data: 00000020: 31 2e 30 20                                      1.0 
[    2.271111] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.276522] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.307899] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.312390] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.318075] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.323732] data: 00000020: 31 2e 30 20                                      1.0 
[    2.341677] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.344063] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.348636] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.354366] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.360141] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.365879] data: 00000020: 31 2e 30 20                                      1.0 
[    2.371340] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.388088] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.393104] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.398875] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.405109] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.410898] data: 00000020: 31 2e 30 20                                      1.0 
[    2.416483] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.433832] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.441820] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.447883] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.454422] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.460592] data: 00000020: 31 2e 30 20                                      1.0 
[    2.469609] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.475498] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.480879] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.511232] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.512355] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.516218] data: 00000020: 31 2e 30 20                                      1.0 
[    2.522068] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.533055] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.547864] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.548934] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.550104] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.554974] data: 00000020: 31 2e 30 20                                      1.0 
[    2.561050] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.567070] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.572454] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.576416] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.580698] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.586924] data: 00000020: 31 2e 30 20                                      1.0 
[    2.610426] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.616682] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.622430] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.628825] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.635315] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.652806] data: 00000020: 31 2e 30 20                                      1.0 
[    2.670313] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.676530] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.682350] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.700658] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.708184] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.713235] data: 00000020: 31 2e 30 20                                      1.0 
[    2.718336] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.724701] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.730493] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.746543] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.751031] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.757802] data: 00000020: 31 2e 30 20                                      1.0 
[    2.764585] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.764859] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.764860] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.764861] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.764863] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.764863] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.764864] data: 00000020: 31 2e 30 20                                      1.0 
[    2.816336] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.822130] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.839623] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.850323] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.857409] data: 00000020: 31 2e 30 20                                      1.0 
[    2.864086] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.864232] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.864233] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.864235] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    2.864236] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.864237] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.864237] data: 00000020: 31 2e 30 20                                      1.0 
[    2.916881] hv_storvsc:  payload size 288 count 1 offset 3840 len 36 pfn 0x1f1275
[    2.937138] hv_storvsc:  sg 0: phys 0x1f1275000 virt ffff905db1275000 offset 0xf00 length 36
[    2.944036] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    2.964796] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    2.974043] data: 00000020: 31 2e 30 20                                      1.0 
[    2.979489] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    2.986125] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    2.992116] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    3.002950] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.011839] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    3.017573] data: 00000020: 31 2e 30 20                                      1.0 
[    3.024620] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.032025] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    3.038325] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    3.055645] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.062027] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    3.069190] data: 00000020: 31 2e 30 20                                      1.0 
[    3.088776] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.093542] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    3.099750] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    3.107258] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.114461] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    3.130818] data: 00000020: 31 2e 30 20                                      1.0 
[    3.139847] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.146845] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    3.166667] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    3.173167] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.178052] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    3.185482] data: 00000020: 31 2e 30 20                                      1.0 
[    3.192503] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.202257] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    3.213984] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    3.222230] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.231055] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    3.232606] data: 00000020: 31 2e 30 20                                      1.0 
[    3.234584] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.243386] hv_storvsc:  payload size 288 count 1 offset 2560 len 36 pfn 0x1f1ef2
[    3.275807] hv_storvsc:  sg 0: phys 0x1f1ef2000 virt ffff905db1ef2000 offset 0xa00 length 36
[    3.280650] data: 00000000: 7f 00 05 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.288369] data: 00000010: 56 69 72 74 75 61 6c 20 44 69 73 6b 20 20 20 20  Virtual Disk    
[    3.311133] data: 00000020: 31 2e 30 20                                      1.0 
[    3.313946] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.314755] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 8
[    3.314940] sr 1:0:0:0: [sr0] scsi3-mmc drive: 0x/0x caddy
[    3.314941] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.323114] hv_storvsc:  payload size 288 count 1 offset 1584 len 8 pfn 0x1f2687
[    3.327097] hv_storvsc:  sg 0: phys 0x1f2687000 virt ffff905db2687000 offset 0x630 length 8
[    3.337525] data: 00000000: 00 00 00 08 00 83 8f b0                          ........
[    3.341499] hv_storvsc: INQUIRY cmd 0x12 0x1 0xb2 scsi status 0x0 srb status 0x1 length 8
[    3.342988] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.342989] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1e3c1e
[    3.342990] hv_storvsc:  sg 0: phys 0x1e3c1e000 virt ffff905da3c1e000 offset 0x0 length 254
[    3.342992] data: 00000000: 05 80 00 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.342993] data: 00000010: 56 69 72 74 75 61 6c 20 44 56 44 2d 52 4f 4d 20  Virtual DVD-ROM 
[    3.342993] data: 00000020: 31 2e 30 20 00 00 00 00 00 00 00 00 00 00 00 00  1.0 ............
[    3.342994] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342994] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342995] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342995] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342996] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342996] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342997] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342997] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342998] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342999] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.342999] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343000] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343000] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.343180] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 6
[    3.343181] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1e3c1f
[    3.343181] hv_storvsc:  sg 0: phys 0x1e3c1f000 virt ffff905da3c1f000 offset 0x0 length 254
[    3.343182] data: 00000000: 05 00 00 02 00 83 00 00 00 00 00 00 00 00 00 00  ................
[    3.343182] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343183] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343183] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343183] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343184] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343184] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343184] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343185] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343185] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343186] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343186] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343186] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343187] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343187] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343188] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.343225] hv_storvsc: INQUIRY cmd 0x12 0x1 0x80 scsi status 0x2 srb status 0x84 length 0
[    3.343225] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1e3c1f
[    3.343226] hv_storvsc:  sg 0: phys 0x1e3c1f000 virt ffff905da3c1f000 offset 0x0 length 254
[    3.343226] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343227] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343227] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343228] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343228] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343228] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343229] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343229] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343229] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343230] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343230] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343231] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343231] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343231] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343232] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343232] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.343263] hv_storvsc: INQUIRY cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 32
[    3.343264] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1e3c1f
[    3.343264] hv_storvsc:  sg 0: phys 0x1e3c1f000 virt ffff905da3c1f000 offset 0x0 length 254
[    3.343265] data: 00000000: 05 83 00 1c 01 01 00 18 4d 53 46 54 20 20 20 20  ........MSFT    
[    3.343265] data: 00000010: 73 05 e3 43 77 03 54 46 94 95 7d 7c ed 62 4a 7d  s..Cw.TF..}|.bJ}
[    3.343265] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343266] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343266] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343266] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343267] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343267] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343268] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343268] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343268] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343269] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343269] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343270] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343270] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.343270] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.344623] hv_storvsc: INQUIRY cmd 0x12 0x0 0x0 scsi status 0x0 srb status 0x1 length 36
[    3.344624] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1f064f
[    3.344625] hv_storvsc:  sg 0: phys 0x1f064f000 virt ffff905db064f000 offset 0x0 length 254
[    3.344626] data: 00000000: 05 80 00 02 1f 00 00 00 4d 73 66 74 20 20 20 20  ........Msft    
[    3.344627] data: 00000010: 56 69 72 74 75 61 6c 20 44 56 44 2d 52 4f 4d 20  Virtual DVD-ROM 
[    3.344627] data: 00000020: 31 2e 30 20 00 00 00 00 00 00 00 00 00 00 00 00  1.0 ............
[    3.344628] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344628] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344628] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344629] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344629] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344629] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344630] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344630] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344631] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344631] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344631] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344632] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344632] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.344807] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 6
[    3.344808] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1f064e
[    3.344809] hv_storvsc:  sg 0: phys 0x1f064e000 virt ffff905db064e000 offset 0x0 length 254
[    3.344810] data: 00000000: 05 00 00 02 00 83 00 00 00 00 00 00 00 00 00 00  ................
[    3.344810] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344811] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344811] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344812] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344812] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344812] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344813] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344814] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344814] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344815] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344816] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344816] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344817] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344817] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344818] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.344848] hv_storvsc: INQUIRY cmd 0x12 0x1 0x80 scsi status 0x2 srb status 0x84 length 0
[    3.344849] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1f064e
[    3.344849] hv_storvsc:  sg 0: phys 0x1f064e000 virt ffff905db064e000 offset 0x0 length 254
[    3.344850] data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344850] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344851] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344851] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344851] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344852] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344852] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344853] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344853] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344853] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344854] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344854] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344855] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344855] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344855] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344856] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.344886] hv_storvsc: INQUIRY cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 32
[    3.344886] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1f064e
[    3.344887] hv_storvsc:  sg 0: phys 0x1f064e000 virt ffff905db064e000 offset 0x0 length 254
[    3.344887] data: 00000000: 05 83 00 1c 01 01 00 18 4d 53 46 54 20 20 20 20  ........MSFT    
[    3.344888] data: 00000010: 73 05 e3 43 77 03 54 46 94 95 7d 7c ed 62 4a 7d  s..Cw.TF..}|.bJ}
[    3.344888] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344889] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344890] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344890] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344891] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344891] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344892] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344893] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344893] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344894] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344894] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344895] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344896] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    3.344896] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[    3.356067] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.356223] sd 1:0:0:1: Attached scsi generic sg2 type 0
[    3.356263] scsi_execute got resid 8
[    3.356265] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    3.356268] sd 1:0:0:1: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[    3.356269] sd 1:0:0:1: [sdb] 0-byte physical blocks
[    3.356294] sd 1:0:0:1: [sdb] Write Protect is off
[    3.356317] sd 1:0:0:2: Attached scsi generic sg3 type 0
[    3.356325] sd 1:0:0:1: [sdb] Asking for cache data failed
[    3.356326] sd 1:0:0:1: [sdb] Assuming drive cache: write through
[    3.356755] scsi_execute got resid 8
[    3.356757] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    3.357078] sd 1:0:0:3: Attached scsi generic sg4 type 0
[    3.357729] sd 1:0:0:4: Attached scsi generic sg5 type 0
[    3.357968] sd 1:0:0:5: Attached scsi generic sg6 type 0
[    3.358146] sd 1:0:0:6: Attached scsi generic sg7 type 0
[    3.358470] sd 1:0:0:7: Attached scsi generic sg8 type 0
[    3.358405] blk_update_request: I/O error, dev sdb, sector 0
[    3.358407] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358416] blk_update_request: I/O error, dev sdb, sector 0
[    3.358416] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358420] blk_update_request: I/O error, dev sdb, sector 0
[    3.358421] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358422] ldm_validate_partition_table(): Disk read failed.
[    3.358440] blk_update_request: I/O error, dev sdb, sector 0
[    3.358441] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358444] blk_update_request: I/O error, dev sdb, sector 0
[    3.358445] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358448] blk_update_request: I/O error, dev sdb, sector 0
[    3.358448] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358451] blk_update_request: I/O error, dev sdb, sector 0
[    3.358452] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358453] Dev sdb: unable to read RDB block 0
[    3.358455] blk_update_request: I/O error, dev sdb, sector 0
[    3.358456] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358459] blk_update_request: I/O error, dev sdb, sector 0
[    3.358459] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358463] blk_update_request: I/O error, dev sdb, sector 0
[    3.358463] Buffer I/O error on dev sdb, logical block 0, async page read
[    3.358467]  sdb: unable to read partition table
[    3.358470] sdb: partition table beyond EOD, enabling native capacity
[    3.358668] scsi_execute got resid 8
[    3.358668] sd 1:0:0:2: [sdc] Sector size 0 reported, assuming 512.
[    3.358668] sd 1:0:0:2: [sdc] 1 512-byte logical blocks: (512 B/512 B)
[    3.358668] sd 1:0:0:2: [sdc] 0-byte physical blocks
[    3.358668] sd 1:0:0:2: [sdc] Write Protect is off
[    3.358668] sd 1:0:0:2: [sdc] Asking for cache data failed
[    3.358668] sd 1:0:0:2: [sdc] Assuming drive cache: write through
[    3.358737] scsi_execute got resid 8
[    3.358738] sd 1:0:0:2: [sdc] Sector size 0 reported, assuming 512.
[    3.359714] scsi_execute got resid 8
[    3.359717] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    3.359898] ldm_validate_partition_table(): Disk read failed.
[    3.359906] Dev sdb: unable to read RDB block 0
[    3.359913]  sdb: unable to read partition table
[    3.359915] sdb: partition table beyond EOD, truncated
[    3.360297] scsi_execute got resid 8
[    3.360300] sd 1:0:0:1: [sdb] Sector size 0 reported, assuming 512.
[    3.360368] sd 1:0:0:1: [sdb] Attached SCSI disk
[    3.360454] scsi_execute got resid 8
[    3.360456] sd 1:0:0:3: [sdd] Sector size 0 reported, assuming 512.
[    3.360458] sd 1:0:0:3: [sdd] 1 512-byte logical blocks: (512 B/512 B)
[    3.360459] sd 1:0:0:3: [sdd] 0-byte physical blocks
[    3.360509] sd 1:0:0:3: [sdd] Write Protect is off
[    3.360542] sd 1:0:0:3: [sdd] Asking for cache data failed
[    3.360550] sd 1:0:0:3: [sdd] Assuming drive cache: write through
[    3.360759] sd 1:0:0:3: [sdd] Sector size 0 reported, assuming 512.
[    3.447345] random: crng init done
[    4.116192] sd 1:0:0:4: [sde] Sector size 0 reported, assuming 512.
[    4.116195] sd 1:0:0:4: [sde] 1 512-byte logical blocks: (512 B/512 B)
[    4.116197] sd 1:0:0:4: [sde] 0-byte physical blocks
[    4.116234] sd 1:0:0:4: [sde] Write Protect is off
[    4.116293] sd 1:0:0:4: [sde] Asking for cache data failed
[    4.116294] sd 1:0:0:4: [sde] Assuming drive cache: write through
[    4.116298] sd 1:0:0:5: [sdf] Sector size 0 reported, assuming 512.
[    4.116301] sd 1:0:0:5: [sdf] 1 512-byte logical blocks: (512 B/512 B)
[    4.116302] sd 1:0:0:5: [sdf] 0-byte physical blocks
[    4.116330] sd 1:0:0:6: [sdg] Sector size 0 reported, assuming 512.
[    4.116332] sd 1:0:0:6: [sdg] 1 512-byte logical blocks: (512 B/512 B)
[    4.116332] sd 1:0:0:6: [sdg] 0-byte physical blocks
[    4.116339] sd 1:0:0:5: [sdf] Write Protect is off
[    4.116378] sd 1:0:0:5: [sdf] Asking for cache data failed
[    4.116379] sd 1:0:0:5: [sdf] Assuming drive cache: write through
[    4.116433] sd 1:0:0:7: [sdh] Sector size 0 reported, assuming 512.
[    4.116435] sd 1:0:0:7: [sdh] 1 512-byte logical blocks: (512 B/512 B)
[    4.116436] sd 1:0:0:7: [sdh] 0-byte physical blocks
[    4.116467] sd 1:0:0:4: [sde] Sector size 0 reported, assuming 512.
[    4.116564] sd 1:0:0:7: [sdh] Write Protect is off
[    4.116609] sd 1:0:0:5: [sdf] Sector size 0 reported, assuming 512.
[    4.116636] sd 1:0:0:6: [sdg] Write Protect is off
[    4.116630] sd 1:0:0:7: [sdh] Asking for cache data failed
[    4.116631] sd 1:0:0:7: [sdh] Assuming drive cache: write through
[    4.116701] sd 1:0:0:6: [sdg] Asking for cache data failed
[    4.116702] sd 1:0:0:6: [sdg] Assuming drive cache: write through
[    4.116887] sd 1:0:0:7: [sdh] Sector size 0 reported, assuming 512.
[    4.116949] sd 1:0:0:6: [sdg] Sector size 0 reported, assuming 512.
[    5.304128] hv_storvsc:  payload size 288 count 1 offset 1584 len 8 pfn 0x1f2687
[    5.306669] hv_storvsc:  sg 0: phys 0x1f2687000 virt ffff905db2687000 offset 0x630 length 8
[    5.309498] data: 00000000: 00 b2 00 04 01 80 02 00                          ........
[    5.312871] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    5.315883] hv_storvsc:  payload size 288 count 1 offset 2496 len 64 pfn 0x1f98c9
[    5.318004] hv_storvsc:  sg 0: phys 0x1f98c9000 virt ffff905db98c9000 offset 0x9c0 length 64
[    5.320694] data: 00000000: 00 00 00 08 00 83 8f b0 b1 b2 ce cf 00 00 ad de  ................
[    5.323745] data: 00000010: 00 02 00 00 00 00 ad de 01 00 00 00 00 00 00 00  ................
[    5.341373] data: 00000020: 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
[    5.344177] data: 00000030: 00 00 00 00 00 00 00 00 d5 0b 50 b2 ff ff ff ff  ..........P.....
[    5.347673] hv_storvsc: INQUIRY cmd 0x12 0x1 0xb0 scsi status 0x0 srb status 0x1 length 64
[    5.350101] hv_storvsc:  payload size 288 count 1 offset 2496 len 64 pfn 0x1f98c9
[    5.352539] hv_storvsc:  sg 0: phys 0x1f98c9000 virt ffff905db98c9000 offset 0x9c0 length 64
[    5.355472] data: 00000000: 00 b0 00 3c 00 01 00 00 00 00 00 00 00 00 00 00  ...<............
[    5.358303] data: 00000010: 00 00 00 00 ff ff ff ff 00 00 10 00 00 01 00 00  ................
[    5.361471] data: 00000020: 80 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00  ..........@.....
[    5.364390] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    5.367553] hv_storvsc: INQUIRY cmd 0x12 0x1 0x0 scsi status 0x0 srb status 0x1 length 12
[    5.369817] hv_storvsc:  payload size 288 count 1 offset 2496 len 64 pfn 0x1f98c9
[    5.375006] hv_storvsc:  sg 0: phys 0x1f98c9000 virt ffff905db98c9000 offset 0x9c0 length 64
[    5.377634] data: 00000000: 00 00 00 08 00 83 8f b0 b1 b2 ce cf 00 00 00 00  ................
[    5.380280] data: 00000010: 00 00 00 00 ff ff ff ff 00 00 10 00 00 01 00 00  ................
[    5.383063] data: 00000020: 80 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00  ..........@.....
[    5.385518] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    5.397950] hv_storvsc: INQUIRY cmd 0x12 0x1 0xb1 scsi status 0x0 srb status 0x1 length 64
[    5.421755] hv_storvsc:  payload size 288 count 1 offset 2496 len 64 pfn 0x1f98c9
[    5.424121] hv_storvsc:  sg 0: phys 0x1f98c9000 virt ffff905db98c9000 offset 0x9c0 length 64
[    5.427212] data: 00000000: 00 b1 00 3c 00 00 00 00 00 00 00 00 00 00 00 00  ...<............
[    5.429834] data: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    5.432738] data: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    5.449282] data: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[    5.461140] sd 0:0:0:0: [sda] 266338304 512-byte logical blocks: (136 GB/127 GiB)
[    5.464335] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    5.467012] sd 0:0:0:0: [sda] Write Protect is off
[    5.468759] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
