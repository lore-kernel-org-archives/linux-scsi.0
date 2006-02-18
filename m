From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: Linux 2.6.16-rc3
Date: Sat, 18 Feb 2006 15:16:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602181515350.4115-100000@netrider.rowland.org>
References: <1140223363.3231.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1140223363.3231.9.camel@mulgrave.il.steeleye.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Russell King <rmk+lkml@arm.linux.org.uk>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org, "Brown, Len" <len.brown@intel.com>, "David S. Miller" <davem@davemloft.net>, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, Ben Castricum <lk@bencastricum.nl>, sanjoy@mrao.cam.ac.uk, Helge Hafting <helgehaf@aitel.hist.no>, "Carlo E. Prelz" <fluido@fluido.as>, Gerrit Bruchh?user <gbruchhaeuser@gmx.de>, Nicolas.Mailhot@LaPoste.net, Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>, Patrizio Bassi <patrizio.bassi@gmail.com>, Bj?rn Nilsson <bni.swe@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>, "P. Christeas" <p_christ@hol.gr>, ghrt <ghrt@dial.kappa.ro>, jinhong hu <jinhong.hu@gmail.com>Andrew
List-Id: linux-scsi@vger.kernel.org

On Fri, 17 Feb 2006, James Bottomley wrote:

> +/**
> + * execute_in_process_context - reliably execute the routine with user context
> + * @fn:		the function to execute
> + * @data:	data to pass to the function
> + *
> + * Executes the function immediately if process context is available,
> + * otherwise schedules the function for delayed execution.
> + *
> + * Returns:	0 - function was executed
> + *		1 - function was scheduled for execution
> + */
> +int execute_in_process_context(void (*fn)(void *data), void *data,
> +			       struct execute_work *ew)
> +{
> +	if (!in_interrupt()) {
> +		fn(data);
> +		return 0;
> +	}

The test should be in_atomic(), not in_interrupt().

Alan Stern

