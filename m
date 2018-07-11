From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH][scsi-next] scsi: lpfc: fix null pointer dereference on
 nvmebuf
Date: Wed, 11 Jul 2018 07:35:30 -0700
Message-ID: <1531319730.3260.1.camel@linux.vnet.ibm.com>
References: <20180711134436.21963-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711134436.21963-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2018-07-11 at 14:44 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check of nvmebuf suggests that it can be null, however a recent
> change dereferences it to determine oxid before it is null checked,
> hence there is a potential null deference on the pointer.  Fix this
> by performing the null check first.  Also remove the oxid from the
> debug log message as this is no longer valid.  I considered an early
> fetch of oxid if nvmebuf was valid, however, what oxid should be set
> to if nvembuf is null could lead to an ambiguous logging of an
> invalid
> oxid, so I thought just removing it from the logging was the least
> confusion solution.
> 
> Detected by CoverityScan, CID#1471753 ("Dereference before null
> check")
> 
> Fixes: 68c9b55deea5 ("scsi: lpfc: Fix abort error path for NVMET")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/lpfc/lpfc_nvmet.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c
> b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 22f8a204b69f..01652d9ac619 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -1742,12 +1742,9 @@ lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba
> *phba, struct lpfc_sli_ring *pring,
>  	uint32_t *payload;
>  	uint32_t size, oxid, sid, rc;
>  
> -	fc_hdr = (struct fc_frame_header *)(nvmebuf->hbuf.virt);
> -	oxid = be16_to_cpu(fc_hdr->fh_ox_id);
> -
>  	if (!nvmebuf || !phba->targetport) {

The !nvmebuf is a bogus check, isn't it? since nvmebuf is always
obtained from a container_of, it can never be NULL.  This would mean
the rest of the contortions are unnecessary.

James
