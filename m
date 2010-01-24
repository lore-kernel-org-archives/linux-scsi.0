From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/8] PM: Asynchronous suspend and resume of devices
Date: Sun, 24 Jan 2010 11:37:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1001241128250.28594-100000@netrider.rowland.org>
References: <201001240035.37550.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <201001240035.37550.rjw@sisk.pl>
Sender: linux-pci-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Linux PCI <linux-pci@vger.kernel.org>, pm list <linux-pm@lists.linux-foundation.org>, linux-usb@vger.kernel.org, Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>, James Bottomley <James.Bottomley@suse.de>, Linux SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>, Nigel Cunningham <ncunningham@crca.org.au>
List-Id: linux-scsi@vger.kernel.org

On Sun, 24 Jan 2010, Rafael J. Wysocki wrote:

> The async threads started for different devices as a result of
> calling async_schedule() are synchronized with each other and with
> the main suspend/resume thread with the help of completions, in the
> following way:
> (1) There is a completion, power.completion, for each device object.
> (2) Each device's completion is reset before calling async_schedule()
>     for the device or, in the case of devices with the
>     power.async_suspend flags unset, before executing the device's
>     suspend and resume callbacks.
> (3) During suspend, right before running the bus type, device type
>     and device class suspend callbacks for the device, the PM core
>     waits for the completions of all the device's children to be
>     completed.
> (4) During resume, right before running the bus type, device type and
>     device class resume callbacks for the device, the PM core waits
>     for the completion of the device's parent to be completed.
> (5) The PM core completes power.completion for each device right
>     after the bus type, device type and device class suspend (or
>     resume) callbacks executed for the device have returned.

...

>  /**
> + * dpm_wait - Wait for a PM operation to complete.
> + * @dev: Device to wait for.
> + * @async: If unset, wait only if the device's power.async_suspend flag is set.
> + */
> +static void dpm_wait(struct device *dev, bool async)
> +{
> +	if (!dev)
> +		return;
> +
> +	if (async || dev->power.async_suspend)
> +		wait_for_completion(&dev->power.completion);
> +}

There needs to be a public interface to this function available for 
drivers that have non-tree constraints.  The arguments should be the 
device to wait for and the device doing the waiting (needed only to 
determine whether the caller is running synchronously or not).

This will be necessary for USB.  In fact, your current code (with patch 
7/8 applied) is subject to a race that will sometimes cause a 
non-high-speed USB device to fail to resume from hibernation.

Alan Stern
