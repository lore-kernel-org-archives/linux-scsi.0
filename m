From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: sg_reset can trigger a NULL pointer dereference in the SRP
	initiator
Date: Thu, 6 Aug 2009 09:39:45 +0200
Message-ID: <e2e108260908060039x7718577yf932d8a9188fe0cb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:55613 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZHFHjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 03:39:46 -0400
Received: by ewy10 with SMTP id 10so572153ewy.37
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2009 00:39:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Roland Dreier <rdreier@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, OpenIB <general@lists.openfabrics.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Aug 5, 2009 at 10:37 PM, James
Bottomley<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2009-08-05 at 19:54 +0200, Bart Van Assche wrote:
>> On Wed, Aug 5, 2009 at 7:44 PM, Roland Dreier<rdreier@cisco.com> wro=
te:
>> >
>> > =A0> The NULL pointer dereference happens when srp_reset_device() =
calls
>> > =A0> srp_send_tsk_mgmt(target, req, SRP_TSK_LUN_RESET) with
>> > =A0> req->scmnd->device =3D=3D NULL. When the sg_reset command iss=
ues an
>> > =A0> SG_SCSI_RESET ioctl, scsi_reset_provider() is invoked and all=
ocates an
>> > =A0> scmnd structure and sets scmnd->device to NULL. It is this sc=
mnd
>> > =A0> structure that is passed to srp_reset_device(). What I'm not =
sure
>> > =A0> about is whether scsi_reset_provider() should set req->scmnd-=
>device
>> > =A0> to a non-NULL value or whether srp_send_tsk_mgmt() should be =
able to
>> > =A0> handle the condition req->scmnd->device =3D=3D NULL.
>> >
>> > Well, I don't see how the reset ioctl can do anything useful unles=
s it
>> > passes a device in with the scsi command -- otherwise for example
>> > srp_reset_device() has no idea what LUN to try and reset.
>>
>> (added linux-scsi in CC)
>>
>> I hope one of the SCSI people can tell us whether the behavior that
>> scsi_reset_provider()
>> passes the value NULL in req->scmnd->device to
>> scsi_try_bus_device_reset() is correct ?
>
> Need more information.
>
> cmd->device is supposed to be initialised in scsi_get_command(), whic=
h
> scsi_reset_provider() calls ... why do you think it got set to null?

This thread started with the observation that it is easy to trigger a
NULL pointer dereference in the SRP initiator
(http://bugzilla.kernel.org/show_bug.cgi?id=3D13893). The following
sequence is sufficient:
* Remove the ib_srp kernel module (doing so closes all active SRP sessi=
ons).
* Insert the ib_srp kernel module.
* Create a new SRP connection.
* Issue the sg_reset -d ${srp_device} command in a shell.
The sg_reset command issues an SG_SCSI_RESET ioctl. This ioctl is
processed by invoking scsi_reset_provider(), which in turns invokes
the eh_device_reset_handler method of the SRP initiator. Further
analysis showed that scsi_reset_provider() passes a non-NULL
cmd->device pointer to the SRP initiator, but that the SRP initiator
does not use this value. Instead srp_find_req() looks up a struct
srp_request pointer based on the struct scsi_cmnd * argument and
continues with the struct scsi_cmnd pointer contained in the struct
srp_request.

While I'm not sure that the patch below makes any sense, it makes the
NULL pointer dereference disappear. This made me wonder which
assumptions srp_find_req() is based on ?

--- linux-2.6.30.4/drivers/infiniband/ulp/srp/ib_srp-orig.c
2009-08-03 12:13:11.000000000 +0200
+++ linux-2.6.30.4/drivers/infiniband/ulp/srp/ib_srp.c  2009-08-06
08:50:30.000000000 +0200
@@ -1325,16 +1325,19 @@ static int srp_cm_handler(struct ib_cm_i
 }

 static int srp_send_tsk_mgmt(struct srp_target_port *target,
+                            struct scsi_cmnd *scmnd,
                             struct srp_request *req, u8 func)
 {
        struct srp_iu *iu;
        struct srp_tsk_mgmt *tsk_mgmt;

+       BUG_ON(!scmnd->device);
+
        spin_lock_irq(target->scsi_host->host_lock);

        if (target->state =3D=3D SRP_TARGET_DEAD ||
            target->state =3D=3D SRP_TARGET_REMOVED) {
-               req->scmnd->result =3D DID_BAD_TARGET << 16;
+               scmnd->result =3D DID_BAD_TARGET << 16;
                goto out;
        }

@@ -1348,7 +1351,7 @@ static int srp_send_tsk_mgmt(struct srp_
        memset(tsk_mgmt, 0, sizeof *tsk_mgmt);

        tsk_mgmt->opcode        =3D SRP_TSK_MGMT;
-       tsk_mgmt->lun           =3D cpu_to_be64((u64)
req->scmnd->device->lun << 48);
+       tsk_mgmt->lun           =3D cpu_to_be64((u64) scmnd->device->lu=
n << 48);
        tsk_mgmt->tag           =3D req->index | SRP_TAG_TSK_MGMT;
        tsk_mgmt->tsk_mgmt_func =3D func;
        tsk_mgmt->task_tag      =3D req->index;
@@ -1395,7 +1398,7 @@ static int srp_abort(struct scsi_cmnd *s
                return FAILED;
        if (srp_find_req(target, scmnd, &req))
                return FAILED;
-       if (srp_send_tsk_mgmt(target, req, SRP_TSK_ABORT_TASK))
+       if (srp_send_tsk_mgmt(target, scmnd, req, SRP_TSK_ABORT_TASK))
                return FAILED;

        spin_lock_irq(target->scsi_host->host_lock);
@@ -1425,7 +1428,9 @@ static int srp_reset_device(struct scsi_
                return FAILED;
        if (srp_find_req(target, scmnd, &req))
                return FAILED;
-       if (srp_send_tsk_mgmt(target, req, SRP_TSK_LUN_RESET))
+       if (WARN_ON(!scmnd->device))
+               return FAILED;
+       if (srp_send_tsk_mgmt(target, scmnd, req, SRP_TSK_LUN_RESET))
                return FAILED;
        if (req->tsk_status)
                return FAILED;

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
