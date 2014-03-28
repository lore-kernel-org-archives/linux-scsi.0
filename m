From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH 2/3] [SCSI] Fix spurious request sense in error handling
Date: Fri, 28 Mar 2014 10:50:17 -0700
Message-ID: <1396029017.15365.32.camel@dabdike>
References: <1396028874.15365.30.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396028874.15365.30.camel@dabdike>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

We unconditionally execute scsi_eh_get_sense() to make sure all failed
commands that should have sense attached, do.  However, the routine forgets
that some commands, because of the way they fail, will not have any sense code
... we should not bother them with a REQUEST_SENSE command.  Fix this by
testing to see if we actually got a CHECK_CONDITION return and skip asking for
sense if we don't.

Tested-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Signed-off-by: James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>
---
 drivers/scsi/scsi_error.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b9f3b07..221a5bc 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1160,6 +1160,15 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     __func__));
 			break;
 		}
+		if (status_byte(scmd->result) != CHECK_CONDITION)
+			/*
+			 * don't request sense if there's no check condition
+			 * status because the error we're processing isn't one
+			 * that has a sense code (and some devices get
+			 * confused by sense requests out of the blue)
+			 */
+			continue;
+
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
-- 
1.9.1



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
