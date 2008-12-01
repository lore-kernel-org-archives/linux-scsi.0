From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12119] iscsi repeatedly times out
Date: Sun, 30 Nov 2008 20:11:16 -0800 (PST)
Message-ID: <20081201041116.A3772108041@picon.linux-foundation.org>
References: <bug-12119-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbYLAELT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 23:11:19 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mB14BG4R025267
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2008 20:11:17 -0800
In-Reply-To: <bug-12119-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12119





------- Comment #2 from anonymous@kernel-bugs.osdl.org  2008-11-30 20:11 -------
Reply-To: michaelc@cs.wisc.edu

Mike Christie wrote:
> bugme-daemon@bugzilla.kernel.org wrote:
>> Hardware Environment:diskless i386, swap on iscsi device
>> Software Environment:open-iscsi v 6.2
> 
> What is the rest of this version string? With fedora run
> 
> rpm -q iscsi-initiator-utils

Ignore that request.

Try the attached patch made over 2.6.27 which was the base for the 
kernel I thought you were using. This should also work with 2.6.28-rc*.

Oh yeah for 2.6.27 are you using a fedora kernel? If you are building 
your own kernel and you are using F8 then make sure you compile the 
kernel with

CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y

because a lot of tools in F8 may not work right without it.  The older 
iscsi tools in there will not and you will run into lots of other 
problems, because there were some sysfs changes which affected iscsi and 
we were not ready for them back then. Newer tools in F9 and F10  and 
open-iscsi.org will handle any sysfs layout so if you can you might want 
to grab the iscsi-initiator-utils rpm from the F9 repository.
--- linux-2.6.27-rc5.work/drivers/scsi/libiscsi.c       2008-08-28
17:52:02.000000000 -0500
+++ linux-2.6.27-rc5/drivers/scsi/libiscsi.c    2008-11-30 21:46:55.000000000
-0600
@@ -494,12 +494,6 @@ __iscsi_conn_send_pdu(struct iscsi_conn 
                if (!__kfifo_get(session->cmdpool.queue,
                                 (void*)&task, sizeof(void*)))
                        return NULL;
-
-               if ((hdr->opcode == (ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE))
&&
-                    hdr->ttt == RESERVED_ITT) {
-                       conn->ping_task = task;
-                       conn->last_ping = jiffies;
-               }
        }
        /*
         * released in complete pdu for task we expect a response for, and
@@ -674,6 +668,11 @@ static void iscsi_send_nopout(struct isc
        task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
        if (!task)
                iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
+       else if (!rhdr) {
+               /* only track our nops */
+               conn->ping_task = task;
+               conn->last_ping = jiffies;
+       }
 }

 static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
