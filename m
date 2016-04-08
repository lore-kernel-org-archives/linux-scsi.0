From: Laurence Oberman <loberman@redhat.com>
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Fri, 8 Apr 2016 04:15:55 -0400 (EDT)
Message-ID: <178841135.28013178.1460103355699.JavaMail.zimbra@redhat.com>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com> <1460093428.13128.5.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46843 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbcDHIP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 04:15:58 -0400
In-Reply-To: <1460093428.13128.5.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

Hello Nicholas

Using fedora here and LIO/
The same array is used in testing the RHEL and upstream kernels.

Linux fedstorage 4.5.0-rc7+ #1 SMP Sun Mar 13 16:30:39 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux

I have 3 NVME cards striped in an LVM configuration and I create the block devices using LVM and then provision using targetcli.

I had not tuned anything on the LIO target because I was able to change the max_sectors_kb on the RHEL kernel.
Looking at the I/O size I was issuing on the initiator I confirmed the 4MB I/O was working on the RHEL kernel.
I realized of course it was possible the I/O could be broken down on the target by the time it handled the I/O but I was not focusing on that.

When I started testing upstream because I bumped into the various sg_map issues this is when I found the different behavior on the LUNS on the initiator.

Let me know if you think this is an array side tuning issue.
optimal_sectors = 256
hw_max_sectors = 256


/sys/kernel/config/target/core/iblock_0/block-1

[root@fedstorage iblock_0]# cat hba_info
HBA Index: 1 plugin: iblock version: v5.0
[root@fedstorage iblock_0]# cat hba_mode
0
[root@fedstorage iblock_0]# cd block-1/

/sys/kernel/config/target/core/iblock_0/block-1/attrib

[root@fedstorage attrib]# for i in *
> do
> echo $i
> cat $i
> echo
> done
block_size
512

emulate_3pc
1

emulate_caw
1

emulate_dpo
1

emulate_fua_read
1

emulate_fua_write
1

emulate_model_alias
1

emulate_rest_reord
0

emulate_tas
1

emulate_tpu
0

emulate_tpws
0

emulate_ua_intlck_ctrl
0

emulate_write_cache
0

enforce_pr_isids
1

force_pr_aptpl
0

hw_block_size
512

hw_max_sectors               *****
256

hw_pi_prot_type
0

hw_queue_depth
128

is_nonrot
1

max_unmap_block_desc_count
1

max_unmap_lba_count
8388607

max_write_same_len
65535

optimal_sectors
256                          *****

pi_prot_format
0

pi_prot_type
0

queue_depth
128

unmap_granularity
1

unmap_granularity_alignment
0

unmap_zeroes_data
0


[root@fedstorage ~]# targetcli ls
o- / ........................................................................................................... [...]
  o- backstores ................................................................................................ [...]
  | o- block ................................................................................... [Storage Objects: 30]
  | | o- block-1 ................................................... [/dev/data/block-1 (9.0GiB) write-thru activated]
  | | o- block-2 ................................................... [/dev/data/block-2 (9.0GiB) write-thru activated]
  | | o- block-3 ................................................... [/dev/data/block-3 (9.0GiB) write-thru activated]
..
..
  | | o- block-28 ................................................. [/dev/data/block-28 (9.0GiB) write-thru activated]
  | | o- block-29 ................................................. [/dev/data/block-29 (9.0GiB) write-thru activated]
  | | o- block-30 ................................................. [/dev/data/block-30 (9.0GiB) write-thru activated]
  | o- fileio ................................................................................... [Storage Objects: 0]
  | o- pscsi .................................................................................... [Storage Objects: 0]
  | o- ramdisk .................................................................................. [Storage Objects: 0]
  o- iscsi .............................................................................................. [Targets: 0]
  o- loopback ........................................................................................... [Targets: 0]
  o- qla2xxx ............................................................................................ [Targets: 0]
  o- srpt ............................................................................................... [Targets: 2]
  | o- ib.fe800000000000007cfe900300726e4e ............................................................. [no-gen-acls]
  | | o- acls .............................................................................................. [ACLs: 2]
  | | | o- ib.4e6e72000390fe7c7cfe900300726ed2 ..................................................... [Mapped LUNs: 30]
  | | | | o- mapped_lun0 ................................................................... [lun0 block/block-1 (rw)]
  | | | | o- mapped_lun1 ................................................................... [lun1 block/block-2 (rw)]
  | | | | o- mapped_lun2 ................................................................... [lun2 block/block-3 (rw)]
..
..
  | | | | o- mapped_lun26 ................................................................ [lun26 block/block-27 (rw)]
  | | | | o- mapped_lun27 ................................................................ [lun27 block/block-28 (rw)]
  | | | | o- mapped_lun28 ................................................................ [lun28 block/block-29 (rw)]
  | | | | o- mapped_lun29 ................................................................ [lun29 block/block-30 (rw)]
  | | | o- ib.4f6e72000390fe7c7cfe900300726ed3 ..................................................... [Mapped LUNs: 30]
  | | |   o- mapped_lun0 ................................................................... [lun0 block/block-1 (rw)]
  | | |   o- mapped_lun1 ................................................................... [lun1 block/block-2 (rw)]
  | | |   o- mapped_lun2 ................................................................... [lun2 block/block-3 (rw)]
  | | |   o- mapped_lun3 ................................................................... [lun3 block/block-4 (rw)]
  | | |   o- mapped_lun4 ................................................................... [lun4 block/block-5 (rw)]
..
,,

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "linux-scsi" <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org, "target-devel" <target-devel@vger.kernel.org>
Sent: Friday, April 8, 2016 1:30:28 AM
Subject: Re: Cant write to max_sectors_kb on 4.5.0  SRP target

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

