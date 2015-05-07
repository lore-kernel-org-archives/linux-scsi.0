From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 03/17] scsi_dh_alua: Use vpd_pg83 information
Date: Thu, 7 May 2015 13:41:55 +0200
Message-ID: <554B4F83.8020308@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:12736
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753268AbbEGLmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:42:04 -0400
In-Reply-To: <1430743343-47174-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> -/*
>    * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>    * @sdev: sdev the command should be sent to
>    */
> @@ -352,55 +315,42 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>   		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
>   			    ALUA_DH_NAME);
>   		break;
> -	default:
> -		h->tpgs = TPGS_MODE_NONE;
> +	case TPGS_MODE_NONE:
>   		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
>   			    ALUA_DH_NAME);
>   		err = SCSI_DH_DEV_UNSUPP;
>   		break;
> +	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: unsupported TPGS setting %d\n",
> +			    ALUA_DH_NAME, h->tpgs);
> +		h->tpgs = TPGS_MODE_NONE;
> +		err = SCSI_DH_DEV_UNSUPP;
> +		break;
>   	}
>
>   	return err;
>   }

The function scsi_device_tpgs() returns a value between 0 and 3. So why 
to add a fifth case in this switch statement ?

Bart.
