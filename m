From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv3 0/5] Dynamic growing data area support
Date: Mon, 20 Mar 2017 22:24:47 -0700
Message-ID: <1490073887.8236.41.camel@haakon3.risingtidesystems.com>
References: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51783 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbdCUFYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2017 01:24:50 -0400
In-Reply-To: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: agrover@redhat.com, mchristi@redhat.com, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com

Hi Xiubo !

On Mon, 2017-03-20 at 17:09 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> Changed for V3:
> - [PATCHv2 2/5] fix double usage of blocks and possible page fault
>   call trace.
> - [PATCHv2 5/5] fix a mistake.
> 
> Changed for V2:
> - [PATCHv2 1/5] just fixes some small spelling and other mistakes.
>   And as the initial patch, here sets cmd area to 8M and data area to
>   1G(1M fixed and 1023M growing)
> - [PATCHv2 2/5] is a new one, adding global data block pool support.
>   The max total size of the pool is 2G and all the targets will get
>   growing blocks from here.
>   Test this using multi-targets at the same time.
> - [PATCHv2 3/5] changed nothing, respin it to avoid the conflict.
> - [PATCHv2 4/5] and [PATCHv2 5/5] are new ones.
> 
> 
> Xiubo Li (5):
>   tcmu: Add dynamic growing data area feature support
>   tcmu: Add global data block pool support
>   target/user: Fix possible overwrite of t_data_sg's last iov[]
>   target/user: Fix wrongly calculating of the base_command_size
>   target/user: Clean up tcmu_queue_cmd_ring
> 
>  drivers/target/target_core_user.c | 621 +++++++++++++++++++++++++++++++-------
>  1 file changed, 514 insertions(+), 107 deletions(-)
> 

I've not been following the details of your TCMU efforts, so will have
defer to MNC + AGrover for Acked-by + Reviewed-bys here.  ;)

One comment on the series ordering though..

Patches #1 + #2 introduce new features, while patches #3 + #4 are
bug-fixes to (existing..?) code.  AFAICT, patches #3 + #4 are
stand-alone that don't depend on the new features.  Is that correct..?

If so, I'd prefer to apply #3 + #4 to target-pending/master for
v4.11-rcX (eg: bug-fixes only), and include new features in #1 + #2 and
cleanup in #5 to target-pending/for-next. (eg: next merge window for
v4.12-rc1).

Usually the preferred way when submitting patches is to always put
bug-fixes first in the series, followed by new features, further
cleanups, etc.

That way it's easy for a maintainer to split out / cherry-pick bug-fixes
from the series as necessary, without needing to worry about
dependencies in the earlier patches.

That said, if patch #3 + #4 are stand-alone bug-fixes, would you be so
kind to re-order them at the head of the series, and re-submit..?
