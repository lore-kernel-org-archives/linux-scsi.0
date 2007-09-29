From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning
 down disk
Date: Sat, 29 Sep 2007 11:56:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709291151030.29112-100000@netrider.rowland.org>
References: <200709282347.17184.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200709282347.17184.oliver@neukum.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 28 Sep 2007, Oliver Neukum wrote:

> Unless I am very mistaken, further down in storage_suspend, I call
> 
> +	/* In case of autosuspend device must be unblocked again */
> +	if (us->pusb_dev->auto_pm) {
> +err_unblock:
> +		shost_for_each_device(sdev, host) {
> +			if (sdev == sdev2) {
> +				scsi_device_put(sdev);
> +				break;
> +			}
> +			scsi_device_resume(sdev);
> 
> which again allows normal io, so the autoresume is triggered.
> It may deadlock, you are right about that, but it is definitely triggered.
> I verified that experimentally.

Yes, okay, sorry, I didn't read far enough into the patch.

Still, doesn't it seem peculiar that to implement autosuspend you have 
to quiesce the device and then reactivate it?  In fact, it's not clear 
why you want to call scsi_device_quiesce() in the first place.  The 
fact that scsi_bus_suspend() does it isn't a good reason.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
