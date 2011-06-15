From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch 2/4] SCSI: target: change lock to unlock
Date: Wed, 15 Jun 2011 09:40:16 -0700
Message-ID: <1308156016.20109.9.camel@haakon2.linux-iscsi.org>
References: <20110613200846.GI3583@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56093 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1FOQtB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 12:49:01 -0400
In-Reply-To: <20110613200846.GI3583@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, Joe Eykholt <jeykholt@cisco.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, target-devel <target-devel@vger.kernel.org>

On Mon, 2011-06-13 at 23:08 +0300, Dan Carpenter wrote:
> There is a typo here, it should be an unlock instead of a lock.  The
> original code will deadlock.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Committed as 3370a334b40 with a 'tcm_fc:' prefix for the commit message.

Thanks Dan!

--nab

> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index 03744c2..7491e21 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -332,7 +332,7 @@ void ft_sess_close(struct se_session *se_sess)
>  	lport = sess->tport->lport;
>  	port_id = sess->port_id;
>  	if (port_id == -1) {
> -		mutex_lock(&ft_lport_lock);
> +		mutex_unlock(&ft_lport_lock);
>  		return;
>  	}
>  	FT_SESS_DBG("port_id %x\n", port_id);

