From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] ahci_xgene: Fix the dma state machine lockup for
 the ATA_CMD_PACKET PIO mode command.
Date: Tue, 16 Dec 2014 20:33:36 +0300
Message-ID: <54906CF0.9010908@cogentembedded.com>
References: <1418748575-27301-1-git-send-email-stripathi@apm.com> <1418748575-27301-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:65064 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaLPRdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2014 12:33:40 -0500
Received: by mail-la0-f50.google.com with SMTP id pn19so11710302lab.37
        for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2014 09:33:38 -0800 (PST)
In-Reply-To: <1418748575-27301-3-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com

Hello.

On 12/16/2014 07:49 PM, Suman Tripathi wrote:

> This patch addresses the issue with ATA_CMD_PACKET pio mode
> command for enumeration and device detection with ATAPI devices.It is the
> same issue as in patch

> www.spinics.net/lists/linux-ide/msg49092.html

> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   drivers/ata/ahci_xgene.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)

> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> index 0ffd3c9..9730907 100644
> --- a/drivers/ata/ahci_xgene.c
> +++ b/drivers/ata/ahci_xgene.c
> @@ -125,10 +125,11 @@ static int xgene_ahci_restart_engine(struct ata_port *ap)
>    * xgene_ahci_qc_issue - Issue commands to the device
>    * @qc: Command to issue
>    *
> - * Due to Hardware errata for IDENTIFY DEVICE command, the controller cannot
> - * clear the BSY bit after receiving the PIO setup FIS. This results in the dma
> - * state machine goes into the CMFatalErrorUpdate state and locks up. By
> - * restarting the dma engine, it removes the controller out of lock up state.
> + * Due to Hardware errata for IDENTIFY DEVICE command and COMMAND PACKET

    Just PACKET.

> + * command of ATAPI protocol set, the controller cannot clear the BSY bit
> + * after receiving the PIO setup FIS. This results in the dma state machine

    DMA.

> + * goes into the CMFatalErrorUpdate state and locks up. By restarting the

    s/goes/going/.

> + * dma engine, it removes the controller out of lock up state.

    DMA again.

>    */
>   static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
>   {
[...]

MBR, Sergei

