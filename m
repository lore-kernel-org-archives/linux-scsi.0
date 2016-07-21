From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Thu, 21 Jul 2016 13:58:32 -0700
Message-ID: <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0081.outbound.protection.outlook.com ([104.47.34.81]:19328
	"EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754088AbcGUU6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 16:58:40 -0400
In-Reply-To: <20160720183321.GA20223@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On 07/20/2016 11:33 AM, Mike Snitzer wrote:
> Would be interesting to know the error returned from map_request()'s
> ti->type->clone_and_map_rq().  Really should just be DM_MAPIO_REQUEUE.
> But the stack you've provided shows map_request calling
> dm_complete_request(), which implies dm_kill_unmapped_request() is being
> called due to ti->type->clone_and_map_rq() returning < 0.

Hello Mike,

Apparently certain requests fail with -EIO because DM_DEV_SUSPEND ioctls 
are being submitted to the same multipath target. As you know 
DM_DEV_SUSPEND changes QUEUE_IF_NO_PATH from 1 into 0. A WARN_ON() 
statement that I added in driver dm-mpath statement learned me that 
multipathd is submitting these DM_DEV_SUSPEND ioctls. In the output of 
strace -fp$(pidof multipathd) I found the following:

[pid 13927] ioctl(5, DM_TABLE_STATUS, 0x7fa1000483f0) = 0
[pid 13927] write(1, "mpathbe: failed to setup multipa"..., 35) = 35
[pid 13927] write(1, "dm-0: uev_add_map failed\n", 25) = 25
[pid 13927] write(1, "uevent trigger error\n", 21) = 21
[pid 13927] write(1, "sdh: remove path (uevent)\n", 26) = 26
[pid 13927] ioctl(5, DM_TABLE_LOAD, 0x7fa1000483f0) = 0
[pid 13927] ioctl(5, DM_DEV_SUSPEND, 0x7fa1000483f0) = 0

I'm still analyzing these and other messages.

Bart.
