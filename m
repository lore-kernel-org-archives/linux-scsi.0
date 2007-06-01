From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [PATCH] aacraid: fix shutdown handler to also disable interrupts.
Date: Fri, 1 Jun 2007 16:38:45 +0530
Message-ID: <20070601110845.GC20714@in.ibm.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com> <AE4F746F2AECFC4DA4AADD66A1DFEF01A55087@otce2k301.adaptec.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37032 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXFALJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 07:09:05 -0400
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55087@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yhlu.kernel@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Wed, May 30, 2007 at 11:59:13AM -0400, Salyzyn, Mark wrote:
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

Thanks Mark. This does fix the issue of unnecessary reset of aacraid
adapter over kexec on my machine.

Thanks
Vivek
