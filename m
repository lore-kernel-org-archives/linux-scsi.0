From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] Fix for hang of Ordered task in TCM
Date: Mon, 23 May 2016 22:47:34 -0700
Message-ID: <1464068854.22249.69.camel@haakon3.risingtidesystems.com>
References: <1463177741-4385-1-git-send-email-mikecyr@linux.vnet.ibm.com>
	 <1463550825.22249.17.camel@haakon3.risingtidesystems.com>
	 <20160523191735.Horde.6wmWQ7EiiPavHDD7pNfVtQ1@ltc.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35085 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbcEXFrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2016 01:47:37 -0400
In-Reply-To: <20160523191735.Horde.6wmWQ7EiiPavHDD7pNfVtQ1@ltc.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryant G Ly <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>, rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org

Hi Bryant,

On Mon, 2016-05-23 at 19:17 -0400, Bryant G Ly wrote:
> Quoting "Nicholas A. Bellinger" <nab@linux-iscsi.org>:
> 
> <SNIP>
> >
> > So AFAICT for delayed commands, the above patch ends up skipping these
> > three checks subsequently when doing __target_execute_cmd() directly
> > from target_restart_delayed_cmds(), no..?
> >
> > After pondering this some more, what about moving these checks into
> > __target_execute_cmd() to handle both target_core_transport.c cases
> > instead..?
> >
> > We'll also need a parameter for internal COMPARE_AND_WRITE usage
> > within compare_and_write_callback(), to bypass checks upon secondary
> > ->execute_cmd() WRITE payload submission after READ + COMPARE has
> > completed successfully.

<SNIP>

> Looks good to me.

Thanks for the review!

> Nick just to let you know I've been working with  
> Mike on VSCSI Target Fabric and we need this patch in kernel 4.4 do
> you know of the process in getting that there?

So pending a bit more list feedback + testing across multiple fabric
drivers, it's been added for the moment to target-pending/queue as post
-rc1 material.

As it merged into target-pending/master next week, the extra stable CC'
can be added to be picked up for linux-4.4.y stable and friends.

Also AFAIK, we've not had reports of other SCSI host environments
triggering this bug, but it's still a good idea to consider it for
linux-3.x.y backport at some point as well.

