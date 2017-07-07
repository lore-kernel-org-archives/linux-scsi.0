From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/5] target: pscsi: Fix sense data handling
Date: Thu, 06 Jul 2017 22:02:54 -0700
Message-ID: <1499403774.30628.33.camel@haakon3.risingtidesystems.com>
References: <20170628055900.22889-1-damien.lemoal@wdc.com>
         <20170628055900.22889-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170628055900.22889-4-damien.lemoal@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

(Adding MNC CC')

On Wed, 2017-06-28 at 14:58 +0900, Damien Le Moal wrote:
> On completion of a request sent to the target backstore device,
> pscsi_req_done() calls target_complete_cmd() which in turn will execute
> pscsi_transport_complete(). In case of a failed request, this last
> function will copy the target request sense data to the initiator side
> request sense data. However, in pscsi_req_done(), the sense data is
> retreived from the request after calling target_complete_cmd(), which
> result in the sense data always conatining zeroes. Simply fix this by
> copying the sense data before calling target_complete_cmd().
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/target/target_core_pscsi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

As per MNC, skipping this patch as the following has been applied that
makes pscsi_complete_cmd() use the new transport_copy_sense_to_cmd()
helper.

https://www.spinics.net/lists/target-devel/msg15433.html

Please let me know if you run into any issues.
