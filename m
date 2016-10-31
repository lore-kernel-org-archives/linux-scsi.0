From: Jim Gill <jgill@vmware.com>
Subject: Re: [PATCH] vmw_pvscsi: return SUCCESS for successful command aborts
Date: Mon, 31 Oct 2016 22:04:16 +0000
Message-ID: <DM2PR0501MB1536D5BFF3BBE109199083C6CBAE0@DM2PR0501MB1536.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:55638 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S947365AbcJaWEZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Oct 2016 18:04:25 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "emilne@redhat.com" <emilne@redhat.com>, "djeffery@redhat.com" <djeffery@redhat.com>, pv-drivers <pv-drivers@vmware.com>


On Fri, 2016-10-28 at 12:27 -0400, David Jeffery wrote:
> The vmw_pvscsi driver reports most successful aborts as FAILED to the scs=
i
> error handler.  This is do to a misunderstanding of how completion_done()=
 works
> and its interaction with a successful wait using wait_for_completion_time=
out().
> The vmw_pvscsi driver is expecting completion_done() to always return tru=
e if
> complete() has been called on the completion structure.  But completion_d=
one()
> returns true after complete() has been called only if no function like
> wait_for_completion_timeout() has seen the completion and cleared it as p=
art of
> successfully waiting for the completion.
>=20
> Instead of using completion_done(), vmw_pvscsi should just use the return
> value from wait_for_completion_timeout() to know if the wait timed out or=
 not.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
>=20
> ---
>  vmw_pvscsi.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -793,6 +793,7 @@ static int pvscsi_abort(struct scsi_cmnd
>  	unsigned long flags;
>  	int result =3D SUCCESS;
>  	DECLARE_COMPLETION_ONSTACK(abort_cmp);
> +	int done;
> =20
>  	scmd_printk(KERN_DEBUG, cmd, "task abort on host %u, %p\n",
>  		    adapter->host->host_no, cmd);
> @@ -824,10 +825,10 @@ static int pvscsi_abort(struct scsi_cmnd
>  	pvscsi_abort_cmd(adapter, ctx);
>  	spin_unlock_irqrestore(&adapter->hw_lock, flags);
>  	/* Wait for 2 secs for the completion. */
> -	wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
> +	done =3D wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000)=
);
>  	spin_lock_irqsave(&adapter->hw_lock, flags);
> =20
> -	if (!completion_done(&abort_cmp)) {
> +	if (!done) {
>  		/*
>  		 * Failed to abort the command, unmark the fact that it
>  		 * was requested to be aborted.
> --

David, VMware prefers to update the module's version number as the driver i=
s updated. Would you
please update the PVSCSI_DRIVER_VERSION_STRING in vmx_pvscsi.h from 1.0.6.0=
-k to 1.0.7.0-k?
Otherwise the patch looks fine to us.=
