From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi: Add STARGET_CREATED_REMOVE state to scsi_target_state
Date: Tue, 27 Jun 2017 21:09:52 -0400
Message-ID: <yq1o9t8zzmn.fsf@oracle.com>
References: <1498589758-31473-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498589758-31473-1-git-send-email-emilne@redhat.com> (Ewan
        D. Milne's message of "Tue, 27 Jun 2017 14:55:58 -0400")
Sender: stable-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ewan,

> The addition of the STARGET_REMOVE state had the side effect of
> introducing a race condition that can cause a crash.
>
> scsi_target_reap_ref_release() checks the starget->state to
> see if it still in STARGET_CREATED, and if so, skips calling
> transport_remove_device() and device_del(), because the starget->state
> is only set to STARGET_RUNNING after scsi_target_add() has called
> device_add() and transport_add_device().
>
> However, if an rport loss occurs while a target is being scanned,
> it can happen that scsi_remove_target() will be called while the
> starget is still in the STARGET_CREATED state.  In this case, the
> starget->state will be set to STARGET_REMOVE, and as a result,
> scsi_target_reap_ref_release() will take the wrong path.  The end
> result is a panic:

Johannes/Bart/James: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
