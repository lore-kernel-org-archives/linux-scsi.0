From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [dm-devel] Re: [PATCH RFC] move scsi parts of dm hw handlers to	scsi layer
Date: Fri, 21 Jul 2006 08:16:56 -0700
Message-ID: <20060721151656.GA10239@us.ibm.com>
References: <1153480817.8030.15.camel@max> <581472.1153482088210.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <44C0BF4C.5060102@cs.wisc.edu> <44C0C0BA.90006@cs.wisc.edu> <4880914.1153483821524.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <44C0C548.4080806@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:34275 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750759AbWGUPQ6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 11:16:58 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6LFGtAs031263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 11:16:56 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6LFGtEs147226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 09:16:55 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6LFGson030416
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2006 09:16:55 -0600
Content-Disposition: inline
In-Reply-To: <44C0C548.4080806@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Patrick Mansfield <patmans@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, agk@redhat.com, linux-scsi@vger.kernel.org

Mike Christie <michaelc@cs.wisc.edu> wrote:
> Hannes Reinecke wrote:
> > Am Fr 21.07.2006 13:55 schrieb Mike Christie <michaelc@cs.wisc.edu>:
> > 
> >> Mike Christie wrote:
> >>> Hannes Reinecke wrote:
> >>>>> The patch below begins to push the scsi hw handler code down to
> >>>>> the
> >>>>> scsi
> >>>>> layer. I only began to covert dm-emc.c and it only hooks in at the
> >>>>> sense
> >>>>> decoding in scsi_error.c. I wanted to make sure I was going about
> >>>>> the
> >>>>> module loading and binding correctly. With a new target bus we
> >>>>> could
> >>>>> do
> >>>>> some driver model stuff instead, but I was not sure if that was
> >>>>> appropriate for this?
> >>>>>
> >>>> Why don't we use scsi_devinfo for this?
> >>> I was adding my fields when I noticed this comment:
> >>>
> >>>
> >>> * Do not add to this list, use the command line or proc interface to
> >>>  add
> >>>  * to the scsi_dev_info_list. This table will eventually go away.
> >>>
> >>>
> >>>> We have to have some sort of device table anyway as these handlers
> >>>> are
> >>>> far from being generic, so any sense code which triggers action on
> >>>> one
> >>>> device might be perfectly ok for others.
> >>> When I was looking for the history of that commet, I thought I read
> >>> that
> >>> we are supposed to be moving to some userspace approach that pushes
> >>> that
> >>> info down via some magic interface.
> >>>
> >> I added this comment at the wrong place. I meant to say I thought we
> >> are
> >> supposed to be moving away from the kernel devinfo list to some
> >> userspace one that gets sent down via the module_param or some new
> >> magic
> >> interface.
> > 
> > Or so they claim. I seem to remember some discussion about it; the net
> > result was the scsi_devinfo will stay with us for the time being.
> > 
> > Otherwise you'll end up having to configure your kernel / module during
> > startup. With parameters which are static anyway. Can't say I like it.
> > And the tricky bit is that these information has to be present prior
> > to any initialisation, so you basically have to feed it during
> > modprobe time. Not really clever.
> > 
> 
> He He fun :)
> 
> Sticking what we need in devinfo is a lot easier. And I think it makes
> sense since the devices info we want to bind with is in there already.
> If nobody says anything, I will send the next version of the path with
> devinfo integration.

I think Patrick added the comment and the interface so he can add the
history. One can use the module or proc interface to pass update devinfo
information in (the sysfs migration never was done). Well it has the
drawback stated above it can address the issue that certain devices can be
supported without a kernel recompile.

Post storage summit I started creating a hardware handler in SCSI, but for
some reason that I do not recall I started working on SDEV state model
change integrated into devinfo. The thought being that devices would come
up in a standby state and then all the varied commands to determine path
state could be executed from user space.

Well it did solve the issue I was trying to address (passive paths
generating errors on startup), it would need user space assistance with all
the plus / minus issues that brings.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 [EXPERIMENTAL] Add standby support to devinfo.


 drivers/scsi/scsi_devinfo.c |    1 +
 drivers/scsi/scsi_priv.h    |    2 +-
 drivers/scsi/scsi_scan.c    |    6 +++++-
 drivers/scsi/scsi_sysfs.c   |    4 ++--
 drivers/scsi/sd.c           |    4 ++--
 include/scsi/scsi_device.h  |    5 +++++
 include/scsi/scsi_devinfo.h |    1 +
 7 files changed, 17 insertions(+), 6 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_devinfo.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_devinfo.c	2006-06-12 14:25:50.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_devinfo.c	2006-06-14 21:59:14.000000000 -0700
@@ -171,6 +171,7 @@ static struct {
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
+	{"IBM", "1742-900", NULL, BLIST_DFLT_STDBY},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_priv.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_priv.h	2006-06-12 14:25:50.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_priv.h	2006-06-12 15:35:47.000000000 -0700
@@ -101,7 +101,7 @@ extern void scsi_exit_sysctl(void);
 #endif /* CONFIG_SYSCTL */
 
 /* scsi_sysfs.c */
-extern int scsi_sysfs_add_sdev(struct scsi_device *);
+extern int scsi_sysfs_add_sdev(struct scsi_device *, enum scsi_device_state);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_scan.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_scan.c	2006-06-12 14:25:50.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_scan.c	2006-06-12 15:35:15.000000000 -0700
@@ -631,6 +631,8 @@ static int scsi_probe_lun(struct scsi_de
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
+	enum scsi_device_state state = SDEV_RUNNING;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -802,7 +804,9 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	if (scsi_sysfs_add_sdev(sdev) != 0)
+	if (*bflags & BLIST_DFLT_STDBY)
+		state = SDEV_STANDBY;
+	if (scsi_sysfs_add_sdev(sdev, state) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_sysfs.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_sysfs.c	2006-06-12 14:29:31.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_sysfs.c	2006-06-12 15:38:16.000000000 -0700
@@ -672,11 +672,11 @@ static int attr_add(struct device *dev, 
  * Return value:
  * 	0 on Success / non-zero on Failure
  **/
-int scsi_sysfs_add_sdev(struct scsi_device *sdev)
+int scsi_sysfs_add_sdev(struct scsi_device *sdev, enum scsi_device_state state)
 {
 	int error, i;
 
-	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
+	if ((error = scsi_device_set_state(sdev, state)) != 0)
 		return error;
 
 	error = device_add(&sdev->sdev_gendev);
Index: aic94xx-sas-2.6-patched/drivers/scsi/sd.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sd.c	2006-06-12 14:25:50.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/sd.c	2006-06-13 09:28:05.000000000 -0700
@@ -769,7 +769,7 @@ static int sd_sync_cache(struct scsi_dev
 	int retries, res;
 	struct scsi_sense_hdr sshdr;
 
-	if (!scsi_device_online(sdp))
+	if (scsi_device_access_restricted(sdp))
 		return -ENODEV;
 
 
@@ -1537,7 +1537,7 @@ static int sd_revalidate_disk(struct gen
 	 * If the device is offline, don't try and read capacity or any
 	 * of the other niceties.
 	 */
-	if (!scsi_device_online(sdp))
+	if (scsi_device_access_restricted(sdp))
 		goto out;
 
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
Index: aic94xx-sas-2.6-patched/include/scsi/scsi_device.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/scsi_device.h	2006-06-12 14:29:31.000000000 -0700
+++ aic94xx-sas-2.6-patched/include/scsi/scsi_device.h	2006-06-12 16:00:08.000000000 -0700
@@ -322,6 +322,11 @@ static inline int scsi_device_online(str
 	return sdev->sdev_state != SDEV_OFFLINE;
 }
 
+static inline int scsi_device_access_restricted(struct scsi_device *sdev)
+{
+	return sdev->sdev_state != SDEV_RUNNING;
+}
+
 /* accessor functions for the SCSI parameters */
 static inline int scsi_device_sync(struct scsi_device *sdev)
 {
Index: aic94xx-sas-2.6-patched/include/scsi/scsi_devinfo.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/scsi_devinfo.h	2006-06-07 13:17:30.000000000 -0700
+++ aic94xx-sas-2.6-patched/include/scsi/scsi_devinfo.h	2006-06-12 15:13:11.000000000 -0700
@@ -30,4 +30,5 @@
 #define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
 #define BLIST_MAX_512		0x800000 /* maximum 512 sector cdb length */
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
+#define BLIST_DFLT_STDBY	0x2000000 /* Default to standby */
 #endif

[EXPERIMENTAL] Add a new scsi device state of standby

 drivers/scsi/scsi_lib.c    |   14 ++++++++++++++
 drivers/scsi/scsi_sysfs.c  |    1 +
 include/scsi/scsi_device.h |    1 +
 3 files changed, 16 insertions(+)

Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_lib.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_lib.c	2006-06-12 14:29:22.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_lib.c	2006-06-12 14:29:31.000000000 -0700
@@ -2009,6 +2009,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_STANDBY:
 			break;
 		default:
 			goto illegal;
@@ -2031,6 +2032,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_STANDBY:
 			break;
 		default:
 			goto illegal;
@@ -2053,6 +2055,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_RUNNING:
 		case SDEV_OFFLINE:
 		case SDEV_BLOCK:
+		case SDEV_STANDBY:
 			break;
 		default:
 			goto illegal;
@@ -2068,6 +2071,17 @@ scsi_device_set_state(struct scsi_device
 		}
 		break;
 
+	case SDEV_STANDBY:
+		switch (oldstate) {
+		case SDEV_CREATED:
+		case SDEV_RUNNING:
+		case SDEV_OFFLINE:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
 	}
 	sdev->sdev_state = state;
 	return 0;
Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_sysfs.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_sysfs.c	2006-06-12 14:25:50.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_sysfs.c	2006-06-12 14:29:31.000000000 -0700
@@ -32,6 +32,7 @@ static const struct {
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
 	{ SDEV_BLOCK,	"blocked" },
+	{ SDEV_STANDBY,	"standby" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
Index: aic94xx-sas-2.6-patched/include/scsi/scsi_device.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/scsi_device.h	2006-06-12 14:27:16.000000000 -0700
+++ aic94xx-sas-2.6-patched/include/scsi/scsi_device.h	2006-06-12 14:29:31.000000000 -0700
@@ -43,6 +43,7 @@ enum scsi_device_state {
 	SDEV_BLOCK,		/* Device blocked by scsi lld.  No scsi 
 				 * commands from user or midlayer should be issued
 				 * to the scsi lld. */
+	SDEV_STANDBY,		/* No media access commands to the device */
 };
 
 struct scsi_device {
