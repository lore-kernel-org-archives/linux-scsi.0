From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 07 Nov 2014 15:15:01 -0500
Message-ID: <545D2845.5020904@interlog.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com> <yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <94D0CD8314A33A4D9D801C0FE68B40295937AE5D@G4W3202.americas.hpqcorp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295937AE5D@G4W3202.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Friesen <chris.friesen@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 14-11-07 12:10 PM, Elliott, Robert (Server Storage) wrote:
>> commit 87c0103ea3f96615b8a9816b8aee8a7ccdf55d50
>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>> Date:   Thu Nov 6 12:31:43 2014 -0500
>>
>>      [SCSI] sd: Sanity check the optimal I/O size
>>
>>      We have come across a couple of devices that report crackpot
>> 	values in the optimal I/O size in the Block Limits VPD page.
>> 	Since this is a 32-bit entity that gets multiplied by the
>> 	logical block size we can get
>>      disproportionately large values reported to the block layer.
>>
>>      Cap io_opt at 1 GB.
>
> Another reasonable cap is the maximum transfer size.
> There are lots of them:
>
> * the block layer BIO_MAX_PAGES value of 256 limits IOs
>    to a maximum of 1 MiB
> * SCSI LLDs report their maximum transfer size in
>    /sys/block/sdNN/queue/max_hw_sectors_kb
> * the SCSI midlayer maximum transfer size is set/reported
>    in /sys/block/sdNN/queue/max_sectors_kb
>    and the default is 512 KiB
> * the SCSI LLD maximum number of scatter gather entries
>    reported in /sys/block/sdNN/queue/max_segments and
>    /sys/block/sdNN/queue/max_segment_size creates a
>    limit based on how fragmented the data buffer is
>    in virtual memory
> * the Block Limits VPD page MAXIMUM TRANSFER LENGTH field
>    indicates the maximum transfer size for one command over
>    the SCSI transport protocol supported by the drive itself
>
> It is risky to use transfer sizes larger than linux and
> Windows can generate, since drives are probably tested in
> those environments.

After being burnt by a (virtual) SCSI disk recently, my
utilities now take a more aggressive approach to the data-in
buffer received from INQUIRY, MODE SENSE and LOG SENSE (and
probably should add a few more):

At a low level, after the command is completed, the data-in
buffer is post-filled with zeros following the last valid
byte as indicated by resid, until the end of that buffer.
Then it is passed back for higher level processing of the
command including its data-in buffer.

Pre-filling the data-in buffer with zeros has been in place
for a long time, but I don't think it helps much.


So if there are any HBA drivers that set resid higher than it
should be, expect some pain soon.

Doug Gilbert
