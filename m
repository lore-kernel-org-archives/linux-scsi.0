From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Mon, 6 Jun 2016 17:43:54 +0200
Message-ID: <92aeeb5e-9b36-339e-8e44-afb78adeac6e@redhat.com>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
 <5755278E.8040002@suse.de> <1465222299.20724.114.camel@localhost.localdomain>
 <5755873E.5080303@suse.de> <4c7c1ec8-06bf-e2f5-c971-de82eb69fdb4@redhat.com>
 <69fd3238-fde2-90f3-2eb6-3f71a7317016@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbcFFPoA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 11:44:00 -0400
In-Reply-To: <69fd3238-fde2-90f3-2eb6-3f71a7317016@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Snow <jsnow@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com
Cc: linux-scsi@vger.kernel.org



On 06/06/2016 17:41, John Snow wrote:
> On 06/06/2016 11:05 AM, Paolo Bonzini wrote:
>> For ATAPI, you have to blacklist all versions up to 2.2 inclusive.
>>
>> This gives:
>>
>> - QEMU / QEMU CD-ROM / 0.8.    (this is IDE and SCSI)
>> - QEMU / QEMU CD-ROM / 0.9.    (this is IDE and SCSI)
>> - QEMU / QEMU CD-ROM / 0.10    (this is SCSI only)
>> - QEMU / QEMU CD-ROM / 0.11    (this is SCSI only)
>> - QEMU / QEMU DVD-ROM / 0.8.   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.9.   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.10   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.11   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.12   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.13   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.14   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 0.15   (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.0    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.1    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.2    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.3    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.4    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.5    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.6    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 1.7    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 2.0    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 2.1    (this is IDE only)
>> - QEMU / QEMU DVD-ROM / 2.2    (this is IDE only)
>>
> 
> If this bug is caused by a missing VPD response, Paolo's version history
> here is correct.... for upstream versions.
> 
> Various downstreams may have backported the VPD fix to older versions,
> we need to be careful not to block those, too ... so targeting the core
> behavior seems like the more strictly correct, easily maintainable solution.

I think this is not practical.  I'm okay with the big hammer if an
algorithmic fix is not feasible; but otherwise it does seem a better
idea than blacklisting based on inquiry data...

Thanks,

Paolo

> Why not just dynamically blacklist devices that fail to respond to VPD
> inquiries?

