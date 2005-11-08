From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: oops with USB Storage on 2.6.14
Date: Tue, 08 Nov 2005 12:01:45 -0500
Message-ID: <1131469305.3270.21.camel@mulgrave>
References: <C2EEB4E538D3DC48BF57F391F422779321ADBA@srmanning.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADBA@srmanning.eng.emc.com>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: "goggin, edward" <egoggin@emc.com>
Cc: 'Andrew Morton' <akpm@osdl.org>, Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2005-11-08 at 11:24 -0500, goggin, edward wrote:
> ! 	struct scsi_device *sdev = cmd->device;
> ! 	struct request_queue *q = sdev->request_queue;
> ! 
> ! 	// need to hold a reference on the device before we let go of the
> cmd
> ! 	if (scsi_device_get(sdev)) {
> ! 		scsi_put_command(cmd);
> ! 		return;		// maybe sdev_state == SDEV_CANCEL, SDEV_DEL
> ! 	}
>   
>   	scsi_put_command(cmd);
>   	scsi_run_queue(q);
> + 
> + 	// ok to remove device now
> + 	scsi_device_put(sdev);

This is the right idea, I think, but not necessarily the right fix.
scsi_device_get() will fail if the device is going offline, but we would
still need to run the queues.

try this sequence instead:

get_device(&sdev->sdev_gendev);
scsi_put_command(cmd);
scsi_run_queue(q);
put_device(&sdev->sdev_gendev);

James




-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
