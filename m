From: Luben Tuikov <tluben@rogers.com>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Wed, 21 May 2003 15:18:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ECBD122.3090702@rogers.com>
References: <3ECA9D46.7010301@rogers.com> <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org> <20030521180308.GD1116@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-mail.bloor.is.net.cable.rogers.com ([66.185.86.72]:58992
	"EHLO fep02-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262278AbTEUTF6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2003 15:05:58 -0400
In-Reply-To: <20030521180308.GD1116@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> 
> DESC
> This patch is against scsi-misc-2.5 but also applies against 2.5.69.
> 
> Move scsi command serial number to per scsi host serial number. We also
> only increment the serial number under a lock now so the race on the value
> is removed. A new serial number is also acquired in the scsi_error handler
> on new commands.
> EDESC
> 
> 
>  drivers/scsi/hosts.h      |    7 +++++++
>  drivers/scsi/scsi.c       |    7 ++-----
>  drivers/scsi/scsi_error.c |    1 +
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff -puN drivers/scsi/hosts.h~scsi_serial_number drivers/scsi/hosts.h
> --- sysfs-scsi-misc-2.5/drivers/scsi/hosts.h~scsi_serial_number	Wed May 21 08:41:49 2003
> +++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.h	Wed May 21 08:41:49 2003
> @@ -487,6 +487,8 @@ struct Scsi_Host
>      struct device host_gendev;
>      struct class_device class_dev;
>  
> +    unsigned long serial_number;
> +
>      /*
>       * We should ensure that this is aligned, both for better performance
>       * and also because some compilers (m68k) don't automatically force
> @@ -532,6 +534,11 @@ static inline struct device *scsi_get_de
>          return shost->host_gendev.parent;
>  }
>  
> +static inline unsigned long scsi_get_next_serial(struct Scsi_Host *shost)
> +{
> +        return (++shost->serial_number) ? shost->serial_number : 1;
> +}
> +

scsi_get_next_serial()???  Do _you_ Mike like this name?

scsi_get_cmdsn()  will be a lot more appropriate.  It doesn't
reveal implementation (``next''), and tells that it's a serial
number for a command, ``sn'' stands for serial number pretty
universally in our society.

How about something like this:

static inline unsigned long scsi_get_cmdsn(struct Scsi_Host, *shost)
{
	static const typeof(shost->serial_number) MAX_SN = 
		~((typeof(shost->serial_number) 0);
	return  shost->serial_number++ == MAX_SN ?
		++shost->serial_number : shost->serial_number;
}

BTW, are you relying on memset(..., 0, sizeof(struct Scsi_Host),
to set the serial number to 0?

-- 
Luben


