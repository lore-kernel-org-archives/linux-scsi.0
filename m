From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 04 Jul 2014 14:31:19 +0200
Message-ID: <53B69E97.4050901@acm.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:44237 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaGDMbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 08:31:21 -0400
In-Reply-To: <1404474875-109997-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 07/04/14 13:54, Hannes Reinecke wrote:
> SRP is capable of handling 64bit LUNs, so as we now have proper
> support for it we can modify the driver to use the standard functions.
> 
> Cc: Bart van Assche <bvanassche@acm.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c   |  9 ++--
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 81 +----------------------------------
>  2 files changed, 7 insertions(+), 83 deletions(-)

The SRP initiator and target drivers are independent drivers so this
should be two patches instead of one. Furthermore, I do not agree with
introducing a call to int_to_scsilun() in the hot path of the initiator
driver since that causes a small but unnecessary additional overhead.
Please keep in mind that there is no need to repeat the int_to_scsilun()
conversion for every I/O request. Hence my earlier proposal to cache the
int_to_scsilun() result.

Bart.

