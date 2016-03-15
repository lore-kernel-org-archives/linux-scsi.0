From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 3/3] megaraid_sas: add missing curly braces in ioctl handler
Date: Tue, 15 Mar 2016 16:38:57 +0530
Message-ID: <474b70a333b44b94018745134c3340d2@mail.gmail.com>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de> <1457965789-3373916-4-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457965789-3373916-4-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, megaraidlinux.pdl@avagotech.com
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, March 14, 2016 8:00 PM
> To: martin.petersen@oracle.com; James.Bottomley@HansenPartnership.com;
> Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Arnd
Bergmann;
> Tomas Henzl; Bjorn Helgaas; megaraidlinux.pdl@avagotech.com
> Subject: [PATCH 3/3] megaraid_sas: add missing curly braces in ioctl
handler
>
> gcc-6 found a dubious indentation in the megasas_mgmt_fw_ioctl
> function:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function
> 'megasas_mgmt_fw_ioctl':
> drivers/scsi/megaraid/megaraid_sas_base.c:6658:4: warning: statement is
> indented as if it were guarded by... [-Wmisleading-indentation]
>     kbuff_arr[i] = NULL;
>     ^~~~~~~~~
> drivers/scsi/megaraid/megaraid_sas_base.c:6653:3: note: ...this 'if'
clause, but
> it is not
>    if (kbuff_arr[i])
>    ^~
>
> The code is actually correct, as there is no downside in clearing a NULL
pointer
> again.
>
> This clarifies the code and avoids the warning by adding extra curly
braces.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 90dc9d98f01b ("megaraid_sas : MFI MPT linked list corruption
fix")
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 5c08568ccfbf..2627200d4f82 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6650,12 +6650,13 @@ out:
>  	}
>
>  	for (i = 0; i < ioc->sge_count; i++) {
> -		if (kbuff_arr[i])
> +		if (kbuff_arr[i]) {
>  			dma_free_coherent(&instance->pdev->dev,
>
le32_to_cpu(kern_sge32[i].length),
>  					  kbuff_arr[i],
>
> le32_to_cpu(kern_sge32[i].phys_addr));
>  			kbuff_arr[i] = NULL;
> +		}
>  	}
>
>  	megasas_return_cmd(instance, cmd);

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> --
> 2.7.0
