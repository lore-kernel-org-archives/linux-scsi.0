From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 0/2] tcm_fc: Generate TASK_SET_FULL for DataIN +
 response failures
Date: Fri, 06 Jun 2014 13:38:41 -0700
Message-ID: <1402087121.5752.91.camel@vi-devel>
References: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402011002-20771-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, fcoe-devel <fcoe-devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-06-05 at 23:30 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi Vasu,
> 
> This series generates SAM_STAT_TASK_SET_FULL status for lport->tt.seq_send()
> failures in DataIN + response status codepaths, which is done in order to get
> the initiator to reduce it's current queue_depth thus reducing the number of
> outstanding I/Os permitted in flight on the wire.
> 
> For the DataIN case, once a lport->tt.seq_send() failure occurs it will stop
> attempting to send subsequent DataIN payload data, and immediately attempt to
> send a response packet with SAM_STAT_TASK_SET_FULL status.
> 
> For the response case, once a lport->tt.seq_send() failure occurs it will
> set SAM_STAT_TASK_SET_FULL status and return -ENOMEM to the target, forcing
> the response to be requeued by target-core
> 

Good change and it was missing in tcm_fc.

> Note this series has been compile tested only, so please review + test.

Just did review and basic test but should be stressed to really ensure
it does work & fixes issues resulting these patches.

Thanks,
Vasu

> Thank you,
> 
> --nab
> 
> Nicholas Bellinger (2):
>   tcm_fc: Generate TASK_SET_FULL status for DataIN failures
>   tcm_fc: Generate TASK_SET_FULL status for response failures
> 
>  drivers/target/tcm_fc/tfc_cmd.c |   19 ++++++++++++++++---
>  drivers/target/tcm_fc/tfc_io.c  |   14 +++++++++++++-
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
