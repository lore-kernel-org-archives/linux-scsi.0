From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Mon, 15 Dec 2008 21:12:05 -0800 (PST)
Message-ID: <20081216051205.A6485108042@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbYLPFMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 00:12:10 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBG5C5J5023058
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 21:12:06 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #14 from ming.m.lin@intel.com  2008-12-15 21:12 -------
(In reply to comment #13)
> 
> diff --git a/drivers/message/fusion/mptscsih.c
> b/drivers/message/fusion/mptscsih.c
> index d62fd4f..ee09041 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2008,6 +2008,9 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
>                 return FAILED;
>         }
> 
> +       /* make sure we have no outstanding commands at this stage */
> +       mptscsih_flush_running_cmds(hd);
> +
>         ioc = hd->ioc;
>         printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
>             ioc->name, SCpnt);
> 

It seems that this patch fixes the bug.
I have been running "dd" for 4 hours and no panic.
dmesg attached. 
Thanks
------------------------------------------------------

end_request: I/O error, dev sdb, sector 34572800                                
Buffer I/O error on device sdb, logical block 8643200
Buffer I/O error on device sdb, logical block 8643201
Buffer I/O error on device sdb, logical block 8643202
Buffer I/O error on device sdb, logical block 8643203
Buffer I/O error on device sdb, logical block 8643204
Buffer I/O error on device sdb, logical block 8643205
Buffer I/O error on device sdb, logical block 8643206
Buffer I/O error on device sdb, logical block 8643207
Buffer I/O error on device sdb, logical block 8643208
Buffer I/O error on device sdb, logical block 8643209
Info fld=0x4044
end_request: I/O error, dev sdb, sector 34572544
__ratelimit: 54 callbacks suppressed
Buffer I/O error on device sdb, logical block 8643136
Buffer I/O error on device sdb, logical block 8643137
Buffer I/O error on device sdb, logical block 8643138
Buffer I/O error on device sdb, logical block 8643139
Buffer I/O error on device sdb, logical block 8643140
Buffer I/O error on device sdb, logical block 8643141
Buffer I/O error on device sdb, logical block 8643142
Buffer I/O error on device sdb, logical block 8643143
Buffer I/O error on device sdb, logical block 8643144
Buffer I/O error on device sdb, logical block 8643145
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
sd 0:0:1:0: rejecting I/O to offline device
__ratelimit: 54 callbacks suppressed
Buffer I/O error on device sdb, logical block 5081200
Buffer I/O error on device sdb, logical block 5081201
Buffer I/O error on device sdb, logical block 5081202
Buffer I/O error on device sdb, logical block 5081203
Buffer I/O error on device sdb, logical block 5081204
Buffer I/O error on device sdb, logical block 5081205
Buffer I/O error on device sdb, logical block 5081206
Buffer I/O error on device sdb, logical block 5081207
Buffer I/O error on device sdb, logical block 5081208
Buffer I/O error on device sdb, logical block 5081209
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
sd 0:0:1:0: rejecting I/O to offline device
__ratelimit: 126 callbacks suppressed
Buffer I/O error on device sdb, logical block 5642800
Buffer I/O error on device sdb, logical block 5642801
Buffer I/O error on device sdb, logical block 5642802
Buffer I/O error on device sdb, logical block 5642803
Buffer I/O error on device sdb, logical block 5642804
Buffer I/O error on device sdb, logical block 5642805
Buffer I/O error on device sdb, logical block 5642806
Buffer I/O error on device sdb, logical block 5642807
Buffer I/O error on device sdb, logical block 5642808
Buffer I/O error on device sdb, logical block 5642809
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
sd 0:0:1:0: rejecting I/O to offline device
__ratelimit: 126 callbacks suppressed
Buffer I/O error on device sdb, logical block 6333104
Buffer I/O error on device sdb, logical block 6333105
Buffer I/O error on device sdb, logical block 6333106
Buffer I/O error on device sdb, logical block 6333107
Buffer I/O error on device sdb, logical block 6333108
Buffer I/O error on device sdb, logical block 6333109
Buffer I/O error on device sdb, logical block 6333110
Buffer I/O error on device sdb, logical block 6333111
Buffer I/O error on device sdb, logical block 6333112
Buffer I/O error on device sdb, logical block 6333113
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
sd 0:0:1:0: rejecting I/O to offline device
__ratelimit: 126 callbacks suppressed
Buffer I/O error on device sdb, logical block 7920944
Buffer I/O error on device sdb, logical block 7920945
Buffer I/O error on device sdb, logical block 7920946
Buffer I/O error on device sdb, logical block 7920947
Buffer I/O error on device sdb, logical block 7920948
Buffer I/O error on device sdb, logical block 7920949
Buffer I/O error on device sdb, logical block 7920950
Buffer I/O error on device sdb, logical block 7920951
Buffer I/O error on device sdb, logical block 7920952
Buffer I/O error on device sdb, logical block 7920953
sd 0:0:1:0: rejecting I/O to offline device
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
sd 0:0:1:0: rejecting I/O to offline device
__ratelimit: 126 callbacks suppressed
Buffer I/O error on device sdb, logical block 6794608
Buffer I/O error on device sdb, logical block 6794609
Buffer I/O error on device sdb, logical block 6794610
Buffer I/O error on device sdb, logical block 6794611
Buffer I/O error on device sdb, logical block 6794612
Buffer I/O error on device sdb, logical block 6794613
Buffer I/O error on device sdb, logical block 6794614
Buffer I/O error on device sdb, logical block 6794615
Buffer I/O error on device sdb, logical block 6794616
Buffer I/O error on device sdb, logical block 6794617
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
program smartd is using a deprecated SCSI ioctl, please convert it to SG_IO
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
sd 0:0:1:0: rejecting I/O to offline device
__ratelimit: 126 callbacks suppressed
Buffer I/O error on device sdb, logical block 8816496
Buffer I/O error on device sdb, logical block 8816497
Buffer I/O error on device sdb, logical block 8816498
Buffer I/O error on device sdb, logical block 8816499
Buffer I/O error on device sdb, logical block 8816500
Buffer I/O error on device sdb, logical block 8816501
Buffer I/O error on device sdb, logical block 8816502
Buffer I/O error on device sdb, logical block 8816503
Buffer I/O error on device sdb, logical block 8816504
Buffer I/O error on device sdb, logical block 8816505
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: rejecting I/O to offline device
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
mptbase: ioc0: WARNING - mpt_fault_reset_work: HardReset: success


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
