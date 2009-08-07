From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: sg_reset can trigger a NULL pointer dereference in the SRP
	initiator
Date: Fri, 7 Aug 2009 10:31:18 +0200
Message-ID: <e2e108260908070131r49dd2d37s8bb36c9365d991e8@mail.gmail.com>
References: <e2e108260908060039x7718577yf932d8a9188fe0cb@mail.gmail.com>
	 <4A7A949B.60408@panasas.com> <ada1vnohmc0.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63552 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbZHGIbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 04:31:19 -0400
Received: by ewy10 with SMTP id 10so1374219ewy.37
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2009 01:31:18 -0700 (PDT)
In-Reply-To: <ada1vnohmc0.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, OpenIB <general@lists.openfabrics.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Aug 6, 2009 at 7:41 PM, Roland Dreier<rdreier@cisco.com> wrote:
>
> =A0> Specifically scmnd->host_scribble can just be Zero.
>
> I see at last, thanks!
>
> The issue is that SRP is using host_scribble to hold an index, and in=
dex
> 0 is valid for us.
>
> I guess the fix is a bit complex, but basically we should use
> host_scribble to point to the request, and if we don't find a request=
 in
> reset_device we should allocate one.

A fix like the one below ?

--- linux-2.6.30.4/drivers/infiniband/ulp/srp/ib_srp-orig.c	2009-08-03
12:13:11.000000000 +0200
+++ linux-2.6.30.4/drivers/infiniband/ulp/srp/ib_srp.c	2009-08-07
10:23:27.000000000 +0200
@@ -1371,16 +1371,27 @@ out:
 	return -1;
 }

+/**
+ * Look up the struct srp_request that has been associated with the sp=
ecified
+ * SCSI command by srp_queuecommand().
+ *
+ * Returns 0 upon success and -1 upon failure.
+ */
 static int srp_find_req(struct srp_target_port *target,
 			struct scsi_cmnd *scmnd,
 			struct srp_request **req)
 {
-	if (scmnd->host_scribble =3D=3D (void *) -1L)
-		return -1;
+	/*
+	 * The code below will only work if SRP_RQ_SIZE is a power of two,
+	 * so check this first.
+	 */
+	BUILD_BUG_ON((SRP_RQ_SIZE ^ (SRP_RQ_SIZE - 1))
+		     !=3D (SRP_RQ_SIZE | (SRP_RQ_SIZE - 1)));

-	*req =3D &target->req_ring[(long) scmnd->host_scribble];
+	*req =3D &target->req_ring[(long)scmnd->host_scribble
+				 & (SRP_RQ_SIZE - 1)];

-	return 0;
+	return (*req)->scmnd =3D=3D scmnd ? 0 : -1;
 }

 static int srp_abort(struct scsi_cmnd *scmnd)
@@ -1423,8 +1434,15 @@ static int srp_reset_device(struct scsi_

 	if (target->qp_in_error)
 		return FAILED;
-	if (srp_find_req(target, scmnd, &req))
-		return FAILED;
+	if (srp_find_req(target, scmnd, &req)) {
+		/*
+		 * scmnd has not yet been queued -- queue it now. This can
+		 * happen e.g. when a SG_SCSI_RESET ioctl has been issued.
+		 */
+		if (srp_queuecommand(scmnd, scmnd->scsi_done)
+		    || srp_find_req(target, scmnd, &req))
+			return FAILED;
+	}
 	if (srp_send_tsk_mgmt(target, req, SRP_TSK_LUN_RESET))
 		return FAILED;
 	if (req->tsk_status)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
