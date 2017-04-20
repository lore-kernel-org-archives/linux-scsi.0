From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH-v1 19/22] Fix implicit logo and RSCN handling for NVMET
Date: Thu, 20 Apr 2017 09:53:58 +0200
Message-ID: <20170420075358.GS6217@linux-x5ow.site>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420044641.10657-20-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938741AbdDTHyC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 03:54:02 -0400
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-20-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Wed, Apr 19, 2017 at 09:46:38PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> NVMET didn't have any RSCN handling at all and
> would not execute implicit LOGO when receiving a PLOGI
> from an rport that NVMET had in state UNMAPPED.
> 
> Clean up the logic in lpfc_nlp_state_cleanup for
> initiators (FCP and NVME). NVMET should not respond to
> RSCN including allocating new ndlps so this code was
> conditionalized when nvmet_support is true.  The check
> for NLP_RCV_PLOGI in lpfc_setup_disc_node was moved
> below the check for nvmet_support to allow the NVMET
> to recover initiator nodes correctly.  The implicit
> logo was introduced with lpfc_rcv_plogi when NVMET gets
> a PLOGI on an ndlp in UNMAPPED state.  The RSCN handling
> was modified to not respond to an RSCN in NVMET.  Instead
> NVMET sends a GID_FT and determines if an NVMEP_INITIATOR
> it has is UNMAPPED but no longer in the zone membership.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
