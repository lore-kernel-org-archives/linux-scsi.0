From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH v2 11/14] BNX2I: Added feature to silently drop NOPOUT
 request
Date: Mon, 22 Nov 2010 11:42:43 -0600
Message-ID: <4CEAAB93.7040103@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1290130209-32133-12-git-send-email-eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRC006rnBBoEqqqYxA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1290130209-32133-12-git-send-email-eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/18/2010 07:30 PM, Eddie Wai wrote:
> In the case the chip is undergoing different invasive operation
> which requires a chip reset, all NOPOUT request during this period
> must be silently dropped from queuing to the hardware.  This patch
> will respond to libiscsi immediately with sent success.  Since the
> request was not actually sent, the NOPIN wait timeout will get
> triggered and another NOPOUT request will commence through the
> proper channel.
>
> Signed-off-by: Eddie Wai<eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Acked-by: Anil Veerabhadrappa<anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |   16 ++++++++++++++++
>   1 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index f622e89..5e8dff9 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1068,6 +1068,22 @@ static int bnx2i_iscsi_send_generic_request(struct iscsi_task *task)
>   	char *buf;
>   	int data_len;
>
> +	/*
> +	 * Forcefully terminate all in progress connection recovery at the
> +	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
> +	 */
> +	if (bnx2i_adapter_ready(bnx2i_conn->ep->hba)) {
> +		if ((task->hdr->opcode&  ISCSI_OPCODE_MASK) ==
> +		    ISCSI_OP_NOOP_OUT)
> +			/* This is a WA to indicate to libiscsi that the nopout
> +			 * request was sent successfully without actually
> +			 * submitting to the hardware.
> +			 * Just silently drop the nopout request
> +			 */
> +			return 0;

I'd like to just have libiscsi handle a error code here instead of 
hacking around its lack of eh handling.


> +		else
> +			return -EIO;
> +	}
>   	bnx2i_iscsi_prep_generic_pdu_bd(bnx2i_conn);
>   	switch (task->hdr->opcode&  ISCSI_OPCODE_MASK) {
>   	case ISCSI_OP_LOGIN:

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
