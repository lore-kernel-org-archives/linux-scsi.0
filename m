From: Don Brace <brace77070@gmail.com>
Subject: Re: [hpsa] regression, does not recognise tape robot changer
Date: Thu, 19 Feb 2015 17:05:12 -0600
Message-ID: <54E66C28.1030401@gmail.com>
References: <54E618D8.9090406@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:39615 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbbBSXFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Feb 2015 18:05:14 -0500
Received: by mail-qa0-f52.google.com with SMTP id v10so9140326qac.11
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:05:13 -0800 (PST)
In-Reply-To: <54E618D8.9090406@redpill-linpro.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kjetil Torgrim Homme <kjetil.homme@redpill-linpro.com>, linux-scsi@vger.kernel.org

On 02/19/2015 11:09 AM, Kjetil Torgrim Homme wrote:
> this regression is getting old, but it's still present in the newest
> Linus kernels.
>
> I have a HP server with a P411 card with a MSL G3 48 slot tape changer
> attached.  the tape changer has two LTO5 and one LTO6 tape drives
> installed.  one of the cables is an "octopus", well "quadpus", but
> changing what's connected with a "proper" cable and two of the quadpus
> doesn't seem to make any difference.  there is no other equipment (e.g.,
> disks) attached to this card.
>
> on Linux 3.14 this works fine, but on anything newer one of the tape
> drives and the changer itself goes missing.  see attachments of boot
> messages from each case.
>
> I've gone through a bisect from v3.14 to v3.15-rc1, and ended up at this
> commit:
>
> : [root@dump2-osl1 ~/src/linux]; git bisect good
> 283b4a9b98b192ebc0e15351fd6fb60e1be78c5d is the first bad commit
> commit 283b4a9b98b192ebc0e15351fd6fb60e1be78c5d
> Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Date:   Tue Feb 18 13:55:33 2014 -0600
>
>      [SCSI] hpsa: add ioaccell mode 1 RAID offload support.
>
>      This enables sending i/o's destined for RAID logical drives
>      which can be serviced by a single physical disk down a different,
>      faster i/o path directly to physical drives for certain logical
>      volumes on SSDs bypassing the Smart Array RAID stack for a
>      performance improvement.
>
>      Signed-off-by: Matt Gates <matthew.gates@hp.com>
>      Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>      Signed-off-by: Scott Teel <scott.teel@hp.com>
>      Signed-off-by: Mike Miller <michael.miller@canonical.com>
>      Signed-off-by: Don Brace <brace@beardog.cce.hp.com>
>      Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
>      Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>
> :040000 040000 2883c53c791ca8add0c8fd743027bb3c65a293b7
> 224b5b082268720c62f0da340017111fe6b03eb2 M      drivers
>
>
> it there any more information I can provide?
>

I'll look into this. I should have all that I need.

