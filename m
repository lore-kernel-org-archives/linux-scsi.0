From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 13:34:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210251834.g9PIY2l03794@localhost.localdomain>
References: <James.Bottomley@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_11899173800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA13005
	for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2002 11:34:14 -0700
In-Reply-To: Message from James Bottomley <James.Bottomley@steeleye.com>
   of "Fri, 25 Oct 2002 09:16:58 CDT." <200210251416.g9PEGxv01952@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

This is a multipart MIME message.

--==_Exmh_11899173800
Content-Type: text/plain; charset=us-ascii


James.Bottomley@steeleye.com said:
> This has all the hallmarks of the Qlogic double done bug:  Under
> certain high  stress/bad bus situations, the Qla driver will call done
> twice on a SCSI  command structure.  I take it this is the 6.1.0 qla
> driver, which qlogic has  assured me "really really" has this bug
> fixed?

> Is there any way to switch adapters to see if we can confirm this
> hypothesis? 

Actually, rather than switching adapters, could you try the attached patch.  
As long as the command isn't reused too fast after the scsi_done, it should 
pick up this problem.

James





--==_Exmh_11899173800
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/scsi.c 1.50 vs edited =====
--- 1.50/drivers/scsi/scsi.c	Tue Oct 22 12:43:29 2002
+++ edited/drivers/scsi/scsi.c	Fri Oct 25 13:23:32 2002
@@ -1224,6 +1224,12 @@
 	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_do_cmd()\n"));
 }
 
+static void scsi_null_done_method(Scsi_Cmnd *SCp)
+{
+	printk(KERN_EMERG "Done called on already done command\n");
+        dump_stack();
+}
+
 /**
  * scsi_done - Mark this command as done
  * @SCpnt: The SCSI Command which we think we've completed.
@@ -1247,6 +1253,10 @@
 	unsigned long flags;
 	int cpu, tstatus;
 	struct softscsi_data *queue;
+
+        /* clear out the done method to produce an error for done on the
+         * same command */
+        SCpnt->scsi_done = scsi_null_done_method;
 
 	/*
 	 * We don't have to worry about this one timing out any more.

--==_Exmh_11899173800--


