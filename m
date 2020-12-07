Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2E4C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 113C523741
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 15:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgLGPeq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 10:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgLGPeq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 10:34:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 813F022B40;
        Mon,  7 Dec 2020 15:34:04 +0000 (UTC)
Date:   Mon, 7 Dec 2020 10:34:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
Message-ID: <20201207103403.1c9c1045@gandalf.local.home>
In-Reply-To: <20201206164226.6595-4-huobean@gmail.com>
References: <20201206164226.6595-1-huobean@gmail.com>
        <20201206164226.6595-4-huobean@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun,  6 Dec 2020 17:42:26 +0100
Bean Huo <huobean@gmail.com> wrote:

> From: Bean Huo <beanhuo@micron.com>
> 
> Transaction Specific Fields (TSF) in the UPIU package could be CDB
> (SCSI/UFS Command Descriptor Block), OSF (Opcode Specific Field), and
> TM I/O parameter (Task Management Input/Output Parameter). But, currently,
> we take all of these as CDB  in the UPIU trace. Thus makes user confuse
> among CDB, OSF, and TM message. So fix it with this patch.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c  |  9 +++++----
>  include/trace/events/ufs.h | 10 +++++++---
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 29d7240a61bf..5b2219e44743 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -315,7 +315,8 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  {
>  	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
>  
> -	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb);
> +	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb,
> +			  "CDB");
>  }
>  
>  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
> @@ -329,7 +330,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
>  
>  	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
> -			  &rq_rsp->qr);
> +			  &rq_rsp->qr, "OSF");
>  }
>  
>  static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
> @@ -340,10 +341,10 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  
>  	if (!strcmp("tm_send", str))
>  		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
> -				  &descp->input_param1);
> +				  &descp->input_param1, "TM_INPUT");
>  	else
>  		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->rsp_header,
> -				  &descp->output_param1);
> +				  &descp->output_param1, "TM_OUTPUT");

You could save some space on the ring buffer, if you made the above into an
enum, and then used print_symbolic().

>  }
>  
>  static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
> diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
> index 0bd54a184391..68e8e97a9b47 100644
> --- a/include/trace/events/ufs.h
> +++ b/include/trace/events/ufs.h
> @@ -295,15 +295,17 @@ TRACE_EVENT(ufshcd_uic_command,
>  );


You could make this:

#define TRACE_TSF_TYPES		\
	EM(CDB)			\
	EM(OSF)			\
	EM(TM_INPUT)		\
	EMe(TM_OUTPUT)

#ifndef TRACE_TSF_TYPES_ENUMS
#define TRACE_TSF_TYPES_ENUMS
#undef EM
#undef EMe

#define EM(x)	TRACE_TSF_##x,
#define EMe(x)	TRACE_TSF_##x

enum {
	TRACE_TSF_TYPES
}
#endif /* TRACE_TSF_TYPES_ENUMS */

#undef EM
#undef EMe

/* These export the enum names to user space */
#define EM(x)	TRACE_DEFINE_ENUM(TRACE_TSF_##x)
#define EMe(x)	TRACE_DEFINE_ENUM(TRACE_TSF_##x)

TRACE_TSF_TYPES

#undef EM
#undef EMe

/* These are used in the print_symbolic */
#define EM(x) { TRACE_TSF_##x, #x },
#define EMe(x) { TRACE_TSF_##x, #x }


>  
>  TRACE_EVENT(ufshcd_upiu,
> -	TP_PROTO(const char *dev_name, const char *str, void *hdr, void *tsf),
> +	TP_PROTO(const char *dev_name, const char *str, void *hdr, void *tsf,
> +		 const char *tsf_type),

		int tsf_type;

>  
> -	TP_ARGS(dev_name, str, hdr, tsf),
> +	TP_ARGS(dev_name, str, hdr, tsf, tsf_type),
>  
>  	TP_STRUCT__entry(
>  		__string(dev_name, dev_name)
>  		__string(str, str)
>  		__array(unsigned char, hdr, 12)
>  		__array(unsigned char, tsf, 16)
> +		__string(tsf_type, tsf_type)

		__field(int, tsf_type)

>  	),
>  
>  	TP_fast_assign(
> @@ -311,12 +313,14 @@ TRACE_EVENT(ufshcd_upiu,
>  		__assign_str(str, str);
>  		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
>  		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
> +		__assign_str(tsf_type, tsf_type);


		__entry->tsf_type = tsf_type;


>  	),
>  
>  	TP_printk(
> -		"%s: %s: HDR:%s, CDB:%s",
> +		"%s: %s: HDR:%s, %s:%s",
>  		__get_str(str), __get_str(dev_name),
>  		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
> +		__get_str(tsf_type),

		print_symbolic(tsf_type, TRACE_TSF_TYPES),

-- Steve


>  		__print_hex(__entry->tsf, sizeof(__entry->tsf))
>  	)
>  );

