From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5 2/3] virtio-scsi: add error handling
Date: Mon, 19 Mar 2012 12:07:25 +0100
Message-ID: <4F67136D.7080500@redhat.com>
References: <1328440562-19425-1-git-send-email-pbonzini@redhat.com> <1328440562-19425-3-git-send-email-pbonzini@redhat.com> <20120319095529.GA25623@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab2CSLHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2012 07:07:48 -0400
In-Reply-To: <20120319095529.GA25623@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Pekka Enberg <penberg@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org

Il 19/03/2012 10:55, Hu Tao ha scritto:
> +	int ret = FAILED;
>  
>  	cmd->comp = &comp;
>  	ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
>  			       sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
>  			       GFP_NOIO);
>  	if (ret < 0)
> -		return FAILED;
> +		goto failed;

This will return the errno, not FAILED.

I have already fixed this up locally, though I've been lazy on actually
sending out the fix.  I'll do this today.

Paolo

>  	wait_for_completion(&comp);
> -	if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
> -	    cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> -		return FAILED;
> +	if (cmd->resp.tmf.response == VIRTIO_SCSI_S_OK ||
> +	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
> +		ret = SUCCESS;
>  
> -	return SUCCESS;
> +failed:
> +	mempool_free(cmd, virtscsi_cmd_pool);
> +	return ret;

