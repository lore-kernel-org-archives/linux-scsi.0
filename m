From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 6/9] scsi: fc: start decoupling fc_block_scsi_eh from
 scsi_cmnd
Date: Wed, 26 Jul 2017 07:58:57 +0200
Message-ID: <c43358d4-720d-0d7e-ddd5-a2d78ee05d8e@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-7-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750747AbdGZF67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 01:58:59 -0400
In-Reply-To: <20170725141427.35258-7-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> Scsi_cmnd is an unsuitable argument for eh_device_reset_handler(),
> eh_target_reset_handler(), and eh_host_reset_handler()
> which do not have the scope of one single SCSI command.
> These callbacks tend to use fc_block_scsi_eh() requiring scsi_cmnd.
> In order to start decoupling above eh callbacks from scsi_cmnd,
> introduce a new variant of the function called fc_block_rport()
> taking an fc_rport as argument.
> Refactor the old fc_block_scsi_eh() to simply delegate to fc_block_rport().
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/scsi/scsi_transport_fc.c | 31 ++++++++++++++++++++++++++-----
>  include/scsi/scsi_transport_fc.h |  1 +
>  2 files changed, 27 insertions(+), 5 deletions(-)
> 
Very good.
I need that for my patchset as well.
Martin, would it be possible to apply this independent of this patchset?
It would help me a lot when redrafting my patchset.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
