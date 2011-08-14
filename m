From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: use after free in error handling
Date: Sat, 13 Aug 2011 22:36:05 -0700
Message-ID: <1313300165.16439.45.camel@haakon2.linux-iscsi.org>
References: <20110809123006.GJ7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45818 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab1HNFpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2011 01:45:50 -0400
In-Reply-To: <20110809123006.GJ7659@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Tue, 2011-08-09 at 15:30 +0300, Dan Carpenter wrote:
> iscsit_release_cmd() frees the memory that "se_cmd" was pointing to
> so this is a use after free bug.  Also "se_cmd" is non-null here so I
> removed the unneeded null check.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Hi Dan,

Apologies for the delay here..

> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index a1acb01..bea5c29 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -297,9 +297,8 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
>  
>  	return cmd;
>  out:
> +	transport_free_se_cmd(se_cmd);
>  	iscsit_release_cmd(cmd);
> -	if (se_cmd)
> -		transport_free_se_cmd(se_cmd);
>  	return NULL;
>  }
>  

So the transport_free_se_cmd() call is not necessary as this point, and
can be safely dropped with the single call to iscsit_release_cmd().

Committing the following patch into lio-core-2.6.git with one additional
missing case in iscsit_allocate_se_cmd_for_tmr().

Thank you,

--nab

commit 81d779b23ef4e33a40f558843af5122cccb2f913
Author: Dan Carpenter <error27@gmail.com>
Date:   Sat Aug 13 22:35:00 2011 -0700

    iscsi-target: Fix iscsit_allocate_se_cmd_for_tmr failure path bugs
    
    This patch fixes two bugs in allocation failure handling in
    iscsit_allocate_se_cmd_for_tmr():
    
    This first reported by DanC is a free-after call to transport_free_se_cmd(), this
    patch drops the transport_free_se_cmd() call all together, as iscsit_release_cmd()
    will release existing allocations as expected.
    
    The second is a bug where iscsi_cmd_t was being leaked on a cmd->tmr_req allocation
    failure, so make this jump to iscsit_release_cmd() as well.
    
    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index a9e7add..20242b5 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -243,7 +243,7 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
        if (!cmd->tmr_req) {
                pr_err("Unable to allocate memory for"
                        " Task Management command!\n");
-               return NULL;
+               goto out;
        }
        /*
         * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -298,8 +298,6 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
        return cmd;
 out:
        iscsit_release_cmd(cmd);
-       if (se_cmd)
-               transport_free_se_cmd(se_cmd);
        return NULL;
 }
 






