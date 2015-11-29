From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Fix regression introduced by configFS changes
Date: Sat, 28 Nov 2015 20:05:45 -0800
Message-ID: <1448769945.579.4.camel@haakon3.risingtidesystems.com>
References: <1448385615-18246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47412 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbbK2EF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Nov 2015 23:05:57 -0500
In-Reply-To: <1448385615-18246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

Hi Himanshu & Co,

On Tue, 2015-11-24 at 12:20 -0500, Himanshu Madhani wrote:
> this patch fixes following regression
> 
>  # targetcli
>  [Errno 13] Permission denied: '/sys/kernel/config/target/qla2xxx/21:00:00:0e:1e:08:c7:20/tpgt_1/enable'
> 
> Fixes: 2eafd72939fd ("target: use per-attribute show and store methods")
> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 3ba2e95..81af294 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -902,7 +902,7 @@ static ssize_t tcm_qla2xxx_tpg_fabric_prot_type_show(struct config_item *item,
>  	return sprintf(page, "%d\n", tpg->tpg_attrib.fabric_prot_type);
>  }
>  
> -CONFIGFS_ATTR_WO(tcm_qla2xxx_tpg_, enable);
> +CONFIGFS_ATTR(tcm_qla2xxx_tpg_, enable);
>  CONFIGFS_ATTR_RO(tcm_qla2xxx_tpg_, dynamic_sessions);
>  CONFIGFS_ATTR(tcm_qla2xxx_tpg_, fabric_prot_type);
>  

Applied to target-pending/master, and including in v4.4-rc fixes PULL.

Thanks for reporting.

--nab

