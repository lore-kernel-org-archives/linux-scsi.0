From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 4/9] libata: move acpi notification code to zpodd
Date: Mon, 7 Jan 2013 10:26:51 -0800
Message-ID: <20130107182651.GQ3926@htj.dyndns.org>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com>
 <1357440509-28108-5-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63831 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3AGS05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2013 13:26:57 -0500
Content-Disposition: inline
In-Reply-To: <1357440509-28108-5-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Sun, Jan 06, 2013 at 10:48:24AM +0800, Aaron Lu wrote:
> @@ -7,6 +9,9 @@ struct zpodd {
>  	bool slot:1;
>  	bool drawer:1;
>  
> +	/* The following bits are synchronized by PM core */
> +	bool from_notify:1; /* resumed as a result of acpi notification */
> +
>  	struct ata_device *dev;
>  };

So, you can't put bitfields which belong to different synchronization
domains next to each other.  They may (and here will) be put into the
same word and RMW cycles may race with each other.  Please either use
unsigned integer flags per sync domain or just put them in separate
bools.  At any rate, please comment on how RWs are supposed to be
synchronized.

Thanks.

-- 
tejun
