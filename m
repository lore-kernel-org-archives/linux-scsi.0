From: Manish Lachwani <manish@Zambeel.com>
Subject: Hangs seen with the 3ware controller and the 2.4.17 kernel ...
Date: Tue, 12 Nov 2002 00:03:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <233C89823A37714D95B1A891DE3BCE5202AB18C1@xch-a.win.zambeel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from XCHANGE.win.zambeel.com (pool123.zambeel.com [192.168.222.123])
	by imrelay-2.zambeel.com (8.11.0/2.4.0) with ESMTP id gAC8KMO15310
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2002 00:20:22 -0800
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


> Hello,
> 
> I am using a 2.4.17 SMP kernel and .018 version of the 3ware driver. This
> happens when we have two controllers (8-port and 4-port), IO is going on
> with both the controllers and on one controller (4-port in my experiment),
> there is  command timeout and the reset sequence fails. This is a hard
> kernel hang. The last message on the window is "reset sequence failed"
> 
> kdb for the eh_1 shows:
> 
> scsi_error_handler -> scsi_unjam_host -> scsi_try_host_reset -> schedule
> 
> I do know that the scsi_try_host_reset(..) calls scsi_sleep for 10*HZ. 
> 
> Anyway, another scenario that causes a hang:
> 
> scsi_error_handler -> scsi_unjam_host -> scsi_try_to_abort_command ->
> schedule
> 
> Also, This hang seems to occur when there are two controllers only. When I
> tried with 
> one controller numerous times, I could not reproduce this problem. Is it
> possible that scsi_unjam_host is getting confused with two devices and
> when reset fails on one host?
> 
> Any help is appreciated ...
> 
