From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [SCSI] pm8001: Fix bogus interrupt state flag issue.
Date: Thu, 1 Mar 2012 20:11:26 +0530
Message-ID: <CAOD=uF42w9zHyi_=S1a05owWfXZRSsa3QbLwrD8=Ape-DBUqdg@mail.gmail.com>
References: <20120301142225.GA9789@elgon.mountain>
	<CAOD=uF46HF3iLto3AhnTkjzSDebAkCYtTE-UJ26s00CwgwRPYA@mail.gmail.com>
	<20120301143757.GT1003@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54405 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519Ab2CAOl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 09:41:26 -0500
Received: by pbcup15 with SMTP id up15so959584pbc.19
        for <linux-scsi@vger.kernel.org>; Thu, 01 Mar 2012 06:41:26 -0800 (PST)
In-Reply-To: <20120301143757.GT1003@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jack Wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org

t->task_state_lock  can be changed to simple spin lock instead of 'irq
spin lock'

Initially I thought to do so. But could not get the intention of the
developer why he used
an irq lock there. Hence left it unchanged. Just changed from 'irqsave
spin lock' to 'irq spin lock'

regard
santosh



On Thu, Mar 1, 2012 at 8:07 PM, Dan Carpenter <dan.carpenter@oracle.com=
> wrote:
> On Thu, Mar 01, 2012 at 07:54:57PM +0530, santosh prasad nayak wrote:
>> The warnings are =A0there since from the beginning.
>> Even before my fix.
>>
>> There are two locks:
>> 1. =A0pm8001_ha->lock
>> 2. t->task_state_lock
>>
>
> Yes. =A0But IRQs are either enabled or disabled for the CPU. =A0You
> can't enable them twice.
>
> In this case we enable them in the first call to unlock and the
> second call doesn't do anything. =A0So possibly the current behavior
> is correct and we should change the second unlock or possibly the
> current behavior is wrong and we should change the first unlock.
>
> But actually the email was more of just a form letter. =A0Perhaps Jac=
k
> knows what to do here...
>
> regards,
> dan carpenter
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
