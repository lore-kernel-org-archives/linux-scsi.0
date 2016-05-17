From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] target: fix max discard sectors calculation
Date: Tue, 17 May 2016 11:16:38 -0700
Message-ID: <573B6006.8010206@sandisk.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
 <1463424410-17196-3-git-send-email-mchristi@redhat.com>
 <573A1826.3050007@sandisk.com> <yq1y479hlmp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <yq1y479hlmp.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/16/2016 12:02 PM, Martin K. Petersen wrote:
>>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:
>
> Bart> That's a good catch. But seeing this patch makes me wonder whether
> Bart> this patch introduces a 64-bit division? If so, I'm afraid this
> Bart> patch will make 32-bit users unhappy. Have you considered to use
> Bart> do_div() or >> (ilog2(block_size) - 9) instead? For the latter
> Bart> alternative no 64-bit cast is needed.
>
> Please use logical_to_sectors().

Hello Martin,

For SCSI initiator devices the logical block size is stored in struct 
scsi_device. logical_to_sectors() gets the logical block size from 
struct scsi_device. LIO however stores the logical block size in struct 
se_dev_attrib. If we want to keep SCSI initiator and SCSI target headers 
separate I think we will need two logical_to_sectors() functions - one 
for SCSI initiator devices and one for SCSI target devices.

Bart.
