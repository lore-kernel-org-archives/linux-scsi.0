From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [Stgt-devel] Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 16:44:31 +0300
Message-ID: <478F5BBF.3080905@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>	<478F246C.4040400@vlnb.net>	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>	<478F2F46.9040103@vlnb.net> <20080117122956.GA3567@porcupine.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:47222 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbYAQNod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 08:44:33 -0500
In-Reply-To: <20080117122956.GA3567@porcupine.cita.utoronto.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robin Humble <robin.humble+stgt@anu.edu.au>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@hansenpartnership.com, scst-devel@lists.sourceforge.net, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org

Robin Humble wrote:
> On Thu, Jan 17, 2008 at 01:34:46PM +0300, Vladislav Bolkhovitin wrote:
> 
>>Hmm, I can't find which IB hardware did he use and it's declared Gbps 
>>speed. He declared only "Mellanox 4X SDR, switch". What does it mean?
> 
> 
> SDR is 10Gbit carrier, at most about  ~900MB/s data rate.
> DDR is 20Gbit carrier, at most about ~1400MB/s data rate.

Thanks. Then the single threaded rate with one outstanding command 
between SCST SRP on 8Gbps link vs STGT iSRP on 10Gbps link (according to 
that paper) is 600MB/s vs ~480MB/s (page 26). Still SCST based target is 
about 60% faster.

> On Thu, 17 Jan 2008 10:27:08 +0100 "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> 
>>Test performed: read 2 GB of data in blocks of 1 MB from a target (hot                                                                                                       
>>cache -- no disk reads were performed, all reads were from the cache).                                                                                                       
>>Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000                                                                                                              
>>                                                                                                                                                                             
>>                              STGT read             SCST read                                                                                                                
>>                           performance (MB/s)   performance (MB/s)                                                                                                           
>>Ethernet (1 Gb/s network)        77                    89                                                                                                                    
>>IPoIB (8 Gb/s network)           82                   229                                                                                                                    
>>SRP (8 Gb/s network)            N/A                   600                                                                                                                    
>>iSER (8 Gb/s network)            80                   N/A                                                                                                                    
> 
> 
> it kinda looks to me like the tgt iSER tests were waaay too slow to be
> using RDMA :-/
> I use tgt to get 500MB/s writes over iSER DDR IB to real files (not
> ramdisk). Reads are a little slower, but that changes a bit with distro
> vs. mainline kernels.
