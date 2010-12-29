From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/7] [SCSI] scst: Add scst_local driver.
Date: Wed, 29 Dec 2010 10:54:34 +0100
Message-ID: <AANLkTingSeNi2bTvtRGWh1o1Oe5HJBPyk93spAAsVX_T@mail.gmail.com>
References: <201012201849.03930.bvanassche@acm.org> <201012281351.20087.konrad@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43294 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0L2Jyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Dec 2010 04:54:55 -0500
Received: by iwn9 with SMTP id 9so9969039iwn.19
        for <linux-scsi@vger.kernel.org>; Wed, 29 Dec 2010 01:54:54 -0800 (PST)
In-Reply-To: <201012281351.20087.konrad@darnok.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, realrichardsharpe@gmail.com

On Tue, Dec 28, 2010 at 7:51 PM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
> On Monday 20
>> +#define TRUE 1
>> +#define FALSE 0
>
> can't you use 'true' or 'false'?
> .. snip..
>> +static int scst_local_get_sas_transport_id(struct scst_local_sess *=
sess,
>> + =A0 =A0 uint8_t **transport_id, int *len)
>> +{
>> + =A0 =A0 int res =3D 0;
>> + =A0 =A0 int tr_id_size =3D 0;
>> + =A0 =A0 uint8_t *tr_id =3D NULL;
>> +
>> + =A0 =A0 tr_id_size =3D 24; =A0/* A SAS TransportID */
>> +
>> + =A0 =A0 tr_id =3D kzalloc(tr_id_size, GFP_KERNEL);
>> + =A0 =A0 if (tr_id =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 PRINT_ERROR("Allocation of TransportID (si=
ze %d) failed",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tr_id_size);
>
> pr_err? Or is this based on a module parameter?

The macro PRINT_ERROR() has been defined in the header file
include/scst/scst_debug.h. For this macro and also for related macros
(e.g. TRACE_DBG()) the user can configure via debugfs whether or not
PID, function name and/or line number should be included in the
generated messages.

>> + =A0 =A0 =A0 =A0 =A0 =A0 res =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 tr_id[0] =3D 0x00 | SCSI_TRANSPORTID_PROTOCOLID_SAS;
>
> Hmm, why the 0x00? Can't you just do an assigment?

If I do not receive further feedback, I will queue the patch below:

[SCSI] scst_local: Clean up source code

Use true and false instead of TRUE and FALSE and remove one occurrence
of "0x00 |".

Signed-off-by: Richard Sharpe <realrichardsharpe@gmail.com>
Acked-by: Bart Van Assche <bvanassche@acm.org>

diff --git a/drivers/scst/scst_local/scst_local.c
b/drivers/scst/scst_local/scst_local.c
index a3804cb..4a20e40 100644
--- a/drivers/scst/scst_local/scst_local.c
+++ b/drivers/scst/scst_local/scst_local.c
@@ -50,9 +50,6 @@
 static unsigned long scst_local_trace_flag =3D SCST_LOCAL_DEFAULT_LOG_=
=46LAGS;
 #endif

-#define TRUE 1
-#define FALSE 0
-
 #define SCST_LOCAL_VERSION "1.0.0"
 #define SCST_LOCAL_VERSION_DATE "20100910"

@@ -147,7 +144,7 @@ static int scst_local_get_sas_transport_id(struct
scst_local_sess *sess,
 		goto out;
 	}

-	tr_id[0] =3D 0x00 | SCSI_TRANSPORTID_PROTOCOLID_SAS;
+	tr_id[0] =3D SCSI_TRANSPORTID_PROTOCOLID_SAS;

 	/*
 	 * Assemble a valid SAS address =3D 0x5OOUUIIR12345678 ... Does SCST
@@ -664,7 +661,7 @@ static int scst_local_abort(struct scsi_cmnd *SCpnt=
)
 	sess =3D to_scst_lcl_sess(scsi_get_device(SCpnt->device->host));

 	ret =3D scst_rx_mgmt_fn_tag(sess->scst_sess, SCST_ABORT_TASK, SCpnt->=
tag,
-				 FALSE, &dev_reset_completion);
+				 false, &dev_reset_completion);

 	/* Now wait for the completion ... */
 	wait_for_completion_interruptible(&dev_reset_completion);
@@ -688,7 +685,7 @@ static int scst_local_device_reset(struct scsi_cmnd=
 *SCpnt)
 	lun =3D cpu_to_be16(SCpnt->device->lun);

 	ret =3D scst_rx_mgmt_fn_lun(sess->scst_sess, SCST_LUN_RESET,
-			(const uint8_t *)&lun, sizeof(lun), FALSE,
+			(const uint8_t *)&lun, sizeof(lun), false,
 			&dev_reset_completion);

 	/* Now wait for the completion ... */
@@ -713,7 +710,7 @@ static int scst_local_target_reset(struct scsi_cmnd=
 *SCpnt)
 	lun =3D cpu_to_be16(SCpnt->device->lun);

 	ret =3D scst_rx_mgmt_fn_lun(sess->scst_sess, SCST_TARGET_RESET,
-			(const uint8_t *)&lun, sizeof(lun), FALSE,
+			(const uint8_t *)&lun, sizeof(lun), false,
 			&dev_reset_completion);

 	/* Now wait for the completion ... */
@@ -795,7 +792,7 @@ static int scst_local_queuecommand(struct Scsi_Host=
 *SChost,
 	 */
 	lun =3D cpu_to_be16(SCpnt->device->lun);
 	scst_cmd =3D scst_rx_cmd(sess->scst_sess, (const uint8_t *)&lun,
-			       sizeof(lun), SCpnt->cmnd, SCpnt->cmd_len, TRUE);
+			       sizeof(lun), SCpnt->cmnd, SCpnt->cmd_len, true);
 	if (!scst_cmd) {
 		PRINT_ERROR("%s", "scst_rx_cmd() failed");
 		return -ENOMEM;
@@ -1214,7 +1211,7 @@ static void scst_local_release_adapter(struct dev=
ice *dev)

 	cancel_work_sync(&sess->aen_work);

-	scst_unregister_session(sess->scst_sess, TRUE, NULL);
+	scst_unregister_session(sess->scst_sess, true, NULL);

 	kfree(sess);

@@ -1292,7 +1289,7 @@ unregister_dev:
 	device_unregister(&sess->dev);

 unregister_session:
-	scst_unregister_session(sess->scst_sess, TRUE, NULL);
+	scst_unregister_session(sess->scst_sess, true, NULL);

 out_free:
 	kfree(sess);
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
