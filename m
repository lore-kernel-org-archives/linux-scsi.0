From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Badness in local_bh_enable under 2.6.10 and
 Xen
Date: Fri, 04 Mar 2005 12:09:47 -0800
Message-ID: <4228C08B.3060909@us.ibm.com>
References: <e5aa64f903ad5689c3a4bd31b67ab20c@gridapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from e31.co.us.ibm.com ([32.97.110.129]:15546 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263112AbVCDUJr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2005 15:09:47 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j24K9kua412604
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2005 15:09:46 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j24K9kEf198616
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2005 13:09:46 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j24K9jNL016988
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2005 13:09:45 -0700
In-Reply-To: <e5aa64f903ad5689c3a4bd31b67ab20c@gridapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Zito <mzito@gridapp.com>
Cc: linux-iscsi-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Zito wrote:
> 
> Hi,
> 
> The iscsi_sfnet module I compiled against my 2.6.10-xen0 tree loads 
> fine, but when the iscsid process goes to discover the luns, it sees the 
> luns but dumps error strings similar to the following:
> 
> ------------------------
> Attached scsi disk sdb at scsi0, channel 0, id 0, lun 0
> Badness in local_bh_enable at kernel/softirq.c:140
>  [<c011fc70>] local_bh_enable+0x80/0x90
>  [<c88b7786>] iscsi_queuecommand+0x176/0x1b0 [iscsi_sfnet]
>  [<c02cdb63>] scsi_dispatch_cmd+0x183/0x270
>  [<c02cddb0>] scsi_done+0x0/0x30
>  [<c02d03f0>] scsi_times_out+0x0/0xb0
>  [<c02d333b>] scsi_request_fn+0x1fb/0x450
>  [<c0235893>] __elv_add_request+0x83/0xd0
>  [<c0238966>] blk_insert_request+0xe6/0x120
>  [<c02d1e9a>] scsi_insert_special_req+0x3a/0x40
>  [<c02d2109>] scsi_wait_req+0x69/0xa0
>  [<c02d2000>] scsi_wait_done+0x0/0xa0
>  [<c02d4d0c>] scsi_report_lun_scan+0x19c/0x390
>  [<c88b712b>] iscsi_slave_configure+0x5b/0x80 [iscsi_sfnet]
>  [<c02d49c1>] scsi_probe_and_add_lun+0x141/0x1c0
>  [<c02d5152>] scsi_scan_target+0x102/0x130
>  [<c02d51d9>] scsi_scan_channel+0x59/0xa0
>  [<c02d52dd>] scsi_scan_host_selected+0xbd/0xd0
>  [<c02d531f>] scsi_scan_host+0x2f/0x40
>  [<c88b78ec>] iscsi_create_host+0xbc/0xd0 [iscsi_sfnet]
>  [<c88bba3d>] iscsi_ioctl_establish_session+0xed/0x130 [iscsi_sfnet]
>  [<c016abaa>] sys_ioctl+0xca/0x230
>  [<c0109838>] syscall_call+0x7/0xb
> -----------------------------------------------------
> 
> This will happen whenever there is any i/o against an iSCSI lun.  Any 
> ideas?  I'm currently working on compiling a standard 2.6.10 kernel and 
> seeing if this problem recurs.
> 

Do not bother retying it is not xen.
it is a scsi-ml problem.

Basically, if someone returns EH_HANDLED in their
scsi_times_out functions you will hit this.
It is becuase scsi_times_out is running from
a timer, and if you return EH_HANDLED __scsi_done
is called and that will call local_irq_save.

In future versions of the driver we just
removed our scsi_times_out function becuase
it was not buying us very much. Forgot to
report this bug though.


> Thanks,
> Matt
> 
> -- 
> Matthew Zito
> GridApp Systems
> Email: mzito@gridapp.com
> Cell: 917-574-1858
> Phone: 212-358-8211 x 359
> http://www.gridapp.com
> 
> 
> 
> -------------------------------------------------------
> SF email is sponsored by - The IT Product Guide
> Read honest & candid reviews on hundreds of IT Products from real users.
> Discover which products truly live up to the hype. Start reading now.
> http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
> _______________________________________________
> linux-iscsi-devel mailing list
> linux-iscsi-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-iscsi-devel
> 


