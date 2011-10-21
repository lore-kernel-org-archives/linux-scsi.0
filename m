From: Hannes Reinecke <hare@suse.de>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 21 Oct 2011 15:26:47 +0200
Message-ID: <4EA17317.1020506@suse.de>
References: <20110702181146.GM23059@one.firstfloor.org>	 <Pine.LNX.4.44L0.1107021544550.16190-100000@netrider.rowland.org>	 <CAA9_cmcPhkA5myxeR5aJWBQ=-C3VuG_M9Appp5WyrLoU5fnw2w@mail.gmail.com>	 <8E203115BDCF42ACA065296214E5B7A0@usish.com.cn>	 <CAD1RLj1SJBPg0F4Dyu_EL05FVm9c7ZZj7_=oRPAdQU4BDUwu5g@mail.gmail.com> <1318973425.5169.39.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1318973425.5169.39.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ankit Jain <mail@ankitjain.org>, Jack Wang <jack_wang@usish.com>, Dan Williams <dan.j.williams@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Andi Kleen <andi@firstfloor.org>, axboe@kernel.dk, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/18/2011 11:30 PM, James Bottomley wrote:
> On Wed, 2011-10-19 at 02:46 +0530, Ankit Jain wrote:
>> On Wed, Jul 20, 2011 at 3:28 PM, Jack Wang<jack_wang@usish.com>  wro=
te:
>>>>
>> <snip>
>>>> On Sat, Jul 2, 2011 at 12:59 PM, Alan Stern<stern@rowland.harvard.=
edu>
>>> wrote:
>>>>> On Sat, 2 Jul 2011, Andi Kleen wrote:
>>>>>
>>>>>>> The problem is that blk_peek_request() calls scsi_prep_fn(), wh=
ich
>>>>>>> does this:
>>>>>>>
>>>>>>>      struct scsi_device *sdev =3D q->queuedata;
>>>>>>>      int ret =3D BLKPREP_KILL;
>>>>>>>
>>>>>>>      if (req->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)
>>>>>>>              ret =3D scsi_setup_blk_pc_cmnd(sdev, req);
>>>>>>>      return scsi_prep_return(q, req, ret);
>>>>>>>
>>>>>>> It doesn't check to see if sdev is NULL, nor does
>>>>>>> scsi_setup_blk_pc_cmnd().  That accounts for this error:
>>>>>>
>>>>>> I actually added a NULL check in scsi_setup_blk_pc_cmnd early on=
,
>>>>>> but that just caused RCU CPU stalls afterwards and then eventual=
ly
>>>>>> a hung system.
>>>>>
>>>>> The RCU problem is likely to be a separate issue.  It might even =
be a
>>>>> result of the use-after-free problem with the elevator.
>>>>>
>>>>> At any rate, it's clear that the crash in the refcounting log you
>>>>> posted occurred because scsi_setup_blk_pc_cmnd() called
>>>>> scsi_prep_state_check(), which tried to dereference the NULL poin=
ter.
>>>>>
>>>>> Would you like to try this patch to see if it fixes the problem? =
 As I
>>>>> said before, I'm not certain it's the best thing to do, but it wo=
rked
>>>>> on my system.
>>>>>
>>>>> Alan Stern
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Index: usb-3.0/drivers/scsi/scsi_lib.c
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> --- usb-3.0.orig/drivers/scsi/scsi_lib.c
>>>>> +++ usb-3.0/drivers/scsi/scsi_lib.c
>>>>> @@ -1247,6 +1247,8 @@ int scsi_prep_fn(struct request_queue *q
>>>>>         struct scsi_device *sdev =3D q->queuedata;
>>>>>         int ret =3D BLKPREP_KILL;
>>>>>
>>>>> +       if (!sdev)
>>>>> +               return ret;
>>>>>         if (req->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)
>>>>>                 ret =3D scsi_setup_blk_pc_cmnd(sdev, req);
>>>>>         return scsi_prep_return(q, req, ret);
>>>>> Index: usb-3.0/drivers/scsi/scsi_sysfs.c
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>> --- usb-3.0.orig/drivers/scsi/scsi_sysfs.c
>>>>> +++ usb-3.0/drivers/scsi/scsi_sysfs.c
>>>>> @@ -322,6 +322,8 @@ static void scsi_device_dev_release_user
>>>>>                 kfree(evt);
>>>>>         }
>>>>>
>>>>> +       /* Freeing the queue signals to block that we're done */
>>>>> +       scsi_free_queue(sdev->request_queue);
>>>>>         blk_put_queue(sdev->request_queue);
>>>>>         /* NULL queue means the device can't be used */
>>>>>         sdev->request_queue =3D NULL;
>>>>> @@ -936,8 +938,6 @@ void __scsi_remove_device(struct scsi_de
>>>>>         /* cause the request function to reject all I/O requests =
*/
>>>>>         sdev->request_queue->queuedata =3D NULL;
>>>>>
>>>>> -       /* Freeing the queue signals to block that we're done */
>>>>> -       scsi_free_queue(sdev->request_queue);
>>>>>         put_device(dev);
>>>>>   }
>>>>
>>>> This patch seems to resolve the block/scsi null-ptr de-references =
in
>>>> our libsas/isci environment, we have yet to try James' alternative
>>>> [1].  Do we potentially need both?
>>>>
>>>> Commit 86cbfb56 moved scsi_free_queue to __scsi_remove_device() bu=
t it
>>>> seems only the "sdev->request_queue->queuedata =3D NULL" needed to=
 be
>>>> moved?
>>>>
>>>> The conversation appeared to be awaiting test results...
>>>>
>>>> [1]: http://marc.info/?l=3Dlinux-scsi&m=3D131007155700831&w=3D2
>>>>
>>>> --
>>>> Dan
>>> [Jack Wang]
>>> This patch fix kernel panic issue when hot-plut disk during I/O, I =
test it
>>> using pm8001 with 3.0.0-rc6 with above patch.
>>
>> I don't see this patch in scsi-misc-2.6 or linus' tree. Is there a
>> different patch that fixes the
>> issue?
>
> It should be fixed by
>
> commit 777eb1bf15b8532c396821774bf6451e563438f5
> Author: Hannes Reinecke<hare@suse.de>
> Date:   Wed Sep 28 08:07:01 2011 -0600
>
>      block: Free queue resources at blk_release_queue()
>
As much as I've hate to admit it, but it looks as if this is only a=20
fix for the second part of the original patch.
I've got reports that we still see crashes, which are fixed by the=20
patch to scsi_lib.c.

So please include this part.
Do you need a resend?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
