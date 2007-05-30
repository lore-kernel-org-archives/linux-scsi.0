From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] aacraid: fix shutdown handler to also disable interrupts.
Date: Wed, 30 May 2007 10:36:35 -0700
Message-ID: <86802c440705301036q45e4bed4ra08a5c4394eafa0e@mail.gmail.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A55087@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:7158 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbXE3Rgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 13:36:36 -0400
Received: by nz-out-0506.google.com with SMTP id n1so1614934nzf
        for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 10:36:36 -0700 (PDT)
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55087@otce2k301.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, vgoyal@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> Moves quiesce, thread and interrupt shutdown into aacraid drivers'
> .shutdown handler. This fix to the aac_shutdown handler will remove the
> superfluous reset of the adapter during a (clean) kexec.
>
> This fix may mitigate the active investigation 'kexec and aacraid
> broken' but it is unlikely to affect the root cause (issue likely
> present in both kexec and kdump). This patch reduces the chance the
> problem will occur with a kexec. The fix for root cause is currently
> expected to be the minimum value check to the aacraid.startup_timeout
> driver variable after an adapter reset within aacraid_commit_reset.patch
> submitted on 05/22/2007 and awaiting testing by Yinghai to confirm.
>
> This attached patch is against current scsi-misc-2.6
>
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patch attachments.
>
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>
> Sincerely -- Mark Salyzyn
>
the kernel with this patch -4  and even without

1. [SCSI] aacraid: superfluous adapter reset for IBM 8 series
ServeRAID controllers
2. [SCSI] aacraid: kexec fix (reset interrupt handler)
3. aacraid_commit_reset.patch

can load other kernel with or without patch 1,2,3

YH
