From: Nilesh Javali <nilesh.javali@qlogic.com>
Subject: Re: [patch] bnx2i: silence uninitialized variable warnings
Date: Mon, 18 Apr 2016 05:17:39 +0000
Message-ID: <D33A6B7E.204D4%nilesh.javali@qlogic.com>
References: <20160414094006.GB16891@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160414094006.GB16891@mwanda>
Content-Language: en-US
Content-ID: <140125C14B5A5146A0C745E8FF9CCA8B@namprd11.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 14/04/16 3:10 PM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>Presumably it isn't possible to have empty lists here, but my static
>checker doesn't know that and complains that "ep" can be used
>uninitialized.
>
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>index 7289437..133901f 100644
>--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>@@ -675,7 +675,7 @@ bnx2i_find_ep_in_ofld_list(struct bnx2i_hba *hba, u32
>iscsi_cid)
> {
> 	struct list_head *list;
> 	struct list_head *tmp;
>-	struct bnx2i_endpoint *ep;
>+	struct bnx2i_endpoint *ep = NULL;
> 
> 	read_lock_bh(&hba->ep_rdwr_lock);
> 	list_for_each_safe(list, tmp, &hba->ep_ofld_list) {
>@@ -703,7 +703,7 @@ bnx2i_find_ep_in_destroy_list(struct bnx2i_hba *hba,
>u32 iscsi_cid)
> {
> 	struct list_head *list;
> 	struct list_head *tmp;
>-	struct bnx2i_endpoint *ep;
>+	struct bnx2i_endpoint *ep = NULL;
> 
> 	read_lock_bh(&hba->ep_rdwr_lock);
> 	list_for_each_safe(list, tmp, &hba->ep_destroy_list) {

Acked-by: Nilesh Javali <nilesh.javali@qlogic.com>
