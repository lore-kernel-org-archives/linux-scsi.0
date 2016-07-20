From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Unsupported SCSI Opcode Fix
Date: Wed, 20 Jul 2016 13:16:32 -0700
Message-ID: <1469045792.13881.5.camel@haakon3.risingtidesystems.com>
References: <B4AAE167-F030-4EDD-9221-2CD07ECD4B61@linux.vnet.ibm.com>
	 <1467312618-21592-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1467312618-21592-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mikecyr@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-06-30 at 13:50 -0500, Bryant G. Ly wrote:
> If a Simple command is sent with a failure,
> target_setup_cmd_from_cdb returns with TCM_UNSUPPORTED_SCSI_OPCODE
> or TCM_INVALID_CDB_FIELD. So in the cases where target_setup_cmd_from_cdb
> returns an error, we never get far enough to call target_execute_cmd to
> increment simple_cmds. Since simple_cmds isn't incremented, the
> result of the failure from target_setup_cmd_from_cdb causes
> transport_generic_request_failure to decrement
> simple_cmds, due to call to transport_complete_task_attr.
> With this dev->simple_cmds or dev->dev_ordered_sync is now -1, not 0.
> So when a subsequent command with an Ordered Task is sent, it causes
> a hang, since dev->simple_cmds is at -1.
> 
> Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_transport.c | 6 ++++++
>  include/target/target_core_base.h      | 3 ++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 

Applied to target-pending/for-next, preceeding the ibmvscsis commit.

Thanks again Bryant + Michael for reviewing + testing this patch.
