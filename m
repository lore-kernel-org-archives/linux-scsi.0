From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Thu, 07 Apr 2016 22:30:28 -0700
Message-ID: <1460093428.13128.5.camel@haakon3.risingtidesystems.com>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Laurence,

On Thu, 2016-04-07 at 17:15 -0400, Laurence Oberman wrote:
> Hello
> 
> I have been testing the SRP initiator code to an LIO array here and
> part of the testing requires me to set the max_sectors_kb size to get
> 4k I/O's.
> This has been due to me having to debug various sg_map issues.
> 
> Linux srptest 4.5.0 #2 SMP Thu Apr 7 16:14:38 EDT 2016 x86_64 x86_64
> x86_64 GNU/Linux
> This kernel has the scan patch from Hannes, as well as the "[PATCH]
> IB/mlx5: Expose correct max_sge_rd limit" patch. 
> However, I also tested with vanilla 4.5.0 as well and its the same
> issue.
> 
> For some reason I cannot change the max_sectors_kb size on 4.5.0 here.
> 
> I chatted with Ewan about it as well and he reminded me about Martins
> changes so wondering if that's playing into this.
> 
> Take /dev/sdb as an example
> 
> [root@srptest queue]# sg_inq --p 0xb0 /dev/sdb
> VPD INQUIRY: Block limits page (SBC)
>   Maximum compare and write length: 1 blocks
>   Optimal transfer length granularity: 256 blocks
>   Maximum transfer length: 256 blocks
>   Optimal transfer length: 768 blocks
>   Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
> 

Just curious what target backend this is with..?

Specifically the optimal transfer length granularity and optimal
transfer length may be reported by underlying backend device (eg:
IBLOCK) in spc_emulate_evpd_b0(). 

What does 'head /sys/kernel/config/target/core/$HBA/$DEV/attrib/*'
of the backend device in question look like..?
