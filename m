From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Problem with external USB2.0 case and LG GSA
	4040-B
Date: 15 Dec 2003 16:08:54 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1071522536.1834.52.camel@mulgrave>
References: <Pine.LNX.4.44L0.0312151529160.895-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0312151529160.895-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelius Claussen <cornelius.claussen@gmx.de>, Patrick Mansfield <patmans@us.ibm.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-12-15 at 15:49, Alan Stern wrote:
> Cornelius Claussen reported the following problem with error recovery in
> 2.6.0-test11.  His device is one of those problem-prone Genesys Logic
> units, a USB DVD drive.  The complete message and log can be found at

It looks like the driver sent a reset to the device on its own without
reporting it to the mid-layer.

There's an expecting_cc_ua flag in the scsi_device.  It gets set on
error recovery actions, or if the device does something to detect or
trigger a reset (that's the scsi_report_device_reset() and
scsi_report_bus_reset() API's).

James




-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
