From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: ["PATCH-v2" 20/22] Update ABORT processing for NVMET.
Date: Fri, 21 Apr 2017 09:07:12 +0200
Message-ID: <20170421070712.GC26346@linux-x5ow.site>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
 <20170420220448.27095-21-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52159 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1035896AbdDUHHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 03:07:15 -0400
Content-Disposition: inline
In-Reply-To: <20170420220448.27095-21-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Thu, Apr 20, 2017 at 03:04:46PM -0700, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> The driver with nvme had this routine stubbed.
> 
> Right now XRI_ABORTED_CQE is not handled and the FC NVMET
> Transport has a new API for the driver.
> 
> Missing code path, new NVME abort API
> Update ABORT processing for NVMET
> 
> There are 3 new FC NVMET Transport API/ template routines for NVMET:
> 
> lpfc_nvmet_xmt_fcp_release
> This NVMET template callback routine called to release context
> associated with an IO This routine is ALWAYS called last, even
> if the IO was aborted or completed in error.
> 
> lpfc_nvmet_xmt_fcp_abort
> This NVMET template callback routine called to abort an exchange that
> has an IO in progress
> 
> nvmet_fc_rcv_fcp_req
> When the lpfc driver receives an ABTS, this NVME FC transport layer
> callback routine is called. For this case there are 2 paths thru the
> driver: the driver either has an outstanding exchange / context for the
> XRI to be aborted or not.  If not, a BA_RJT is issued otherwise a BA_ACC
> 
> NVMET Driver abort paths:
> 
> There are 2 paths for aborting an IO. The first one is we receive an IO and
> decide not to process it because of lack of resources. An unsolicated ABTS
> is immediately sent back to the initiator as a response.
> lpfc_nvmet_unsol_fcp_buffer
>             lpfc_nvmet_unsol_issue_abort  (XMIT_SEQUENCE_WQE)
> 
> The second one is we sent the IO up to the NVMET transport layer to
> process, and for some reason the NVME Transport layer decided to abort the
> IO before it completes all its phases. For this case there are 2 paths
> thru the driver:
> the driver either has an outstanding TSEND/TRECEIVE/TRSP WQE or no
> outstanding WQEs are present for the exchange / context.
> lpfc_nvmet_xmt_fcp_abort
>     if (LPFC_NVMET_IO_INP)
>         lpfc_nvmet_sol_fcp_issue_abort  (ABORT_WQE)
>                 lpfc_nvmet_sol_fcp_abort_cmp
>     else
>         lpfc_nvmet_unsol_fcp_issue_abort
>                 lpfc_nvmet_unsol_issue_abort  (XMIT_SEQUENCE_WQE)
>                         lpfc_nvmet_unsol_fcp_abort_cmp
> 
> Context flags:
> LPFC_NVMET_IOP - his flag signifies an IO is in progress on the exchange.
> LPFC_NVMET_XBUSY  - this flag indicates the IO completed but the firmware
> is still busy with the corresponding exchange. The exchange should not be
> reused until after a XRI_ABORTED_CQE is received for that exchange.
> LPFC_NVMET_ABORT_OP - this flag signifies an ABORT_WQE was issued on the
> exchange.
> LPFC_NVMET_CTX_RLS  - this flag signifies a context free was requested,
> but we are deferring it due to an XBUSY or ABORT in progress.
> 
> A ctxlock is added to the context structure that is used whenever these
> flags are set/read  within the context of an IO.
> The LPFC_NVMET_CTX_RLS flag is only set in the defer_relase routine when
> the transport has resolved all IO associated with the buffer. The flag is
> cleared when the CTX is associated with a new IO.
> 
> An exchange can has both an LPFC_NVMET_XBUSY and a LPFC_NVMET_ABORT_OP
> condition active simultaneously. Both conditions must complete before the
> exchange is freed.
> When the abort callback (lpfc_nvmet_xmt_fcp_abort) is envoked:
> If there is an outstanding IO, the driver will issue an ABORT_WQE. This
> should result in 3 completions for the exchange:
> 1) IO cmpl with XB bit set
> 2) Abort WQE cmpl
> 3) XRI_ABORTED_CQE cmpl
> For this scenerio, after completion #1, the NVMET Transport IO rsp
> callback is called.  After completion #2, no action is taken with respect
> to the exchange / context.  After completion #3, the exchange context is
> free for re-use on another IO.
> 
> If there is no outstanding activity on the exchange, the driver will send a
> ABTS to the Initiator. Upon completion of this WQE, the exchange / context
> is freed for re-use on another IO.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---

Looks good. Thanks,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
