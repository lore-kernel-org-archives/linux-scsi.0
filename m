From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/13] target: Change target_submit_cmd() to return void
Date: Thu, 19 Jan 2012 16:46:43 -0800
Message-ID: <1327020403.16983.302.camel@haakon2.linux-iscsi.org>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
	 <1327009163-10177-14-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-14-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-01-19 at 13:39 -0800, Andy Grover wrote:
> Retval not very useful, and may even be harmful. Once submitted, fabrics
> should expect a sense error if anything goes wrong. All fabrics checking
> of this retval are useless or broken:
> 
> fc checks it just to emit more debug output.
> ib_srpt trickles retval up, then it is ignored.
> qla2xxx trickles it up, which then causes a bug because the abort goto
> in qla_target.c thinks cmd hasn't been sent to target.
> 
> Just returning nothing is best.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c  |    5 +----
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    7 ++-----
>  drivers/target/target_core_transport.c |    5 ++---
>  drivers/target/tcm_fc/tfc_cmd.c        |    9 ++-------
>  include/target/target_core_fabric.h    |    2 +-
>  5 files changed, 8 insertions(+), 20 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 15faca4..cfc4e02 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1633,7 +1633,7 @@ EXPORT_SYMBOL(transport_handle_cdb_direct);
>   * This may only be called from process context, and also currently
>   * assumes internal allocation of fabric payload buffer by target-core.
>   **/
> -int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> +void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
>  		u32 data_length, int task_attr, int data_dir, int flags)
>  {
> @@ -1682,12 +1682,11 @@ int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  	 * when fabric has filled the incoming buffer.
>  	 */
>  	transport_handle_cdb_direct(se_cmd);
> -	return 0;
> +	return;
>  
>  out_check_cond:
>  	transport_send_check_condition_and_sense(se_cmd,
>  				se_cmd->scsi_sense_reason, 0);
> -	return 0;
>  }
>  EXPORT_SYMBOL(target_submit_cmd);
>  

Your patch is fine here..

However my original usage of transport_send_check_condition_and_sense()
is wrong wrt target_submit_cmd() failures.  The cmd_kref will have
already been taken by target_get_sess_cmd(), so this needs to be using
transport_generic_request_failure() around sense_check_condition to
handle proper TFO->check_stop_free() kref_puts + response queue_full
cases.

So I'm looking into addressing this breakage in lio-core now, and will
post a patch for 3.3-rc-fixes soon after I can verify the fix with
qla2xxx + ib_srpt failures.

--nab
