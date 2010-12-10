From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] add stats info for FC rports
Date: Fri, 10 Dec 2010 21:35:22 +0800
Message-ID: <AANLkTimyuEPVz6hdWk93sjY_me-+RRKLCPBc5M-1tmrJ@mail.gmail.com>
References: <AANLkTi=mwHmJwNwCqJXxGXsfyULpnTX0t7rOq3eV9YOF@mail.gmail.com>
	<4D000183.9050804@cisco.com>
	<AANLkTikWJ-M53Qvd+bM9_xZ11it=gz3p5qVQN037fGT_@mail.gmail.com>
	<4D012B58.3030804@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60486 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0LJNfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Dec 2010 08:35:24 -0500
Received: by wyb28 with SMTP id 28so3450888wyb.19
        for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2010 05:35:23 -0800 (PST)
In-Reply-To: <4D012B58.3030804@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Fri, Dec 10, 2010 at 3:17 AM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
>
>
> On 12/9/10 6:18 AM, Hillf Danton wrote:
>> On Thu, Dec 9, 2010 at 6:06 AM, Joe Eykholt <jeykholt@cisco.com> wro=
te:
>>
>> Locking here looks unnecessary, since lport could not goto Mars.
>> If could, lot of orphans have to stay on Earth with no more care.
>
> The lport could go away before the rport is freed by rcu.

Yes, rcu was neglected by my fault.

> Also, two rports could be freed in rcu callbacks at the same time,
> so two decrements of nr_rdata could be concurrent and you would
> get nondeterministic results since the decrement isn't atomic.
>
>
>>
>> When initing lport, clarity could be redundant.
>
> So, you agree or not?

Agree with no doubt.

>
>> When destroying lport, it is the right place to report leakage.
>
> Yes, but there's a call from lport destroy into rport, and that's the
> place to report rport leakage, not in the FCP module. =C2=A0For one t=
hing,
> not all LLDs use that fcp module.

Great point.

Redelivery soon out.

good weekend
Hillf
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
