From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi:Make the variable rc to be a integer in the
 function ibmvfc_handle_crq
Date: Fri, 17 Jul 2015 14:09:48 -0700
Message-ID: <55A96F1C.3060204@linux.vnet.ibm.com>
References: <1436472607-31765-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436472607-31765-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/09/2015 01:10 PM, Nicholas Krause wrote:
> This makes the variable rc to be a integer in the function
> ibmvfc_handle_crq due to this function's value never being
> greater then a standard C sized integer. In addition due to
> this make the printk statement that prints this variable out
> if the call to ibmvfc_sen_crq_init_complete fails to use the
> string format %d rather then %ld in other to avoid build
> warnings due to the variable rc having a change in type from
> long to int now.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Again, the wording is a little difficult and much too verbose for such a
trivial change. You really don't need to explain the change of printk
conversion specifier as it is obvious and implied by the patch itself.
Something like the following would be better:

"ibmvscsi: change type of rc to int in ibmvfc_handle_crq

Change type of rc variable in ibmvfc_handle_crq() to match return type
of ibmvfc_send_crq_init_complete()."

Otherwise,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>


> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 057d277..a33e2af 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2720,7 +2720,7 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
>   **/
>  static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
>  {
> -	long rc;
> +	int rc;
>  	struct ibmvfc_event *evt = (struct ibmvfc_event *)be64_to_cpu(crq->ioba);
> 
>  	switch (crq->valid) {
> @@ -2733,7 +2733,7 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost)
>  			if (rc == 0)
>  				ibmvfc_init_host(vhost);
>  			else
> -				dev_err(vhost->dev, "Unable to send init rsp. rc=%ld\n", rc);
> +				dev_err(vhost->dev, "Unable to send init rsp. rc=%d\n", rc);
>  			break;
>  		case IBMVFC_CRQ_INIT_COMPLETE:
>  			dev_info(vhost->dev, "Partner initialization complete\n");
> 
