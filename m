From: Frederic Barrat <fbarrat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 10/38] cxlflash: Setup AFU PASID
Date: Thu, 22 Mar 2018 17:23:40 +0100
Message-ID: <4293e697-78fa-7c92-20a6-213b7b60d586@linux.vnet.ibm.com>
References: <1519683513-16731-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1519683693-17113-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1519683693-17113-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Content-Language: fr
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Christophe Lombard <clombard@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
List-Id: linux-scsi@vger.kernel.org



Le 26/02/2018 à 23:21, Uma Krishnan a écrit :
> Per the OCXL specification, the maximum PASID supported by the AFU is
> indicated by a field within the configuration space. Similar to acTags,
> implementations can choose to use any sub-range of PASID within their
> assigned range. For cxlflash, the entire range is used.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---

It sure helps to know you've got only one function/AFU :-)

Reviewed-by: Frederic Barrat <fbarrat@linux.vnet.ibm.com>

>   drivers/scsi/cxlflash/ocxl_hw.c | 3 +++
>   drivers/scsi/cxlflash/ocxl_hw.h | 2 ++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.c b/drivers/scsi/cxlflash/ocxl_hw.c
> index d01847d9..bd86eef 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.c
> +++ b/drivers/scsi/cxlflash/ocxl_hw.c
> @@ -111,6 +111,9 @@ static int ocxlflash_config_afu(struct pci_dev *pdev, struct ocxl_hw_afu *afu)
>   	dev_dbg(dev, "%s: acTag base=%d enabled=%d\n", __func__, base, count);
>   	afu->afu_actag_base = base;
>   	afu->afu_actag_enabled = count;
> +	afu->max_pasid = 1 << acfg->pasid_supported_log;
> +
> +	ocxl_config_set_afu_pasid(pdev, pos, 0, acfg->pasid_supported_log);
>   out:
>   	return rc;
>   }
> diff --git a/drivers/scsi/cxlflash/ocxl_hw.h b/drivers/scsi/cxlflash/ocxl_hw.h
> index 9c675fa..a6f7796 100644
> --- a/drivers/scsi/cxlflash/ocxl_hw.h
> +++ b/drivers/scsi/cxlflash/ocxl_hw.h
> @@ -24,4 +24,6 @@ struct ocxl_hw_afu {
>   	int fn_actag_enabled;		/* Function acTag number enabled */
>   	int afu_actag_base;		/* AFU acTag base */
>   	int afu_actag_enabled;		/* AFU acTag number enabled */
> +
> +	int max_pasid;			/* Maximum number of contexts */
>   };
> 
