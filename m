From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH v3 3/5] st: get rid of scsi_tapes array
Date: Mon, 02 Jul 2012 17:16:56 -0700
Message-ID: <4FF239F8.7030101@suse.com>
References: <4FBACC66.80208@suse.com> <alpine.LNX.2.00.1207011147110.3650@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1207011147110.3650@kai.makisara.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jeffm@suse.com
List-Id: linux-scsi@vger.kernel.org


On 07/01/2012 01:57 AM, Kai Makisara wrote:
> On Mon, 21 May 2012, Lee Duncan wrote:
> 
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> st currently allocates an array to store pointers to all of the
>> scsi_tape objects. It's used to discover available indexes to use as the
>> base for the minor number selection and later to look up scsi_tape
>> devices for character devices.
>>
>> We switch to using an IDR for minor selection and a pointer from
>> st_modedef back to scsi_tape for the lookups.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>>  drivers/scsi/st.c |  172 ++++++++++++++++++++---------------------------------
>>  drivers/scsi/st.h |    2 +
>>  2 files changed, 65 insertions(+), 109 deletions(-)
>>
> ... patch removed
> 
> I have finally had time to review and test this patch set. I am sorry this 
> has taken so long.
> 
> I have found one change of behaviour and a theoretical problem:
> The new code does not re-use the tape numbers when freed and re-scanned. 
> The current code does re-use the freed numbers. Are there any reasons for 
> this changed behaviour? (The theoretical problem is that the new code 
> frees the tape structure but leaves the pointer in the idr tree.)
> 
> The patch at the end of this message (applies after the whole series) is 
> an attempt to implement re-use of tape numbers. I am not completely sure 
> that the change is correctly placed but it seems to work.


Thanks for the review, and good catch. I'll look over your added patch
and give feedback as soon as I can.

> 
> Another minor thing is that the documentation should be updated :-)

Of course.

> 
> The patch at the end also updates the version code. I am not sure if the 
> version code is useful, but it should be either updated or removed.
> 
> Otherwise no problems found. I am ready to ack the patch set after the 
> re-use thing has been resolved (one way or another).
> 
> Thanks,
> Kai
> 
-- 
The Lee-Man
