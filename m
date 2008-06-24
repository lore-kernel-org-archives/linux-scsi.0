From: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Tue, 24 Jun 2008 11:25:19 +0800
Message-ID: <804dabb00806232025m31ba0826lbddac040428e974f@mail.gmail.com>
References: <1213999774.3443.49.camel@localhost.localdomain>
	 <Pine.LNX.4.44L0.0806231054540.2556-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:53242 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYFXDZd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 23:25:33 -0400
Received: by an-out-0708.google.com with SMTP id d40so657428and.103
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2008 20:25:30 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0806231054540.2556-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Jun 23, 2008 at 11:04 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 20 Jun 2008, James Bottomley wrote:
>
>> Yes, thanks.  It's a bit nasty from a security point of view, since the
>> leaking data apparently belonged to a different command.  Wouldn't a
>> better fix (and a more secure one) be to clear from the end of the valid
>> data to the end of the buffer?
>
> Here's the promised patch.  Maciej and Peter, please try it out.
>
> Alan Stern
>
>
> Index: usb-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> +++ usb-2.6/drivers/scsi/scsi_lib.c
> @@ -207,6 +207,15 @@ int scsi_execute(struct scsi_device *sde
>         */
>        blk_execute_rq(req->q, NULL, req, 1);
>
> +       /*
> +        * Some devices (USB mass-storage in particular) may transfer
> +        * garbage data together with a residue indicating that the data
> +        * is invalid.  Prevent the garbage from being misinterpreted
> +        * and prevent security leaks by zeroing out the excess data.
> +        */
> +       if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
> +               memset(buffer + (bufflen - req->data_len), 0, req->data_len);
> +
>        ret = req->errors;
>  out:
>        blk_put_request(req);
>
>

Yes, it worked (based on latest linus git tree) the before and after
patch dmesg are as follows:

[  387.015562] scsi 3:0:0:0: Direct-Access     WD
1600BEAExternal  1.02 PQ: 0 ANSI: 0
[  387.018563] sd 3:0:0:0: [sde] 312581808 512-byte hardware sectors (160042 MB)
[  387.018573] sd 3:0:0:0: [sde] Write Protect is on
[  387.018583] sd 3:0:0:0: [sde] Mode Sense: 12 a1 9e af
[  387.018589] sd 3:0:0:0: [sde] Assuming drive cache: write through
[  387.020182] sd 3:0:0:0: [sde] 312581808 512-byte hardware sectors (160042 MB)
[  387.020602] sd 3:0:0:0: [sde] Write Protect is on
[  387.020602] sd 3:0:0:0: [sde] Mode Sense: 12 a1 9e af
[  387.020602] sd 3:0:0:0: [sde] Assuming drive cache: write through
[  387.020602]  sde: sde1 sde2 sde3 < sde5 > sde4
[  387.094903] sd 3:0:0:0: [sde] Attached SCSI disk
[  387.095304] sd 3:0:0:0: Attached scsi generic sg4 type 0

After patching and recompiling and reboot:

[  230.281708] sd 3:0:0:0: [sdd] 312581808 512-byte hardware sectors (160042 MB)
[  230.282708] sd 3:0:0:0: [sdd] Write Protect is off
[  230.282708] sd 3:0:0:0: [sdd] Mode Sense: 00 00 00 00
[  230.282708] sd 3:0:0:0: [sdd] Assuming drive cache: write through
[  230.283708] sd 3:0:0:0: [sdd] 312581808 512-byte hardware sectors (160042 MB)
[  230.284709] sd 3:0:0:0: [sdd] Write Protect is off
[  230.284709] sd 3:0:0:0: [sdd] Mode Sense: 00 00 00 00
[  230.284709] sd 3:0:0:0: [sdd] Assuming drive cache: write through
[  230.284709]  sdd: sdd1 sdd2 sdd3 < sdd5 > sdd4
[  230.364830] sd 3:0:0:0: [sdd] Attached SCSI disk

Thank you very much Alan.

-- 
Regards,
Peter Teoh
