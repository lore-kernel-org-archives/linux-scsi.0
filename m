From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Summary of the Multi-Path BOF at OLS and future directions
Date: 04 Aug 2003 20:54:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060042082.1985.53.camel@fuzzy>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-GziSwaPjwi0KoEUT16ms"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:13063 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S272407AbTHEDy6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2003 23:54:58 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h753ssI23876
	for <linux-scsi@vger.kernel.org>; Mon, 4 Aug 2003 23:54:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-GziSwaPjwi0KoEUT16ms
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,

For those of you who couldn't attend OLS, I thought a short summary of
what went on might be useful.

Multi-path was a hot topic throughout both the Kernel Summit and OLS.
Thing began with a requirement inputs panel of vendors identifying
multi-path as one of their primary problems.  Followed by an invited
discussion with Lars Marowski-Br=E9e and Mike Anderson on multi-path. At
OLS, there was a paper presentation by Mike and Patrick Mansfield on the
IBM SCSI layer multi-pathing solution and finally there was the BOF
session which tried to pick a way forwards for us in 2.6/2.7

What I'd like to summarise is what I think the conclusions we reached
are:

1. Multi-path is relevant to more layers of the I/O stack than just
SCSI. Thus, it makes sense to do it at the layer just above bio.  This
would either be md/multipath or the Device Mapper multi-path module.

2. Doing multi-path at that level is not easy without fast failure
indications.

2a. On discussion of this, it was decided that on each bio/request, the
upper layers would like to indicate which failures they wish to be fast
and which they wish not to know about.  The two principle ones were
transport errors (relevant to multi-path) and medium errors (relevant to
software raid).

2b. Upwards, on fast failure, we would send back the raw sense data
(probably encoded in the sense request) plus a translated indication of
what the problem was.  The translations would probably be a combination
of (fatal|retryable) and (driver error (card out of
resources/failure)|transport error|medum error).

3.  It was noted that symmetric active multi-path in this scheme is not
possible without the ability to place a proper elevator above the
multi-pathing driver (and have a simple queue only noop elevator
below).  This should help alleviate the current fragmentation issues
where symmetric active multi-path produces I/O in decidedly non-optimal
page sized chunks.

4. Configuration of this solution would be extremely important.  The
idea here is to rely on the udev solution currently making its way into
the kernel and essentially have a vendor specific multi-path
configuration as a udev plug-in.

5. Vendor value add for specific devices could be encoded both as
configuration (udev) pieces and plug-ins to the upper layer multi-path
driver to activate any proprietary vendor specific configuration options
that may be needed for specific solutions.

6. Ownership.  This wasn't exactly discussed, but in light of the
problems with even SCSI-3 reservations, it is becoming clear that
storage ownership in a multi-path configuration is getting impossible to
maintain from user level.  Therefore, I at least will be giving thought
to an ownership API that could be used to manage storage ownership from
the kernel in the face of path fail overs.

As far as the beginnings of implementation go, we already have
md/multi-path.  Joe Thorber of Sistina will shortly be releasing the
code to do multi-path over the device mapper interface, and our trusty
block layer maintainer, Jens Axboe, has done the skeleton of a fast fail
infrastructure for us (in 2.6.0-test2).  The attached patch should add
the fast fail capability to SCSI (although without the upwards/downwards
failure indications) and we should be able to build the rest of the
infrastructure on this framework.

As far as errors and omissions go, I found KS/OLS to go rather fast and
be a bit blurry, so hopefully those who were also present can chime in
on this thread to amplify/correct the points I actually managed to grasp
and summarise the ones I missed.

Thanks,

James




--=-GziSwaPjwi0KoEUT16ms
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D scsi_error.c 1.60 vs edited =3D=3D=3D=3D=3D
--- 1.60/drivers/scsi/scsi_error.c	Thu Jul 31 07:32:18 2003
+++ edited/scsi_error.c	Mon Aug  4 14:20:24 2003
@@ -1285,7 +1285,12 @@
=20
       maybe_retry:
=20
-	if ((++scmd->retries) < scmd->allowed) {
+	/* we requeue for retry because the error was retryable, and
+	 * the request was not marked fast fail.  Note that above,
+	 * even if the request is marked fast fail, we still requeue
+	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
+	if ((++scmd->retries) < scmd->allowed=20
+	    && !blk_noretry_request(scmd->request)) {
 		return NEEDS_RETRY;
 	} else {
 		/*
=3D=3D=3D=3D=3D scsi_lib.c 1.108 vs edited =3D=3D=3D=3D=3D
--- 1.108/drivers/scsi/scsi_lib.c	Sat Aug  2 10:18:20 2003
+++ edited/scsi_lib.c	Mon Aug  4 14:26:46 2003
@@ -497,6 +497,13 @@
 	struct request *req =3D cmd->request;
 	unsigned long flags;
=20
+	/* If failfast is enabled, override the number of completed
+	 * sectors to make sure the entire request is finished right
+	 * now */
+	if(blk_noretry_request(req)) {
+		sectors =3D req->hard_nr_sectors;
+	}
+
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.

--=-GziSwaPjwi0KoEUT16ms--

