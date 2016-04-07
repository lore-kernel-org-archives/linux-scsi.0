From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Cant write to max_sectors_kb on 4.5.0  SRP target
Date: Thu, 7 Apr 2016 17:15:13 -0400 (EDT)
Message-ID: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com>
References: <480311118.27942868.1460063633409.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <480311118.27942868.1460063633409.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello

I have been testing the SRP initiator code to an LIO array here and part of the testing requires me to set the max_sectors_kb size to get 4k I/O's.
This has been due to me having to debug various sg_map issues.

Linux srptest 4.5.0 #2 SMP Thu Apr 7 16:14:38 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux
This kernel has the scan patch from Hannes, as well as the "[PATCH] IB/mlx5: Expose correct max_sge_rd limit" patch. 
However, I also tested with vanilla 4.5.0 as well and its the same issue.

For some reason I cannot change the max_sectors_kb size on 4.5.0 here.

I chatted with Ewan about it as well and he reminded me about Martins changes so wondering if that's playing into this.

Take /dev/sdb as an example

[root@srptest queue]# sg_inq --p 0xb0 /dev/sdb
VPD INQUIRY: Block limits page (SBC)
  Maximum compare and write length: 1 blocks
  Optimal transfer length granularity: 256 blocks
  Maximum transfer length: 256 blocks
  Optimal transfer length: 768 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks

[root@srptest queue]# sg_inq --p 0x83 /dev/sdb
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x1405
      Vendor Specific Identifier: 0x3ec95b43d
      Vendor Specific Identifier Extension: 0xaf74871a5f1a0117
      [0x60014053ec95b43daf74871a5f1a0117]
  Designation descriptor number 2, descriptor length: 57
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: LIO-ORG
      vendor specific: block-1:3ec95b43-daf7-4871-a5f1-a0117ecc9c87
  Designation descriptor number 3, descriptor length: 8
    transport: SCSI RDMA Protocol (SRP)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x2
  Designation descriptor number 4, descriptor length: 8
    transport: SCSI RDMA Protocol (SRP)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 48
    transport: SCSI RDMA Protocol (SRP)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      0xfe800000000000007cfe900300726e4f,t,0x0001
  Designation descriptor number 7, descriptor length: 40
    transport: SCSI RDMA Protocol (SRP)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target device that contains addressed lu
      SCSI name string:
      0xfe800000000000007cfe900300726e4f

[root@srptest queue]# cat max_hw_sectors_kb max_sectors_kb
4096
1280
[root@srptest queue]# echo 4096 > max_sectors_kb
-bash: echo: write error: Invalid argument

The exact same targets served by the same array work fine when I test with the RHEL 7.2 kernel

Linux srptest 3.10.0-327.10.1.el7.bz1313814.x86_64 #1 SMP Fri Mar 11 14:10:52 EST 2016 x86_64 x86_64 x86_64 GNU/Linux
[root@srptest ~]# cd /sys/block/sdb/queue

cat max_hw_sectors_kb max_sectors_kb 
4096
512
echo 4096 > max_sectors_kb

cat max_hw_sectors_kb max_sectors_kb
4096
4096

[root@srptest ~]# sg_inq --p 0xb0 /dev/sdb
VPD INQUIRY: Block limits page (SBC)
  Maximum compare and write length: 1 blocks
  Optimal transfer length granularity: 256 blocks
  Maximum transfer length: 256 blocks
  Optimal transfer length: 768 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks

This is an SRP device served by LVM via target LIO on my SRp target server

[root@srptest ~]# sg_inq --p 0x83 /dev/sdb
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x1405
      Vendor Specific Identifier: 0x3ec95b43d
      Vendor Specific Identifier Extension: 0xaf74871a5f1a0117
      [0x60014053ec95b43daf74871a5f1a0117]
  Designation descriptor number 2, descriptor length: 57
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: LIO-ORG
      vendor specific: block-1:3ec95b43-daf7-4871-a5f1-a0117ecc9c87
  Designation descriptor number 3, descriptor length: 8
    transport: SCSI RDMA Protocol (SRP)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x1
  Designation descriptor number 4, descriptor length: 8
    transport: SCSI RDMA Protocol (SRP)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 48
    transport: SCSI RDMA Protocol (SRP)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      0xfe800000000000007cfe900300726e4e,t,0x0001
  Designation descriptor number 7, descriptor length: 40
    transport: SCSI RDMA Protocol (SRP)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target device that contains addressed lu
      SCSI name string:
      0xfe800000000000007cfe900300726e4e



Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
