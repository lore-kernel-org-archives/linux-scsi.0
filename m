From: Vladislav Bolkhovitin <ml@vlnb.net>
Subject: Re: atomic write & T10 standards
Date: Wed, 03 Jul 2013 20:18:02 -0700
Message-ID: <51D4E96A.6040002@vlnb.net>
References: <51D4365C.1030008@redhat.com> <20130703143844.14981.69152@localhost.localdomain> <51D43B87.5090005@redhat.com> <1372863655.3601.19.camel@dabdike> <51D43D6C.6050505@redhat.com> <1372864959.3601.37.camel@dabdike> <51D442DD.8000001@redhat.com> <1372865829.3601.41.camel@dabdike> <51D4466E.8040408@redhat.com> <20130703155400.14981.4222@localhost.localdomain> <51D46E1F.1090501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3GDDSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 23:18:11 -0400
In-Reply-To: <51D46E1F.1090501@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <clmason@fusionio.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@mkp.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ric Wheeler, on 07/03/2013 11:31 AM wrote:
>>> Journals are normally big (128MB or so?) - I don't think that this is unique to xfs.
>> We're mixing a bunch of concepts here.  The filesystems have a lot of
>> different requirements, and atomics are just one small part.
>>
>> Creating a new file often uses resources freed by past files.  So
>> deleting the old must be ordered against allocating the new.  They are
>> really separate atomic units but you can't handle them completely
>> independently.
>>
>>> If our existing journal commit is:
>>>
>>> * write the data blocks for a transaction
>>> * flush
>>> * write the commit block for the transaction
>>> * flush
>>>
>>> Which part of this does and atomic write help?
>>>
>>> We would still need at least:
>>>
>>> * atomic write of data blocks & commit blocks
>>> * flush

No necessary.

Consider a case, when you are creating many small files in a big directory. Consider
that every such operation needs 3 actions: add new directory entry, get free space and
write data there. If 1 atomic write (scattered) command is used for each operation and
you order them between each other, if needed, in some way, e.g. by using ORDERED SCSI
attribute or queue draining, you don't need any intermediate flushes. Only one final
flush would be sufficient. In case of crash simply some of the new files would
"disappear", but everything would be fully consistent, so the only needed recovery
would be to recreate them.

> The catch is that our current flush mechanisms are still pretty brute force and 
> act across either the whole device or in a temporal (everything flushed before 
> this is acked) way.
> 
> I still see it would be useful to have the atomic write really be atomic and 
> durable just for that IO - no flush needed.
> 
> Can you give a sequence for the use case for the non-durable atomic write that 
> would not need a sync?

See above.

> Can we really trust all devices to make something atomic 
> that is not durable :) ?

Sure, if application allows that and the atomicity property itself is durable, why not?

Vlad

P.S. With atomic writes there's no need in a journal, no?
