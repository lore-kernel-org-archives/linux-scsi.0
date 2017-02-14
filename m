From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] sg: protect access to to 'reserved' page array
Date: Tue, 14 Feb 2017 21:48:58 +0100
Message-ID: <CACT4Y+Ywna_Bb6WWEC9kHEt=uCdiTaYtS5ZWaVkeVTN9Q0wzJg@mail.gmail.com>
References: <1485948135-83249-1-git-send-email-hare@suse.de>
 <20170201131247.GA5384@lst.de> <4c9af917-79db-67e4-d28c-c30009756a0c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <4c9af917-79db-67e4-d28c-c30009756a0c@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jth@kernel.org>, stable <stable@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 1, 2017 at 2:21 PM, Hannes Reinecke <hare@suse.de> wrote:
> On 02/01/2017 02:12 PM, Christoph Hellwig wrote:
>> On Wed, Feb 01, 2017 at 12:22:15PM +0100, Hannes Reinecke wrote:
>>> The 'reserved' page array is used as a short-cut for mapping
>>> data, saving us to allocate pages per request.
>>> However, the 'reserved' array is only capable of holding one
>>> request, so we need to protect it against concurrent accesses.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>>> Link: http://www.spinics.net/lists/linux-scsi/msg104326.html
>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>> Tested-by: Johannes Thumshirn <jth@kernel.org>
>>> ---
>>>  drivers/scsi/sg.c | 30 ++++++++++++------------------
>>>  1 file changed, 12 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>>> index 652b934..6a8601c 100644
>>> --- a/drivers/scsi/sg.c
>>> +++ b/drivers/scsi/sg.c
>>> @@ -155,6 +155,8 @@
>>>      unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
>>>      char keep_orphan;       /* 0 -> drop orphan (def), 1 -> keep for read() */
>>>      char mmap_called;       /* 0 -> mmap() never called on this fd */
>>> +    unsigned long flags;
>>> +#define SG_RESERVED_IN_USE 1
>>>      struct kref f_ref;
>>>      struct execute_work ew;
>>>  } Sg_fd;
>>> @@ -198,7 +200,6 @@ static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
>>>  static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
>>>  static Sg_request *sg_add_request(Sg_fd * sfp);
>>>  static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
>>> -static int sg_res_in_use(Sg_fd * sfp);
>>>  static Sg_device *sg_get_dev(int dev);
>>>  static void sg_device_destroy(struct kref *kref);
>>>
>>> @@ -721,7 +722,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
>>>                      sg_remove_request(sfp, srp);
>>>                      return -EINVAL; /* either MMAP_IO or DIRECT_IO (not both) */
>>>              }
>>> -            if (sg_res_in_use(sfp)) {
>>> +            if (test_bit(SG_RESERVED_IN_USE, &sfp->flags)) {
>>>                      sg_remove_request(sfp, srp);
>>>                      return -EBUSY;  /* reserve buffer already being used */
>>>              }
>>> @@ -963,10 +964,14 @@ static int max_sectors_bytes(struct request_queue *q)
>>>              val = min_t(int, val,
>>>                          max_sectors_bytes(sdp->device->request_queue));
>>>              if (val != sfp->reserve.bufflen) {
>>> -                    if (sg_res_in_use(sfp) || sfp->mmap_called)
>>> +                    if (sfp->mmap_called)
>>> +                            return -EBUSY;
>>> +                    if (test_and_set_bit(SG_RESERVED_IN_USE, &sfp->flags))
>>>                              return -EBUSY;
>>> +
>>>                      sg_remove_scat(sfp, &sfp->reserve);
>>>                      sg_build_reserve(sfp, val);
>>> +                    clear_bit(SG_RESERVED_IN_USE, &sfp->flags);
>>
>>
>> This seems to be abusing an atomic bitflag as a lock.
>
> Hmm. I wouldn't call it 'abusing'; the driver can proceed quite happily
> without the 'reserved' buffer, so taking a lock would be overkill.
> I could modify it to use a mutex if you insist ...
>
>>  And I think
>> in general we have two different things here that this patch conflates:
>>
>>  a) a lock to protect building and using the reserve lists
>>  b) a flag is a reservations is in use
>>
> No. This is not about reservations, this is about the internal
> 'reserved' page buffer array.
> (Just in case to avoid any misunderstandings).
> We need to have an atomic / protected check in the 'sfp' structure if
> the 'reserved' page buffer array is in use; there's an additional check
> in the 'sg_request' structure (res_in_use) telling us which of the
> requests is using it.


So, how should we proceed here?
We could use a mutex with only trylock, but it would be effectively the same.

There is one missed user of sg_res_in_use in "case SG_SET_FORCE_LOW_DMA".
