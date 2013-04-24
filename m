From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 16:41:51 -0400
Message-ID: <5178438F.3010103@gmail.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de> <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com> <5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com> <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f169.google.com ([209.85.160.169]:60925 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab3DXUly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 16:41:54 -0400
Received: by mail-gh0-f169.google.com with SMTP id r18so20607ghr.14
        for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2013 13:41:54 -0700 (PDT)
In-Reply-To: <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Black, David" <david.black@emc.com>
Cc: Jeremy Linton <jlinton@tributary.com>, Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

On 04/24/2013 02:20 PM, Black, David wrote:
> Jeremy,
>
> It looks like, you, Paolo and Ric have hit the nail on the head here - this is
> a nice summary, IMHO:
>
>> On 4/24/2013 7:57 AM, Paolo Bonzini wrote:
>>>> If the device can promise this, we don't care (and don't know) how it
>>>> manages that promise. It can leave the data on battery backed DRAM, can
>>> archive it to flash or any other scheme that works.
>>>
>>> That's exactly the point of SYNC_NV=1.
>> 	Well its the point, but the specification is written such that the vendors can
>> choose to implement it any way they wish, especially for split cache
>> systems where there is both volatile and non volatile cache.
> Independent of T10's best intentions at the time, the implementations aren't
> doing what's needed or intended, and I'd guess that the SYNC_NV bit is not
> being set to 1 by [other people's ;-) ] software that should be setting it
> to 1 if it were paying attention to the standard.
>
> This is further complicated by it being completely legitimate wrt the SCSI
> standard to put non-volatile cache in a system and not have the SCSI interface
> admit that the non-volatile cache exists (WCE=0, SYNCHRONIZE CACHE is a no-op
> independent of the value of SYNC_NV).
>
> I believe that Rob Elliot's 13-050 proposal to obsolete SYNC_NV and re-specify
> SYNCHRONIZE CACHE to make all data non-volatile by whatever means the target
> chooses is what T10 should do, and that matches Ric's summary:
>
>>>> If the device can promise this, we don't care (and don't know) how it
>>>> manages that promise. It can leave the data on battery backed DRAM, can
>>> archive it to flash or any other scheme that works.
> Beyond that, attempting to manage drive removal from storage systems via the
> SCSI interface with standard commands is a waste of time and effort, IMHO.
> In a serious storage array (and even some fairly simple RAID controllers), some
> vendor-specific "magic" is needed to get the array (or controller) to prepare
> so that the drive can be removed cleanly.  To oversimplify, it's not enough to
> flush data to the drive; the array or controller is stateful, and hence has
> to be told to "forget" the drive, where "forget" involves things that are
> rather implementation-specific.
>
> Thanks,
> --David
>

So I think that leaves us with some arrays that might benefit from Paolo's 
proposed patch, but almost certainly still will need to be able to "ignore 
flushes" for some block device accessing DB's, etc....

Ric

