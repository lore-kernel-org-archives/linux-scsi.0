From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/5] target: core: Fix failed command sense data handling
Date: Thu, 06 Jul 2017 22:06:13 -0700
Message-ID: <1499403973.30628.37.camel@haakon3.risingtidesystems.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
         <20170628055900.22889-6-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40325 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdGGFGS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2017 01:06:18 -0400
In-Reply-To: <20170628055900.22889-6-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <mchristi@redhat.com>

(Adding MNC CC')

On Wed, 2017-06-28 at 14:59 +0900, Damien Le Moal wrote:
> For a target device without a transport->transport_complete method
> defined (e.g. target_core_user), target_complete_cmd() will always
> result in a failed command completion being processed through target
> failure completion work even when the command failure comes from the
> target processing and has valid sense data (and hence does not require
> sense data emulation as done in the failure work processing). To ensure
> that the failed command sense data is propagated as indicated by the
> target, make sure that the normal "ok" work completion path is used by
> moving the command SCF_TRANSPORT_TASK_SENSE flag test out of the
> transport_complete defined conditional.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/target/target_core_transport.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Per MNC, skipping this patch in favor of target_complete_cmd() checking
se_cmd->scsi_status:

https://www.spinics.net/lists/target-devel/msg15436.html
