From: "Shashi Kiran T.R" <shkiran@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 21 Nov 2003 17:10:09 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <DBEOIJFONILFHFGKLPGFCECICEAA.shkiran@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:36541 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264358AbTKULkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 06:40:17 -0500
Received: from samrat.cisco.com (samrat.cisco.com [192.135.241.21])
	by india-msg-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id hALH7n0s012447
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2003 17:07:50 GMT
Received: from shkiranw2k (dhcp-10-77-7-93.cisco.com [10.77.7.93])
	by samrat.cisco.com (8.8.8/2.6/Cisco List Logging/8.8.8) with SMTP id RAA15626
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2003 17:10:18 +0530 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>- the whole iscsi_do_cmnd use looks very very strange.  you're probably
> much better of to use the scsi_request based interfaces and use midlayer
 >queueing and sometimes even higher level interfaces, e.g. your
iscsi_send_tur
 >coudld be replaced by an scsi_ioctl(sdp, SCSI_IOCTL_TEST_UNIT_READY, NULL)
> I still don't understand, though why the heck you need to do a TUR in
 >a lowlevel driver and even more need a thread do a single TUR, started
from
 >another kernel tread.  there more I dig into it your probing and thread
 >abuse looks horribly screwed.
 >- reinitilialize disk is another such candidate.  again why do you
 >need to send START_STOP commands from the LLDD, why do you need another
 >thread instead of a state machine and again life would be a lot simpler
> by using the midlayer queueing infrastructure.

In the existing code upon seeing ASC/ASCQ 04/02, the failed I/O are retried
in the iSCSI driver after issuing START_STOP using iscsi_do_cmnd(). This
ensures that application does not see an I/O error.

 We tried replacing  iscsi_do_cmnd() call  by kernel_scsi_ioctl() , but  the
ioctl call never completed. Looks like scsi mid layer prevents the
processing of START_STOP command until responses for earlier commands are
obtained. The response is deferred upstream from iSCSI driver since it
retries any failed I/O. Probably this is creating a deadlock situation
making this alternative infeasible!.

-Shashi

