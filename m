From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RESEND] SCSI: sd: don't fail if the device doesn't
 recognize SYNCHRONIZE CACHE
Date: Wed, 5 Mar 2014 16:14:05 -0800
Message-ID: <CAA9_cmffKCnam5n2U9y1NzJpBRVzLyb2F+m8F5e6eW2Hub-HTA@mail.gmail.com>
References: <1393881957-12320-1-git-send-email-zonque@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54263 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbaCFAOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2014 19:14:06 -0500
In-Reply-To: <1393881957-12320-1-git-send-email-zonque@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Mack <zonque@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, stable@vger.kernel.org

On Mon, Mar 3, 2014 at 1:25 PM, Daniel Mack <zonque@gmail.com> wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
>
> Evidently some wacky USB-ATA bridges don't recognize the SYNCHRONIZE
> CACHE command, as shown in this email thread:
>
>         http://marc.info/?t=138978356200002&r=1&w=2
>
> The fact that we can't tell them to drain their caches shouldn't
> prevent the system from going into suspend.  Therefore sd_sync_cache()
> shouldn't return an error if the device replies with an Invalid
> Command ASC.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Sven Neumann <s.neumann@raumfeld.com>
> Tested-by: Daniel Mack <zonque@gmail.com>
> CC: Oliver Neukum <oliver@neukum.org>
> CC: <stable@vger.kernel.org>
> ---
> Hi,
>
> this patch has been around for awhile, but hasn't gained much
> attraction, and hasn't been merged anywhere yet. Which is sad,
> as it fixes a bug on real hardware when going to suspend :)
>
> Could anyone from the SCSI people have a quick look maybe?

Acked-by: Dan Williams <dan.j.williams@intel.com>

But I agree with Tejun [1], that this likely does not go far enough.
We should also be looking to fail future writes to the device or
disabling the cache.

Tejun's comment:
"Ooh, yeah, flush failure is special.  That said, I think the right way
to deal with that is marking the device as failed and fail writes /
flushes afterwards instead of failing suspend.  It's hightly unlikely
the device is in any useable state after failing flushes anyway and
failing suspend has potential to lead to pretty dramatic failure
conditions (device overheating in the bag would be a common one) too."

[1]: http://marc.info/?l=linux-scsi&m=138998568010393&w=2
