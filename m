From: Andries Brouwer <aebr@win.tue.nl>
Subject: [PATCH] oops in sd_shutdown
Date: Tue, 12 Aug 2003 00:28:44 +0200
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030812002844.B1353@pclin040.win.tue.nl>
References: <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher>; from number6@cox.net on Mon, Aug 11, 2003 at 02:38:11PM -0700
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: linux-scsi@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I see an Oops in the SCSI code, caused by the fact that sdkp is NULL
in sd_shutdown. "How can that be?", you will ask - dev->driver_data was set
in sd_probe. But in my case sd_probe never finished. An insmod usb-storage
hangs forever, or at least for more than six hours, giving ample opportunity
to observe this race between sd_probe and sd_shutdown.
(Of course sd_probe hangs in sd_revalidate disk.)

Perhaps the obvious test is a good idea.
Locking seems meaningless - sd_probe will never finish.

Andries

[Probably the init of usb_storage should start probing the devices in separate
threads, in parallel, and return immediately.]

The obvious patch (with whitespace damage)

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c Mon Jul 28 05:39:31 2003
+++ b/drivers/scsi/sd.c Tue Aug 12 01:24:51 2003
@@ -1351,10 +1351,14 @@
 static void sd_shutdown(struct device *dev)
 {
        struct scsi_device *sdp = to_scsi_device(dev);
-       struct scsi_disk *sdkp = dev_get_drvdata(dev);
+       struct scsi_disk *sdkp;
        struct scsi_request *sreq;
        int retries, res;
 
+       sdkp = dev_get_drvdata(dev);
+       if (!sdkp)
+               return;         /* this can happen */
+
        if (!sdp->online || !sdkp->WCE)
                return;
 



-------------------------------------------------------
This SF.Net email sponsored by: Free pre-built ASP.NET sites including
Data Reports, E-commerce, Portals, and Forums are available now.
Download today and enter to win an XBOX or Visual Studio .NET.
http://aspnet.click-url.com/go/psa00100003ave/direct;at.aspnet_072303_01/01
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
