From: Willem Riede <wrlk@riede.org>
Subject: Re: buggy scsi_register behaviour in 2.5.51
Date: Tue, 17 Dec 2002 20:52:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021218015233.GM7990@linnie.riede.org>
References: <3DFE998E.1080103@interlog.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DFE998E.1080103@interlog.com>; from dgilbert@interlog.com on Mon, Dec 16, 2002 at 22:27:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2002.12.16 22:27 Douglas Gilbert wrote:
> Willem,
> Can't fix all those problems but I did notice that
> idescsi_release() was missing a call to scsi_unregister().
> With this patch the ide-scsi entry remains dangling in
> sysfs (ide problem??) 

Indeed. There is a call to driver_register in ide_register_driver
but no call to driver_unregister in ide_unregister_driver.

I put one in, and that takes care of it. PATCH to ide.c attached.

Regards, Willem Riede.


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ide.patch"

--- ide.c-l2552	2002-12-09 21:45:52.000000000 -0500
+++ ide.c	2002-12-17 20:43:29.000000000 -0500
@@ -2314,6 +2314,8 @@
 {
 	ide_drive_t *drive;
 
+	driver_unregister(&driver->gen_driver);
+
 	spin_lock(&drivers_lock);
 	list_del(&driver->drivers);
 	spin_unlock(&drivers_lock);

--UlVJffcvxoiEqYs2--
