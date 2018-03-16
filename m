From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH] Change synchronize_rcu() in scsi_device_quiesce() into
 synchronize_sched()
Date: Fri, 16 Mar 2018 14:51:43 -0700
Message-ID: <c95b659b-164e-48f7-2033-30fb8f66462f@wdc.com>
References: <20180316173516.3048-1-bart.vanassche@wdc.com>
 <1890027.S58v862tbq@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1890027.S58v862tbq@merkaba>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/16/18 14:42, Martin Steigerwald wrote:
> What is this one about?
> 
> Fix for the regression I (and others?) reported?¹
> 
> [1] [Bug 199077] [Possible REGRESSION, 4.16-rc4] Error updating SMART data
> during runtime and boot failures with blk_mq_terminate_expired in backtrace
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=199077

Hello Martin,

This patch is a fix for the fix for the bug that you and others had 
reported. See also "I/O hangs after resuming from suspend-to-ram" 
(https://marc.info/?l=linux-block&m=150340235201348).

This patch fixes an API violation. For those users for which suspend and 
resume works fine with commit 3a0a529971ec applied it should still work 
fine with this patch applied since this patch may cause 
scsi_device_quiesce() to wait longer.

Bart.
