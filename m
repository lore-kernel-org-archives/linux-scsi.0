From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: linux-2.4.18-modified-scsi-h.patch
Date: Tue, 19 Nov 2002 01:28:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD9DA23.1070102@pobox.com>
References: <Pine.LNX.4.10.10211182138310.2779-200000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.10.10211182138310.2779-200000@master.linux-ide.org>
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@pyxtechnologies.com>
Cc: Douglas Gilbert <dougg@torque.net>, "J. E. J. Bottomley" <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Andre Hedrick wrote:

> Greetings Doug et al.
>
> Please consider the addition of this simple void ptr to the scsi_request
> struct.  The addition of this simple void pointer allows one to map any
> and all request execution caller the facility to search for a specific
> operation without having to run in circles.  Hunting for these details
> over the global device list of all HBA's is silly and one of the key
> reasons why there error recovery path is so painful.
>
>
> Scsi_Request    *req = sc_cmd->sc_request;
> blah_blah_t     *trace = NULL;
>
> trace = (blah_blah_t *)req->trace_ptr;
>
>
> Therefore the specific transport invoking operations via the midlayer will
> have the ablity to track and trace any operation.
>
> It will save everyone headaches.
>
> Cheers,
>
>
> Andre Hedrick, CTO & Founder
> iSCSI Software Solutions Provider
> http://www.PyXTechnologies.com/
>
>
> ------------------------------------------------------------------------
>
> --- linux/drivers/scsi/scsi.h.orig	2002-10-31 01:45:39.000000000 -0800
> +++ linux/drivers/scsi/scsi.h	2002-10-31 01:46:31.000000000 -0800
> @@ -667,8 +667,11 @@
>  	unsigned short sr_sglist_len;	/* size of malloc'd scatter-gather list */
>  	unsigned sr_underflow;	/* Return error if less than
>  				   this amount is transferred */
> +	void *trace_ptr;	/* capable of cmd-cmnd-error tracing */


ok


>  };
>
> +#define MODIFIED_SCSI_H


This falls into C style :)  Instead of this I would do

	#define HAVE_TRACE_PTR 1

just like we already do HAVE_xxx in include/linux/netdevice.h and other 
places.

	Jeff



