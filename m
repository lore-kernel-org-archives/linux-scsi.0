From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/5] block/scsi/lio support for COMPARE_AND_WRITE
Date: Thu, 16 Oct 2014 12:39:24 +0200
Message-ID: <543FA05C.6060200@interlog.com>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On 14-10-16 07:37 AM, michaelc@cs.wisc.edu wrote:
> The following patches implement the SCSI command COMPARE_AND_WRITE as a new
> bio/request type REQ_CMP_AND_WRITE. COMPARE_AND_WRITE is defined in the
> SCSI SBC (SCSI block command) specs as:
>
> The COMPARE AND WRITE command requests that the device server perform the
> following as an uninterrupted series of actions:
>
> 1) perform the following operations:
>          A) read the specified logical blocks; and
>          B) transfer the specified number of logical blocks from the Data-Out
>          Buffer (i.e., the verify instance of the data is transferred from the
>          Data-Out Buffer);
>
> 2) compare the data read from the specified logical blocks with the verify
> instance of the data; and
> 3) If the compared data matches, then perform the following operations:
>          1) transfer the specified number of logical blocks from the Data-Out
>          Buffer (i.e., the write instance of the data transferred from the
>          Data-Out Buffer); and
>          2) write those logical blocks.
>
> The most command use of this command today is in VMware ESX where it is used
> for locking. See
> http://blogs.vmware.com/vsphere/2012/05/vmfs-locking-uncovered.html
> [in ESX is it is called ATS (atomic test and set)] for more VMware info.
> Linux fits into this use, because its SCSI target layer (LIO) is commonly
> used as storage for ESX VMs.
>
> Currently, to support this command in LIO we emulate it by taking a lock,
> doing a read, comparing it, then doing a write. The problem this patchset
> tries to solve is that in many cases it is more efficient to pass the one
> COMPARE_AND_REQUEST request directly to the device where it might have
> optimized locking and also will require fewer requests to/from the target
> and backing storage device.
>
> I am also bugging the ceph-devel list, because I am working on LIO + ceph
> support. I am interested in using ceph's rbd device for the backing
> storage for LIO, and I was thinking this request could be implemented similar
> to how REQ_DISCARD (unmap/trim) is going to be, and I wanted to get some early
> feedback. I know the scsi layer better, so I have only added support in sd in
> this patchset.
>
> The following patches were made over the target-pending for-next branch but
> also apply to Linus's tree.

As I found when I implemented this command in sg3_utils,
my library's support for handling and reporting the
MISCOMPARE sense key needed to be strengthened. [A sense
buffer with a MISCOMPARE sense key is what results when
the compare in step 2) is unequal.]

Since it was relatively rare prior to VMWare's use of
the COMPARE AND WRITE command, MISCOMPARE is often forgotten
in sense key handling. Also it should not be considered
as an error and definitely should not lead to the command
being retried.

The COMPARE AND WRITE command may fail for other reasons
such as a transport problem or a Unit Attention, so the
SCSI eh logic may need to know about it.

Doug Gilbert
