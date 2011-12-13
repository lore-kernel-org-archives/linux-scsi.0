From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
Date: Tue, 13 Dec 2011 09:20:59 +0900
Message-ID: <CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	<1323694267.20451.5.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55744 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1LMAVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2011 19:21:00 -0500
In-Reply-To: <1323694267.20451.5.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

2011/12/12 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Mon, 2011-12-12 at 16:48 +0530, Amit Sahrawat wrote:
>> It has been observed that a number of USB HDD's do not respond corre=
ctly
>> to SCSI mode sense command(retrieve caching pages) which results in =
their
>> Write Cache being discarded by queue requests i.e., WCE if left set =
to
>> '0'(disabled).
>> This results in a number of Filesystem corruptions, when the device
>> is unplugged abruptly.
>
> Um, how would knowing the caching type correctly help? =C2=A0If you s=
urprise
> unplug the device, we can't send a flush to it anyway ...
Hi. James.
We can get device specification buffer to use ata_16 cmd.So we are
able to distinguish caching type by using 85byte of buffer.
And filesystem is using write barrier function to protect important
data like journaling data.
If filesystem is able to use write barrier by correctly setting WCE,
ordering can be guaranteed to flush data(preflush/postflush) to
internal write cache in hdd before power off. so filesystem can get
consistency and reliability by sudden plug and power off.
>
>> So, in order to identify the devices correctly - give it
>> a last try using ATA_16 after failure from normal routine.
>> Introduce a mechanism to store write-cache type using /sys/class/
>> interface, so that the normal code continues to function without err=
ors.
>>
>> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>> Signed-off-by: Nam-Jae Jeon <namjae.jeon@samsung.com>
>
> This whole patch looks like a layering violation. =C2=A0Why not just =
update
> the SAT layer to translate the MODE SENSE correctly?
Would plz you explain more ? I didn't clearly understand your point yet=
=2E
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
