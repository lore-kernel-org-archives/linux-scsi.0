From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: introduce short_inquiry flag for broken host
 adapters
Date: Tue, 15 Sep 2015 11:24:05 -0700
Message-ID: <1442341445.2177.9.camel@HansenPartnership.com>
References: <1441296673-14315-1-git-send-email-vkuznets@redhat.com>
	 <87k2rryczs.fsf@vitty.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55599 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbbIOSYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2015 14:24:07 -0400
In-Reply-To: <87k2rryczs.fsf@vitty.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>

On Tue, 2015-09-15 at 16:27 +0200, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Some host adapters (e.g. Hyper-V storvsc) are known for not respecting the
> > SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain at
> > least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
> > INQUIRY result too short (5), using 36' messages on console. This can be
> > problematic for slow consoles. Introduce short_inquiry host template flag
> > to avoid printing error messages for such adapters.
> >
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---
> > Changes since v1:
> > - This is a successor of previously sent "scsi_scan: move 'INQUIRY result
> >   too short' message to debug level" patch. Instead of moving the message
> >   to debug level for all adapters introduce a special 'short_inquiry' flag
> >   for host template [inspired by James Bottomley].
> 
> James,
> 
> sorry for the ping but can you please let me know your opinion? This is
> not a 'cosmetic fix', serial port on Hyper-V is extremely slow and users
> get softlockups just because we output too much. Here is a freshly
> booted guest with SCSI and FC adapters connected:
> 
> # dmesg | grep -c INQUIRY
> 2076

It needs a review ... preferably from someone who validates that we
don't get any adverse impact from the missing inquiry data

> (my other pernding '[PATCH] scsi_scan: don't dump trace when
> scsi_prep_async_scan() is called twice' is related to the same issue).

So does this.

James


> See also: https://lkml.org/lkml/2015/9/6/119
> 
> Thanks,
> 
> [...]
> 



