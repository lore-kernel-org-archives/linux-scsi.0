From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: device removal causes "sysfs: can not remove 'bsg', no directory"
Date: Thu, 9 Feb 2012 12:17:16 -0800
Message-ID: <CAA9_cmcD3L7T5uzZ3P7soKM=PAnm_txuhGPXqYTXhGjsVKis9A@mail.gmail.com>
References: <CAErSpo5vyFDA9OikJM5GvUbb8Bk6fU47JjY7t9GU4Ppqr1O_BQ@mail.gmail.com>
	<m1wr83mekd.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59161 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2BIURQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 15:17:16 -0500
Received: by vbjk17 with SMTP id k17so1335362vbj.19
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2012 12:17:16 -0800 (PST)
In-Reply-To: <m1wr83mekd.fsf@fess.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-scsi@vger.kernel.org, Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com

On Fri, Feb 3, 2012 at 8:02 PM, Eric W. Biederman <ebiederm@xmission.co=
m> wrote:
> Bjorn Helgaas <bhelgaas@google.com> writes:
>
>> Eric recently added ce59791936, which is a check that complains if w=
e
>> try to remove files from non-existent directories.
>
> Yes. =A0It has always been a bug but since no one checked their error
> codes it has been going unnoticed.
>
>> When I remove a device (LSI SAS2008 in this case, but I don't know i=
f
>> it's specific to that), I hit that warning three times. =A0Let me kn=
ow
>> if I can collect any more data.
>
> I tried to read that code and understand what is going on but I don't
> know enough about the block and scsi layers to have a clue where to
> start.
>
> bsg_unregister_queue seems to be a generic piece of infrastructure.
>
> q->kobj seems to be managed separately from =A0q->bsg_dev->class_dev.
>
> If I read q->kobj correctly that is managed with blk_put_queue.
>
> So it seems like the final blk_put_queue or blk_unregister_queue is
> being called before bsg_unregister_queue and causing this problem.
>
> What the solution might be I can't believe to figure out.

This fixed it for me:

https://lkml.org/lkml/2012/2/8/246

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
