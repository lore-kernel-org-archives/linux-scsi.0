From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi/hosts.c device_register fix
Date: Fri, 29 Nov 2002 09:53:28 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DE69E68.7070304@torque.net>
References: <200211281657.gASGve102802@localhost.localdomain>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090009020605010109080903"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries.Brouwer@cwi.nl, torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090009020605010109080903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> Actually, the patch is wrong.  It will wreak havoc with SCSI's use of sysfs.  
> The device_register has to be done in scsi_add_host, which is called after all 
> the driver specific sysfs setup has been done.  The correct fix is to move the 
> corresponding device_unregister into scsi_remove_host so that they match.
> 
> I've attached it below.  I'll also commit it to the scsi-misc-2.5 BK tree.
> 
> James
> 
> 
> 
> ------------------------------------------------------------------------
> 
> ===== hosts.c 1.31 vs edited =====
> --- 1.31/drivers/scsi/hosts.c	Sun Nov 17 15:47:02 2002
> +++ edited/hosts.c	Sat Nov 23 17:25:57 2002
> @@ -295,6 +295,8 @@
>  		kfree(sdev);
>  	}
>  
> +	device_unregister(&shost->host_driverfs_dev);
> +
>  	return 0;
>  }
>  
> @@ -348,7 +350,6 @@
>  
>  	/* Cleanup proc and driverfs */
>  	scsi_proc_host_rm(shost);
> -	device_unregister(&shost->host_driverfs_dev);
>  
>  	kfree(shost);
>  }

James,
The above patch is a bit noisy when applied to lk 2.5.50 .
Attached is the same patch (I hope) which applies cleanly.

Doug Gilbert

--------------090009020605010109080903
Content-Type: text/plain;
 name="dev_reg_2550.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dev_reg_2550.diff"

--- linux/drivers/scsi/hosts.c	2002-11-29 09:27:35.000000000 +1100
+++ linux/drivers/scsi/hosts.c2550jb	2002-11-29 09:45:28.000000000 +1100
@@ -297,6 +297,8 @@
 		scsi_free_sdev(list_entry(le, Scsi_Device, siblings));
 	}
 
+	device_unregister(&shost->host_driverfs_dev);
+
 	return 0;
 }
 
@@ -348,7 +350,6 @@
 
 	/* Cleanup proc and driverfs */
 	scsi_proc_host_rm(shost);
-	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
 }

--------------090009020605010109080903--


