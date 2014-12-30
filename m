From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: [PATCH] lpfc: correct device removal deadlock after link bounce
Date: Tue, 30 Dec 2014 12:15:32 -0500
Message-ID: <CAAzz28gouFW=2JBcLK+sZb-6-k+-kYhWFRH6prF5kUawgTrchg@mail.gmail.com>
References: <1419959338.1683.1.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:64364 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaL3RPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 12:15:33 -0500
Received: by mail-la0-f51.google.com with SMTP id ms9so12810388lab.38
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 09:15:32 -0800 (PST)
In-Reply-To: <1419959338.1683.1.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, "loberman@redhat.com" <loberman@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch was tested in house at Red Hat and is running in test
kernels at a couple of Red Hat customers.
James, thanks for sending it upstream.
Laurence

On Tue, Dec 30, 2014 at 12:08 PM, James Smart <james.smart@emulex.com> wrote:
> This patch, applicable to 8G/4G/2G adapters, adds a call that
> resumes transmit operations after a link bounce. Without it, targets
> that tried to suspend exchanges after a link bounce (such as tape devices
> using sequence level error recovery) would never resume io operation,
> causing scan failures, and eventually deadlocks if a device removal
> request is made.
>
> The patches were cut against Christoph's scsi-queue.git,
> branch "drivers-for-3.18".  The driver rev cut against is 10.4.8000.0
>
> -- james s
>
>
> Signed-off-by: James Smart <james.smart@emulex.com>
> Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
> ---
>  lpfc_els.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> --- a/drivers/scsi/lpfc/lpfc_els.c      2014-12-29 12:48:08.000000000 -0500
> +++ b/drivers/scsi/lpfc/lpfc_els.c      2014-12-30 11:23:04.344426606 -0500
> @@ -2225,6 +2225,15 @@ lpfc_adisc_done(struct lpfc_vport *vport
>         if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
>             !(vport->fc_flag & FC_RSCN_MODE) &&
>             (phba->sli_rev < LPFC_SLI_REV4)) {
> +               /* The ADISCs are complete.  Doesn't matter if they
> +                * succeeded or failed because the ADISC completion
> +                * routine guarantees to call the state machine and
> +                * the RPI is either unregistered (failed ADISC response)
> +                * or the RPI is still valid and the node is marked
> +                * mapped for a target.  The exchanges should be in the
> +                * correct state. This code is specific to SLI3.
> +                */
> +               lpfc_issue_clear_la(phba, vport);
>                 lpfc_issue_reg_vpi(phba, vport);
>                 return;
>         }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
