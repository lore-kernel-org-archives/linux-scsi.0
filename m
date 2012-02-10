From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: device removal causes "sysfs: can not remove 'bsg', no directory"
Date: Thu, 09 Feb 2012 17:10:02 -0800
Message-ID: <m1bop75w9h.fsf@fess.ebiederm.org>
References: <CAErSpo5vyFDA9OikJM5GvUbb8Bk6fU47JjY7t9GU4Ppqr1O_BQ@mail.gmail.com>
	<m1wr83mekd.fsf@fess.ebiederm.org>
	<CAA9_cmcD3L7T5uzZ3P7soKM=PAnm_txuhGPXqYTXhGjsVKis9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:60426 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2BJBHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 20:07:13 -0500
In-Reply-To: <CAA9_cmcD3L7T5uzZ3P7soKM=PAnm_txuhGPXqYTXhGjsVKis9A@mail.gmail.com>
	(Dan Williams's message of "Thu, 9 Feb 2012 12:17:16 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com

Dan Williams <dan.j.williams@gmail.com> writes:

> On Fri, Feb 3, 2012 at 8:02 PM, Eric W. Biederman <ebiederm@xmission.=
com> wrote:
>> Bjorn Helgaas <bhelgaas@google.com> writes:
>>
>>> Eric recently added ce59791936, which is a check that complains if =
we
>>> try to remove files from non-existent directories.
>>
>> Yes. =C2=A0It has always been a bug but since no one checked their e=
rror
>> codes it has been going unnoticed.
>>
>>> When I remove a device (LSI SAS2008 in this case, but I don't know =
if
>>> it's specific to that), I hit that warning three times. =C2=A0Let m=
e know
>>> if I can collect any more data.
>>
>> I tried to read that code and understand what is going on but I don'=
t
>> know enough about the block and scsi layers to have a clue where to
>> start.
>>
>> bsg_unregister_queue seems to be a generic piece of infrastructure.
>>
>> q->kobj seems to be managed separately from =C2=A0q->bsg_dev->class_=
dev.
>>
>> If I read q->kobj correctly that is managed with blk_put_queue.
>>
>> So it seems like the final blk_put_queue or blk_unregister_queue is
>> being called before bsg_unregister_queue and causing this problem.
>>
>> What the solution might be I can't believe to figure out.
>
> This fixed it for me:
>
> https://lkml.org/lkml/2012/2/8/246

It is good to see that there is a fix.  But using an internal sysfs
field like that is a bit scary.

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
