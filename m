From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 1/2] mpt3sas: Free memory pools before retrying to
 allocate with different value.
Date: Thu, 18 Feb 2016 13:54:02 +0100
Message-ID: <56C5BEEA.7030004@redhat.com>
References: <1455784786-19086-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425294AbcBRMyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2016 07:54:07 -0500
In-Reply-To: <1455784786-19086-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

On 18.2.2016 09:39, Suganath Prabu Subramani wrote:
> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>
> Deallocate resources before reallocating of the same in retry_allocation
> path of _base_allocate_memory_pools()
>
> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index afdb13a..5bbbbf2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -3414,6 +3414,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
>  			goto out;
>  		retry_sz = 64;
>  		ioc->hba_queue_depth -= retry_sz;
> +		_base_release_memory_pools(ioc);
>  		goto retry_allocation;
>  	}
>  

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

