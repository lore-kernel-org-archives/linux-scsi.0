From: Laurence Oberman <loberman@redhat.com>
Subject: Re: Cant write to max_sectors_kb on 4.5.0 SRP target
Date: Fri, 8 Apr 2016 03:58:18 -0400 (EDT)
Message-ID: <1542480389.28011375.1460102298392.JavaMail.zimbra@redhat.com>
References: <302427900.27942894.1460063713447.JavaMail.zimbra@redhat.com> <57071C56.7070500@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46553 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbcDHH6V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 03:58:21 -0400
In-Reply-To: <57071C56.7070500@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org

Hi Bart

"Have you already tried to set the max_sect parameter in
/etc/srp_daemon.conf (assuming you are using srptools >= 1.0.3 for SRP
login) ? Additionally, writing something like "options ib_srp
cmd_sg_entries=255" into /etc/modprobe.d/ib_srp.conf will increase the
maximum SRP transfer size.
"

Bart, I am using the exact same configuration for the SRP initiator for both kernels.
Simply rebooting into upstream for baseline. All that is changing is the kernel.

The same parameters are applied to the initiator modules in both kernels.
When booting into the RHEL kernel the same applies and I am not changing the target LIO server.
(For Nicholas will follow up with the LIO target details in another email)

Here are my parameters and startup

srptools-1.0.2-1.el7.x86_64

[root@srptest modprobe.d]# cat ib_srp.conf
options ib_srp cmd_sg_entries=128 indirect_sg_entries=1024 

[root@srptest modprobe.d]# cat ib_srpt.conf
options ib_srpt srp_max_req_size=8296

Setting up the LUNS I am using 

[root@srptest ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i mlx5_0 -p 1 
id_ext=7cfe900300726e4e,ioc_guid=7cfe900300726e4e,dgid=fe800000000000007cfe900300726e4e,pkey=ffff,service_id=7cfe900300726e4e,initiator_ext=4e6e72000390fe7c,queue_size=128,max_cmd_per_lun=128,max_sect=8192
id_ext=7cfe900300726ed2,ioc_guid=7cfe900300726ed2,dgid=fe800000000000007cfe900300726ed2,pkey=ffff,service_id=7cfe900300726ed2,initiator_ext=d26e72000390fe7c,queue_size=128,max_cmd_per_lun=128,max_sect=8192

[root@srptest ~]# cat /etc/ddn/srp_daemon.conf
a      queue_size=128,max_cmd_per_lun=128 max_sect=8192


These allow me to set and use the 4MB I/O size on the RHEL kernel.

Example on the RHEL kernel
Linux srptest 3.10.0-327.10.1.el7.bz1313814.x86_64

mpathhh (3600140538661058fbcd4dcca8222f5d5) dm-26 LIO-ORG ,block-2         
size=9.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=50 status=active
  `- 4:0:0:1  sdc  8:32   active ready running

/sys/block/sdc/queue
[root@srptest queue]# echo 4096 > max_sectors_kb
[root@srptest queue]# cat max_sectors_kb
4096

/sys/block/dm-26/queue
[root@srptest queue]# echo 4096 > max_sectors_kb
[root@srptest queue]# cat max_sectors_kb
4096

dd if=/dev/zero of=/dev/mapper/mpathhh bs=4096k oflag=direct count=1000

# DISK STATISTICS (/sec)
#                   <---------reads---------><---------writes---------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize  QLen  Wait SvcTim Util
03:42:45 sdc              0      0    0    0  405504      0   99 4096    4096     1     3      3   39
03:42:45 dm-26            0      0    0    0  405504    300   99 4096    4096     1     4      4   42
03:42:46 sdc              0      0    0    0  815104      0  199 4096    4096     1     4      4   80
03:42:46 dm-26            0      0    0    0  815104    597  199 4096    4096     1     4      4   84
03:42:47 sdc              0      0    0    0  839680      0  205 4096    4096     1     3      3   79

So no issues here, I am able to change the max_sectors_kb to 4096 and then issue 4MB writes to the target from the initiator view.

Now rebooting into the upstream 4.5.0 

Linux srptest 4.5.0 #2 SMP Thu Apr 7 16:14:38 EDT 2016 x86_64 x86_64 x86_64 GNU/Linux

[root@srptest ~]# run_srp_daemon  -f /etc/ddn/srp_daemon.conf -R 30 -T 10 -t 7000 -ance -i mlx5_0 -p 1 
id_ext=7cfe900300726e4e,ioc_guid=7cfe900300726e4e,dgid=fe800000000000007cfe900300726e4e,pkey=ffff,service_id=7cfe900300726e4e,initiator_ext=4e6e72000390fe7c,queue_size=128,max_cmd_per_lun=128,max_sect=8192
id_ext=7cfe900300726ed2,ioc_guid=7cfe900300726ed2,dgid=fe800000000000007cfe900300726ed2,pkey=ffff,service_id=7cfe900300726ed2,initiator_ext=d26e72000390fe7c,queue_size=128,max_cmd_per_lun=128,max_sect=8192

mpathhh (3600140538661058fbcd4dcca8222f5d5) dm-4 LIO-ORG ,block-2         
size=9.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=50 status=active
  `- 6:0:0:1  sdc  8:32   active ready running

[root@srptest queue]# pwd
/sys/block/sdc/queue
[root@srptest queue]# echo 4096 > max_sectors_kb
-bash: echo: write error: Invalid argument
[root@srptest queue]# cat max_sectors_kb
1280

[root@srptest queue]# pwd
/sys/block/dm-4/queue
[root@srptest queue]# echo 4096 > max_sectors_kb
-bash: echo: write error: Invalid argument
[root@srptest queue]# cat max_sectors_kb
1280

So trying 4MB on the initiator I get it pinned to 1MB and cannot write 4MB

[root@srptest ~]# dd if=/dev/zero of=/dev/mapper/mpathhh bs=4096k oflag=direct count=1000
1000+0 records in
1000+0 records out
4194304000 bytes (4.2 GB) copied, 3.72675 s, 1.1 GB/s

# DISK STATISTICS (/sec)
#                   <---------reads---------><---------writes---------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize  QLen  Wait SvcTim Util
03:56:57 sdc              0      0    0    0  1092608      0 1067 1024    1024     3     2      0   74
03:56:57 dm-4             0      0    0    0  1092608      0 1067 1024    1024     3     2      0   79
03:56:58 sdc              0      0    0    0  1070080      0 1045 1024    1024     3     2      0   73
03:56:58 dm-4             0      0    0    0  1070080      0 1045 1024    1024     3     2      0   78
03:56:59 sdc              0      0    0    0  1101824      0 1076 1024    1024     3     2      0   72
03:56:59 dm-4             0      0    0    0  1101824      0 1076 1024    1024     3     2      0   77


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>, "linux-scsi" <linux-scsi@vger.kernel.org>, linux-rdma@vger.kernel.org
Sent: Thursday, April 7, 2016 10:49:58 PM
Subject: Re: Cant write to max_sectors_kb on 4.5.0 SRP target

On 04/07/16 14:16, Laurence Oberman wrote:
> I have been testing the SRP initiator code to an LIO array here and
 > part of the testing requires me to set the max_sectors_kb size to
 > get 4k I/O's.
                                                                        .
Hello Laurence,

Have you already tried to set the max_sect parameter in 
/etc/srp_daemon.conf (assuming you are using srptools >= 1.0.3 for SRP 
login) ? Additionally, writing something like "options ib_srp 
cmd_sg_entries=255" into /etc/modprobe.d/ib_srp.conf will increase the 
maximum SRP transfer size.

Bart.
