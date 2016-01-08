From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] hisi_sas: use u64 for qw0 in free_device_v1_hw()
Date: Thu, 7 Jan 2016 22:51:10 -0600
Message-ID: <AC4CAD57-D230-4F26-9DCB-2F1FCECBCC4E@linux.vnet.ibm.com>
References: <1450697709-120516-1-git-send-email-john.garry@huawei.com> <1450697709-120516-4-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:47192 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbcAHEvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2016 23:51:20 -0500
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 7 Jan 2016 23:51:18 -0500
In-Reply-To: <1450697709-120516-4-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

> On Dec 21, 2015, at 5:35 AM, John Garry <john.garry@huawei.com> wrote:
> 
> By reading in itct.qw0 into a 32b variable the top
> 32 bits were being lost.
> In practice this was OK as they were zeroes.
> 
> Fixes: 27a3f229 ("hisi_sas: Add cq interrupt")
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index 38ff575..057fdeb 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -539,7 +539,8 @@ static void free_device_v1_hw(struct hisi_hba *hisi_hba,
> {
> 	u64 dev_id = sas_dev->device_id;
> 	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
> -	u32 qw0, reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
> +	u64 qw0;

This should probably be a __le64, but not a big deal.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com> 

