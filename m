From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 5/9] zfcp: decouple SCSI setup of TMF from scsi_cmnd
Date: Wed, 26 Jul 2017 07:56:41 +0200
Message-ID: <d1f1b0d7-6445-dbc3-d9fa-b65e91c7c6ac@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-6-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50238 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750907AbdGZF4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 01:56:44 -0400
In-Reply-To: <20170725141427.35258-6-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> Actually change the signature of zfcp_fsf_fcp_task_mgmt().
> Since it was prepared in the previous patch, we only need to delete
> some local auto variables which are now the intended arguments.
> 
> Refactor zfcp_scsi_forget_cmnds() to now take a mandatory zfcp_port
> and an optional zfcp_scsi_dev, which can be NULL for target reset,
> instead of a mandatory zfcp_scsi_dev.
> 
> Prepare zfcp_fsf_fcp_task_mgmt's caller zfcp_task_mgmt_function()
> to have its function body only depend on a mandatory zfcp_port
> and an optional scsi_device, which can be NULL for target reset.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_ext.h  |  4 +++-
>  drivers/s390/scsi/zfcp_fsf.c  | 15 ++++++++-------
>  drivers/s390/scsi/zfcp_scsi.c | 28 +++++++++++++++++++---------
>  3 files changed, 30 insertions(+), 17 deletions(-)
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
