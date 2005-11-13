From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Sun, 13 Nov 2005 11:46:45 -0600
Message-ID: <1131904005.3291.5.camel@mulgrave>
References: <20051113164732.73492.qmail@web88010.mail.re2.yahoo.com>
	 <43777ACC.8070503@redhat.com>
Reply-To: James Bottomley <James.Bottomley@SteelEye.com>,
	338089@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.338089.B338089.113190407825311@bugs.debian.org>
In-Reply-To: <43777ACC.8070503@redhat.com>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Doug Ledford <dledford@redhat.com>
Cc: Graham Knap <graham.knap@rogers.com>, Horms <horms@debian.org>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2005-11-13 at 12:41 -0500, Doug Ledford wrote:
> If the drive is unaccessible after the DV failure, even on a warm reboot 
> (which includes a SCSI bus reset), then the drive is flat hung. 
> Something done in the current code is breaking it.  Can you get a boot 
> with DV turned off and capture the log messages and post them here 
> please?  You already said it didn't help with the problem, but I'd like 
> to see the failure scenario with it off, that might help determine the 
> true root cause of the issue.

Yes, you're right ... the sequencer code seems to identify the
WRITE_BUFFER as the failing command.  Can you try with the attached
patch, which will force DV to ignore the echo buffer write tests?

Thanks,

James

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -816,8 +816,10 @@ spi_dv_device_internal(struct scsi_devic
 	 * do the SPI pattern write tests */
 
 	len = 0;
+#if 0
 	if (scsi_device_dt(sdev))
 		len = spi_dv_device_get_echo_buffer(sdev, buffer);
+#endif
 
  retry:
 
