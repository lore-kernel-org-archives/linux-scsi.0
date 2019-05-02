From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ibmvscsi: redo driver work thread to use enum action
 states
Date: Thu, 2 May 2019 16:43:23 -0500
Message-ID: <5515ab01-f2d4-d925-76ff-7fa8416b86f8@linux.vnet.ibm.com>
References: <20190502004729.19962-1-tyreld@linux.ibm.com>
 <20190502004729.19962-2-tyreld@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20190502004729.19962-2-tyreld@linux.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Tyrel Datwyler <tyreld@linux.ibm.com>, james.bottomley@hansenpartnership.com
Cc: brking@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 5/1/19 7:47 PM, Tyrel Datwyler wrote:
> From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> 
> The current implemenation relies on two flags in the drivers private host
> structure to signal the need for a host reset or to reenable the CRQ after a
> LPAR migration. This patch does away with those flags and introduces a single
> action flag and defined enums for the supported kthread work actions. Lastly,
> the if/else logic is replaced with a switch statement.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 57 +++++++++++++++++++++-----------
>  drivers/scsi/ibmvscsi/ibmvscsi.h |  9 +++--
>  2 files changed, 45 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 1c37244f16a0..683139e6c63f 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -828,7 +828,7 @@ static void ibmvscsi_reset_host(struct ibmvscsi_host_data *hostdata)
>  	atomic_set(&hostdata->request_limit, 0);
>  
>  	purge_requests(hostdata, DID_ERROR);
> -	hostdata->reset_crq = 1;
> +	hostdata->action = IBMVSCSI_HOST_ACTION_RESET;
>  	wake_up(&hostdata->work_wait_q);
>  }
>  
> @@ -1797,7 +1797,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>  			/* We need to re-setup the interpartition connection */
>  			dev_info(hostdata->dev, "Re-enabling adapter!\n");
>  			hostdata->client_migrated = 1;
> -			hostdata->reenable_crq = 1;
> +			hostdata->action = IBMVSCSI_HOST_ACTION_REENABLE;
>  			purge_requests(hostdata, DID_REQUEUE);
>  			wake_up(&hostdata->work_wait_q);
>  		} else {
> @@ -2118,26 +2118,32 @@ static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
>  
>  static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
>  {
> +	unsigned long flags;
>  	int rc;
>  	char *action = "reset";
>  
> -	if (hostdata->reset_crq) {
> -		smp_rmb();
> -		hostdata->reset_crq = 0;
> -
> +	spin_lock_irqsave(hostdata->host->host_lock, flags);
> +	switch (hostdata->action) {
> +	case IBMVSCSI_HOST_ACTION_NONE:
> +		break;
> +	case IBMVSCSI_HOST_ACTION_RESET:
>  		rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);

Looks like you are now calling ibmvscsi_reset_crq_queue with the host_lock held.
However, ibmvscsi_reset_crq_queue can call msleep.

This had been implemented as separate reset_crq and reenable_crq fields
so that it could run lockless. I'm not opposed to changing this to a single
field in general, we just need to be careful where we are adding locking.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
