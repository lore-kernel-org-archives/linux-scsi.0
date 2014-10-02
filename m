From: Christophe Vu-Brugier <cvubrugier@fastmail.fm>
Subject: Re: PR registration on LIO iscsi returns sense key not ready
Date: Thu, 2 Oct 2014 16:11:49 +0200
Message-ID: <20141002161149.383599e3@grp-cvubrugier>
References: <542D2D2D.2030100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <542D2D2D.2030100@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Luigi Tarenga <luigi.tarenga@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear Luigi,

On Thu, 02 Oct 2014 12:47:09 +0200, Luigi Tarenga wrote :
> I have a little problem with LIO iscsi target and SPC-3 persistent 
> reservation.
> The summary of my setup is:
> host:
>    centos 6.5 x86_64 with custom kernel 3.16.3 + scst patches
>    targetcli (-fb) 2.1.fb37
>    this host is configured to export a lun0 to the guest via iscsi
> 
> guest:
>    centos 7 x64_64 with stock kernel 3.10.0-123.6.3.el7.x86_64
>    iscsi-initiator-utils-6.2.0.873-21.el7.x86_64
>    sg3_utils-1.37-5.el7.x86_64
> 
> [snip]
> 
> the guest virtualization is done with qemu-2.0.0+kvm, NIC is virt-io and 
> the guest
> connect to the host via a tap device.
> 
> The guest can connect to the iSCSI target and i see the device as /dev/sda.
> I partitioned, formatted and mounted it successfully.
> 
> My problem that every PR Out command return a sense key not ready
> even if the command run successfully, see this sequence:

I think I already experienced these errors. Could you check the
output of `dmesg` and look for errors like:

  filp_open(/var/target/pr/aptpl_1a4f52f5-1036-498a-a14f-8818d28de1bb) for APTPL metadata failed
  SPC-3 PR REGISTER: Received res_key: 0x0000000000000000 does not match existing SA REGISTER res_key: 0x000000002e5f2049
  filp_open(/var/target/pr/aptpl_1a4f52f5-1036-498a-a14f-8818d28de1bb) for APTPL metadata failed

You can fix this issue by creating the /var/target/pr directory.
You should also create the /var/target/alua directory whih is
expected by LIO too.

Best regards,

> [root@centos7 ~]# ll 
> /dev/disk/by-path/ip-172.24.49.193\:3260-iscsi-iqn.2003-01.org.linux-iscsi.lizard.x8664\:sn.15df8aa9db1d-lun-0
> lrwxrwxrwx. 1 root root 9 Oct  2 12:29 
> /dev/disk/by-path/ip-172.24.49.193:3260-iscsi-iqn.2003-01.org.linux-iscsi.lizard.x8664:sn.15df8aa9db1d-lun-0 
> -> ../../sda
> 
> [root@centos7 ~]# sg_persist -n --read-keys --device=/dev/sda
>    PR generation=0x0, there are NO registered reservation keys
> 
> [root@centos7 ~]# sg_persist -n -v --out --register 
> --param-sark=ac1831c2 --device=/dev/sda
>      Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
> persistent reserve out:  Fixed format, current;  Sense key: Not Ready
>   Additional sense: Logical unit communication failure
> PR out: command failed
> 
> [root@centos7 ~]# sg_persist -n --read-keys --device=/dev/sda
>    PR generation=0x1, 1 registered reservation key follows:
>      0xac1831c2
> 
> [root@centos7 ~]# sg_persist -n -v --out --register --param-rk=ac1831c2 
> --device=/dev/sda
>      Persistent Reservation Out cmd: 5f 00 00 00 00 00 00 00 18 00
> persistent reserve out:  Fixed format, current;  Sense key: Not Ready
>   Additional sense: Logical unit communication failure
> PR out: command failed
> 
> [root@centos7 ~]# sg_persist -n --read-keys --device=/dev/sda
>    PR generation=0x1, there are NO registered reservation keys
> 
> [root@centos7 ~]# dmesg | tail
> [  170.695433] scsi 3:0:0:0: alua: port group 00 rel port 01
> [  170.695626] scsi 3:0:0:0: alua: port group 00 state A non-preferred 
> supports TOlUSNA
> [  170.695629] scsi 3:0:0:0: alua: Attached
> [  170.698855] scsi 3:0:0:0: Attached scsi generic sg1 type 0
> [  170.738866] sd 3:0:0:0: [sda] 20480 512-byte logical blocks: (10.4 
> MB/10.0 MiB)
> [  170.740658] sd 3:0:0:0: [sda] Write Protect is off
> [  170.740664] sd 3:0:0:0: [sda] Mode Sense: 43 00 10 08
> [  170.741107] sd 3:0:0:0: [sda] Write cache: enabled, read cache: 
> enabled, supports DPO and FUA
> [  170.745222]  sda: sda1
> [  170.747875] sd 3:0:0:0: [sda] Attached SCSI disk
> 
> 
> With the same setup I tryed to switch from LIO to scst and it works as 
> expected, sg_persist
> can register and reserve keys without getting a sense key not ready.
> 
> My tought are about a little bug in LIO but maybe is it my fault that I 
> added some patches to
> vanilla kernel that broke LIO?
> the patches I added are:
> scst_exec_req_fifo-3.16.patch
> put_page_callback-3.16.patch
> 
> as documented here:
> http://scst.sourceforge.net/iscsi-scst-howto.txt
> 
> regards
> Luigi
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Christophe Vu-Brugier
