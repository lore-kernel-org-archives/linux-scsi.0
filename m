From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix scsi add-single-device
Date: Mon, 27 Jan 2003 00:15:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030127081535.GA7780@beaverton.ibm.com>
References: <1043604061.12324.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1043604061.12324.59.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@steeleye.com] wrote:
> diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	Sun Jan 26 11:58:46 2003
> +++ b/drivers/scsi/scsi_scan.c	Sun Jan 26 11:58:46 2003
> @@ -1758,7 +1758,7 @@
>  	shost = scsi_host_hn_get(host);
>  	if (!shost)
>  		return -ENODEV;
> -	if(scsi_find_device(shost, channel, id, lun) != NULL)
> +	if(scsi_find_device(shost, channel, id, lun) == NULL)
>  		goto out;

The previous condition seemed to be correct as you want to exit if
scsi_find_device finds a scsi_device at the nexus you are trying to add.

The patch below fixed the interface for me.  Though I only tested in
with scsi_debug under UML YMMV.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 hosts.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

------

--- 1.48/drivers/scsi/hosts.h	Fri Jan 10 13:13:38 2003
+++ edited/drivers/scsi/hosts.h	Mon Jan 27 00:02:23 2003
@@ -605,8 +605,8 @@
 	list_for_each_entry (sdev, &shost->my_devices, siblings)
                 if (sdev->channel == channel && sdev->id == pun
                    && sdev->lun ==lun)
-                        break;
-        return sdev;
+                        return sdev;
+        return NULL;
 }
 
 /*
