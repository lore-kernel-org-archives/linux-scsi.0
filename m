From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: make INQUIRY response SPC-compliant
Date: Tue, 07 Jul 2015 17:01:24 +0200
Message-ID: <87bnfo106z.fsf@vitty.brq.redhat.com>
References: <1435741448-29070-1-git-send-email-vkuznets@redhat.com>
	<20150703161903.GA20449@infradead.org>
	<BY2PR0301MB1654779EEF1205C4A009C5F6A0960@BY2PR0301MB1654.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757106AbbGGPB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jul 2015 11:01:29 -0400
In-Reply-To: <BY2PR0301MB1654779EEF1205C4A009C5F6A0960@BY2PR0301MB1654.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Fri, 3 Jul 2015 16:28:25 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Long Li <longli@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

KY Srinivasan <kys@microsoft.com> writes:

>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@infradead.org]
>> Sent: Friday, July 3, 2015 9:19 AM
>> To: Vitaly Kuznetsov
>> Cc: linux-scsi@vger.kernel.org; Long Li; KY Srinivasan; Haiyang Zhang; James
>> E.J. Bottomley; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] scsi: storvsc: make INQUIRY response SPC-compliant
>> 
>> On Wed, Jul 01, 2015 at 11:04:08AM +0200, Vitaly Kuznetsov wrote:
>> > SPC-2/3/4 specs state that "The standard INQUIRY data (see table ...)
>> > shall contain at least 36 bytes". Hyper-V host doesn't always honor this
>> > requirement, e.g. when there is no physical device present at a particular
>> > LUN host sets Peripheral qualifier to 011b and Additional length to 0
>> > (thus making the reply 5-bytes long). Upper level SCSI stack complains
>> > with 'INQUIRY result too short (5), using 36'. Fix the issue by mangling
>> > Additional length field in host's reply at the driver level.
>> 
>> This looks like a big mess, and usage of phys_to_virt is not generally
>> safe to start with.
>> 
>> If HyperV really is that broken the warning seems correct, but if you
>> really have to get rid of it we could add a blist flag to not issue
>> the warning in the core code instead of hacking around it in the driver.
>
> Agreed. We have fixed this issue in win10 and I am trying to get the fix backported.

In case this is fixed in future Hyper-V versions introducing new blist
flags looks like an overkill, let's leave things as they are.

Thanks,

-- 
  Vitaly
