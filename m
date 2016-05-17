From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Tue, 17 May 2016 08:46:25 +0200
Message-ID: <573ABE41.5000402@suse.de>
References: <1461571293-953-1-git-send-email-hare@suse.de>
 <57322963.7040507@sandisk.com> <5732C7E5.3000709@suse.de>
 <5732CC17.20800@suse.de> <5733455B.7050903@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbcEQGq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2016 02:46:28 -0400
In-Reply-To: <5733455B.7050903@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/11/2016 04:44 PM, Bart Van Assche wrote:
> On 05/10/16 23:07, Hannes Reinecke wrote:
>> On 05/11/2016 07:49 AM, Hannes Reinecke wrote:
>> RIP: 0010:[<ffffffffa00b2adb>]  [<ffffffffa00b2adb>]
>> fc_rport_lookup+0x4b/0x70 [libfc]
>> Call Trace:
>>    [<ffffffffa00b2e17>] fc_rport_create+0x17/0x1b0 [libfc]
>>    [<ffffffffa00a9f81>] fc_disc_recv_req+0x261/0x480 [libfc]
>>    [<ffffffffa00b1008>] fc_lport_recv_els_req+0x68/0x130 [libfc]
>>    [<ffffffffa00afd5a>] fc_lport_recv_req+0x9a/0xf0 [libfc]
>>    [<ffffffffa00e8333>] fnic_handle_frame+0x63/0xd0 [fnic]
>>    [<ffffffff8106fd52>] process_one_work+0x172/0x420
>>    [<ffffffff810709ca>] worker_thread+0x11a/0x3c0
>>    [<ffffffff81077344>] kthread+0xb4/0xc0
>>    [<ffffffff81521318>] ret_from_fork+0x58/0x90
>
> Hello Hannes,
>
> Thanks for sharing this information. fc_disc_recv_req() protects the
> fc_rport_create() call via a mutex (disc_mutex). Since a mutex_lock()
> call may sleep it can trigger the start of an RCU grace period. I thi=
nk
> this may result in freeing of an rport while fc_rport_lookup() is
> examining it. Have you already considered to add a
> rcu_read_lock()/rcu_read_unlock() pair in fc_rport_lookup()?
>
No, I haven't so far.
This issue is hard to trigger, and I've only got the customer report to=
=20
go by.

Also, when using an rcu_read_lock() here one probably needs to revisit=20
the entire locking structure in libfc:
rport list is an RCU-proctected list, so in principle one only needs to=
=20
hold the rport mutex when _assigning_ new rports, and _could_ drop the=20
mutex usage for a simple lookup.
But this really needs some more thought and testing, so I haven't=20
attempted it.

Also, with your suggestion I would need to take the mutex_lock _and_=20
call rcu_read_lock(), which just looks wrong.
Hence I prefer to use the spin_lock method (which, incidentally, is als=
o=20
suggested in the RCU documentation).

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
