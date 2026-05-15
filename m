Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C943E2AB5;
	Fri, 15 May 2026 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778871054; cv=none; b=MJDlnZDKSsvCJplG3e+pDAQBKkqK/rypQA4bJO6waWCHOATkKjw12sQ8XXmTY4K8dAc7LARkvfa69S1a2h5CVi+SReV3qp0yGm/dTlhnpP1ckmnKsBn1kOIHA8DtW/CaWBzes3XuAAGDPUzZAXfWDSTx9jca+OybKkumOcQ2iyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778871054; c=relaxed/simple;
	bh=Fh5nIpKIEkRcePCEGBEElyMGaMyAieIuHMAMa3JLQKc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t30DQhOlqmG0X2yU+SDIAVi8G/NsccL640HhzrNlLzuleGsA7gfqJwRczf0FuDMegc96pzvPBP6an4htCfXE4QOHcl9d5RWOjs+YwXyUipvyuezLDGRGhURmx7j/zdvhFYG4luQByjrFY791ASZm5ii1kILwHEulHQCDP/VWva0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 80D43160141;
	Fri, 15 May 2026 18:50:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id A64386000A;
	Fri, 15 May 2026 18:50:41 +0000 (UTC)
Date: Fri, 15 May 2026 14:50:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 08/11] scsi: ufs: Use trace_call__##name() at guarded
 tracepoint call sites
Message-ID: <20260515145048.1c021bc9@gandalf.local.home>
In-Reply-To: <9fde73e7-0108-48d7-a1a0-ccc9776beb5c@acm.org>
References: <20260515135946.2238888-1-vineeth@bitbyteword.org>
	<9fde73e7-0108-48d7-a1a0-ccc9776beb5c@acm.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w5gpk5wojme4p8f8rrjh4175dhuiaho5
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: A64386000A
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/lFLOMhLKhFr6Eb1OV9O9g+yqC6Yty8l0=
X-HE-Tag: 1778871041-350002
X-HE-Meta: U2FsdGVkX18KIYL7SUQ2xQVpSH5T5kZIcsMwMPv9mvMpLdospCP7ZQKNVNhMSM3zbIU/H66gjIKgAJ91J1uGh/FiOY2uL9V4kAECr092XuR+LeI8mPmMFvonO1lIUTQjS7VmxX0UV8IygAHXNfTAKMAVriEHSuP6NAkUuQuf9aE6pZNtcQcBYj6ppOsDYGks4SQ6UYIQaXIoU7GBh9I1QXW7jKBDq5wilWYz4nvsVjV7rrPmfTxHmaXUvBU3H825iHtfl/pwiirvSTR7mNDgzbd/+2CKFx4YloTGgvevu7tulZ/a5pBqItyto4hjCcStVQ1WxjxNIGfg8TUZa1oAKRs5YnmOj/fV

On Fri, 15 May 2026 08:27:27 -0700
Bart Van Assche <bvanassche@acm.org> wrote:

> On 5/15/26 6:59 AM, Vineeth Pillai (Google) wrote:
> >   static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
> > @@ -432,8 +432,8 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
> >   	if (!trace_ufshcd_upiu_enabled())
> >   		return;
> >   
> > -	trace_ufshcd_upiu(hba, str_t, &rq_rsp->header,
> > -			  &rq_rsp->qr, UFS_TSF_OSF);
> > +	trace_call__ufshcd_upiu(hba, str_t, &rq_rsp->header,
> > +			       &rq_rsp->qr, UFS_TSF_OSF);
> >   }  
> 
> Instead of making this change, please remove the 
> trace_ufshcd_upiu_enabled() call because it is redundant.

You mean to remove the ufshcd_add_query_upiu_trace() function and just use
a tracepoint where it is called?

Makes sense.

> 
> >   static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
> > @@ -445,15 +445,15 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
> >   		return;
> >   
> >   	if (str_t == UFS_TM_SEND)
> > -		trace_ufshcd_upiu(hba, str_t,
> > -				  &descp->upiu_req.req_header,
> > -				  &descp->upiu_req.input_param1,
> > -				  UFS_TSF_TM_INPUT);
> > +		trace_call__ufshcd_upiu(hba, str_t,
> > +					&descp->upiu_req.req_header,
> > +					&descp->upiu_req.input_param1,
> > +					UFS_TSF_TM_INPUT);
> >   	else
> > -		trace_ufshcd_upiu(hba, str_t,
> > -				  &descp->upiu_rsp.rsp_header,
> > -				  &descp->upiu_rsp.output_param1,
> > -				  UFS_TSF_TM_OUTPUT);
> > +		trace_call__ufshcd_upiu(hba, str_t,
> > +					&descp->upiu_rsp.rsp_header,
> > +					&descp->upiu_rsp.output_param1,
> > +					UFS_TSF_TM_OUTPUT);
> >   }  
> 
> Same comment here: I think it would be better to remove the 
> trace_ufshcd_upiu_enabled() call rather than
> changing trace_ufshcd_upiu() into trace_call__ufshcd_upiu().

Well, removing it here would mean placing the if (str == UFS_TM_SEND) into
the code and processing it even when tracing is disabled. With the
trace_*_enabled() helper, it's all a nop.

-- Steve


