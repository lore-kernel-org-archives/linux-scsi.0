From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 12:52:11 +0400
Message-ID: <1343292731.3115.17.camel@dabdike>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
	 <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 18:05 +0200, Paolo Bonzini wrote:
> Hotplug/hot-unplug of a LUN whose number is greater than 255
> uses the "flat" format for LUNs, which has bit 14 set.  Clear
> the bit when parsing the event structs.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |    8 ++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c7030fb..c937232 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -252,13 +252,19 @@ static void virtscsi_cancel_event_work(struct virtio_scsi *vscsi)
>  		cancel_work_sync(&vscsi->event_list[i].work);
>  }
>  
> +static unsigned int virtscsi_get_lun(u8 *lun_bytes)
> +{
> +	unsigned int lun = (lun_bytes[2] << 8) | lun_bytes[3];
> +	return lun & 16383;
> +}
> +

Why are you rolling your own incomplete version of scsilun_to_int here?

James
