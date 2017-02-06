From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 12/39] megaraid_sas: raid 1 write performance for large io
Date: Mon, 6 Feb 2017 11:54:01 +0100
Message-ID: <56bf1b6a-43c0-6d39-204d-99bbd706f7a6@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:36856 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbdBFKyE (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 05:54:04 -0500
In-Reply-To: <1486375212-17329-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Avoid Host side PCI bandwidth bottleneck and hint FW to do Write buffering using
> RaidFlag MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT.
> Once IO is landed in FW with MR_RAID_FLAGS_IO_SUB_TYPE_LDIO_BW_LIMIT,
> it will do single DMA from host and buffer the Write operation. On back end,
> FW will DMA same buffer to the Mirror and Data Arm.
> This will improve large block IO performance which bottleneck due to Host side PCI bandwidth limitation.
> 
> Consistent ~4000MB T.P for 256K Block size is expected performance numbers.
> IOPS for small Block size should be on par with Disk performance.
> (E.g 42 SAS Disk in JBOD mode gives 3700MB T.P.
> Same Drive used in R1 WT mode, should give ~1800MB T.P)
> 
> Using this patch 24 R1 VDs (HDD) gives below performance for Sequential Write.
> Without this patch, we cannot reach above 3200MB (Throughput is in MB. )
> 
> Block Size   	50% 256K and 50% 4K          100% 256K
> 4K                 3100                        2030
> 8K                 3140                        2740
> 16K                3140                        3140
> 32K                3400                        3240
> 64K                3500                        3700
> 128K               3870                        3870
> 256K               3920                        3920
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  5 +++++
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 32 +++++++++++++++++++++++++++--
>  2 files changed, 35 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
