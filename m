From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv5 00/36] asynchronous ALUA device handler
Date: Wed, 30 Sep 2015 15:21:32 +0200
Message-ID: <560BE1DC.9060600@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de> <560AD88B.9050902@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbbI3NVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 09:21:34 -0400
In-Reply-To: <560AD88B.9050902@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 09/29/2015 08:29 PM, Bart Van Assche wrote:
> On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
>> here the next round of my update to the ALUA device handler.
>=20
> Hello Hannes,
>=20
> Sorry but this with this version I see an initiator kernel lockup
> shortly after the initiator system had been booted. I have attached
> the output of echo t > /proc/sysrq-trigger to this e-mail.
>=20
Hmm. Weird.
Everything seems to wait for alua_rtpg() to complete:

kworker/4:2     D ffff88045c64c380     0   203      2 0x00000000
Workqueue: kaluad_wq alua_rtpg_work [scsi_dh_alua]
 ffff88045d94f968 0000000000000086 ffff88047fd0dcc0 ffff88047fd15ad8
 ffff88045c64c380 ffff88044fc7c380 ffff88045d950000 ffff88047fd0dcc0
 ffff88047fd0dcc0 000000010001c779 0000000000000004 ffff88045d94f980
Call Trace:
 [<ffffffff814f078a>] schedule+0x3a/0x90
 [<ffffffff814f4b53>] schedule_timeout+0x143/0x290
 [<ffffffff810df1ed>] ? ktime_get+0x7d/0x130
 [<ffffffff810d5b00>] ? init_timer_key+0x140/0x140
 [<ffffffff814efb86>] io_schedule_timeout+0xa6/0x120
 [<ffffffff810ba14d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff814f126f>] wait_for_completion_io_timeout+0xdf/0x120
 [<ffffffff8109ec00>] ? wake_up_q+0x70/0x70
 [<ffffffff8126e46d>] blk_execute_rq+0xad/0x130
 [<ffffffff8125fc39>] ? bio_alloc_bioset+0x179/0x200
 [<ffffffff8125e259>] ? bio_phys_segments+0x19/0x20
 [<ffffffff81269e23>] ? blk_rq_bio_prep+0x63/0x80
 [<ffffffff8126e1c7>] ? blk_rq_map_kern+0xb7/0x130
 [<ffffffffa006b6c3>] scsi_execute+0xd3/0x160 [scsi_mod]
 [<ffffffffa006dafe>] scsi_execute_req_flags+0x8e/0xf0 [scsi_mod]
 [<ffffffffa0281e90>] alua_rtpg_work+0x2d0/0xc10 [scsi_dh_alua]

But this just seems to wait for a command completion, which
apparently doesn't arrive. Or not in time.
What's curious, though, is that there are several instances of
'srp_daemon', each trying to allocate/setup a new SRP device:

srp_daemon      D ffff88045ca2ad00     0   595    592 0x00000000
 ffff88043c3db960 0000000000000082 ffffffff810ba14d ffff88047fd55ad8
 ffff88045ca2ad00 ffff88043cf24380 ffff88043c3dc000 ffff880425ef6548
 ffff88042d5c3f78 ffff880425ef5968 ffff880425ef4dd0 ffff88043c3db978
Call Trace:
 [<ffffffff810ba14d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff814f078a>] schedule+0x3a/0x90
 [<ffffffff81271e76>] blk_mq_freeze_queue_wait+0x56/0xb0
 [<ffffffff810b4650>] ? prepare_to_wait_event+0xf0/0xf0
 [<ffffffff81273e71>] blk_mq_update_tag_set_depth+0x41/0xb0
 [<ffffffff812746a4>] blk_mq_init_allocated_queue+0x7c4/0x860
 [<ffffffff8127477a>] blk_mq_init_queue+0x3a/0x60
 [<ffffffffa006fa6c>] scsi_mq_alloc_queue+0x1c/0x50 [scsi_mod]
 [<ffffffffa0070c51>] scsi_alloc_sdev+0x331/0x3b0 [scsi_mod]
 [<ffffffffa0071554>] scsi_probe_and_add_lun+0x884/0xd20 [scsi_mod]
 [<ffffffffa00721cb>] __scsi_scan_target+0x52b/0x5f0 [scsi_mod]

Unfortunately I cannot tell from the provided logs whether both
refer to the same device; if so this would easily explain the issue.
Can you check if there is some line-bouncing involved?
If a device would be setup and teared down several times that would
explain things.
However, the main point seems to be that we never get a completion
for the RTPG command, Which also might be an issue with the srp
driver, as I've never seen this issue during my tests.

Is there a way on how I could be trying to reproduce it?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
