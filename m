From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Isn't sd_major() broken ?
Date: Thu, 10 Apr 2003 16:39:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304102039.h3AKdYC31797@devserv.devel.redhat.com>
References: <mailman.1049998202.18407.linux-kernel2news@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.200]:24851 "EHLO
	devserv.devel.redhat.com") by vger.kernel.org with ESMTP
	id S264144AbTDJU14 (for <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2003 16:27:56 -0400
In-Reply-To: <mailman.1049998202.18407.linux-kernel2news@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> --- drivers/scsi/sd.c.org	Wed Apr  9 13:12:38 2003
> +++ drivers/scsi/sd.c	Thu Apr 10 11:01:45 2003
> @@ -123,7 +123,7 @@ static int sd_major(int major_idx)
>  	case 1 ... 7:
>  		return SCSI_DISK1_MAJOR + major_idx - 1;
>  	case 8 ... 15:
> -		return SCSI_DISK8_MAJOR + major_idx;
> +		return SCSI_DISK8_MAJOR + major_idx - 8;
>  	default:
>  		BUG();
>  		return 0;	/* shut up gcc */
> 

Yes this seems good.

One is left to wonder, however, why 2.5 version is not using
a little array of majors here.

-- Pete
