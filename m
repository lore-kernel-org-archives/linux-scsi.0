From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [GIT PULL] target updates for v3.18-rc2
Date: Tue, 21 Oct 2014 12:24:59 +0300
Message-ID: <5446266B.4080800@dev.mellanox.co.il>
References: <1413848357.16343.35.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46302 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaJUJZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 05:25:05 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so847270wgg.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2014 02:25:03 -0700 (PDT)
In-Reply-To: <1413848357.16343.35.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 10/21/2014 2:39 AM, Nicholas A. Bellinger wrote:
> Hi Linus,
>
> Here are the target updates for v3.18-rc2 code.  These where originally
> destined for -rc1, but due to the combination of travel last week for
> KVM Forum and my mistake of taking the three week merge window
> literally, the pull request slipped..  Apologies for that.
>
> A heads-up that you'll hit one minor conflict with scsi.git, that was
> caught by sfr in linux-next here:
>
> http://marc.info/?l=linux-next&m=141223868207635&w=2
>
> Please go ahead and pull from:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
>
> Things where reasonably quiet this round.  The highlights include:
>
>    - New userspace backend driver (target_core_user.ko) by Shaohua Li
>      and Andy Grover
>    - A number of cleanups in target, iscsi-taret and qla_target code
>      from Joern Engel
>    - Fix an OOPs related to queue full handling with CHECK_CONDITION
>      status from Quinn Tran
>    - Fix to disable TX completion interrupt coalescing in iser-target,
>      that was causing problems on some hardware
>    - Fix for PR APTPL metadata handling with demo-mode ACLs
>
> I'm most excited about the new backend driver that uses UIO + shared
> memory ring to dispatch I/O and control commands into user-space.  This
> was probably the most requested feature by users over the last couple of
> years, and opens up a new area of development + porting of existing
> user-space storage applications to LIO.  Thanks to Shaohua + Andy for
> making this happen.
>
> Also another honorable mention, a new Xen PV SCSI driver was merged via
> the xen/tip.git tree recently, which puts us now at 10 target drivers in
> upstream!  Thanks to David Vrabel + Juergen Gross for their work to get
> this code merged.
>
> Thank you,
>

Nic,

Why are these fixes are not included?

Target/iser: Fix initiator_depth and responder_resources
Target/iser: Avoid calling rdma_disconnect twice
Target/iser: Don't put isert_conn inside disconnected handler
Target/iser: Get isert_conn reference once got to connected_handler

They are sitting around for some time and  were supposed to make it to
3.17, I don't want these to miss 3.18 too...

Sagi.
