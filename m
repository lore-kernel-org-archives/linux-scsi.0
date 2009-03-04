From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
 scsi-sgpool)objects
Date: Wed, 4 Mar 2009 22:45:28 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903042232270.29264@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>  <49ACF8FE.2020904@panasas.com>  <1236093718.3263.3.camel@localhost.localdomain>  <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>  <1236097526.3263.17.camel@localhost.localdomain>
  <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>  <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain> <1236119195.24019.24.camel@localhost.localdomain> <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:54112 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZCDVpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 16:45:45 -0500
In-Reply-To: <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

On Wed, 4 Mar 2009, Thomas Gleixner wrote:

Instrumented the code and the result of the failing request is
below. Looks like the function which sets up the request gets
nr_phys_segments wrong by one. 

If you need further trace data feel free to ask.

Thanks,

	tglx

bvprv: bvec_to_phys(bvprv)
bvec:  bvec_to_phys(bvec)
max_segment_size is 65536

scsi_init_sgtable: ISG: nr_seg 9 nents 9

blk_rq_map_sg: MSG: nbytes 4096

blk_rq_map_sg: MSG: new segment 1: bvec 0x6a8cd000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8cd000 bvec 0x6a8ce000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ce000 bvec 0x6a8cf000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8cf000 bvec 0x6a8d0000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d0000 bvec 0x6a8d1000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d1000 bvec 0x6a8d2000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d2000 bvec 0x6a8d3000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d3000 bvec 0x6a8d4000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d4000 bvec 0x6a8d5000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d5000 bvec 0x6a8d6000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d6000 bvec 0x6a8d7000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d7000 bvec 0x6a8d8000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d8000 bvec 0x6a8d9000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8d9000 bvec 0x6a8da000 sg->length 53248 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8da000 bvec 0x6a8db000 sg->length 57344 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8db000 bvec 0x6a8dc000 sg->length 61440 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8dc000 bvec 0x6a8dd000 sg->length 65536 

blk_rq_map_sg: MSG: new segment 2: bvec 0x6a8dd000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8dd000 bvec 0x6a8de000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8de000 bvec 0x6a8df000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8df000 bvec 0x6a8e0000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e0000 bvec 0x6a8e1000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e1000 bvec 0x6a8e2000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e2000 bvec 0x6a8e3000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e3000 bvec 0x6a8e4000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e4000 bvec 0x6a8e5000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e5000 bvec 0x6a8e6000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e6000 bvec 0x6a8e7000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e7000 bvec 0x6a8e8000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e8000 bvec 0x6a8e9000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8e9000 bvec 0x6a8ea000 sg->length 53248 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ea000 bvec 0x6a8eb000 sg->length 57344 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8eb000 bvec 0x6a8ec000 sg->length 61440 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ec000 bvec 0x6a8ed000 sg->length 65536 

blk_rq_map_sg: MSG: new segment 3: bvec 0x6a8ed000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ed000 bvec 0x6a8ee000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ee000 bvec 0x6a8ef000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ef000 bvec 0x6a8f0000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f0000 bvec 0x6a8f1000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f1000 bvec 0x6a8f2000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f2000 bvec 0x6a8f3000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f3000 bvec 0x6a8f4000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f4000 bvec 0x6a8f5000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f5000 bvec 0x6a8f6000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f6000 bvec 0x6a8f7000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f7000 bvec 0x6a8f8000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f8000 bvec 0x6a8f9000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8f9000 bvec 0x6a8fa000 sg->length 53248 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8fa000 bvec 0x6a8fb000 sg->length 57344 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8fb000 bvec 0x6a8fc000 sg->length 61440 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8fc000 bvec 0x6a8fd000 sg->length 65536 

blk_rq_map_sg: MSG: new segment 4: bvec 0x6a8fd000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8fd000 bvec 0x6a8fe000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8fe000 bvec 0x6a8ff000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6a8ff000 bvec 0x6ac80000 sg->length 12288 

blk_rq_map_sg: MSG: new segment 5: bvec 0x6ac80000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac80000 bvec 0x6ac81000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac81000 bvec 0x6ac82000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac82000 bvec 0x6ac83000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac83000 bvec 0x6ac84000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac84000 bvec 0x6ac85000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac85000 bvec 0x6ac86000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac86000 bvec 0x6ac87000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac87000 bvec 0x6ac88000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac88000 bvec 0x6ac89000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac89000 bvec 0x6ac8a000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac8a000 bvec 0x6ac8b000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac8b000 bvec 0x6ac8c000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ac8c000 bvec 0x6accd000 sg->length 53248 

blk_rq_map_sg: MSG: new segment 6: bvec 0x6accd000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6accd000 bvec 0x6acce000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acce000 bvec 0x6accf000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6accf000 bvec 0x6acd0000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd0000 bvec 0x6acd1000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd1000 bvec 0x6acd2000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd2000 bvec 0x6acd3000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd3000 bvec 0x6acd4000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd4000 bvec 0x6acd5000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd5000 bvec 0x6acd6000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd6000 bvec 0x6acd7000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd7000 bvec 0x6acd8000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd8000 bvec 0x6acd9000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acd9000 bvec 0x6acda000 sg->length 53248 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acda000 bvec 0x6acdb000 sg->length 57344 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acdb000 bvec 0x6acdc000 sg->length 61440 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acdc000 bvec 0x6acdd000 sg->length 65536 

blk_rq_map_sg: MSG: new segment 7: bvec 0x6acdd000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acdd000 bvec 0x6acde000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acde000 bvec 0x6acdf000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acdf000 bvec 0x6ace0000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace0000 bvec 0x6ace1000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace1000 bvec 0x6ace2000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace2000 bvec 0x6ace3000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace3000 bvec 0x6ace4000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace4000 bvec 0x6ace5000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace5000 bvec 0x6ace6000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace6000 bvec 0x6ace7000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace7000 bvec 0x6ace8000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace8000 bvec 0x6ace9000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6ace9000 bvec 0x6acea000 sg->length 53248 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acea000 bvec 0x6aceb000 sg->length 57344 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6aceb000 bvec 0x6acec000 sg->length 61440 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acec000 bvec 0x6aced000 sg->length 65536 

blk_rq_map_sg: MSG: new segment 8: bvec 0x6aced000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6aced000 bvec 0x6acee000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acee000 bvec 0x6acef000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acef000 bvec 0x6acf0000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf0000 bvec 0x6acf1000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf1000 bvec 0x6acf2000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf2000 bvec 0x6acf3000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf3000 bvec 0x6acf4000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf4000 bvec 0x6acf5000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf5000 bvec 0x6acf6000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf6000 bvec 0x6acf7000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf7000 bvec 0x6acf8000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf8000 bvec 0x6acf9000 sg->length 49152 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acf9000 bvec 0x6acfa000 sg->length 53248 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acfa000 bvec 0x6acfb000 sg->length 57344 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acfb000 bvec 0x6acfc000 sg->length 61440 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acfc000 bvec 0x6acfd000 sg->length 65536 

blk_rq_map_sg: MSG: new segment 9: bvec 0x6acfd000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acfd000 bvec 0x6acfe000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acfe000 bvec 0x6acff000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6acff000 bvec 0x6b080000 sg->length 12288 

blk_rq_map_sg: MSG: new segment 10: bvec 0x6b080000

blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b080000 bvec 0x6b081000 sg->length 4096 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b081000 bvec 0x6b082000 sg->length 8192 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b082000 bvec 0x6b083000 sg->length 12288 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b083000 bvec 0x6b084000 sg->length 16384 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b084000 bvec 0x6b085000 sg->length 20480 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b085000 bvec 0x6b086000 sg->length 24576 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b086000 bvec 0x6b087000 sg->length 28672 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b087000 bvec 0x6b088000 sg->length 32768 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b088000 bvec 0x6b089000 sg->length 36864 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b089000 bvec 0x6b08a000 sg->length 40960 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b08a000 bvec 0x6b08b000 sg->length 45056 
blk_rq_map_sg: MSG: nbytes 4096
blk_rq_map_sg: MSG: bvprv 0x6b08b000 bvec 0x6b08c000 sg->length 49152 

scsi_init_sgtable: ISG: count 10
