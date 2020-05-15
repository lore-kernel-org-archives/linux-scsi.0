Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AE9C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 13:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D1A20759
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 13:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgEONwb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 09:52:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:47770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgEONwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 09:52:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 76813AE09;
        Fri, 15 May 2020 13:52:31 +0000 (UTC)
Subject: Re: [PATCH] fnic: to not call 'scsi_done()' for unhandled commands
To:     Laurence Oberman <loberman@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200515112647.49260-1-hare@suse.de>
 <fe3e6ab8cfeb23dc46f0413ddfd47efe5e33df7f.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5aa5ed17-e763-4b07-7526-fe1c97c04f31@suse.de>
Date:   Fri, 15 May 2020 15:52:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fe3e6ab8cfeb23dc46f0413ddfd47efe5e33df7f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/15/20 3:06 PM, Laurence Oberman wrote:
> On Fri, 2020-05-15 at 13:26 +0200, Hannes Reinecke wrote:
>> The fnic drivers assigns an ioreq structure to each command, and
>> severs this assignment once scsi_done() has been called and the
>> command has been completed.
>> So when traversing commands to terminate outstanding I/O we should
>> not call scsi_done() on commands which do not have a corresponding
>> ioreq structure; these commands have either never entered the driver
>> or have already been completed.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/fnic/fnic_scsi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/fnic/fnic_scsi.c
>> b/drivers/scsi/fnic/fnic_scsi.c
>> index 27535c90b248..8d2798cbd30f 100644
>> --- a/drivers/scsi/fnic/fnic_scsi.c
>> +++ b/drivers/scsi/fnic/fnic_scsi.c
>> @@ -1401,7 +1401,7 @@ static void fnic_cleanup_io(struct fnic *fnic,
>> int exclude_id)
>>   		}
>>   		if (!io_req) {
>>   			spin_unlock_irqrestore(io_lock, flags);
>> -			goto cleanup_scsi_cmd;
>> +			continue;
>>   		}
>>   
>>   		CMD_SP(sc) = NULL;
> 
> Hi Hannes,
> Thanks for this patch, but can you share what the impact was of this
> issue.
> What diod you see in logs/behavior
> 
Unmap the LUNs from the array, and reboot the machine.
Causing a nice kernel oops in fnic_terminate_rport_io:

[   41.904013]  rport-3:0-2: blocked FC remote port time out: removing rport
[   41.911625] BUG: kernel NULL pointer dereference, address: 
0000000000000040
[   41.919408] #PF: supervisor read access in kernel mode
[   41.919409] #PF: error_code(0x0000) - not-present page
[   41.919411] PGD 0 P4D 0
[   41.919416] Oops: 0000 [#1] SMP PTI
[   41.919420] CPU: 1 PID: 219 Comm: kworker/1:1 Kdump: loaded Tainted: 
G               X   5.3.18-16-default #1 SLE15-SP2 (unreleased)
[   41.919421] Hardware name: Cisco Systems Inc 
UCSC-C220-M3S/UCSC-C220-M3S, BIOS C220M3.3.0.4e.0.1106191007 11/06/2019
[   41.919433] Workqueue: fc_wq_3 fc_rport_final_delete [scsi_transport_fc]
[   41.919443] RIP: 0010:fnic_terminate_rport_io+0x2db/0x6c0 [fnic]
[   41.919446] Code: 3c c2 e8 48 00 95 f5 48 85 c0 49 89 c5 74 2c 48 05 
20 01 00 00 48 89 44 24 10 74 1f 49 8b 85 58 01 00 00 48 8b 80 c0 01 00 
00 <48> 8b 78 40 e8 1c 0f e4 ff 85 c0 0f 85 b2 fd ff ff 4c 89 e6 48 89
[   41.919448] RSP: 0018:ffffa521c164bde0 EFLAGS: 00010082
[   41.919450] RAX: 0000000000000000 RBX: ffff8c33633587c8 RCX: 
ffff8c3363358bc0
[   41.919452] RDX: ffff8c336347bc80 RSI: 0000000000000080 RDI: 
ffff8c33632dd8c0
[   41.919453] RBP: ffff8c3363359208 R08: 00335f71775f6366 R09: 
8080808080808080
[   41.919455] R10: ffffa521c0087dc8 R11: fefefefefefefeff R12: 
0000000000000246
[   41.919456] R13: ffff8c33633e8100 R14: ffff8c24470a4000 R15: 
0000000000000080
[   41.919459] FS:  0000000000000000(0000) GS:ffff8c33bfa40000(0000) 
knlGS:0000000000000000
[   41.919461] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.919466] CR2: 0000000000000040 CR3: 000000011340a003 CR4: 
00000000000606e0
[   42.066910] Call Trace:
[   42.066929]  fc_terminate_rport_io+0x51/0x70 [scsi_transport_fc]
[   42.066935]  fc_rport_final_delete+0x53/0x1e0 [scsi_transport_fc]
[   42.066943]  process_one_work+0x1f4/0x3e0
[   42.066947]  worker_thread+0x2d/0x3e0
[   42.066951]  ? process_one_work+0x3e0/0x3e0
[   42.066954]  kthread+0x10d/0x130
[   42.066957]  ? kthread_park+0xa0/0xa0
[   42.066961]  ret_from_fork+0x35/0x40

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
