From: Martin Hicks <mort@bork.org>
Subject: Re: Transport Attributes -- attempt#3
Date: Fri, 16 Jan 2004 11:47:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116164740.GJ27591@localhost>
References: <OF2D4C46F4.BCE421EB-ONC1256E1C.0045A5CA-C1256E1C.00472906@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:1429 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265579AbUAPQrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 11:47:40 -0500
Content-Disposition: inline
In-Reply-To: <OF2D4C46F4.BCE421EB-ONC1256E1C.0045A5CA-C1256E1C.00472906@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org



On Thu, Jan 15, 2004 at 01:52:16PM +0100, Martin Peschke3 wrote:
> Hi,
> 
> +     if (sdev->transport_classdev.class) {
> +           attrs = sdev->host->transportt->attrs;
> +           for (i = 0; attrs[i]; i++) {
> +                 error = class_device_create_file
> (&sdev->transport_classdev,
> +                                         attrs[i]);
> +                 if (error)
> +                       scsi_remove_device(sdev);
> +           }
> +     }
> 
> Isn't there a break needed in the error case to quit
> the loop after scsi_remove_device(sdev) in order to
> avoid trouble with sdev in subsequent iterations?
> I am not very familiar with the 2.6 SCSI code. But,
> is scsi_remove_device(sdev) an appropriate answer
> to the failed registration of sysfs attributes?

It looks that way.  There are a couple other places in the same function
that need similar fixes.

Thanks
mh

-- 
Martin Hicks || mort@bork.org || PGP/GnuPG: 0x4C7F2BEE
