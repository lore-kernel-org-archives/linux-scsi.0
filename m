From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Don't change direction flags in struct request.
Date: Fri, 12 Mar 2010 16:04:52 -0600
Message-ID: <4B9ABA84.9020801@cs.wisc.edu>
References: <1268976690-3386-1-git-send-email-hdasch@broadcom.com> <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000804010505080801010901"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1268976690-3386-2-git-send-email-hdasch@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, Eddie Williams <Eddie.Williams@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000804010505080801010901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/19/2010 12:31 AM, Hugh Daschbach wrote:
> The EMC multipath device handler should not change the I/O direction
> flags of its trespass command request.
>
> The CFQ elevator may BUG if the direction flags on an I/O request are
> changed after allocation.  cfq_set_request() and cfq_put_request()
> count READ and WRITE requests separately.  Changing the I/O request
> direction after blk_get_request() allocates the request throws off
> this CFQ accounting.
>
> Signed-off-by: Hugh Daschbach<hdasch@broadcom.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_emc.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 6196675..3709342 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -269,10 +269,12 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>   				unsigned char *buffer)
>   {
>   	struct request *rq;
> +	int mode = READ;
>   	int len = 0;
>
> -	rq = blk_get_request(sdev->request_queue,
> -			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
> +	if (cmd == MODE_SELECT || cmd == MODE_SELECT_10)
> +		mode = WRITE;
> +	rq = blk_get_request(sdev->request_queue, mode, GFP_NOIO);
>   	if (!rq) {
>   		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
>   		return NULL;
> @@ -284,12 +286,10 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>   	switch (cmd) {
>   	case MODE_SELECT:
>   		len = sizeof(short_trespass);
> -		rq->cmd_flags |= REQ_RW;
>   		rq->cmd[1] = 0x10;
>   		break;
>   	case MODE_SELECT_10:
>   		len = sizeof(long_trespass);
> -		rq->cmd_flags |= REQ_RW;
>   		rq->cmd[1] = 0x10;
>   		break;
>   	case INQUIRY:

Did you try the patch I linked to the last time you posted about this?

I think there should be a patch which fixes this problem here:
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=6c71dcb28ff9b63b814a0b76a256f5dae08d3e0d;hp=3a5b27bf6f29574d667230c7e76e4b83fe3014e0
I think it got into 2.6.34-rc1.

With that patch mode selects should get set up as writes.

Does it work? If it does then I think we just need the attached cleanup 
patch which removes the cmd_flags setting. The patch that got merged 
fixed the problem of initializing the request properly, but it forgot to 
remove the cmd_flags setting.

--------------000804010505080801010901
Content-Type: text/plain;
 name="emc-cleanup-cmd-flags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="emc-cleanup-cmd-flags.patch"

blk_get_request sets the cmd_flags, so we should not and do not
need to set them. If we did set them to a different value then
it can cause a oops in the elevator code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 63032ec..2752892 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -284,13 +284,11 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 	switch (cmd) {
 	case MODE_SELECT:
 		len = sizeof(short_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		rq->cmd[4] = len;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		rq->cmd[8] = len;
 		break;

--------------000804010505080801010901--
