From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3] ibmvscsis: Do not send aborted task response
Date: Sun, 07 May 2017 14:59:21 -0700
Message-ID: <1494194361.30469.0.camel@haakon3.risingtidesystems.com>
References: <1494011835-29476-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48646 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbdEGV7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 May 2017 17:59:31 -0400
In-Reply-To: <1494011835-29476-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Bart.VanAssche@sandisk.com, martin.petersen@oracle.com, mikecyr@linux.vnet.ibm.com, mikecyr@us.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org

On Fri, 2017-05-05 at 14:17 -0500, Bryant G. Ly wrote:
> The driver is sending a response to the actual scsi op that was
> aborted by an abort task TM, while LIO is sending a response to
> the abort task TM.
> 
> ibmvscsis_tgt does not send the response to the client until
> release_cmd time. The reason for this was because if we did it
> at queue_status time, then the client would be free to reuse the
> tag for that command, but we're still using the tag until the
> command is released at release_cmd time, so we chose to delay
> sending the response until then. That then caused this issue, because
> release_cmd is always called, even if queue_status is not.
> 
> SCSI spec says that the initiator that sends the abort task
> TM NEVER gets a response to the aborted op and with the current
> code it will send a response. Thus this fix will remove that response
> if the CMD_T_ABORTED && !CMD_T_TAS.
> 
> Another case with a small timing window is the case where if LIO sends a
> TMR_DOES_NOT_EXIST, and the release_cmd callback is called for the TMR Abort
> cmd before the release_cmd for the (attemped) aborted cmd, then we need to
> ensure that we send the response for the (attempted) abort cmd to the client
> before we send the response for the TMR Abort cmd.
> 
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 114 ++++++++++++++++++++++++-------
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |   2 +
>  2 files changed, 91 insertions(+), 25 deletions(-)
> 

Applied.

Thanks Bryant + Michael.
