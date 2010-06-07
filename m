From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/3] [tgt]: Add proper STGT LUN backstore passthrough
 support (rev 3)
Date: Mon, 7 Jun 2010 15:45:26 +0900
Message-ID: <20100607153931J.fujita.tomonori@lab.ntt.co.jp>
References: <1275882625-5376-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55645 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab0FGGpx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2010 02:45:53 -0400
In-Reply-To: <1275882625-5376-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com

On Sun,  6 Jun 2010 20:50:25 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds two new queueing and completion function pointers to struct scsi_lu called ->cmd_perform()
> and ->cmd_done() for handling existing internal STGT port emulation and the struct scsi_cmd
> passthrough with bs_sg.c.  It retains the struct device_type_template->cmd_passthrough()
> from the original patches, which still appears to be necessary for a device type to perform passthrough.
> Also as before we modify the struct device_type_template sbc_template->cmd_passthrough() for sbc.c /
> TYPE_DISK that we want to use passthrough for bs_sg LUNs.
> 
> For the setup path, we update tgt_device_create() to check if lu->cmd_perform() and lu->cmd_done()
> have been set by struct backingstore_template->bs_init().  We expect bs_sg to setup these
> pointers for us using the new target_cmd_perform_passthrough() and __cmd_done_passthrough() (see below).
> Otherwise we setup the pointers following existing logic with target_cmd_perform() (also below) and
> __cmd_done() for the non bs_sg case.
> 
> For the queue path and struct scsi_lu->cmd_perform() it made sense to split up target_cmd_queue()
> into two functions, the original code at the tail of target_cmd_queue() now becomes
> target_cmd_perform() and calls existing STGT port emulation code via cmd_enabled() -> scsi_cmd_perform().
> A new function for passthrough has been added called target_cmd_perform_passthrough() that will do
> struct scsi_lu->dev_type_template.cmd_passthrough() into the device type for bs_sg LUNs.
> 
> For the completion path and struct scsi_lu->cmd_done(), a new __cmd_done_passthrough()
> has been added minus the original cmd_hlist_remove() and SCSI TASK attr checking in
> __cmd_done().  __cmd_done() is used for the existing port emulation case, and modify the
> two original users target_cmd_lookup() and abort_cmd() to call cmd->dev->cmd_done() instead.
> 
> Finally, it adds the passthrough case to tgt_device_create() in order to locate the
> struct device_type_template * using device_type_passthrough().
> 
> This patch has been tested with STGT/iSCSI and TCM_Loop SPC-4 iSCSI Target Port emulation.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  usr/target.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  usr/tgtd.h   |   16 ++++++++
>  2 files changed, 118 insertions(+), 11 deletions(-)
> 
> diff --git a/usr/target.c b/usr/target.c
> index c848757..3e2aa2b 100644
> --- a/usr/target.c
> +++ b/usr/target.c
> @@ -48,11 +48,27 @@ int device_type_register(struct device_type_template *t)
>  	return 0;
>  }
>  
> -static struct device_type_template *device_type_lookup(int type)
> +static struct device_type_template *device_type_passthrough(void)
>  {
>  	struct device_type_template *t;
>  
>  	list_for_each_entry(t, &device_type_list, device_type_siblings) {
> +		if (t->cmd_passthrough != NULL)
> +			return t;
> +	}
> +	return NULL;
> +}
> +
> +static struct device_type_template *device_type_lookup(int type, int passthrough)
> +{
> +	struct device_type_template *t;
> +
> +	if (passthrough)
> +		return device_type_passthrough();
> +
> +	list_for_each_entry(t, &device_type_list, device_type_siblings) {
> +		if (t->cmd_passthrough != NULL)
> +			continue;
>  		if (t->type == type)
>  			return t;
>  	}
> @@ -425,11 +441,13 @@ static match_table_t device_tokens = {
>  	{Opt_err, NULL},
>  };

I think that we can avoid the above complexity if we create a new
device type.


> +static void __cmd_done(struct target *, struct scsi_cmd *);
> +
>  int tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
>  		      int backing)
>  {
>  	char *p, *path = NULL, *bstype = NULL;
> -	int ret = 0;
> +	int ret = 0, passthrough = 0;
>  	struct target *target;
>  	struct scsi_lu *lu, *pos;
>  	struct device_type_template *t;
> @@ -479,10 +497,11 @@ int tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
>  				ret = TGTADM_INVALID_REQUEST;
>  				goto out;
>  			}
> +			passthrough = bst->bs_passthrough;
>  		}
>  	}
>  
> -	t = device_type_lookup(dev_type);
> +	t = device_type_lookup(dev_type, passthrough);
>  	if (!t) {
>  		eprintf("Unknown device type %d\n", dev_type);
>  		ret = TGTADM_INVALID_REQUEST;
> @@ -515,6 +534,26 @@ int tgt_device_create(int tid, int dev_type, uint64_t lun, char *params,
>  		if (ret)
>  			goto fail_lu_init;
>  	}
> +	/*
> +	 * Check if struct scsi_lu->cmd_perform() has been filled in
> +	 * by the SG_IO backstore for passthrough (SG_IO) in ->bs_init() call.
> +	 * If the function pointer does not exist, use the default internal
> +	 * target_cmd_perform() and __cmd_done() calls.
> +	 */
> +	if (!(lu->cmd_perform)) {
> +		lu->cmd_perform = &target_cmd_perform;
> +		lu->cmd_done = &__cmd_done;
> +	} else if (!(lu->cmd_done)) {
> +		eprintf("Unable to locate struct scsi_lu->cmd_done() with"
> +				" valid ->cmd_perform()\n");
> +		ret = TGTADM_INVALID_REQUEST;
> +		goto fail_bs_init;
> +	} else if (!(lu->dev_type_template.cmd_passthrough)) {
> +		eprintf("Unable to locate ->cmd_passthrough() handler"
> +				" for device type template\n");
> +		ret = TGTADM_INVALID_REQUEST;
> +		goto fail_bs_init;
> +	}

I think that it's more simple to set up the function pointers first
then let bs_init overwrite them.
