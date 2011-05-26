From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Question about aborting commands
Date: Thu, 26 May 2011 17:56:09 -0500
Message-ID: <4DDEDA89.3090303@cs.wisc.edu>
References: <20110525135035.GK26570@beardog.cce.hp.com> <20110525202411.GO26570@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35969 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab1EZWzp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2011 18:55:45 -0400
In-Reply-To: <20110525202411.GO26570@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org

On 05/25/2011 03:24 PM, scameron@beardog.cce.hp.com wrote:
>> Le 25 mai 2011 06:50,  <scameron@beardog.cce.hp.com> a =E9crit :
>>> Or, maybe I should be reporting the CMD_ABORTED case back as
>>>
>>>        cmd->result =3D DID_SOFT_ERROR << 16;
>>
>> look at scsi_error.c:scsi_decide_disposition(). DID_SOFT_ERROR
>> triggers retry handling while DID_ABORT does not (at least in the tr=
ee
>> that i'm looking at).
>>
>=20
> Yes this is what I was looking at, and part of what is confusing me.
> This makes me think that DID_ABORT is the wrong thing to do, because=20
> it would seem that there is no retry, and yet, dd does not complain
> that one of the reads initiated on it's behalf has been aborted.
> Does that mean it copied bogus data (uninitialized memory)?  Not sure=
,
> but if so, that would be bad. (Easy enough to test this case.)


scsi_decide_disposition is not used in the abort path. In the abort pat=
h
commands go through scsi_eh_flush_done_q. In there you can see some
basic handling. We check if we can failfast the cmd (scsi_noretry_cmd)
and if there are enough retries. If it is not fastfailbale and there ar=
e
enough retries we retry the IO by calling scsi_queue_insert.

If there are not enough retries or we want to fastfail it then
scsi_finish_command is called like is done in the normal completion pat=
h
from (scsi_softirq_done -> scsi_decide_disposition -> (look at return
value) -> scsi_finish_command.

=46rom scsi_finish_command the cmd is then handled like in the normal p=
ath
where something like the ULD done function is called then
scsi_io_completion is.

So as you can see from scsi_eh_flush_done_q, the scsi layer does not
really look at what you return and do anything with it. There is just
the basic check for if the IO is fastfailable. When I added that code,
it looked like most drivers returned a wide range of values and in some
cases did not return anything (if a driver does not set anything for th=
e
result then there is that check in scsi_eh_flush_done_q that sets the
DRIVER_TIMEOUT bit).

I do not know what the policy is. I have been converting drivers to
return something useful when they want to control if IO is fastfailed i=
n
this path.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
