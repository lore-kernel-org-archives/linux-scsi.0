Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8BC266576;
	Tue, 30 Jun 2026 21:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782856204; cv=none; b=bf0R4j11EqlJYNV5306LgBHwPg9uYvPoxUp1j2t5Cm49zUW21v0ahNPeHfTTmZ0sGI3vFnjGjyKjzha+dBZajtxrSDYaBTlNXQzIk7DQYibTiV/LxXuv/Xh4PHChefNTxVzRwM1l7XgMaW+cwTpbMWE9W5pLTRPoruDHqFnjhGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782856204; c=relaxed/simple;
	bh=9uV2+og0x+C3Hw9tJNpVd6mxE97BmE40f3K1a7HJIqo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hh94uwj9PR4ruLcO5XL0mEhuwgsnEJS+QG5c+SwuJDiL1wOZQIF0K/0EWVGzGGA8PPeHw3tQ9UbG6N3DwUquShvbYwGHOFHLb3SSbF+aKWBhTwaZ3pxXRWcWd5ncFR9CSutT8BELpycEUv9NQJRnvNPqkT6RcOYXWCDK5DCPRHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 403081C4D3D;
	Tue, 30 Jun 2026 21:49:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 89BA880011;
	Tue, 30 Jun 2026 21:49:49 +0000 (UTC)
Date: Tue, 30 Jun 2026 17:49:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
 <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
 <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
 <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
 <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
 <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
 <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
 <eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>,
 <ed.tsai@mediatek.com>, <bvanassche@acm.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
Message-ID: <20260630174949.16a9d867@gandalf.local.home>
In-Reply-To: <20260630165612.3e21b510@gandalf.local.home>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
	<20260630165612.3e21b510@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 89BA880011
X-Stat-Signature: zos49tdjtipgczwyznzu5ysm1neddnbt
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19HS5wj3FmjR/6nlugjqjNUD4CtmIyueu4=
X-HE-Tag: 1782856189-902037
X-HE-Meta: U2FsdGVkX1+ct3S9wj9/rXc92SKoO6+Hfwymjc0MrzcE9PcUIltCCG96E2qjO5DwH94u/1YaFxCD3VVej/72IZ/D1TRoZXUXBgaizmcQK5gSswyuFgFSc5g+ptsPAL6PhZc8eou89Ef4UGhbxeMimseREvSgbxWIjnoaAa3Bbw9LicC27+4o+ysE0r6e98ejbKa9dnhGbeXJOXFgoHwH4N76NHE7YIktHW4bSPc+TKqf5cVjp9i8F3RUeCO8iQoZPaU3uIBi2A+3MNIpnFeqwedCfIHjrCrL+/p/nrUkVEEpXkQpL89PiCvtW/GmBGkEDeqlyB4RXvw8gpIWNDSGv9S4JFjJM7IdyWJLiwhKLHYRAn7UjwBJDdhgZOh2CdrtPk1V6r88pEychDDySzRKOA==

On Tue, 30 Jun 2026 16:56:12 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> >  
> >  	TP_printk("%s: gating state changed to %s",
> > -		__get_str(dev_name),
> > +		dev_name(__entry->hba->dev),  
> 
> NO YOU CAN NOT DO THIS!!!!

This is why you should always Cc linux-trace-kernel@vger.kernel.org on any
trace event updates. We look to catch bugs like this.

The below patch should fix it, and I'll send it as a proper patch soon:

diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
index 309ae51b4906..377a3c54b9f5 100644
--- a/drivers/ufs/core/ufs_trace.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -89,16 +89,18 @@ TRACE_EVENT(ufshcd_clk_gating,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(int, state)
 	),
 
 	TP_fast_assign(
+		__assign_str(dev_name);
 		__entry->hba = hba;
 		__entry->state = state;
 	),
 
 	TP_printk("%s: gating state changed to %s",
-		dev_name(__entry->hba->dev),
+		__get_str(dev_name),
 		__print_symbolic(__entry->state, UFSCHD_CLK_GATING_STATES))
 );
 
@@ -111,6 +113,7 @@ TRACE_EVENT(ufshcd_clk_scaling,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__string(state, state)
 		__string(clk, clk)
 		__field(u32, prev_state)
@@ -119,6 +122,7 @@ TRACE_EVENT(ufshcd_clk_scaling,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__assign_str(state);
 		__assign_str(clk);
 		__entry->prev_state = prev_state;
@@ -126,7 +130,7 @@ TRACE_EVENT(ufshcd_clk_scaling,
 	),
 
 	TP_printk("%s: %s %s from %u to %u Hz",
-		dev_name(__entry->hba->dev), __get_str(state), __get_str(clk),
+		__get_str(dev_name), __get_str(state), __get_str(clk),
 		__entry->prev_state, __entry->curr_state)
 );
 
@@ -138,16 +142,18 @@ TRACE_EVENT(ufshcd_auto_bkops_state,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__string(state, state)
 	),
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__assign_str(state);
 	),
 
 	TP_printk("%s: auto bkops - %s",
-		dev_name(__entry->hba->dev), __get_str(state))
+		__get_str(dev_name), __get_str(state))
 );
 
 DECLARE_EVENT_CLASS(ufshcd_profiling_template,
@@ -158,6 +164,7 @@ DECLARE_EVENT_CLASS(ufshcd_profiling_template,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__string(profile_info, profile_info)
 		__field(s64, time_us)
 		__field(int, err)
@@ -165,13 +172,14 @@ DECLARE_EVENT_CLASS(ufshcd_profiling_template,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__assign_str(profile_info);
 		__entry->time_us = time_us;
 		__entry->err = err;
 	),
 
 	TP_printk("%s: %s: took %lld usecs, err %d",
-		dev_name(__entry->hba->dev), __get_str(profile_info),
+		__get_str(dev_name), __get_str(profile_info),
 		__entry->time_us, __entry->err)
 );
 
@@ -200,6 +208,7 @@ DECLARE_EVENT_CLASS(ufshcd_template,
 		__field(s64, usecs)
 		__field(int, err)
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(int, dev_state)
 		__field(int, link_state)
 	),
@@ -208,13 +217,14 @@ DECLARE_EVENT_CLASS(ufshcd_template,
 		__entry->usecs = usecs;
 		__entry->err = err;
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->dev_state = dev_state;
 		__entry->link_state = link_state;
 	),
 
 	TP_printk(
 		"%s: took %lld usecs, dev_state: %s, link_state: %s, err %d",
-		dev_name(__entry->hba->dev),
+		__get_str(dev_name),
 		__entry->usecs,
 		__print_symbolic(__entry->dev_state, UFS_PWR_MODES),
 		__print_symbolic(__entry->link_state, UFS_LINK_STATES),
@@ -279,6 +289,7 @@ TRACE_EVENT(ufshcd_command,
 	TP_STRUCT__entry(
 		__field(struct scsi_device *, sdev)
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(&sdev->sdev_dev))
 		__field(enum ufs_trace_str_t, str_t)
 		__field(unsigned int, tag)
 		__field(u32, doorbell)
@@ -291,6 +302,7 @@ TRACE_EVENT(ufshcd_command,
 	),
 
 	TP_fast_assign(
+		__assign_str(dev_name);
 		__entry->sdev = sdev;
 		__entry->hba = hba;
 		__entry->str_t = str_t;
@@ -307,7 +319,7 @@ TRACE_EVENT(ufshcd_command,
 	TP_printk(
 		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x (%s), group_id: 0x%x, hwq_id: %d",
 		show_ufs_cmd_trace_str(__entry->str_t),
-		dev_name(&__entry->sdev->sdev_dev), __entry->tag,
+		__get_str(dev_name), __entry->tag,
 		__entry->doorbell, __entry->transfer_len, __entry->intr,
 		__entry->lba, (u32)__entry->opcode, str_opcode(__entry->opcode),
 		(u32)__entry->group_id, __entry->hwq_id
@@ -322,6 +334,7 @@ TRACE_EVENT(ufshcd_uic_command,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(enum ufs_trace_str_t, str_t)
 		__field(u32, cmd)
 		__field(u32, arg1)
@@ -331,6 +344,7 @@ TRACE_EVENT(ufshcd_uic_command,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->str_t = str_t;
 		__entry->cmd = cmd;
 		__entry->arg1 = arg1;
@@ -340,7 +354,7 @@ TRACE_EVENT(ufshcd_uic_command,
 
 	TP_printk(
 		"%s: %s: cmd: 0x%x, arg1: 0x%x, arg2: 0x%x, arg3: 0x%x",
-		show_ufs_cmd_trace_str(__entry->str_t), dev_name(__entry->hba->dev),
+		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
 		__entry->cmd, __entry->arg1, __entry->arg2, __entry->arg3
 	)
 );
@@ -353,6 +367,7 @@ TRACE_EVENT(ufshcd_upiu,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(enum ufs_trace_str_t, str_t)
 		__array(unsigned char, hdr, 12)
 		__array(unsigned char, tsf, 16)
@@ -361,6 +376,7 @@ TRACE_EVENT(ufshcd_upiu,
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->str_t = str_t;
 		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
 		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
@@ -369,7 +385,7 @@ TRACE_EVENT(ufshcd_upiu,
 
 	TP_printk(
 		"%s: %s: HDR:%s, %s:%s",
-		show_ufs_cmd_trace_str(__entry->str_t), dev_name(__entry->hba->dev),
+		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
 		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
 		show_ufs_cmd_trace_tsf(__entry->tsf_t),
 		__print_hex(__entry->tsf, sizeof(__entry->tsf))
@@ -384,16 +400,18 @@ TRACE_EVENT(ufshcd_exception_event,
 
 	TP_STRUCT__entry(
 		__field(struct ufs_hba *, hba)
+		__string(dev_name, dev_name(hba->dev))
 		__field(u16, status)
 	),
 
 	TP_fast_assign(
 		__entry->hba = hba;
+		__assign_str(dev_name);
 		__entry->status = status;
 	),
 
 	TP_printk("%s: status 0x%x",
-		dev_name(__entry->hba->dev), __entry->status
+		__get_str(dev_name), __entry->status
 	)
 );
 
-- Steve
