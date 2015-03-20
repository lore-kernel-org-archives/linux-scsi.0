From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 15/15] iscsi-target: don't export static symbol
Date: Fri, 20 Mar 2015 11:42:12 -0700
Message-ID: <1426876932.16687.5.camel@haakon3.risingtidesystems.com>
References: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1426092997-30605-16-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1426092997-30605-16-git-send-email-Julia.Lawall@lip6.fr>
Sender: target-devel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-03-11 at 17:56 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> type T;
> identifier f;
> @@
> 
> static T f (...) { ... }
> 
> @@
> identifier r.f;
> declarer name EXPORT_SYMBOL;
> @@
> 
> -EXPORT_SYMBOL(f);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/target/iscsi/iscsi_target.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff -u -p a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -2155,7 +2155,6 @@ reject:
>  	cmd->text_in_ptr = NULL;
>  	return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
>  }
> -EXPORT_SYMBOL(iscsit_handle_text_cmd);
>  
>  int iscsit_logout_closesession(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>  {
> 

Applied to target-pending/for-next.

Thanks Julia!

--nab
