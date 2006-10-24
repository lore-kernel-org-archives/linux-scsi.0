From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Wed, 25 Oct 2006 00:39:04 +0200
Message-ID: <453E9608.9000709@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@osdl.org>, Meelis Roos <mroos@linux.ee>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alan Stern wrote:
...
> @@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
...
> +	 * On the whole, the best approach seems to be to assume the first
> +	 * 36 bytes are valid no matter what the device says.  That's
> +	 * better than copying < 36 bytes to the inquiry-result buffer
> +	 * and displaying garbage for the Vendor, Product, or Revision
> +	 * strings.
> +	 */
> +	if (sdev->inquiry_len < 36) {
> +		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
> +				" using 36\n", sdev->inquiry_len);
> +		sdev->inquiry_len = 36;
> +	}
...

BTW, AFAIU the sbp2 driver did exactly this in older versions, when it
did its own conversions of commands and results.
-- 
Stefan Richter
-=====-=-==- =-=- ==--=
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
