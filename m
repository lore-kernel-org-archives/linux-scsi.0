From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 03/39] megaraid_sas: raid 1 fast path code optimize
Date: Mon, 6 Feb 2017 11:26:14 +0100
Message-ID: <7f060b48-a1f1-a248-5c2e-12bf99c434eb@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:59861 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdBFK0R (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 05:26:17 -0500
In-Reply-To: <1486375212-17329-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> No functional change. Code refactor.
> Remove function megasas_fpio_to_ldio as we never require to convert fpio to ldio because of frame unavailability.
> Grab extra frame of raid 1 write fast path before it creates first frame as Fast Path.
> Removed is_raid_1_fp_write flag as raid 1 write fast path command is decided using r1_alt_dev_handle only.
> Move resetting megasas_cmd_fusion fields at common function megasas_return_cmd_fusion.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fp.c     |  14 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 348 +++++++++-------------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   3 +-
>  3 files changed, 117 insertions(+), 248 deletions(-)
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
