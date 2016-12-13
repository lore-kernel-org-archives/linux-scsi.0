From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: version 3.18.44 to 3.18.45 introduced a bug in
 "drivers/scsi/megaraid/megaraid_sas_base.c"
Date: Tue, 13 Dec 2016 08:08:27 -0800
Message-ID: <a9788b9c-6361-f79e-f851-e8c4871571cb@infradead.org>
References: <23B7B563BA4E9446B962B142C86EF24ADB6F24@CNMAILEX03.lenovo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <23B7B563BA4E9446B962B142C86EF24ADB6F24@CNMAILEX03.lenovo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dashi DS1 Cao <caods1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[adding other lists + gregkh]


On 12/13/16 02:56, Dashi DS1 Cao wrote:
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1614,16 +1614,13 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>                 goto out_done;
>         }
> 
> -       switch (scmd->cmnd[0]) {
> -       case SYNCHRONIZE_CACHE:
> -               /*
> -                * FW takes care of flush cache on its own
> -                * No need to send it down
> -                */
> +       /*
> +        * FW takes care of flush cache on its own for Virtual Disk.
> +        * No need to send it down for VD. For JBOD send SYNCHRONIZE_CACHE to FW.
> +        */
> +       if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd)) {
>                 scmd->result = DID_OK << 16;
>                 goto out_done;
> -       default:
> -               break;
>         }
> 
>         if (instance->instancet->build_and_issue_cmd(instance, scmd)) {
> 
> MEGASAS_IS_LOGICAL is defined to be a macro with '?' operator, which has a lower precedence than '&&'.
> The macro should have been defined as:
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1823,7 +1823,7 @@ struct megasas_instance_template {
>  };
> 
>  #define MEGASAS_IS_LOGICAL(scp)                                                \
> -       (scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
> +       ((scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1)
> 
>  #define MEGASAS_DEV_INDEX(inst, scp)                                   \
>         ((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +    \
> 
> Dashi Cao
> 


-- 
~Randy
