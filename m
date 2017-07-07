From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/5] target: user: Fix sense data handling
Date: Thu, 06 Jul 2017 22:04:55 -0700
Message-ID: <1499403895.30628.35.camel@haakon3.risingtidesystems.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
         <20170628055900.22889-5-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170628055900.22889-5-damien.lemoal@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

(Adding MNC CC')

On Wed, 2017-06-28 at 14:58 +0900, Damien Le Moal wrote:
> If the user request handler completed the request with a CHECK CONDITION
> status, tcmu_handle_completion() copies the command entry sense data
> into the session request structure sense data. However, the sense data
> length indicated by the field scsi_sense_length is not set and equal to
> 0, resulting in the copy being a no-op and failure to propagate the
> sense data back to the initiator. To fix this, properly set the session
> command sense data length and also set the session command
> SCF_TRANSPORT_TASK_SENSE flag to indicate that the command has valid
> sense data.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/target/target_core_user.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Per MNC, skipping this patch in favor of tcmu_handle_completion() using
the new transport_copy_sense_to_cmd() helper.

https://www.spinics.net/lists/target-devel/msg15435.html
