From: Arvind Kumar <arvindkumar@vmware.com>
Subject: RE: [PATCH] vmw_pvscsi: fixup tagging
Date: Fri, 17 Oct 2014 18:34:48 +0000
Message-ID: <41c186a1dcd04732a87f8bc47336a5d7@EX13-MBX-025.vmware.com>
References: <1412234501-78199-1-git-send-email-hare@suse.de>,<20141017131651.GD16538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:37784 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbaJQSfI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2014 14:35:08 -0400
In-Reply-To: <20141017131651.GD16538@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: "pv-drivers@vmware.com" <pv-drivers@vmware.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Christoph,

Thanks for the change. Sorry for the delay. The change looks fine to me. I just have a question.

The comment in include/scsi/scsi_cmnd.h says:

struct scsi_cmnd {
...
             unsigned char tag; /* SCSI-II queued command tag */
}

Is that comment not right? Should we update that too?

Thanks!
Arvind
________________________________________
From: Christoph Hellwig <hch@infradead.org>
Sent: Friday, October 17, 2014 6:16 AM
To: Hannes Reinecke
Cc: Arvind Kumar; pv-drivers@vmware.com; James Bottomley; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] vmw_pvscsi: fixup tagging

Can I get a review from VMWare for this one, please?

On Thu, Oct 02, 2014 at 09:21:41AM +0200, Hannes Reinecke wrote:
> The request (and SCSI command) tag is the tag number assigned
> by the generic block-tagging code, not the SCSI-II tag messages.
> Those are represented by the device flags 'tagged_supported',
> 'simple_tags', and 'ordered_tags'.
> (The SCSI midlayer doesn't use HEAD_OF_QUEUE tags).
> So fixup vmw_pvscsi to assign the correct tag type.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/vmw_pvscsi.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 598f65e..d18df8c 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -724,9 +724,8 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
>
>       e->tag = SIMPLE_QUEUE_TAG;
>       if (sdev->tagged_supported &&
> -         (cmd->tag == HEAD_OF_QUEUE_TAG ||
> -          cmd->tag == ORDERED_QUEUE_TAG))
> -             e->tag = cmd->tag;
> +         sdev->ordered_tags)
> +             e->tag = ORDERED_QUEUE_TAG;
>
>       if (cmd->sc_data_direction == DMA_FROM_DEVICE)
>               e->flags = PVSCSI_FLAG_CMD_DIR_TOHOST;
> --
> 1.8.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v1/url?u=http://vger.kernel.org/majordomo-info.html&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=5bh61bBshOhAkuAAXcD9BERI%2F4iK5qLrSSxbaPeaJh4%3D%0A&m=3T3CxXvbfPAK%2FDIE7aWB7MFmojVqfTOyoVs1VP7639M%3D%0A&s=97965a758f2187327667f0a727748779fd8dcdd81eb2da9d33f694fe7893e5d3
---end quoted text---
