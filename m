From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 10/12] IB/srp: Remove !ch->target tests from the reconnect
 code
Date: Thu, 30 Apr 2015 13:19:37 +0300
Message-ID: <554201B9.8040308@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EF62.8050107@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36465 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbD3KTm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 06:19:42 -0400
Received: by wgen6 with SMTP id n6so56840549wge.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2015 03:19:41 -0700 (PDT)
In-Reply-To: <5541EF62.8050107@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 4/30/2015 12:01 PM, Bart Van Assche wrote:
> Remove the !ch->target tests from the reconnect code. These
> tests are not needed: upon entry of srp_rport_reconnect()
> it is guaranteed that all ch->target pointers are non-NULL.
> None of the functions srp_new_cm_id(), srp_finish_req(),
> srp_create_ch_ib() nor srp_connect_ch() modifies this pointer.
> srp_free_ch_ib() is never called concurrently with
> srp_rport_reconnect().
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 6 ------
>   1 file changed, 6 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index a73eb1e5..400ef7a 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1216,14 +1216,10 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>   	 */
>   	for (i = 0; i < target->ch_count; i++) {
>   		ch = &target->ch[i];
> -		if (!ch->target)
> -			break;
>   		ret += srp_new_cm_id(ch);
>   	}
>   	for (i = 0; i < target->ch_count; i++) {
>   		ch = &target->ch[i];
> -		if (!ch->target)
> -			break;
>   		for (j = 0; j < target->req_ring_size; ++j) {
>   			struct srp_request *req = &ch->req_ring[j];
>
> @@ -1232,8 +1228,6 @@ static int srp_rport_reconnect(struct srp_rport *rport)
>   	}
>   	for (i = 0; i < target->ch_count; i++) {
>   		ch = &target->ch[i];
> -		if (!ch->target)
> -			break;
>   		/*
>   		 * Whether or not creating a new CM ID succeeded, create a new
>   		 * QP. This guarantees that all completion callback function
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
