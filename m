From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/5] block/scsi/lio support for COMPARE_AND_WRITE
Date: Fri, 17 Oct 2014 08:02:02 +0200
Message-ID: <5440B0DA.4020902@suse.de>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu> <543FA05C.6060200@interlog.com> <54402421.8060808@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaJQGCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2014 02:02:06 -0400
In-Reply-To: <54402421.8060808@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk

On 10/16/2014 10:01 PM, Douglas Gilbert wrote:
> On 14-10-16 12:39 PM, Douglas Gilbert wrote:
>> On 14-10-16 07:37 AM, michaelc@cs.wisc.edu wrote:
>>> The following patches implement the SCSI command COMPARE_AND_WRITE =
as
>>> a new
>>> bio/request type REQ_CMP_AND_WRITE. COMPARE_AND_WRITE is defined in=
 the
>>> SCSI SBC (SCSI block command) specs as:
>>>
>>> The COMPARE AND WRITE command requests that the device server perfo=
rm
>>> the
>>> following as an uninterrupted series of actions:
>>>
>>> 1) perform the following operations:
>>>          A) read the specified logical blocks; and
>>>          B) transfer the specified number of logical blocks from th=
e
>>> Data-Out
>>>          Buffer (i.e., the verify instance of the data is transferr=
ed
>>> from the
>>>          Data-Out Buffer);
>>>
>>> 2) compare the data read from the specified logical blocks with the
>>> verify
>>> instance of the data; and
>>> 3) If the compared data matches, then perform the following operati=
ons:
>>>          1) transfer the specified number of logical blocks from th=
e
>>> Data-Out
>>>          Buffer (i.e., the write instance of the data transferred
>>> from the
>>>          Data-Out Buffer); and
>>>          2) write those logical blocks.
>>>
>>> The most command use of this command today is in VMware ESX where i=
t
>>> is used
>>> for locking. See
>>> http://blogs.vmware.com/vsphere/2012/05/vmfs-locking-uncovered.html
>>> [in ESX is it is called ATS (atomic test and set)] for more VMware =
info.
>>> Linux fits into this use, because its SCSI target layer (LIO) is
>>> commonly
>>> used as storage for ESX VMs.
>>>
>>> Currently, to support this command in LIO we emulate it by taking a
>>> lock,
>>> doing a read, comparing it, then doing a write. The problem this
>>> patchset
>>> tries to solve is that in many cases it is more efficient to pass t=
he
>>> one
>>> COMPARE_AND_REQUEST request directly to the device where it might h=
ave
>>> optimized locking and also will require fewer requests to/from the
>>> target
>>> and backing storage device.
>>>
>>> I am also bugging the ceph-devel list, because I am working on LIO =
+
>>> ceph
>>> support. I am interested in using ceph's rbd device for the backing
>>> storage for LIO, and I was thinking this request could be implement=
ed
>>> similar
>>> to how REQ_DISCARD (unmap/trim) is going to be, and I wanted to get
>>> some early
>>> feedback. I know the scsi layer better, so I have only added suppor=
t
>>> in sd in
>>> this patchset.
>>>
>>> The following patches were made over the target-pending for-next
>>> branch but
>>> also apply to Linus's tree.
>>
>> As I found when I implemented this command in sg3_utils,
>> my library's support for handling and reporting the
>> MISCOMPARE sense key needed to be strengthened. [A sense
>> buffer with a MISCOMPARE sense key is what results when
>> the compare in step 2) is unequal.]
>>
>> Since it was relatively rare prior to VMWare's use of
>> the COMPARE AND WRITE command, MISCOMPARE is often forgotten
>> in sense key handling. Also it should not be considered
>> as an error and definitely should not lead to the command
>> being retried.
>>
>> The COMPARE AND WRITE command may fail for other reasons
>> such as a transport problem or a Unit Attention, so the
>> SCSI eh logic may need to know about it.
>
> Elaborating ...
>
> Hannes will enjoy this one: say a COMPARE AND WRITE (CAW) fails
> due to a transport error or timeout. What should the EH do *** ?
> Answer: read that LBA(s) to see whether the command succeeded
> (i.e. wrote the new data)! If it did, do nothing; if it didn't,
> repeat the CAW command. And naturally that second CAW may
> yield a MISCOMPARE.
>
Hmm. Surely we should be getting a sense code telling us up to
which block the CAW failed? Reading the LBA(s) seems like a daft
idea to me ...

>
> Mike proposes using ECANCELED for the errno corresponding to
> MISCOMPARE. Not wild about that but can't see anything better,
> and it is definitely much better than EIO.
>
Yup. Please do.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
