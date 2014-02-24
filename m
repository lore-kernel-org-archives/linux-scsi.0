From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] vhost/scsi: Check LUN structure byte 0 is set to 1, per
 spec
Date: Mon, 24 Feb 2014 17:27:39 -0500 (EST)
Message-ID: <1662106574.8578383.1393280859359.JavaMail.zimbra@redhat.com>
References: <20140224221332.GA32725@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140224221332.GA32725@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

> The virtio spec requires byte 0 of the virtio-scsi LUN structure
> to be '1'.
> 
> Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
> ---
>   drivers/vhost/scsi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 0a025b8..e48d4a6 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1001,6 +1001,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct
> vhost_virtqueue *vq)
>   			break;
>   		}
>   
> +		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
> +		if (unlikely(v_req.lun[0] != 1)) {
> +			vhost_scsi_send_bad_target(vs, vq, head, out);
> +			continue;
> +		}
> +
>   		/* Extract the tpgt */
>   		target = v_req.lun[1];
>   		tpg = ACCESS_ONCE(vs_tpg[target]);
> --
> 1.8.5.3
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
