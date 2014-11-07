From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Thu, 6 Nov 2014 23:35:23 -0600
Message-ID: <545C5A1B.9020206@windriver.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com> <yq1zjc3ai4h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zjc3ai4h.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/06/2014 07:56 PM, Martin K. Petersen wrote:
>>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:
>
> Chris,
>
> Chris> For a RAID card I expect it would be related to chunk size or
> Chris> stripe width or something...but even then I would expect to be
> Chris> able to cap it at 100MB or so.  Or are there storage systems on
> Chris> really fast interfaces that could legitimately want a hundred meg
> Chris> of data at a time?
>
> Well, there are several devices that report their capacity to indicate
> that they don't suffer any performance (RMW) penalties for large
> commands regardless of size. I would personally prefer them to report 0
> in that case.

I got curious and looked at the spec at 
"http://www.13thmonkey.org/documentation/SCSI/sbc3r25.pdf".  I'm now 
wondering if maybe linux is misbehaving.

I think there is actually some justification for putting a huge value in 
the "optimal transfer length" field.  That field is described as "the 
optimal transfer length in blocks for a single...command", but then 
later it has "If a device server receives a request with a transfer 
length exceeding this value, then a significant delay in processing the 
request may be incurred."  As written, it is ambiguous.

Looking at "ftp://ftp.t10.org/t10/document.03/03-028r2.pdf" it appears 
that originally that field was the "optimal maximum transfer length", 
not the "optimal transfer length".  It appears that the intent was that 
the device was able to take requests up to the "maximum transfer 
length", but there would be a performance penalty if you went over the 
"optimum maximum transfer length".

Section E.4 in "sbc3r25.pdf" talks about optimizing transfers.  They 
suggest using a transfer length that is a multiple of "optimal transfer 
length granularity", up to a max of either the max or optimal transfer 
lengths depending on the size of the penalty if you exceed the optimal 
transfer length.  This reinforces the idea that the "optimal transfer 
length" is actually the optimal *maximum* length, but any multiple of 
the optimal granularity is fine.

Based on that, I think it would have been clearer if it had been called 
"/sys/block/sdb/queue/optimal_max_io_size".

Also, I think it's wrong for filesystems and userspace to use it for 
alignment.  In E.4 and E.5 in the "sbc3r25.pdf" doc, it looks like they 
use the optimal granularity field for alignment, not the optimal 
transfer length.


So for the ST900MM0006, it had:

# sg_inq --vpd --page=0xb0 /dev/sdb
VPD INQUIRY: Block limits page (SBC)
   Optimal transfer length granularity: 1 blocks
   Maximum transfer length: 0 blocks
   Optimal transfer length: 4294967295 blocks

In this case I think the drive is trying to say that it doesn't require 
any special granularity (can handle alignment on 512-byte blocks), and 
that it can handle any size of transfer without performance penalty.

Chris
