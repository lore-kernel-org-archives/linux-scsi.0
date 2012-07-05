From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] tcm_vhost: Fix tv_cmd completion -> release SGL memory
 leak
Date: Thu, 05 Jul 2012 13:24:16 +0800
Message-ID: <1341465859.20287.66.camel@f15.cn.ibm.com>
References: <1341461663-13434-1-git-send-email-nab@linux-iscsi.org>
Reply-To: wuzhy@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:43520 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2GEFZB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2012 01:25:01 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wuzhy@linux.vnet.ibm.com>;
	Wed, 4 Jul 2012 23:25:00 -0600
In-Reply-To: <1341461663-13434-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>

On Thu, 2012-07-05 at 04:14 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> The SGL memory allocated during vhost_scsi_map_iov_to_sgl() setup was never
> getting freed during tv_cmd completion -> release path.  Fix this up by releasing
> tv_cmd->tvc_sgl in vhost_scsi_free_cmd() ahead of tv_cmd descriptor free.
> 
> Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/vhost/tcm_vhost.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/vhost/tcm_vhost.c b/drivers/vhost/tcm_vhost.c
> index cd86633..9692153 100644
> --- a/drivers/vhost/tcm_vhost.c
> +++ b/drivers/vhost/tcm_vhost.c
> @@ -387,6 +387,8 @@ static void vhost_scsi_free_cmd(struct tcm_vhost_cmd *tv_cmd)
>  		u32 i;
>  		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
>  			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
> +
> +		kfree(tv_cmd->tvc_sgl);
>  	}
> 
>  	kfree(tv_cmd);

Reviewed-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

-- 
Regards,

Zhi Yong Wu

