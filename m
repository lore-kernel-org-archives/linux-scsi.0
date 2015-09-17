From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH RESEND] libiscsi: Fix iscsi_check_transport_timeouts
 possible infinite loop
Date: Thu, 17 Sep 2015 15:43:02 +0300
Message-ID: <55FAB556.6000602@dev.mellanox.co.il>
References: <1441298995-27927-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37972 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbIQMmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 08:42:43 -0400
Received: by wiclk2 with SMTP id lk2so25660096wic.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 05:42:42 -0700 (PDT)
In-Reply-To: <1441298995-27927-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Ariel Nahum <arieln@mellanox.com>

On 9/3/2015 7:49 PM, Sagi Grimberg wrote:
> From: Ariel Nahum <arieln@mellanox.com>
>
> Connection last_ping is not being updated when iscsi_send_nopout fails.
> Not updating the last_ping will cause firing a timer to a past time
> (last_ping + ping_tmo < current_time) which triggers an infinite loop of
> iscsi_check_transport_timeouts() and hogs the cpu.
>
> Fix this issue by checking the return value of iscsi_send_nopout.
> If it fails set the next_timeout to one second later.
>
> Signed-off-by: Ariel Nahum <arieln@mellanox.com>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

James, can you pick this up please?

Thanks,
Sagi.
