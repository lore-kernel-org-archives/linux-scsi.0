From: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: disk restart failure after suspend
Date: Mon, 19 Oct 2009 20:05:09 +0200
Message-ID: <20091019180509.GA24410@mac.home>
References: <4ADB2967.7000103@s5r6.in-berlin.de>
	<Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0910181642390.18952-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

for reference, I attach the patch I used to workaround this.

Regards,
Tino

--qMm9M+Fa2AknHoGS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="retry_restart_disk.diff"

--- sd.c	2009-10-19 14:19:20.199156476 +0200
+++ linux-2.6.31/drivers/scsi/sd.c	2009-10-14 22:38:27.922974268 +0200
@@ -2183,6 +2185,7 @@
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp = sdkp->device;
 	int res;
+	int i = 0;
 
 	if (start)
 		cmd[4] |= 1;	/* START */
@@ -2193,8 +2196,13 @@
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-			       SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+	while (res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES, NULL) && i < 10) {
+		i++;
+		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED, retrying.\n");
+		msleep(2000);
+	}
+
 	if (res) {
 		sd_printk(KERN_WARNING, sdkp, "START_STOP FAILED\n");
 		sd_print_result(sdkp, res);

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Come build with us! The BlackBerry(R) Developer Conference in SF, CA
is the only developer event you need to attend this year. Jumpstart your
developing skills, take BlackBerry mobile applications to market and stay 
ahead of the curve. Join us from November 9 - 12, 2009. Register now!
http://p.sf.net/sfu/devconference
--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--qMm9M+Fa2AknHoGS--
