From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: fix oops/BUG in lpfc_sli_ringtxcmpl_put()
Date: Wed, 23 Nov 2016 15:12:22 +0100
Message-ID: <20161123141222.knkjbhzia6lr3orl@linux-x5ow.site>
References: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: james.smart@broadcom.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 23, 2016 at 10:33:19AM -0200, Mauricio Faria de Oliveira wrote:
> The BUG_ON() recently introduced in lpfc_sli_ringtxcmpl_put()
> is hit in the lpfc_els_abort() > lpfc_sli_issue_abort_iotag()
>  > lpfc_sli_abort_iotag_issue() function path [similar names],
> due to 'piocb->vport == NULL':
> 
> 	BUG_ON(!piocb || !piocb->vport);
> 
> This happens because lpfc_sli_abort_iotag_issue() doesn't set
> the 'abtsiocbp->vport' pointer -- but this is not the problem.
> 
> Previously, lpfc_sli_ringtxcmpl_put() accessed 'piocb->vport'
> only if 'piocb->iocb.ulpCommand' is neither CMD_ABORT_XRI_CN
> nor CMD_CLOSE_XRI_CN, which are the only possible values for
> lpfc_sli_abort_iotag_issue():
> 
>     lpfc_sli_ringtxcmpl_put():
> 
>         if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
>            (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
>            (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
>             (!(piocb->vport->load_flag & FC_UNLOADING)))
> 
>     lpfc_sli_abort_iotag_issue():
> 
>         if (phba->link_state >= LPFC_LINK_UP)
>                 iabt->ulpCommand = CMD_ABORT_XRI_CN;
>         else
>                 iabt->ulpCommand = CMD_CLOSE_XRI_CN;
> 
> So, this function path would not have hit this possible NULL
> pointer dereference before.
> 
> In order to fix this regression, move the second part of the
> BUG_ON() check prior to the pointer dereference that it does
> check for.
> 
> For reference, this is the stack trace observed. The problem
> happened because an unsolicited event was received - a PLOGI
> was received after our PLOGI was issued but not yet complete,
> so the discovery state machine goes on to sw-abort our PLOGI.
> 
>     kernel BUG at drivers/scsi/lpfc/lpfc_sli.c:1326!
>     Oops: Exception in kernel mode, sig: 5 [#1]
>     <...>
>     NIP [...] lpfc_sli_ringtxcmpl_put+0x1c/0xf0 [lpfc]
>     LR  [...] __lpfc_sli_issue_iocb_s4+0x188/0x200 [lpfc]
>     Call Trace:
>     [...] [...] __lpfc_sli_issue_iocb_s4+0xb0/0x200 [lpfc] (unreliable)
>     [...] [...] lpfc_sli_issue_abort_iotag+0x2b4/0x350 [lpfc]
>     [...] [...] lpfc_els_abort+0x1a8/0x4a0 [lpfc]
>     [...] [...] lpfc_rcv_plogi+0x6d4/0x700 [lpfc]
>     [...] [...] lpfc_rcv_plogi_plogi_issue+0xd8/0x1d0 [lpfc]
>     [...] [...] lpfc_disc_state_machine+0xc0/0x2b0 [lpfc]
>     [...] [...] lpfc_els_unsol_buffer+0xcc0/0x26c0 [lpfc]
>     [...] [...] lpfc_els_unsol_event+0xa8/0x220 [lpfc]
>     [...] [...] lpfc_complete_unsol_iocb+0xb8/0x138 [lpfc]
>     [...] [...] lpfc_sli4_handle_received_buffer+0x6a0/0xec0 [lpfc]
>     [...] [...] lpfc_sli_handle_slow_ring_event_s4+0x1c4/0x240 [lpfc]
>     [...] [...] lpfc_sli_handle_slow_ring_event+0x24/0x40 [lpfc]
>     [...] [...] lpfc_do_work+0xd88/0x1970 [lpfc]
>     [...] [...] kthread+0x108/0x130
>     [...] [...] ret_from_kernel_thread+0x5c/0xbc
>     <...>
> 
> Cc: stable@vger.kernel.org # v4.8
> Fixes: 22466da5b4b7 ("lpfc: Fix possible NULL pointer dereference")
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---

Looks good and sorry for the bug,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
