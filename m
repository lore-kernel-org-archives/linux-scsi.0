From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Tue, 06 May 2003 11:12:27 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB70BFB.8080009@torque.net>
References: <20030505083315.GB8416@beaverton.ibm.com> <3EB64F11.2030806@torque.net> <20030505214532.GB3254@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:39435 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262258AbTEFA5T
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 20:57:19 -0400
In-Reply-To: <20030505214532.GB3254@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Douglas Gilbert [dougg@torque.net] wrote:
> 
>>What seems to be missing, at least in what I am
>>running here is a useful 'name'. There is no 'name'
>>file in the listing above (under each 'host<n>'
>>directory). There is a 'name' file in that 'device' (symlink)
>>directory but it is an empty file here.
>>
>>
>>># tree /sys/bus/scsi/devices
>>>/sys/bus/scsi/devices
>>>|-- 0:0:0:0 -> ../../../devices/pci0/00:09.0/host0/0:0:0:0
>>
>>So finally I can get some output from my
>>version of lsscsi (unreleased version 10):
>>
>>$ lsscsi -Hl
>>[0]    ??
>>  cmd_per_lun=64   host_busy=0    sg_tablesize=96   unchecked_isa_dma=0
>>[1]    ??
>>  cmd_per_lun=64   host_busy=0    sg_tablesize=96   unchecked_isa_dma=0
>>[2]    ??
>>  cmd_per_lun=3    host_busy=0    sg_tablesize=64   unchecked_isa_dma=0
>>[3]    ??
>>  cmd_per_lun=5    host_busy=0    sg_tablesize=255  unchecked_isa_dma=0
>>
>>Hosts 0 and 1 are the 2 HBAs on a Tekram 390u3w while
>>host 2 is a scsi_debug pseudo host and host3 is
>>ide-scsi. A name would be instructive.
>>
>>$ lsscsi
>>[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
>>[2:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
>>[3:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr0
>>
> 
> 
> OK, that is a bug. Is proc_name ok for name
> 
> # cat /sys/class/scsi_host/*/device/name
> ips
> aic7xxx
> aic7xxx

Mike,
Yes, proc_name is fine (although the previous release
of this patch set used a longer winded variant).

Also the 'unique_id' attribute looks a bit strange
(or is aften misued by LLDs).
$ cat /sys/class/scsi_host/host[0123]/unique_id
33792        # half 390u3w
32768        # other half 390u3w
0            # ide-scsi
0            # Adaptec AIC-7892A

This is nothing to do with your patch, of course. Does
the unique_id help the user space in any way?

Doug Gilbert


