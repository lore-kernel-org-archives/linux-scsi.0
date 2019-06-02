From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] scsi: ibmvscsi: Don't use rc uninitialized in ibmvscsi_do_work
Date: Sun, 02 Jun 2019 20:15:38 +1000
Message-ID: <87blzgnvhx.fsf@concordia.ellerman.id.au>
References: <20190531185306.41290-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531185306.41290-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: clang-built-linux@googlegroups.com, Nathan Chancellor <natechancellor@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Nathan,

Nathan Chancellor <natechancellor@gmail.com> writes:
> clang warns:
>
> drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
> uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
>         case IBMVSCSI_HOST_ACTION_NONE:
>              ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ibmvscsi/ibmvscsi.c:2151:6: note: uninitialized use occurs
> here
>         if (rc) {
>             ^~
>
> Initialize rc to zero so that the atomic_set and dev_err statement don't
> trigger for the cases that just break.
>
> Fixes: 035a3c4046b5 ("scsi: ibmvscsi: redo driver work thread to use enum action states")
> Link: https://github.com/ClangBuiltLinux/linux/issues/502
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 727c31dc11a0..6714d8043e62 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -2118,7 +2118,7 @@ static unsigned long ibmvscsi_get_desired_dma(struct vio_dev *vdev)
>  static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
>  {
>  	unsigned long flags;
> -	int rc;
> +	int rc = 0;
>  	char *action = "reset";
>  
>  	spin_lock_irqsave(hostdata->host->host_lock, flags);

It's always preferable IMHO to keep any initialisation as localised as
possible, so that the compiler can continue to warn about uninitialised
usages elsewhere. In this case that would mean doing the rc = 0 in the
switch, something like:

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 727c31dc11a0..7ee5755cf636 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2123,9 +2123,6 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
 
        spin_lock_irqsave(hostdata->host->host_lock, flags);
        switch (hostdata->action) {
-       case IBMVSCSI_HOST_ACTION_NONE:
-       case IBMVSCSI_HOST_ACTION_UNBLOCK:
-               break;
        case IBMVSCSI_HOST_ACTION_RESET:
                spin_unlock_irqrestore(hostdata->host->host_lock, flags);
                rc = ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
@@ -2142,7 +2139,10 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data *hostdata)
                if (!rc)
                        rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
                break;
+       case IBMVSCSI_HOST_ACTION_NONE:
+       case IBMVSCSI_HOST_ACTION_UNBLOCK:
        default:
+               rc = 0;
                break;
        }


But then that makes me wonder if that's actually correct?

If we get an action that we don't recognise should we just throw it away
like that? (by doing hostdata->action = IBMVSCSI_HOST_ACTION_NONE). Tyrel?

cheers
