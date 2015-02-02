From: Sergei Shtylyov <sergei.shtylyov-M4DtvfQ/ZS1MRgGoP+s0PdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3] ahci_xgene: Fix the dma state machine lockup for the
 ATA_CMD_SMART PIO mode command.
Date: Mon, 02 Feb 2015 22:12:40 +0300
Message-ID: <54CFCC28.6050609@cogentembedded.com>
References: <1422900439-5541-1-git-send-email-stripathi@apm.com> <1422900439-5541-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422900439-5541-2-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 02/02/2015 09:07 PM, Suman Tripathi wrote:

> This patch addresses the issue with ATA_CMD_SMART pio mode
> command for enumeration and device detection with ATA devices.
> The X-Gene AHCI controller has an errata in which it cannot clear
> the BSY bit after the PIO setup FIS. The dma state machine enters

    Hum, if this happens after every PIO command (PIO setup FISes are not 
specific to the command, right?), perhaps it would make more sense to record 
the *protocol* used by the last command?

> CMFatalErrorUpdate state and locks up. It is the same issue as
> in the commit 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016 (ahci-xgene:
> fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode
> command).

> For example :  without this patch it results in READ DMA command failure
> as shown below :

[...]

> Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
> Reported-by:   Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

MBR, Sergei

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
