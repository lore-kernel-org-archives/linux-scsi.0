From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: oops on usb storage device disconnect with
 2.6.14-rc1
Date: Sun, 18 Sep 2005 16:37:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509181625240.1209-100000@netrider.rowland.org>
References: <1127073920.4847.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <1127073920.4847.34.camel@mulgrave>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Sun, 18 Sep 2005, James Bottomley wrote:

>  void scsi_remove_host(struct Scsi_Host *shost)
>  {
> +	unsigned long flags;
>  	down(&shost->scan_mutex);
> -	scsi_host_set_state(shost, SHOST_CANCEL);
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	if (scsi_host_set_state(shost, SHOST_CANCEL))
> +		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			up(&shost->scan_mutex);
> +			return;
> +		}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> 	up(&shost->scan_mutex);
> 	scsi_forget_host(shost);

Personally I would prefer to see something like:

	if (scsi_host_set_state(shost,
			(shost->shost_state == SHOST_RECOVERY) ?
			SHOST_CANCEL_RECOVERY : SHOST_CANCEL)) {
		spin_unlock_irqrestore...

with similar changes in the other places.  It avoids a function call and
prevents misleading error messages from showing up in the system log.

Actually, I would probably do

	unsigned long flags;
	int rc;

	down(&shost->scan_mutex);
	spin_lock_irqsave(shost->host_lock, flags);
	rc = scsi_host_set_state(shost,
			(shost->shost_state == SHOST_RECOVERY) ?
			SHOST_CANCEL_RECOVERY : SHOST_CANCEL);
	spin_unlock_irqrestore(shost->host_lock, flags);
	up(&shost->scan_mutex);
	if (rc)
		return;
	scsi_forget_host(shost);
	...

just to avoid the extra spin_unlock call.  Those macros can expand to a 
surprising length.

Alan Stern



-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
