From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv7 20/23] scsi: Add 'access_state' attribute
Date: Thu, 18 Feb 2016 14:06:17 -0800
Message-ID: <56C64059.8060604@sandisk.com>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
 <1455524690-121073-21-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0074.outbound.protection.outlook.com ([207.46.100.74]:52421
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423513AbcBRWGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 17:06:43 -0500
In-Reply-To: <1455524690-121073-21-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 02/15/2016 12:24 AM, Hannes Reinecke wrote:
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -277,5 +277,17 @@ struct scsi_lun {
>   	__u8 scsi_lun[8];
>   };
>
> +/* SPC asymmetric access states */
> +#define SCSI_ACCESS_STATE_OPTIMAL     0x00
> +#define SCSI_ACCESS_STATE_ACTIVE      0x01
> +#define SCSI_ACCESS_STATE_STANDBY     0x02
> +#define SCSI_ACCESS_STATE_UNAVAILABLE 0x03
> +#define SCSI_ACCESS_STATE_LBA         0x04
> +#define SCSI_ACCESS_STATE_OFFLINE     0x0e
> +#define SCSI_ACCESS_STATE_TRANSITIONING 0x0f
> +
> +#define SCSI_ACCESS_STATE_MASK        0x0f
> +#define SCSI_ACCESS_STATE_PREFERRED   0x80
> +#define SCSI_ACCESS_STATE_UNKNOWN     0x70

Please mention in the comment above these constants that the ALUA state 
values apply to both the RTPG and STPG commands but that the PREFERRED 
bit only applies to the RTPG command.

All constants in scsi_proto.h come from a SCSI standard. However, this 
patch adds a constant that does not come from a SCSI standard 
(SCSI_ACCESS_STATE_UNKNOWN). Please remove this constant entirely 
because it causes confusion. sdev_show_access_state() only interprets 
the PREFERRED bit and the lower 4 bits of the access_state member 
variable. This means that the SCSI_ACCESS_STATE_UNKNOWN entry in 
sdev_access_states[] is never used and hence should be left out. This 
also means that the "sdev->access_state = SCSI_ACCESS_STATE_UNKNOWN" 
assignment in scsi_scan.c is equivalent to "sdev->access_state = 
SCSI_ACCESS_STATE_OPTIMAL".

Bart.
