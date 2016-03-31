From: jthumshirn <jthumshirn@suse.de>
Subject: Re: [RESEND PATCH v2 2/2] scsi: Add intermediate STARGET_REMOVE state
 to scsi_target_state
Date: Thu, 31 Mar 2016 09:24:19 +0200
Message-ID: <489e694e1f1913205f7e3a8fabd26ee6@suse.de>
References: <cover.1459249252.git.jthumshirn@suse.de>
 <108843b606da2c793bd830af42d5907bf8776d13.1459249252.git.jthumshirn__45300.0338202857$1459322118$gmane$org@suse.de>
 <20160330234456.00004733@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160330234456.00004733@localhost>
Sender: stable-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

Hi Sebastian,

On 2016-03-30 23:44, Sebastian Herbszt wrote:
> Johannes Thumshirn wrote:
>> Add intermediate STARGET_REMOVE state to scsi_target_state to avoid 
>> running
>> into the BUG_ON() in scsi_target_reap().
>> 
>> This intermediate state is only valid in the path from 
>> scsi_remove_target() to
>> scsi_target_destroy() indicating this target is going to be removed.
>> 
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Hannes Reinecke <hare@suse.com>
>> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>> ---
>> 
>> Changes from v1:
>> * The state transition from STARGET_CREATED to STARGET_DEL is 
>> legitimate,
>>   so don't BUG() on it. Found by the 0-Day Bot.
> 
> This is yet another attempt to fix 40998193560d. Can you please explain 
> how
> it is "superior" to the one proposed by Bart before [1] ?
> 
> [1] http://marc.info/?l=linux-scsi&m=145227191917602&w=2

First of all I didn't oppose Bart's patch.
But let me try explaining mine (in contrast to Bart's).

The patch above expands the current SCSI target state machine, whereas 
Bart's patch removed the target state machine and tied the target states 
to their sysfs representaion, like his patch description explains

[quote]
Instead of representing the states "visible in sysfs" and
"has been removed from the target list" by a single state
variable, use two variables to represent this information.
[/quote]

It is actually the other way round to my patch. The above expands the 
target state machine from (simplified)

CREATED -> RUNNING -> DEL
         \_____________^

to:
CREATED -> RUNNING -> REMOVE -> DEL
         \_______________________^

This intermediate step ensures that scsi_target_reap() is not called 
with a target in the STARGET_DEL state (which causes the BUG_ON() to 
trigger).

As said above, both patches do the same (eliminate the race in the 
target removal path) but differently.

I hope I could answer your questions.

Byte,
     Johannes
