From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 5/8] megaraid_sas: Send SYNCHRONIZE_CACHE for VD to
 firmware
Date: Mon, 24 Oct 2016 16:36:07 +0200
Message-ID: <86780024-ea65-1137-a78f-674055267edc@suse.de>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
 <1477056816-7058-6-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54111 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932346AbcJXOgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:36:10 -0400
In-Reply-To: <1477056816-7058-6-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

On 10/21/2016 03:33 PM, Kashyap Desai wrote:
> From previous patch we have below changes in v2 (only for Virtual Disk)-
> 1.  Updated change log.  Provided more detail in change log.
> 2.  Agreed to remove module parameter. If we remove module parameter, we
>     can ask customer to disable WCE on drive to get similar impact.
> 3.  Always Send SYNCHRONIZE_CACHE  for JBOD (non Raid) Device to Firmware.
>
> Current megaraid_sas driver returns SYNCHRONIZE_CACHE(related to Drive
> Cache)  command  back to SCSI layer without sending it down to firmware as
> firmware supposed to take care of flushing disk cache for all drives
> belongs to Virtual Disk at the time of system reboot/shutdown.
>
> We evaluate and understood that for Raid Volume, why driver should not
> send SYNC_CACHE command to the Firmware.
> There may be a some reason in past, but now it looks to be not required and
> we have fixed this issue as part of this patch.
>
>  - Additional background -
> There are some instance of MegaRaid FW (E.a Gen2 and Gen2.5 FW) set WCE bit
> for Virtual Disk but firmware does not reply correct status for SYNCH_CACHE.
> It is very difficult to find out which Device ID and firmware has capability
> to manage SYNC_CACHE, so we managed to figure out which are the new firmware
> (canHandleSyncCache is set in scratch pad register at 0xB4) and use that
> interface for correct behavior as explained above.
>
> E.g Liberator/Thunderbolt MegaRaid FW returns SYNC_CACHE as Unsupported
> command (this is a firmware bug) and eventually command will be failed to SML.
> This will cause File system to go Read-only.
>
>  - New behavior described -
>
> IF application requests SYNCH_CACHE
>    IF 'JBOD'
>               Driver sends SYNCH_CACHE command to the FW
>                FW sends SYNCH_CACHE to drive
>                FW obtains status from drive and returns same status back to driver
>    ELSEIF 'VirtualDisk'
>                IF any FW which supports new API bit called canHandleSyncCache
>                               Driver sends SYNCH_CACHE command to the FW
>                               FW does not send SYNCH_CACHE to drives
>                               FW returns SUCCESS
>                ELSE
>                               Driver does not send SYNCH_CACHE command to the FW.
>                               Driver return SUCCESS for that command.
>                ENDIF
>     ENDIF
> ENDIF
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        | 3 +++
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 7 ++-----
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++++
>  3 files changed, 10 insertions(+), 5 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
