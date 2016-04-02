From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/2] scsi: Add intermediate STARGET_REMOVE state to
 scsi_target_state
Date: Sat, 02 Apr 2016 09:36:20 -0700
Message-ID: <1459614980.2306.5.camel@linux.vnet.ibm.com>
References: <cover.1459428540.git.jthumshirn@suse.de>
	 <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459428540.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42390 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbcDBQg2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2016 12:36:28 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Sat, 2 Apr 2016 10:36:28 -0600
In-Reply-To: <95ae7ee32dca23bb7f3ab432046fb7016b341049.1459428540.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2016-03-31 at 14:53 +0200, Johannes Thumshirn wrote:
> Add intermediate STARGET_REMOVE state to scsi_target_state to avoid
> running
> into the BUG_ON() in scsi_target_reap().
> 
> This intermediate state is only valid in the path from
> scsi_remove_target() to
> scsi_target_destroy() indicating this target is going to be removed.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38

The code and ordering is fine with me, so you can add

Reviewed-by: James Bottomley <jejb@linux.vnet.ibm.com>

However, I'd really appreciate it if the description of what was going
on was clearer for a non-SUSE distro maintainer.  What we're doing is
applying a more comprehensive fix for a previously hack fixed problem
and then reverting the hack.  I think message 1 should say "this
refixes the problem introduced by commit X in a more comprehensive way"

and message 2 "Now that we've done a more comprehensive fix with the
intermediate target state in patch Y, we can remove the previous hack"

James


