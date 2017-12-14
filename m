From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH 5/6] Documentetion: cdrom: introduce CDS_DRIVE_ERROR
Date: Thu, 14 Dec 2017 16:13:54 +0100
Message-ID: <794a72f8f78b076a9b8a47cbc8cb63e650a2ce37.1513263482.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1513263482.git.msuchanek@suse.de>
In-Reply-To: <cover.1513263482.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Suchanek <msuchanek@suse.de>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


CDS_DRIVE_NOT_READY is used for the state in which CDROM is 'becoming
ready' (typically analyzing the disc) but also as the fallback when
nothing else applies. Introduce CDS_DRIVE_ERROR for the fallback case.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 Documentation/cdrom/cdrom-standard.tex | 8 +++++++-
 Documentation/cdrom/ide-cd             | 6 ++++++
 Documentation/ioctl/cdrom.txt          | 1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/cdrom/cdrom-standard.tex b/Documentation/cdrom/cdrom-standard.tex
index 8f85b0e41046..018284ba696a 100644
--- a/Documentation/cdrom/cdrom-standard.tex
+++ b/Documentation/cdrom/cdrom-standard.tex
@@ -371,11 +371,17 @@ $$
 CDS_NO_INFO& no information available\cr
 CDS_NO_DISC& no disc is inserted, tray is closed\cr
 CDS_TRAY_OPEN& tray is opened\cr
-CDS_DRIVE_NOT_READY& something is wrong, tray is moving?\cr
+CDS_DRIVE_NOT_READY& tray just closed?\cr
 CDS_DISC_OK& a disc is loaded and everything is fine\cr
+CDS_DRIVE_ERROR& something is wrong\cr
 }
 $$
 
+Note: The IDE and SCSI cdroms have a status code 'drive becoming ready' which
+is typically returned when the drive has just closed and is analyzing the disc.
+For other cdrom types this state is not reported by the hardware or not
+implemented by the driver.
+
 \subsection{$Int\ media_changed(struct\ cdrom_device_info * cdi, int\ disc_nr)$}
 
 This function is very similar to the original function in $struct\ 
diff --git a/Documentation/cdrom/ide-cd b/Documentation/cdrom/ide-cd
index a5f2a7f1ff46..9324a8fd9a39 100644
--- a/Documentation/cdrom/ide-cd
+++ b/Documentation/cdrom/ide-cd
@@ -455,6 +455,9 @@ main (int argc, char **argv)
 		case CDS_DRIVE_NOT_READY:
 			printf ("Drive Not Ready.\n");
 			break;
+		case CDS_DRIVE_ERROR:
+			printf ("Drive problem.\n");
+			break;
 		default:
 			printf ("This Should not happen!\n");
 			break;
@@ -481,6 +484,9 @@ main (int argc, char **argv)
 			case CDS_NO_INFO:
 				printf ("No Information available.");
 				break;
+			case CDS_DRIVE_ERROR:
+				printf ("Drive problem.\n");
+				break;
 			default:
 				printf ("This Should not happen!\n");
 				break;
diff --git a/Documentation/ioctl/cdrom.txt b/Documentation/ioctl/cdrom.txt
index a4d62a9d6771..7720d11807c3 100644
--- a/Documentation/ioctl/cdrom.txt
+++ b/Documentation/ioctl/cdrom.txt
@@ -700,6 +700,7 @@ CDROM_DRIVE_STATUS		Get tray position, etc.
 	    CDS_TRAY_OPEN
 	    CDS_DRIVE_NOT_READY
 	    CDS_DISC_OK
+	    CDS_DRIVE_ERROR
 	    -1			error
 
 	error returns:
-- 
2.13.6
