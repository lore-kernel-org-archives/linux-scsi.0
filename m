From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 15/16] qla2xxx: Add bulk send for atio & ctio
 completion paths.
Date: Sun, 20 Dec 2015 23:13:53 -0800
Message-ID: <1450682033.25674.44.camel@haakon3.risingtidesystems.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1450382231-4259-16-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34178 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbLUHNz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 02:13:55 -0500
In-Reply-To: <1450382231-4259-16-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 2015-12-17 at 14:57 -0500, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
> 
> At high traffic, the work queue can become a bottle neck.
> Instead of putting each command on the work queue as 1 work
> element, the fix would daisy chain a list of commands that came
> from FW/interrupt under 1 work element to reduce lock contention.
> 

I'm wondering if we are better served by turning this into generic logic
in kernel/workqueue.c to be used beyond qla2xxx, or:

using WQ_UNBOUND (following iser-target) and verify if observed
bottleneck is due to internal !(WQ_UNBOUND) usage in qla_target.c.

Out of curiosity, what level of performance improvement does this
patch (as is) actually provide..?

Thank you,

--nab

