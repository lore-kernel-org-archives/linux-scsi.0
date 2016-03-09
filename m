From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 03/17] scsi: ufs: implement scsi host timeout handler
Date: Wed, 9 Mar 2016 07:44:49 +0100
Message-ID: <56DFC661.1020706@suse.de>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
 <1457440568-13084-4-git-send-email-ygardi@codeaurora.org>
 <56DECD23.7090704@suse.de> <56DED1A2.2060609@suse.de>
 <6ad16fc5ec3738fb3f671e9dc71e7fb4.squirrel@us.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <6ad16fc5ec3738fb3f671e9dc71e7fb4.squirrel@us.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: ygardi@codeaurora.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 03/08/2016 08:58 PM, ygardi@codeaurora.org wrote:
>> On 03/08/2016 02:01 PM, Hannes Reinecke wrote:
>>> On 03/08/2016 01:35 PM, Yaniv Gardi wrote:
>>>> A race condition exists between request requeueing and scsi layer
>>>> error handling:
>>>> When UFS driver queuecommand returns a busy status for a request,
>>>> it will be requeued and its tag will be freed and set to -1.
>>>> At the same time it is possible that the request will timeout and
>>>> scsi layer will start error handling for it. The scsi layer reuses
>>>> the request and its tag to send error related commands to the devi=
ce,
>>>> however its tag is no longer valid.
>>>> As this request was never really sent to the device, there is no
>>>> point to start error handling with the device.
>>>> Implement the scsi error handling timeout callback and bypass SCSI
>>>> error handling for request that were not actually sent to the devi=
ce.
>>>> For such requests simply reset the block layer timer. Otherwise, l=
et
>>>> SCSI layer perform the usual error handling.
>>>>
>>>> Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
>>>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>>
>>>> ---
>>>>  drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++++++++++++=
++
>>>>  1 file changed, 36 insertions(+)
>>>>
>>> Having a timeout handler is always a good idea, even though this
>>> doesn't do anything here.
>>> Are we sure that the requests will return eventually?
>>> Does the UFS spec provide for a command abort?
>>>
>> In fact, looking at the UFS spec there _is_ a command abort.
>> I would recommend implementing a task management request UPIO with
>> type 'ABORT TASK' here for any task found to be pending.
>> In the end, you might run into a _valid_ timeout, at which point you
>> really want to abort the command...
>>
>=20
> but this is not what we'd like to achieve.
> we don't want to abort a task that was not even dispatched to the UFS=
 driver.
> in those cases we need to re-queue the request and reset the timer.
>=20
=46ully understood.

> Hannes, i appreciate your time, but I really don't understand why you
> insist on coming up with suggestions, when we already implemented one=
 that
> is working. more over, your solution doesn't fix the race condition w=
hich is the
> reason for this patch.
> as i don't have HW to test anything at the moment, I think it's bette=
r to
> stick with this solution that also fix the BUG and also was verified =
and
> tested.
>=20
Ah. Didn't know that. I was under the impression that you _had_ the
hardware available. If not then of course it's not easy to verify
anything.

So, all things considered:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
