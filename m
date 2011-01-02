From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC 6/8] IB/srp: reduce lock coverage of command completion
Date: Sun, 2 Jan 2011 18:27:36 +0100
Message-ID: <AANLkTikBkdn6XWgJELaBBFi1ZHen+UwQuumDn+yEPDPg@mail.gmail.com>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov> <1293139893-11678-7-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55661 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1ABR15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2011 12:27:57 -0500
In-Reply-To: <1293139893-11678-7-git-send-email-dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Dec 23, 2010 at 10:31 PM, David Dillow <dillowda@ornl.gov> wrot=
e:
> [ ... ]
> @@ -913,14 +917,6 @@ static void srp_process_rsp(struct srp_target_po=
rt *target, struct srp_rsp *rsp)
> =A0{
> =A0 =A0 =A0 =A0struct srp_request *req;
> =A0 =A0 =A0 =A0struct scsi_cmnd *scmnd;
> - =A0 =A0 =A0 unsigned long flags;
> - =A0 =A0 =A0 s32 delta;
> -
> - =A0 =A0 =A0 delta =3D (s32) be32_to_cpu(rsp->req_lim_delta);
> -
> - =A0 =A0 =A0 spin_lock_irqsave(target->scsi_host->host_lock, flags);
> -
> - =A0 =A0 =A0 target->req_lim +=3D delta;
>
> =A0 =A0 =A0 =A0if (unlikely(rsp->tag & SRP_TAG_TSK_MGMT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0target->tsk_mgmt_status =3D -1;
> @@ -948,12 +944,10 @@ static void srp_process_rsp(struct srp_target_p=
ort *target, struct srp_rsp *rsp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (rsp->flags & (SRP_RSP_FLAG_DI=
OVER | SRP_RSP_FLAG_DIUNDER))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_set_resid(scmnd, =
be32_to_cpu(rsp->data_in_res_cnt));
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_remove_req(target, req, be32_to_cpu=
(rsp->req_lim_delta));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scmnd->host_scribble =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scmnd->scsi_done(scmnd);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 srp_remove_req(target, req);
> =A0 =A0 =A0 =A0}
> -
> - =A0 =A0 =A0 spin_unlock_irqrestore(target->scsi_host->host_lock, fl=
ags);
> =A0}
>
> =A0[ ... ]

Hello Dave,

Before this patch target->req_lim was updated both when receiving a
response for a regular SRP command and when receiving a response for
an SRP task management command. This patch modifies that in only
updating target->req_lim in the former case. Are you sure that's
correct ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
