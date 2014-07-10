From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Thu, 10 Jul 2014 12:33:05 +0200
Message-ID: <CAFLxGvzFTeE9J-4KFUn9q1fggB_pGBHEMEPcBtDhje+uRm7yMw@mail.gmail.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-1-git-send-email-kys@microsoft.com>
	<1404866812-26950-6-git-send-email-kys@microsoft.com>
	<20140709084415.GF6012@infradead.org>
	<9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36769 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaGJKdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 06:33:07 -0400
In-Reply-To: <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "apw@canonical.com" <apw@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jul 9, 2014 at 8:51 PM, KY Srinivasan <kys@microsoft.com> wrote:
>
>
>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@infradead.org]
>> Sent: Wednesday, July 9, 2014 1:44 AM
>> To: KY Srinivasan
>> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
>> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
>> apw@canonical.com; linux-scsi@vger.kernel.org
>> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
>>
>> On Tue, Jul 08, 2014 at 05:46:50PM -0700, K. Y. Srinivasan wrote:
>> > Implement a simple abort handler. The host does not support "Abort";
>> > just ensure that all inflight I/Os have been accounted for.
>>
>> The abort handler should abort a single command, not wait for all of them.
>> What issue do you see that this tries to address?
>
> On Azure, we sometimes have unbounded I/O latencies and some distributions (such as SLES12) based on recent kernels are invoking
> the "Abort Handler". Unfortunately, our scsi emulation on the host does not support aborting a command.
> The issue I have seen is that the upper level scsi code attempts error recovery when the command times out and finally frees up the command.
> The host subsequently responds to the command that has timed out and since the memory has been freed up, we end up touching freed memory
> in this driver. Since the host is also doing error recovery, by just delaying the error handler in the guest until we can account for all the in-flight commands,
> we can get around the problem.

I see strange issues in Azure and maybe they are related to this.
Some Linux machines crash in a way that no disk IO is possible (thus,
no SSH for me) but they still respond to
ping. It happens rather seldom (every few weeks).

Do you see similar symptoms?

-- 
Thanks,
//richard
