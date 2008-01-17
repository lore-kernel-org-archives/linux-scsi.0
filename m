From: Robin Humble <robin.humble+stgt-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Thu, 17 Jan 2008 07:29:56 -0500
Message-ID: <20080117122956.GA3567@porcupine.cita.utoronto.ca>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<478F2F46.9040103@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <478F2F46.9040103-d+Crzxg7Rs0@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 17, 2008 at 01:34:46PM +0300, Vladislav Bolkhovitin wrote:
>Hmm, I can't find which IB hardware did he use and it's declared Gbps 
>speed. He declared only "Mellanox 4X SDR, switch". What does it mean?

SDR is 10Gbit carrier, at most about  ~900MB/s data rate.
DDR is 20Gbit carrier, at most about ~1400MB/s data rate.

On Thu, 17 Jan 2008 10:27:08 +0100 "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Test performed: read 2 GB of data in blocks of 1 MB from a target (hot                                                                                                       
> cache -- no disk reads were performed, all reads were from the cache).                                                                                                       
> Test command: time dd if=/dev/sde of=/dev/null bs=1M count=2000                                                                                                              
>                                                                                                                                                                              
>                               STGT read             SCST read                                                                                                                
>                            performance (MB/s)   performance (MB/s)                                                                                                           
> Ethernet (1 Gb/s network)        77                    89                                                                                                                    
> IPoIB (8 Gb/s network)           82                   229                                                                                                                    
> SRP (8 Gb/s network)            N/A                   600                                                                                                                    
> iSER (8 Gb/s network)            80                   N/A                                                                                                                    

it kinda looks to me like the tgt iSER tests were waaay too slow to be
using RDMA :-/
I use tgt to get 500MB/s writes over iSER DDR IB to real files (not
ramdisk). Reads are a little slower, but that changes a bit with distro
vs. mainline kernels.

was iscsiadm was pointed at the IP of the IPoIB interface on the
target? I think tgtd requires that.

how about setting the transport to be iser with eg.
  iscsiadm --mode node --targetname <something> --portal <ipoib>:3260 --op update -n node.transport_name -v iser
  iscsiadm --mode node --targetname <something> --portal <ipoib>:3260 --op update -n "node.conn[0].iscsi.HeaderDigest" -v None

does the initiator side kernel report that it's using iSER?
it should look roughly like the below.

 Jan 14 14:37:21 x2 kernel: iscsi: registered transport (iser) 
 Jan 14 14:37:21 x2 iscsid: iSCSI logger with pid=5617 started! 
 Jan 14 14:37:22 x2 iscsid: transport class version 2.0-724. iscsid version 2.0-865 
 Jan 14 14:37:22 x2 iscsid: iSCSI daemon with pid=5618 started! 
 Jan 14 14:37:22 x2 kernel: iser: iser_connect:connecting to: 192.168.1.8, port 0xbc0c 
 Jan 14 14:37:23 x2 kernel: iser: iser_cma_handler:event 0 conn ffff8102523c4c80 id ffff81025df68e00 
 Jan 14 14:37:23 x2 kernel: iser: iser_cma_handler:event 2 conn ffff8102523c4c80 id ffff81025df68e00 
 Jan 14 14:37:24 x2 kernel: iser: iser_create_ib_conn_res:setting conn ffff8102523c4c80 cma_id ffff81025df68e00: fmr_pool ffff81025341b5c0 qp ffff810252109200 
 Jan 14 14:37:24 x2 kernel: iser: iser_cma_handler:event 9 conn ffff8102523c4c80 id ffff81025df68e00 
 Jan 14 14:37:24 x2 kernel: iser: iscsi_iser_ep_poll:ib conn ffff8102523c4c80 rc = 1 
 Jan 14 14:37:24 x2 kernel: scsi6 : iSCSI Initiator over iSER, v.0.1 
 Jan 14 14:37:24 x2 kernel: iser: iscsi_iser_conn_bind:binding iscsi conn ffff810251a94290 to iser_conn ffff8102523c4c80 
 Jan 14 14:37:24 x2 kernel:   Vendor: IET       Model: Controller        Rev: 0001 
 Jan 14 14:37:24 x2 kernel:   Type:   RAID                               ANSI SCSI revision: 05 
 Jan 14 14:37:24 x2 kernel: scsi 6:0:0:0: Attached scsi generic sg2 type 12 
 Jan 14 14:37:25 x2 kernel:   Vendor: IET       Model: VIRTUAL-DISK      Rev: 0001 
 Jan 14 14:37:25 x2 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05 
 Jan 14 14:37:25 x2 kernel: SCSI device sdc: 20971520 512-byte hdwr sectors (10737 MB) 
 Jan 14 14:37:25 x2 kernel: sdc: Write Protect is off 
 Jan 14 14:37:25 x2 kernel: SCSI device sdc: drive cache: write back 
 Jan 14 14:37:25 x2 kernel: SCSI device sdc: 20971520 512-byte hdwr sectors (10737 MB) 
 Jan 14 14:37:25 x2 kernel: sdc: Write Protect is off 
 Jan 14 14:37:25 x2 kernel: SCSI device sdc: drive cache: write back 
 Jan 14 14:37:25 x2 kernel:  sdc: unknown partition table 
 Jan 14 14:37:25 x2 kernel: sd 6:0:0:1: Attached scsi disk sdc 
 Jan 14 14:37:26 x2 kernel: sd 6:0:0:1: Attached scsi generic sg3 type 0 
 Jan 14 14:37:26 x2 iscsid: connection1:0 is operational now 

cheers,
robin
