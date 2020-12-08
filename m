Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F530C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BD323B1F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgLHVhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730023AbgLHVhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:37:04 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BEDC061793;
        Tue,  8 Dec 2020 13:36:48 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id jx16so26729246ejb.10;
        Tue, 08 Dec 2020 13:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3mkuqVS814q87loikDpaZu7IaU0Kbf/7WNbywxM0lk=;
        b=SJX/b33U3+d2bDD5cO+9tiqdcJTxDpDRnpMtJR3QjVWV9CCjvA3ZzBcHhWXC4lMFUT
         FvMJ+TKrxQH1am4s9WleFY25JBmQUodAJhzoOGjLQddSSNm2Z1RY1uJyxTCHjAn3aV67
         wpcsw7XM081WsTV8aIYXfZ835wHch6mJ3nb4aI+RmAWrBc5lVbE4CfipVN4yGlZfQaE2
         uqjIo+GiNgeL2m+4MhgFN81tug31skFG8cb2Z5dXsdTy1YC3FTRKzE22c9vmitgmkjmQ
         TsYvGFHf3qKNMSqBh9G6D7JhCK+Tw/6KDVkRp68LYFSSqyeChjWYENN3jpRjdHgD+uw5
         q36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3mkuqVS814q87loikDpaZu7IaU0Kbf/7WNbywxM0lk=;
        b=Nd/vw2wp1H61wCU5zzwdSZnQtAaXHeGh+YTtM8z4tYZZLdOUF2lV2RqhZs0cpcxvNF
         I1Y/0W9Kmbf8LA9tcHCiZHwb3iwg65BwGDG9RcehoQ/T2Qti7Cab/EevYHFABSilTlnl
         jM/LJ+CKtyG5CAjfRkg7gO03h8hGp+oRF/gjuvTdBSIkVVbz61jzmlaOeZhjREABoUI6
         TMggVBFwaE41oGU/RQNJxREjuEUJpyB2iZsFstv2wH5UrzI1s/p1Z+sApmMbTCCi+Xx2
         vwKc9KT3VyrewYFM5qgqmiJb44ae9AG5iMe/2pEi+FQDNKXKelearaP+Fh8h9laa2xhb
         H4XA==
X-Gm-Message-State: AOAM531oJ8jnaVpdOfTilRKdHuYkO0X456pD+KhTupQr2SOSCJD7rtvm
        NpLOtL8RfWtir83MJOQ/T7Q=
X-Google-Smtp-Source: ABdhPJx8sRGBOrlEfiouGxgEcGiRsq1uXUyhJeycQdZdsXWuHNncIgRrlwF5dlJ3idcIOIZH4JBSSA==
X-Received: by 2002:a17:906:d9cf:: with SMTP id qk15mr25848350ejb.453.1607463407738;
        Tue, 08 Dec 2020 13:36:47 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id m3sm68824edj.22.2020.12.08.13.36.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 13:36:47 -0800 (PST)
Message-ID: <a79d20c320aee5b29d3a3037877829b7a328765b.camel@gmail.com>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
From:   Bean Huo <huobean@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>, bvanassche@acm.org
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Dec 2020 22:36:46 +0100
In-Reply-To: <20201207103403.1c9c1045@gandalf.local.home>
References: <20201206164226.6595-1-huobean@gmail.com>
         <20201206164226.6595-4-huobean@gmail.com>
         <20201207103403.1c9c1045@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-07 at 10:34 -0500, Steven Rostedt wrote:
> On Sun,  6 Dec 2020 17:42:26 +0100
> Bean Huo <huobean@gmail.com> wrote:
> 
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Transaction Specific Fields (TSF) in the UPIU package could be CDB
> > (SCSI/UFS Command Descriptor Block), OSF (Opcode Specific Field),
> > and
> > TM I/O parameter (Task Management Input/Output Parameter). But,
> > currently,
> > we take all of these as CDB  in the UPIU trace. Thus makes user
> > confuse
> > among CDB, OSF, and TM message. So fix it with this patch.
> > 
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c  |  9 +++++----
> >  include/trace/events/ufs.h | 10 +++++++---
> >  2 files changed, 12 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 29d7240a61bf..5b2219e44743 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -315,7 +315,8 @@ static void ufshcd_add_cmd_upiu_trace(struct
> > ufs_hba *hba, unsigned int tag,
> >  {
> >  	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
> >  
> > -	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq-
> > >sc.cdb);
> > +	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq-
> > >sc.cdb,
> > +			  "CDB");
> >  }
> >  
> >  static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
> > unsigned int tag,
> > @@ -329,7 +330,7 @@ static void ufshcd_add_query_upiu_trace(struct
> > ufs_hba *hba, unsigned int tag,
> >  		rq_rsp = (struct utp_upiu_req *)hba-
> > >lrb[tag].ucd_rsp_ptr;
> >  
> >  	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
> > -			  &rq_rsp->qr);
> > +			  &rq_rsp->qr, "OSF");
> >  }
> >  
> >  static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned
> > int tag,
> > @@ -340,10 +341,10 @@ static void ufshcd_add_tm_upiu_trace(struct
> > ufs_hba *hba, unsigned int tag,
> >  
> >  	if (!strcmp("tm_send", str))
> >  		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp-
> > >req_header,
> > -				  &descp->input_param1);
> > +				  &descp->input_param1, "TM_INPUT");
> >  	else
> >  		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp-
> > >rsp_header,
> > -				  &descp->output_param1);
> > +				  &descp->output_param1, "TM_OUTPUT");
> 
> You could save some space on the ring buffer, if you made the above
> into an
> enum, and then used print_symbolic().
> 
> >  }
> >  
> >  static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
> > diff --git a/include/trace/events/ufs.h
> > b/include/trace/events/ufs.h
> > index 0bd54a184391..68e8e97a9b47 100644
> > --- a/include/trace/events/ufs.h
> > +++ b/include/trace/events/ufs.h
> > @@ -295,15 +295,17 @@ TRACE_EVENT(ufshcd_uic_command,
> >  );
> 
> 
> You could make this:
> 
> #define TRACE_TSF_TYPES		\
> 	EM(CDB)			\
> 	EM(OSF)			\
> 	EM(TM_INPUT)		\
> 	EMe(TM_OUTPUT)
> 
> #ifndef TRACE_TSF_TYPES_ENUMS
> #define TRACE_TSF_TYPES_ENUMS
> #undef EM
> #undef EMe
> 
> #define EM(x)	TRACE_TSF_##x,
> #define EMe(x)	TRACE_TSF_##x
> 
> enum {
> 	TRACE_TSF_TYPES
> }
> #endif /* TRACE_TSF_TYPES_ENUMS */
> 
> #undef EM
> #undef EMe
> 
> /* These export the enum names to user space */
> #define EM(x)	TRACE_DEFINE_ENUM(TRACE_TSF_##x)
> #define EMe(x)	TRACE_DEFINE_ENUM(TRACE_TSF_##x)
> 
> TRACE_TSF_TYPES
> 
> #undef EM
> #undef EMe
> 
> /* These are used in the print_symbolic */
> #define EM(x) { TRACE_TSF_##x, #x },
> #define EMe(x) { TRACE_TSF_##x, #x }
> 
> 
> >  
> >  TRACE_EVENT(ufshcd_upiu,
> > -	TP_PROTO(const char *dev_name, const char *str, void *hdr, void
> > *tsf),
> > +	TP_PROTO(const char *dev_name, const char *str, void *hdr, void
> > *tsf,
> > +		 const char *tsf_type),
> 
> 		int tsf_type;
> 
> >  
> > -	TP_ARGS(dev_name, str, hdr, tsf),
> > +	TP_ARGS(dev_name, str, hdr, tsf, tsf_type),
> >  
> >  	TP_STRUCT__entry(
> >  		__string(dev_name, dev_name)
> >  		__string(str, str)
> >  		__array(unsigned char, hdr, 12)
> >  		__array(unsigned char, tsf, 16)
> > +		__string(tsf_type, tsf_type)
> 
> 		__field(int, tsf_type)
> 
> >  	),
> >  
> >  	TP_fast_assign(
> > @@ -311,12 +313,14 @@ TRACE_EVENT(ufshcd_upiu,
> >  		__assign_str(str, str);
> >  		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
> >  		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
> > +		__assign_str(tsf_type, tsf_type);
> 
> 
> 		__entry->tsf_type = tsf_type;
> 
> 
> >  	),
> >  
> >  	TP_printk(
> > -		"%s: %s: HDR:%s, CDB:%s",
> > +		"%s: %s: HDR:%s, %s:%s",
> >  		__get_str(str), __get_str(dev_name),
> >  		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
> > +		__get_str(tsf_type),
> 
> 		print_symbolic(tsf_type, TRACE_TSF_TYPES),
> 
> -- Steve
> 
> 
> >  		__print_hex(__entry->tsf, sizeof(__entry->tsf))
> >  	)
> >  );
> 
> 

Thanks Bart and Steve,
That's nice, I will change them in the next version.

Bean



