From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: initial LIO iSER performance numbers [was: GIT PULL] target
 updates for v3.10-rc1)
Date: Thu, 02 May 2013 12:31:55 -0700
Message-ID: <1367523115.23900.118.camel@haakon3.risingtidesystems.com>
References: <1367290766.16334.77.camel@haakon3.risingtidesystems.com>
	 <51827114.9010907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51827114.9010907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Asias He <asias-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Shlomi Sasson <shlomis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-05-02 at 16:58 +0300, Or Gerlitz wrote:
> On 30/04/2013 05:59, Nicholas A. Bellinger wrote:
> > Hello Linus!
> >
> > Here are the target pending changes for the v3.10-rc1 merge window.
> >
> > Please go ahead and pull from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge
> >

<SNIP>

> Hi Nic, everyone,
> 
> So LIO iser target code is now merged into Linus tree, and will be in 
> kernel 3.10, exciting!
> 
> Here's some data on raw performance numbers we were able to get with the 
> LIO iser code.
> 
> For single initiator and single lun, block sizes varying over the range 
> 1KB,2KB... 128KB
> doing random read:
> 
> 1KB 227,870K
> 2KB 458,099K
> 4KB 909,761K
> 8KB 1,679,922K
> 16KB 3,233,753K
> 32KB 4,905,139K
> 64KB 5,294,873K
> 128KB 5,565,235K
> 
> When enlarging the number of luns and still with single initiator, for 
> 1KB randomreads we get:
> 
> 1 LUN  = 230k IOPS
> 2 LUNs = 420k IOPS
> 4 LUNs = 740k IOPS
> 
> When enlarging the number of initiators, and each having four lunswe get 
> for 1KB random reads:
> 
> 1 initiator  x 4 LUNs = 740k  IOPS
> 2 initiators x 4 LUNs = 1480k IOPS
> 3 initiators x 4 LUNs = 1570k IOPS
> 
> So all in all, things scale pretty nicely, and we observe a some bottleneck
> in the IOPS rate around 1.6 Million IOPS, so there's where to improve...
> 

Excellent.  Thanks for the posting these initial performance results.

> Here's the fio command line used by the initiators
> 
> $ fio --cpumask=0xfc --rw=randread --bs=1k --numjobs=2 --iodepth=128 
> --runtime=62 --time_based --size=1073741824k --loops=1 --ioengine=libaio 
> --direct=1 --invalidate=1 --fsync_on_close=1 --randrepeat=1 
> --norandommap --group_reporting --exitall --name 
> dev-sdb-randread-1k-2thr-libaio-128iodepth-62sec --filename=/dev/sdb
> 
> And some details on the setup:
> 
> The nodes are HP ProLiant DL380p Gen8 with the following CPU: Intel(R) 
> Xeon(R) CPU E5-2650 0 @ 2.00GHz
> two NUMA nodes with eight cores each, 32GB RAM, PCI express gen3 8x, the 
> HCA being Mellanox ConnectX3 with firmware 2.11.500
> 
> The target node was running upstream kernel and the initiators RHEL 6.3 
> kernel, all X86_64
> 
> We used RAMDISK_MCP backend which was patched to act as NULL device, so 
> we can test the raw iSER wire performance.
> 

Btw, I'll be including a similar patch to allow for RAMDISK_NULL to be
configured as a NULL device mode.

Thanks Or & Co!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
