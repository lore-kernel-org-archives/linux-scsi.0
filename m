From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Check return value of fc_block_scsi_eh()
Date: Fri, 15 Oct 2010 10:39:21 +0200
Message-ID: <4CB81339.8010105@suse.de>
References: <20101013114228.96669354D8@ochil.suse.de> <4CB618A5.8030108@cs.wisc.edu> <4CB6A712.3090705@suse.de> <4CB753D7.6080608@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0JOIjY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 04:39:24 -0400
In-Reply-To: <4CB753D7.6080608@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Mike Christie wrote:
> On 10/14/2010 01:45 AM, Hannes Reinecke wrote:
>> Mike Christie wrote:
>>> On 10/13/2010 06:42 AM, Hannes Reinecke wrote:
>>>>
>>>> fc_block_scsi_eh() might return with status FAST_IO_FAIL
>>>> indicating I/O has been terminated due to fast_io_fail timeout.
>>>> In this case the rport is still blocked, so any error recovery
>>>> will be failing on this port.
>>>> Hence each driver needs to check if the return value from
>>>> fc_block_scsi_eh() is something other than SUCCESS, in which
>>>> case it should just return with that status.
>>>> And we need to update the error handler to deal with a
>>>> status of FAST_IO_FAIL, too.
>>>> And fc_block_scsi_eh() should return SUCCESS on success,
>>>> not 0. Otherwise the calling routine will become confused
>>>> when reusing that value.
>>>>
>>>
>>> Is this patch supposed to fix the problem I described or is there m=
ore
>>> patches to follow or do you think I am being too paranoid? It seems=
 the
>>> patch alone is going to make the problem worse in the drivers you a=
re
>>> speeding up failure in. In the drivers now checking fc_block_scsi_e=
h and
>>> returning when fast io fail is returned then the scsi eh
>>> scsi_eh_flush_done_q's scsi_finish_command/scsi_queue_insert proces=
sing
>>> is going to get done faster and more likely to conflict with the
>>> termiante_rport_io callback processing, right?
>>
>> No, this patch does _not_ fix the race you've described, it just
>> fixes the problem of fc_block_scsi_eh() returning FAST_IO_FAIL,
>> which screws the error handler in drivers not checking the return va=
lue.
>> So it's partially covered by your patchset.
>>
>> However, in your patchset you're missing two issues:
>> - The current implementation of fc_block_scsi_eh() return '0' on
>>    success. This screws over drivers which re-uses this value;
>>    check eg. lpfc_abort_handler(). So we should be returning
>>    'SUCCESS' here.
>=20
> Yeah, my patchset is actually backwards. I converted the other driver=
s
> to check for 0 (forgot to fix lpfc though). I think your patch patch
> where we return SUCCESS is better than what I was doing.
>=20
>=20
>> - scsi_error needs to be fixed up to handle FAST_IO_FAIL.
>>    Any of the functions called from scsi_abort_eh_cmnd() can return
>>    FAST_IO_FAIL, in which case escalating to the next function
>>    becomes pointless.
>=20
> There is a problem with fnic (it is also a bug in my patches). If fni=
c's
> terminate_rport_io fails to abort the cmds, it is relying on the scsi=
 eh
> callouts to clean things up. So if fc_scsi_block_eh returns non-succe=
ss
> then we cannot return immediately from the callout. The drivers scsi =
eh
> callout may still need to clean up the command internally.
>=20
Maybe it's better to change fnic to modify the FAST_IO_FAIL return
value from fc_block_scsi_eh() and return FAILED here.

> iSCSI/qla4xxx also needs to be changed to return SUCCESS instead of
> zero. Luckily there is only one driver using it so far.
>=20
Yes, that would be preferable.

>>
>> I guess it would make sense to merge these two patchsets, either
>> having two patchsets (one for the FAST_IO_FAIL changes and one for
>> the rport race) or indeed merge them both into one.
>> I'm okay with either of it.
>>
>=20
> My patches for the race do not work though. When you replied to my
> thread I thought you mean you were going to fix that too :)
>=20
> I have been thinking of how to fix the race. I will make my patches o=
ver
> yours since your return SUCCESS fix is better.
Ok, I'll be sending an updated patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
