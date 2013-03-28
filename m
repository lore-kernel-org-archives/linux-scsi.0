From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [patch] scsi_dh_hp_sw.c: return DEV_OFFLINED when
 blk_get_request fails
Date: Thu, 28 Mar 2013 17:52:47 -0400
Message-ID: <20130328175247.1f164783@jlaw-desktop.mno.stratus.com>
References: <x49y5d7xqv7.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:47337 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3C1V4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Mar 2013 17:56:31 -0400
In-Reply-To: <x49y5d7xqv7.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 28 Mar 2013 15:32:12 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> If blk_get_requet fails here, it means that the queue is dead.  It
> seems better to return a DEV_OFFLINED error code than the misleading
> TEMP_UNAVAIL.  Comments?
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> b/drivers/scsi/device_handler/scsi_dh_hp_sw.c index 084062b..eec24d3
> 100644 --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -118,7 +118,7 @@ static int hp_sw_tur(struct scsi_device *sdev,
> struct hp_sw_dh_data *h) retry:
>  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
>  	if (!req)
> -		return SCSI_DH_RES_TEMP_UNAVAIL;
> +		return SCSI_DH_DEV_OFFLINED;
>  
>  	req->cmd_type = REQ_TYPE_BLOCK_PC;
>  	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |

Hi Jeff,

How about hp_sw_start_stop?  It calls blk_get_request with GFP_ATOMIC,
so it might see !req for dead queue or no memory.

-- Joe
