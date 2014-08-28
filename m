From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 11/22] Implement scsi_opcode_sa_name
Date: Thu, 28 Aug 2014 19:50:27 -0400
Message-ID: <53FFC043.4020608@interlog.com>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-12-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50205 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaH1Xud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 19:50:33 -0400
In-Reply-To: <1409247216-76074-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 14-08-28 01:33 PM, Hannes Reinecke wrote:
> Implement a lookup array for SERVICE ACTION commands instead
> of hardcoding it in a large switch statement.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/constants.c | 130 +++++++++++++++++++----------------------------
>   1 file changed, 53 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 323e944..813c482 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -244,102 +244,77 @@ static const struct value_name_pair variable_length_arr[] = {
>   };
>   #define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
>
> -static const char * get_sa_name(const struct value_name_pair * arr,
> -			        int arr_sz, int service_action)
> +struct sa_name_list {
> +	int cmd;
> +	const struct value_name_pair *arr;
> +	int arr_sz;
> +};
> +
> +static struct sa_name_list sa_names_arr[] = {
> +	{VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
> +	{MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
> +	{MAINTENANCE_OUT, maint_out_arr, MAINT_OUT_SZ},
> +	{PERSISTENT_RESERVE_IN, pr_in_arr, PR_IN_SZ},
> +	{PERSISTENT_RESERVE_OUT, pr_out_arr, PR_OUT_SZ},
> +	{SERVICE_ACTION_IN_12, serv_in12_arr, SERV_IN12_SZ},
> +	{SERVICE_ACTION_OUT_12, serv_out12_arr, SERV_OUT12_SZ},
> +	{SERVICE_ACTION_BIDIRECTIONAL, serv_bidi_arr, SERV_BIDI_SZ},
> +	{SERVICE_ACTION_IN_16, serv_in16_arr, SERV_IN16_SZ},
> +	{SERVICE_ACTION_OUT_16, serv_out16_arr, SERV_OUT16_SZ},
> +	{THIRD_PARTY_COPY_IN, tpc_in_arr, TPC_IN_SZ},
> +	{THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
> +	{0, NULL, 0},
> +};

Plus I added these recently (after observing the output from
REPORT SUPPORTED OPERATION CODES):
     READ BUFFER
     WRITE BUFFER
     SANITIZE

[And I'll take your lead and remove the big switch
  statement from sg3_utils.]

Doug Gilbert



/* Read buffer [0x3c] service actions */
struct sg_lib_value_name_t sg_lib_read_buff_arr[] = {
     {0x0, 0, "combined header and data [or multiple modes]"},
     {0x2, 0, "data"},
     {0x3, 0, "descriptor"},
     {0xa, 0, "read data from echo buffer"},
     {0xb, 0, "echo buffer descriptor"},
     {0x1a, 0, "enable expander comms protocol and echo buffer"},
     {0x1c, 0, "error history"},
     {0xffff, 0, NULL},
};

/* Write buffer [0x3b] service actions */
struct sg_lib_value_name_t sg_lib_write_buff_arr[] = {
     {0x0, 0, "combined header and data [or multiple modes]"},
     {0x2, 0, "data"},
     {0x4, 0, "download microcode and activate"},
     {0x5, 0, "download microcode, save, and activate"},
     {0x6, 0, "download microcode with offsets and activate"},
     {0x7, 0, "download microcode with offsets, save, and activate"},
     {0xa, 0, "write data to echo buffer"},
     {0xd, 0, "download microcode with offsets, select activation events, "
              "save and defer activate"},
     {0xe, 0, "download microcode with offsets, save and defer activate"},
     {0xf, 0, "activate deferred microcode"},
     {0x1a, 0, "enable expander comms protocol and echo buffer"},
     {0x1b, 0, "disable expander comms protocol"},
     {0x1c, 0, "download application client error history"},
     {0xffff, 0, NULL},
};

/* Sanitize [0x48] service actions */
struct sg_lib_value_name_t sg_lib_sanitize_sa_arr[] = {
     {0x1, 0, "Sanitize, overwrite"},
     {0x2, 0, "Sanitize, block erase"},
     {0x3, 0, "Sanitize, cryptographic erase"},
     {0x1f, 0, "Sanitize, exit failure mode"},
     {0xffff, 0, NULL},
};

