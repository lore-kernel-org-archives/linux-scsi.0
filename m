From: Gabriel C <nix.or.die@gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.9-rc3
Date: Fri, 11 Nov 2016 04:30:48 +0100
Message-ID: <1eee17da-1166-6a48-8a21-0ad5d6a0660a@gmail.com>
References: <1478352591.2858.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1478352591.2858.5.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 05.11.2016 14:29, James Bottomley wrote:


...

> Kashyap Desai (1):
>       scsi: megaraid_sas: Fix data integrity failure for JBOD (passthrough) devices
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 9ff57de..d8b1fbd 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1700,16 +1700,13 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  		goto out_done;
>  	}
>  
> -	switch (scmd->cmnd[0]) {
> -	case SYNCHRONIZE_CACHE:
> -		/*
> -		 * FW takes care of flush cache on its own
> -		 * No need to send it down
> -		 */
> +	/*
> +	 * FW takes care of flush cache on its own for Virtual Disk.
> +	 * No need to send it down for VD. For JBOD send SYNCHRONIZE_CACHE to FW.
> +	 */
> +	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd)) {
>  		scmd->result = DID_OK << 16;
>  		goto out_done;
> -	default:
> -		break;
>  	}
>  
>  	return instance->instancet->build_and_issue_cmd(instance, scmd);

This patch breaks my box.. I'm not able to boot it anymore.
It seems with this patch I have /dev/sda[a-z] to /dev/sdz[a-z] ?!?

I'm not sure how to get an log since dracut times out and I'm dropped , after a very long time
of probing 'ghost devices', in a emercency shell, journalctl doesn't work also..

After reverting this one I can boot normal.

Box is a FUJITSU PRIMERGY TX200 S5..

This is from an working kernel..

[    5.119371] megaraid_sas 0000:01:00.0: FW now in Ready state
[    5.119418] megaraid_sas 0000:01:00.0: firmware supports msix        : (0)
[    5.119420] megaraid_sas 0000:01:00.0: current msix/online cpus      : (1/16)
[    5.119422] megaraid_sas 0000:01:00.0: RDPQ mode     : (disabled)
[    5.123100] ehci-pci 0000:00:1a.7: cache line size of 32 is not supported
[    5.123113] ehci-pci 0000:00:1a.7: irq 18, io mem 0xb0020000

...

[    5.208063] megaraid_sas 0000:01:00.0: controller type       : MR(256MB)
[    5.208065] megaraid_sas 0000:01:00.0: Online Controller Reset(OCR)  : Enabled
[    5.208067] megaraid_sas 0000:01:00.0: Secure JBOD support   : No
[    5.208070] megaraid_sas 0000:01:00.0: megasas_init_mfi: fw_support_ieee=0
[    5.208073] megaraid_sas 0000:01:00.0: INIT adapter done
[    5.208075] megaraid_sas 0000:01:00.0: Jbod map is not supported megasas_setup_jbod_map 4967
[    5.230163] megaraid_sas 0000:01:00.0: MR_DCMD_PD_LIST_QUERY failed/not supported by firmware
[    5.252080] megaraid_sas 0000:01:00.0: DCMD not supported by firmware - megasas_ld_list_query 4369
[    5.274086] megaraid_sas 0000:01:00.0: pci id                : (0x1000)/(0x0060)/(0x1734)/(0x10f9)
[    5.274089] megaraid_sas 0000:01:00.0: unevenspan support    : no
[    5.274090] megaraid_sas 0000:01:00.0: firmware crash dump   : no
[    5.274092] megaraid_sas 0000:01:00.0: jbod sync map         : no
[    5.274094] scsi host0: Avago SAS based MegaRAID driver
[    5.280022] scsi 0:0:6:0: Direct-Access     ATA      WDC WD5002ABYS-5 3B06 PQ: 0 ANSI: 5
[    5.282153] scsi 0:0:7:0: Direct-Access     ATA      WDC WD5002ABYS-5 3B06 PQ: 0 ANSI: 5
[    5.285180] scsi 0:0:10:0: Direct-Access     ATA      ST500NM0011      FTM6 PQ: 0 ANSI: 5
[    5.369885] scsi 0:2:0:0: Direct-Access     LSI      MegaRAID SAS RMB 1.40 PQ: 0 ANSI: 5

..

Please let me know if you need more infos and/or want me to test patches.


Best Regards,

Gabriel C
