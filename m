From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V3 01/11] megaraid_sas: Add new pci device Ids for SAS3.5
 Generic Megaraid Controllers
Date: Tue, 6 Dec 2016 17:01:56 +0100
Message-ID: <4e332ea6-1285-2d3c-0632-4f608a6ccd9b@redhat.com>
References: <1480955261-178967-1-git-send-email-sasikumar.pc@broadcom.com>
 <1480955261-178967-2-git-send-email-sasikumar.pc@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480955261-178967-2-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 5.12.2016 17:27, Sasikumar Chandrasekaran wrote:
> This patch contains new pci device ids for SAS3.5 Generic Megaraid Controllers
>
> Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        | 11 ++++++++++-
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 20 ++++++++++++++++++-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 30 ++++++++++++++++++++++-------
>  3 files changed, 52 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 0d2625b..f24ce88 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -56,6 +56,14 @@
>  #define PCI_DEVICE_ID_LSI_INTRUDER_24		0x00cf
>  #define PCI_DEVICE_ID_LSI_CUTLASS_52		0x0052
>  #define PCI_DEVICE_ID_LSI_CUTLASS_53		0x0053
> +#define PCI_DEVICE_ID_LSI_MECTOR		    0x00D4
> +#define PCI_DEVICE_ID_LSI_VENTURA		    0x0014
> +#define PCI_DEVICE_ID_LSI_CRUSADER		    0x0015

Nack.

This is not good, my test system panics instead of booting.
megaraid_sas 0000:02:0e.0: RDPQ mode	: (disabled)
BUG: unable to handle kernel paging request at 0000000000001e78
IP: [<ffffffffa0321321>] megasas_issue_init_mfi+0x171/0x270 [megaraid_sas]


you are already having a device with same device value in your pci_table  
(PCI_DEVICE_ID_DELL_PERC5 is also 0x15), so fix the switch in  megasas_probe_one.

Cheers,
tomash


(when sending new fixed versions, please add to the changed patches a text explaining
what was changed in which version, like so - www.spinics.net/lists/linux-scsi/msg102122.html)


>  
> @@ -5723,6 +5732,15 @@ static int megasas_probe_one(struct pci_dev *pdev,
>  	instance->pdev = pdev;
>  
>  	switch (instance->pdev->device) {
> +	case PCI_DEVICE_ID_LSI_VENTURA:
> +	case PCI_DEVICE_ID_LSI_MARLIN:
> +	case PCI_DEVICE_ID_LSI_MECTOR:
> +	case PCI_DEVICE_ID_LSI_CRUSADER:
> +	case PCI_DEVICE_ID_LSI_HARPOON:
> +	case PCI_DEVICE_ID_LSI_TOMCAT:
> +	case PCI_DEVICE_ID_LSI_VENTURA_4PORT:
> +	case PCI_DEVICE_ID_LSI_CRUSADER_4PORT:
> +	     instance->is_ventura = true;
>  	case PCI_DEVICE_ID_LSI_FUSION:
>  	case PCI_DEVICE_ID_LSI_PLASMA:
>  	case PCI_DEVICE_ID_LSI_INVADER:
