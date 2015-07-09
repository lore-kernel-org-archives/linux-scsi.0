From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1] libiscsi: Fix iscsi_check_transport_timeouts possible
 infinite loop
Date: Thu, 9 Jul 2015 14:35:36 +0300
Message-ID: <559E5C88.2060807@dev.mellanox.co.il>
References: <1436008133-20226-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33670 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbGILfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 07:35:25 -0400
Received: by wiwl6 with SMTP id l6so15878702wiw.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2015 04:35:24 -0700 (PDT)
In-Reply-To: <1436008133-20226-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ariel Nahum <arieln@mellanox.com>


Ping?

> From: Ariel Nahum <arieln@mellanox.com>
>
> Connection last_ping is not being updated when iscsi_send_nopout fails.
> Not updating the last_ping will cause firing a timer to a past time
> (last_ping + ping_tmo < current_time) which triggers an infinite loop of
> iscsi_check_transport_timeouts() and hogs the cpu.
>
> Fix this issue by checking the return value of iscsi_send_nopout.
> If it fails set the next_timeout to one second later.
>
> Signed-off-by: Ariel Nahum <arieln@mellanox.com>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
> Changes from v0:
> - Fixed coding style comment
>
>   drivers/scsi/libiscsi.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 8053f24..29c02b8 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -979,13 +979,13 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>   	wake_up(&conn->ehwait);
>   }
>
> -static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
> +static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>   {
>           struct iscsi_nopout hdr;
>   	struct iscsi_task *task;
>
>   	if (!rhdr && conn->ping_task)
> -		return;
> +		return -EINVAL;
>
>   	memset(&hdr, 0, sizeof(struct iscsi_nopout));
>   	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
> @@ -999,13 +999,16 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>   		hdr.ttt = RESERVED_ITT;
>
>   	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
> -	if (!task)
> +	if (!task) {
>   		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
> -	else if (!rhdr) {
> +		return -EIO;
> +	} else if (!rhdr) {
>   		/* only track our nops */
>   		conn->ping_task = task;
>   		conn->last_ping = jiffies;
>   	}
> +
> +	return 0;
>   }
>
>   static int iscsi_nop_out_rsp(struct iscsi_task *task,
> @@ -2095,8 +2098,10 @@ static void iscsi_check_transport_timeouts(unsigned long data)
>   	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
>   		/* send a ping to try to provoke some traffic */
>   		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
> -		iscsi_send_nopout(conn, NULL);
> -		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
> +		if (iscsi_send_nopout(conn, NULL))
> +			next_timeout = jiffies + (1 * HZ);
> +		else
> +			next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
>   	} else
>   		next_timeout = last_recv + recv_timeout;
>
>

