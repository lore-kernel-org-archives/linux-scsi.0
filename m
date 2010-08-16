From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: fix use-after-free in scsi_init_io()
Date: Mon, 16 Aug 2010 10:06:26 -0500
Message-ID: <1281971186.8326.1.camel@mulgrave.site>
References: <4C6947E5.2080208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0HPPGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2010 11:06:31 -0400
In-Reply-To: <4C6947E5.2080208@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, stable@kernel.org

On Mon, 2010-08-16 at 16:15 +0200, Tejun Heo wrote:
> scsi_init_io() dereferences scsi_cmnd after putting it in the error
> path leading to oops.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@kernel.org
> ---
>  drivers/scsi/scsi_lib.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: block/drivers/scsi/scsi_lib.c
> ===================================================================
> --- block.orig/drivers/scsi/scsi_lib.c
> +++ block/drivers/scsi/scsi_lib.c
> @@ -968,7 +968,9 @@ static int scsi_init_sgtable(struct requ
>   */
>  int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  {
> +	struct request *req = cmd->request;
>  	int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
> +
>  	if (error)
>  		goto err_exit;
> 
> @@ -1012,7 +1014,7 @@ int scsi_init_io(struct scsi_cmnd *cmd,
>  err_exit:
>  	scsi_release_buffers(cmd);
>  	scsi_put_command(cmd);
> -	cmd->request->special = NULL;
> +	req->special = NULL;

Thanks for the bug report.  The fix is a bit heavy handed; what about
this?

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ade720..ee02d38 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1011,8 +1011,8 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 err_exit:
 	scsi_release_buffers(cmd);
-	scsi_put_command(cmd);
 	cmd->request->special = NULL;
+	scsi_put_command(cmd);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);


