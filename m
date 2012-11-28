From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/1] iscsi_target: Remove redundant null check before
 kfree
Date: Tue, 27 Nov 2012 18:51:55 -0800
Message-ID: <1354071115.18736.99.camel@haakon2.linux-iscsi.org>
References: <1353494680-29476-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47038 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2K1Cv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Nov 2012 21:51:59 -0500
In-Reply-To: <1353494680-29476-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, patches@linaro.org

Hi Sachin,

On Wed, 2012-11-21 at 16:14 +0530, Sachin Kamat wrote:
> kfree on null pointer is a no-op.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---

Apologies for the delayed response.  Applied to target-pending/for-next.

Thank you!

--nab

>  drivers/target/iscsi/iscsi_target_login.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 7bf9ccc..fdb632f 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1118,10 +1118,8 @@ new_sess_out:
>  		idr_remove(&sess_idr, conn->sess->session_index);
>  		spin_unlock_bh(&sess_idr_lock);
>  	}
> -	if (conn->sess->sess_ops)
> -		kfree(conn->sess->sess_ops);
> -	if (conn->sess)
> -		kfree(conn->sess);
> +	kfree(conn->sess->sess_ops);
> +	kfree(conn->sess);
>  old_sess_out:
>  	iscsi_stop_login_thread_timer(np);
>  	/*


