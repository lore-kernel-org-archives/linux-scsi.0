From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Mon, 3 Mar 2003 16:08:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303160831.A32018@beaverton.ibm.com>
References: <20030303221532.GB1587@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030303221532.GB1587@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Mar 03, 2003 at 02:15:32PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, mdharm-scsi@one-eyed-alien.net

Looks nice. Two nits.

On Mon, Mar 03, 2003 at 02:15:32PM -0800, Mike Anderson wrote:

> +	spin_lock_irqsave(shost->host_lock, flags);
> +	for (lh = shost->my_devices.next; lh != &shost->my_devices;){

Uh oh you are missing a space above, better call the code style police :)

> +		sdev = list_entry(lh, struct scsi_device, siblings);
> +		scsi_device_get(sdev);
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		error = fn(sdev, data);
> +		spin_lock_irqsave(shost->host_lock, flags);
> +		lh = lh->next;
> +		scsi_device_put(sdev);
> +		if (error)
> +			break;

Embedding "!error &&" in the for conditional is a bit cleaner.

-- Patrick Mansfield
