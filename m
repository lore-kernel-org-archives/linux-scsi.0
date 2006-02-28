From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix scsi process problems and clean up the target reap
	issues
Date: Tue, 28 Feb 2006 11:39:04 -0600
Message-ID: <1141148345.3258.24.camel@mulgrave.il.steeleye.com>
References: <1140726438.2809.18.camel@localhost.localdomain>
	 <20060228172436.GA1456@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:65234 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751071AbWB1RjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 12:39:08 -0500
In-Reply-To: <20060228172436.GA1456@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-02-28 at 09:24 -0800, Mike Anderson wrote:
> The patch was tried on the aic7xxx ahc_linux_target_alloc issue I
> previously mentioned and it did not change the result of a BUG_ON.

Hmm ... could you repost the panic ... I also put in Brian King's check
for device_add failure, which should have picked this up ... it sounds
like there's something else going on.

> Is there some reason we cannot do the list_del_init(&starget->siblings) in
> scsi_target_dev_release post calling target_destroy? It would appear with
> the check for STARGET_DEL that being on the list longer should not be a
> problem.

No, it shouldn't ... it just potentially delays the allocation to wait
for everything to finish using the old target ... we might have to put a
reschedule in the retry loop in alloc to avoid a busy wait.

Does that fix your aic problem?

James


