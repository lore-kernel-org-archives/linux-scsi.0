From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Wed, 11 May 2016 07:44:43 -0700
Message-ID: <5733455B.7050903@sandisk.com>
References: <1461571293-953-1-git-send-email-hare@suse.de>
 <57322963.7040507@sandisk.com> <5732C7E5.3000709@suse.de>
 <5732CC17.20800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0059.outbound.protection.outlook.com ([157.56.111.59]:56271
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751627AbcEKOot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 10:44:49 -0400
In-Reply-To: <5732CC17.20800@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/10/16 23:07, Hannes Reinecke wrote:
> On 05/11/2016 07:49 AM, Hannes Reinecke wrote:
> RIP: 0010:[<ffffffffa00b2adb>]  [<ffffffffa00b2adb>]
> fc_rport_lookup+0x4b/0x70 [libfc]
> Call Trace:
>    [<ffffffffa00b2e17>] fc_rport_create+0x17/0x1b0 [libfc]
>    [<ffffffffa00a9f81>] fc_disc_recv_req+0x261/0x480 [libfc]
>    [<ffffffffa00b1008>] fc_lport_recv_els_req+0x68/0x130 [libfc]
>    [<ffffffffa00afd5a>] fc_lport_recv_req+0x9a/0xf0 [libfc]
>    [<ffffffffa00e8333>] fnic_handle_frame+0x63/0xd0 [fnic]
>    [<ffffffff8106fd52>] process_one_work+0x172/0x420
>    [<ffffffff810709ca>] worker_thread+0x11a/0x3c0
>    [<ffffffff81077344>] kthread+0xb4/0xc0
>    [<ffffffff81521318>] ret_from_fork+0x58/0x90

Hello Hannes,

Thanks for sharing this information. fc_disc_recv_req() protects the 
fc_rport_create() call via a mutex (disc_mutex). Since a mutex_lock() 
call may sleep it can trigger the start of an RCU grace period. I think 
this may result in freeing of an rport while fc_rport_lookup() is 
examining it. Have you already considered to add a 
rcu_read_lock()/rcu_read_unlock() pair in fc_rport_lookup()?

Thanks,

Bart.
