Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E5532FA2E;
	Tue, 30 Jun 2026 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860352; cv=none; b=ASdNL7OjFFTdUtdXNZe74ZOVolKSAK0kz+UFKaZcBSbPSahAr3tjikhbjJFlcI2AfDh9rvzZoRe3WnlnmAtYSDY8AJut64Z0DyLlcEhTlNc7GIh1THA2lPZj/EkHF4m4kWfWXqMZ6qtsDJamT7IVAV2Gq2asMurbvylTZ+CIIIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860352; c=relaxed/simple;
	bh=7Wguo1ZUvqbxvXsicL8g03KZwVIjlp+iRC2iuUcRVlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m3p9019VQsw2domdNOkVVD0fL2ZRdxoqb4QiCavR9Qnk9VEW4gQqIPOkwVoO1txlRFKE4h5RWJO8MH+x537JHgKyD6PhhhOUVoKtGB65IdkYaLcvgsWCmKCCvVT2U531HjADqKc2yzIFCUE49pR8E03wGULAL+WWy+s9PbuOlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1064AC077A;
	Tue, 30 Jun 2026 22:59:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 664BF30;
	Tue, 30 Jun 2026 22:58:57 +0000 (UTC)
Date: Tue, 30 Jun 2026 18:58:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com, sutoshd@codeaurora.org, wsd_upstream@mediatek.com,
 linux-mediatek@lists.infradead.org, chun-hung.wu@mediatek.com,
 alice.chao@mediatek.com, cc.chou@mediatek.com, chaotian.jing@mediatek.com,
 jiajie.hao@mediatek.com, yi-fan.peng@mediatek.com, qilin.tan@mediatek.com,
 lin.gui@mediatek.com, tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
 naomi.chu@mediatek.com, ed.tsai@mediatek.com, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ufs: core: add hba parameter to trace events
Message-ID: <20260630185857.54c55d97@gandalf.local.home>
In-Reply-To: <16f26ea9-69d6-4f2f-9adc-c576c288a2f5@acm.org>
References: <20250213113707.955255-1-peter.wang@mediatek.com>
	<16f26ea9-69d6-4f2f-9adc-c576c288a2f5@acm.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 664BF30
X-Stat-Signature: uwehtoqqednqhf3zyo5jct5fcbfkhzr8
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/neeUCV/R9KHhr+SS3nL47b2vY2VzQvkE=
X-HE-Tag: 1782860337-648722
X-HE-Meta: U2FsdGVkX19nYBCqwu9Ixhtn09ay8RBzQ10D02bQ6sj9JfNDHi+XUt/BVZ4gGAaXgyyFLsjh8lbrwf4x+RJUcsbgjLoQE+pFkRBoKhPWJonoTwg32+oRA1Y1xvdg4Em/A6mEJW5v6irtqUi3xX04bR0xjgdImMU3GChz6lRzZlbQjRZgzPmzbJRVi1MhHvAAn0d+3nM7OKrXU0ggWrQ4X3YT7vqhxODo/OFhNtsUStSPx97/RBhxC340pR2yjuNo0ObTldNO+0gp2B05+BunahPio2cMJcm0ZCt9ASPRpbaPnS2jeDiNFb8ZTLXet79cxCGTvH5+zIBllavd2ZRAM1TtlB9R5pfMugudoQQQ8tik9aTC7JvqKQ==

On Thu, 13 Feb 2025 09:19:42 -0800
Bart Van Assche <bvanassche@acm.org> wrote:

> On 2/13/25 3:35 AM, peter.wang@mediatek.com wrote:
> > diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
> > index 84deca2b841d..2f79982846b6 100644
> > --- a/drivers/ufs/core/ufs_trace.h
> > +++ b/drivers/ufs/core/ufs_trace.h
> > @@ -83,16 +83,18 @@ UFS_CMD_TRACE_TSF_TYPES
> >   
> >   TRACE_EVENT(ufshcd_clk_gating,
> >   
> > -	TP_PROTO(const char *dev_name, int state),
> > +	TP_PROTO(struct ufs_hba *hba, int state),
> >   
> > -	TP_ARGS(dev_name, state),
> > +	TP_ARGS(hba, state),
> >   
> >   	TP_STRUCT__entry(
> > -		__string(dev_name, dev_name)
> > +		__field(struct ufs_hba *, hba)
> > +		__string(dev_name, dev_name(hba->dev))
> >   		__field(int, state)
> >   	),  
> 
> Please reduce the size of the tracing entries by removing dev_name from 
> TP_STRUCT__entry() and by replacing 'dev_name' with 'dev_name(hba->dev)'
> in the TP_printk() calls.

For future references, please do not recommend moving dereferences into the
TP_printk() callers. Those happen when the event is read by the user and
the hba pointer may no longer exist.

-- Steve
