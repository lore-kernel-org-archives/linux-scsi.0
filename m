From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] aacraid: fix shutdown handler to also disable interrupts.
Date: Fri, 1 Jun 2007 10:07:48 -0700
Message-ID: <86802c440706011007r7c9162c3w1fe0ba1952361f19@mail.gmail.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A55087@otce2k301.adaptec.com>
	 <20070601110845.GC20714@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:63722 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760771AbXFARHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 13:07:49 -0400
Received: by wa-out-1112.google.com with SMTP id j4so565834wah
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jun 2007 10:07:48 -0700 (PDT)
In-Reply-To: <20070601110845.GC20714@in.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 6/1/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> On Wed, May 30, 2007 at 11:59:13AM -0400, Salyzyn, Mark wrote:
> > Moves quiesce, thread and interrupt shutdown into aacraid drivers'
> > .shutdown handler. This fix to the aac_shutdown handler will remove the
> > superfluous reset of the adapter during a (clean) kexec.
> >
> > This fix may mitigate the active investigation 'kexec and aacraid
> > broken' but it is unlikely to affect the root cause (issue likely
> > present in both kexec and kdump). This patch reduces the chance the
> > problem will occur with a kexec. The fix for root cause is currently
> > expected to be the minimum value check to the aacraid.startup_timeout
> > driver variable after an adapter reset within aacraid_commit_reset.patch
> > submitted on 05/22/2007 and awaiting testing by Yinghai to confirm.
> >
> > This attached patch is against current scsi-misc-2.6
> >
> > ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> > handling of patch attachments.
> >
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> >
>
> Thanks Mark. This does fix the issue of unnecessary reset of aacraid
> adapter over kexec on my machine.
>
i'm little confused about that.
this patch is some clear shutdown, so even next start will have tight
condition will not try to reset the adapter fw. right Mark?
Maybe the driver could be smart to find out if it need to reset adaptec fw.

YH
