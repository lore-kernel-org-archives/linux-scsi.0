From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Fri, 7 Apr 2017 09:02:55 -0700
Message-ID: <0c80c6e3-168a-d8bd-d7b4-e727723bcf18@sandisk.com>
References: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/07/2017 08:49 AM, Bryant G. Ly wrote:
> The driver is sending a response to the aborted task response
                                                       ^^^^^^^^
That occurrence of "response" looks extraneous?

> along with LIO sending the tmr response. SCSI spec says
> that the initiator that sends the abort task TM NEVER gets a
> response to the aborted op and with the current code it will
> send a response. Thus this fix will remove that response if the
> op is aborted.

Hello Bryan,

Are you sure that a new flag needed to prevent that a command response
is sent to the initiator that submitted the ABORT?
__target_check_io_state() only sets CMD_T_TAS if the TMF was received
from another I_T nexus than the I_T nexus through which the aborted
command was received. core_tmr_handle_tas_abort() only triggers a call
to .queue_status() if CMD_T_TAS is set. Do you agree with this analysis?

Thanks,

Bart.
