From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Tue, 9 Jan 2018 15:50:44 -0500
Message-ID: <27ebbe5f-e06b-a800-5518-ec63d65d142a@interlog.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org>
 <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
 <20180109164540.GA11861@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40302 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757083AbeAIUuw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jan 2018 15:50:52 -0500
In-Reply-To: <20180109164540.GA11861@infradead.org>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>

On 2018-01-09 11:45 AM, Christoph Hellwig wrote:
> On Tue, Jan 09, 2018 at 10:07:28PM +0530, Kashyap Desai wrote:
>> Chris -
>>
>> Overall NVME support behind MR controller is really a SCSI device. On top
>> of that, for MegaRaid, NVME device can be part of Virtual Disk and those
>> drive will not be exposed to the driver. User application may like to talk
>> to hidden NVME devices (part of VDs). This patch will extend the existing
>> interface for megaraid product in the same way it is currently supported
>> for other protocols like SMP, SATA pass-through.
>>
>> Example - Current smartmon is using megaraid.h (MFI headers) to send SATA
>> pass-through.
>>
>> https://github.com/mirror/smartmontools/blob/master/megaraid.h
> 
> And that is exactly the example of why we should have never allowed
> megaraid any private passthrough ioctls to start with.

Christoph,
Have you tried to do any serious work with <linux/nvme_ioctl.h> and
say compared it with FreeBSD and Microsoft's approach? No prize for
guessing which one is worst (and least extensible). Looks like the
Linux pass-through was at the end of a ToDo list and was "designed"
at 5 a.m in the morning.

RAID cards need a pass-through that allows them to address one of
many physical disks behind the virtual disk presented to OS.
Pass-throughs need to have uncommited room for extra parameters that
will be passed through as-is to the RAID LLD.

So until Christoph gives an example of how that can be done with
<linux/nvme_ioctl.h> then I would like to see Christoph's objection
ignored.


And as a maintainer of smartmontools, I would like to point out that
pretty well all supported RAIDs, on all platforms need specialized
pass-through code. Start by looking at os_linux.cpp and then at the
other OSes. And now smartmontools supports NVMe on most platforms
and at the pass-through level, it is just another one, and not a
particularly clean one.

IMO Intel had their chance on the pass-through front, and blew it.
It is now too late to fix it and that job (impossible ?) should not
fall to MegaRaid maintainers.

Douglas Gilbert
