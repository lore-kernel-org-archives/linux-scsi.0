From: Willem Riede <wrlk@riede.org>
Subject: [RFC] Change signal used to exit scsi error handlers
Date: Wed, 1 Jan 2003 16:05:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030101210555.GS1378@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pvezYHf7grwyp3Bc"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id h01L5tf08805
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jan 2003 16:05:55 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

I earlier reported, that the error handler for ide-scsi exits prematurely if modprobed
from rc.sysinit. I put in some debug prints to apprehend the culprit responsible for
sending the SIGHUP signal that causes the exit.

This is what my log captured:

Jan  1 12:20:13 fallguy kernel: Process 223 [modprobe] starting scsi error handler
Jan  1 12:20:13 fallguy kernel: Wake up parent of scsi_eh_2, pid 224
Jan  1 12:20:13 fallguy kernel: Signals pending for scsi_eh_2: 00000000 00000000
Jan  1 12:20:13 fallguy kernel: Error handler scsi_eh_2 sleeping
Jan  1 12:20:13 fallguy kernel: scsi2 : SCSI host adapter emulation for IDE ATAPI devices
[detected devices skipped]
Jan  1 12:20:14 fallguy kernel: Signal 15 sent from 181 [rc.sysinit] to 182 [getkey]
Jan  1 12:20:14 fallguy kernel: Signal 1 sent from 22 [init] to 22 [init]
Jan  1 12:20:14 fallguy kernel: Signal 18 sent from 22 [init] to 22 [init]
Jan  1 12:20:14 fallguy kernel: Signal 1 sent from 22 [init] to 22 [init]
Jan  1 12:20:14 fallguy kernel: Signal 1 sent from 22 [init] to 24 [initlog]
Jan  1 12:20:14 fallguy kernel: Signal 1 sent from 22 [init] to 78 [khubd]
Jan  1 12:20:14 fallguy kernel: Signal 1 sent from 22 [init] to 224 [scsi_eh_2]
Jan  1 12:20:14 fallguy kernel: Signals pending for scsi_eh_2: 00000001 00000000
Jan  1 12:20:14 fallguy kernel: Error handler scsi_eh_2 exiting

Here is a snapshot of some processes made during rc.sysinit:

  F   UID   PID  PPID PRI  NI   VSZ  RSS WCHAN  STAT TTY        TIME COMMAND
100     0     1     0  15   0  1332  420 schedu S    ?          0:05 init
...
040     0    22     1  16   0  1332  388 wait4  S    tty1       0:00 init
000     0    23    22  15   0  4116 1316 wait4  S    tty1       0:00 /bin/bash /
040     0    24    23  16   0  2160 1364 schedu S    tty1       0:00 /sbin/initl
...

Init must have forked to exec bash to exec rc.sysinit which then gets re-executed
through initlog. When rc.sysinit ends, the last thing it does is send that TERM
signal from sub-process 181 to getkey (process 182) -- the 'Signal 15 ...' line 
above.

As the forked init (process 22) exits, it sends a flurry of signals to all surviving
processes created from it. That looks like standard "if I am to die I need to take
all my offspring down with me" behavior -- do you agree?

Since we want error handlers to survive, IMHO that means that the choice of signal
for error handler exit is unfortunate. The source of scsi_error suggests SIGPWR
might be a worthy alternative. I think that is true. From inspecting init source,
it is not capable of sending SIGPWR. SIGPWR should never be sent by dying processes
(its sole use should be from a power daemon _to_ init to shut the system down when
the juice is running out).

So I suggest the following changes to hosts.c and scsi_error.c:

--- drivers/scsi/hosts.c	Tue Dec 24 09:59:30 2002
+++ /home/wriede/develop/hosts.c	Wed Jan  1 15:09:05 2003
@@ -337,7 +337,7 @@
 	if (shost->ehandler) {
 		DECLARE_MUTEX_LOCKED(sem);
 		shost->eh_notify = &sem;
-		send_sig(SIGHUP, shost->ehandler, 1);
+		send_sig(SIGPWR, shost->ehandler, 1);
 		down(&sem);
 		shost->eh_notify = NULL;
 	}

--- drivers/scsi/scsi_error.c	Tue Dec 24 09:59:30 2002
+++ /home/wriede/develop/scsi_error.c	Wed Jan  1 15:21:46 2003
@@ -52,8 +52,12 @@
  * go to single-user mode.  For that matter, init also sends SIGKILL,
  * so we mustn't enable that one either.  We use SIGHUP instead.  Other
  * options would be SIGPWR, I suppose.
+ *
+ * Changed behavior 1/1/2003 - it turns out, that SIGHUP can get sent
+ * to error handlers from a process responsible for their creation.
+ * To sidestep that issue, we now use SIGPWR as suggested above.
  */
-#define SHUTDOWN_SIGS	(sigmask(SIGHUP))
+#define SHUTDOWN_SIGS	(sigmask(SIGPWR))
 
 #ifdef DEBUG
 #define SENSE_TIMEOUT SCSI_TIMEOUT

Seperatly, I'd like to suggest improving the debug printout associated with the
error handler process.

Full diffs against 2.5.53 attached. If accepted, they need to go in 2.4.x too,
as I have confirmed, that the same problem exists there.

Comments, please. Willem Riede.

--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hosts.patch"

--- drivers/scsi/hosts.c	Tue Dec 24 09:59:30 2002
+++ /home/wriede/develop/hosts.c	Wed Jan  1 15:09:05 2003
@@ -337,7 +337,7 @@
 	if (shost->ehandler) {
 		DECLARE_MUTEX_LOCKED(sem);
 		shost->eh_notify = &sem;
-		send_sig(SIGHUP, shost->ehandler, 1);
+		send_sig(SIGPWR, shost->ehandler, 1);
 		down(&sem);
 		shost->eh_notify = NULL;
 	}

--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi_error.patch"

--- drivers/scsi/scsi_error.c	Tue Dec 24 09:59:30 2002
+++ /home/wriede/develop/scsi_error.c	Wed Jan  1 15:21:46 2003
@@ -52,8 +52,12 @@
  * go to single-user mode.  For that matter, init also sends SIGKILL,
  * so we mustn't enable that one either.  We use SIGHUP instead.  Other
  * options would be SIGPWR, I suppose.
+ *
+ * Changed behavior 1/1/2003 - it turns out, that SIGHUP can get sent
+ * to error handlers from a process responsible for their creation.
+ * To sidestep that issue, we now use SIGPWR as suggested above.
  */
-#define SHUTDOWN_SIGS	(sigmask(SIGHUP))
+#define SHUTDOWN_SIGS	(sigmask(SIGPWR))
 
 #ifdef DEBUG
 #define SENSE_TIMEOUT SCSI_TIMEOUT
@@ -1619,7 +1623,7 @@
 	/*
 	 * Wake up the thread that created us.
 	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent \n"));
+	SCSI_LOG_ERROR_RECOVERY(3, printk("Wake up parent of scsi_eh_%d\n",shost->host_no));
 
 	up(shost->eh_notify);
 
@@ -1629,7 +1633,7 @@
 		 * away and die.  This typically happens if the user is
 		 * trying to unload a module.
 		 */
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler sleeping\n"));
+		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d sleeping\n",shost->host_no));
 
 		/*
 		 * Note - we always use down_interruptible with the semaphore
@@ -1644,7 +1648,7 @@
 		if (signal_pending(current))
 			break;
 
-		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler waking up\n"));
+		SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d waking up\n",shost->host_no));
 
 		shost->eh_active = 1;
 
@@ -1672,7 +1676,7 @@
 
 	}
 
-	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler exiting\n"));
+	SCSI_LOG_ERROR_RECOVERY(1, printk("Error handler scsi_eh_%d exiting\n",shost->host_no));
 
 	/*
 	 * Make sure that nobody tries to wake us up again.

--pvezYHf7grwyp3Bc--
