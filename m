From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Wed, 09 Apr 2014 19:42:24 +0200
Message-ID: <53458680.4090500@suse.de>
References: <Pine.LNX.4.44L0.1404071125220.20747-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1404071125220.20747-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/07/2014 05:26 PM, Alan Stern wrote:
> On Wed, 2 Apr 2014, Hannes Reinecke wrote:
>
>> On 04/01/2014 11:28 PM, Alan Stern wrote:
>>> On Tue, 1 Apr 2014, Hannes Reinecke wrote:
>>>
>>>>>> So if the above reasoning is okay then this patch should be doin=
g
>>>>>> the trick:
>>>>>>
>>>>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error=
=2Ec
>>>>>> index 771c16b..0e72374 100644
>>>>>> --- a/drivers/scsi/scsi_error.c
>>>>>> +++ b/drivers/scsi/scsi_error.c
>>>>>> @@ -189,6 +189,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>>>>>                  /*
>>>>>>                   * Retry after abort failed, escalate to next l=
evel.
>>>>>>                   */
>>>>>> +               scmd->eh_eflags &=3D ~SCSI_EH_ABORT_SCHEDULED;
>>>>>>                  SCSI_LOG_ERROR_RECOVERY(3,
>>>>>>                          scmd_printk(KERN_INFO, scmd,
>>>>>>                                      "scmd %p previous abort
>>>>>> failed\n", scmd));
>>>>>>
>>>>>> (Beware of line
>>>>>> breaks)
>>>>>>
>>>>>> Can you test with it?
>>>>>
>>>>> I don't understand.  This doesn't solve the fundamental problem (=
namely
>>>>> that you escalate before aborting a running command).  All it doe=
s is
>>>>> clear the SCSI_EH_ABORT_SCHEDULED flag before escalating.
>>>>>
>>>> Which was precisely the point :-)
>>>>
>>>> Hmm. The comment might've been clearer.
>>>>
>>>> What this patch is _supposed_ to be doing is that it'll clear the
>>>> SCSI_EH_ABORT_SCHEDULED flag it it has been set.
>>>> Which means this will be the second time scsi_abort_command() has
>>>> been called for the same command.
>>>> IE the first abort went out, did its thing, but now the same comma=
nd
>>>> has timed out again.
>>>>
>>>> So this flag gets cleared, and scsi_abort_command() returns FAILED=
,
>>>> and _no_ asynchronous abort is being scheduled.
>>>> scsi_times_out() will then proceed to call scsi_eh_scmd_add().
>>>> But as we've cleared the SCSI_EH_ABORT_SCHEDULED flag
>>>> the SCSI_EH_CANCEL_CMD flag will continue to be set,
>>>> and the command will be aborted with the main SCSI EH routine.
>>>>
>>>> It looks to me as if it should do what you desire, namely abort th=
e
>>>> command asynchronously the first time, and invoking the SCSI EH th=
e
>>>> second time.
>>>>
>>>> Am I wrong?
>>>
>>> I don't know -- I'll have to try it out.  Currently I'm busy with a
>>> bunch of other stuff, so it will take some time.
>
> I finally got a chance to try it out.  It does seem to do what we wan=
t.
> I didn't track the flow of control in complete detail, but the comman=
d
> definitely got aborted both times it was issued.
>
Good, so it is as I thought. James, can we include this patch instead o=
f=20
your prior solution?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
