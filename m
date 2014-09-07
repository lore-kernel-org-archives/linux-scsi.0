From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/1] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu
Date: Sun, 07 Sep 2014 15:42:47 +0300
Message-ID: <540C52C7.6030907@dev.mellanox.co.il>
References: <1409720439-6226-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51830 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaIGMmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 08:42:51 -0400
Received: by mail-wi0-f181.google.com with SMTP id e4so1379283wiv.2
        for <linux-scsi@vger.kernel.org>; Sun, 07 Sep 2014 05:42:50 -0700 (PDT)
In-Reply-To: <1409720439-6226-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 9/3/2014 8:00 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> This patches fixes a potential buffer overrun in __iscsi_conn_send_pdu.
> This function is used by iscsi drivers and userspace to send iscsi PDUs/
> commands. For login commands, we have a set buffer size. For all other
> commands we do not support data buffers.
>
> This was reported by Dan Carpenter here:
> http://www.spinics.net/lists/linux-scsi/msg66838.html
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/libiscsi.c |   10 ++++++++++
>   1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ea025e4..191b597 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -717,11 +717,21 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   			return NULL;
>   		}
>
> +		if (data_size > ISCSI_DEF_MAX_RECV_SEG_LEN) {
> +			iscsi_conn_printk(KERN_ERR, conn, "Invalid buffer len of %u for login task. Max len is %u\n", data_size, ISCSI_DEF_MAX_RECV_SEG_LEN);
> +			return NULL;
> +		}
> +
>   		task = conn->login_task;
>   	} else {
>   		if (session->state != ISCSI_STATE_LOGGED_IN)
>   			return NULL;
>
> +		if (data_size != 0) {
> +			iscsi_conn_printk(KERN_ERR, conn, "Can not send data buffer of len %u for op 0x%x\n", data_size, opcode);
> +			return NULL;
> +		}
> +
>   		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
>   		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
>
>

Looks good to me too,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
