From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RESEND/PATCH v8 3/3] scsi: ufs: add trace events and dump
 prints for debug
Date: Tue, 14 Apr 2015 09:05:08 -0400
Message-ID: <20150414090508.678bbd70@gandalf.local.home>
References: <1429012281-24068-1-git-send-email-gbroner@codeaurora.org>
	<1429012281-24068-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1429012281-24068-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 14 Apr 2015 14:51:21 +0300
Gilad Broner <gbroner@codeaurora.org> wrote:


> +static const char *ufschd_uic_link_state_to_string(
> +			enum uic_link_state state)
> +{
> +	switch (state) {
> +	case UIC_LINK_OFF_STATE:	return "OFF";
> +	case UIC_LINK_ACTIVE_STATE:	return "ACTIVE";
> +	case UIC_LINK_HIBERN8_STATE:	return "HIBERN8";
> +	default:			return "UNKNOWN";
> +	}
> +}
> +
> +static const char *ufschd_ufs_dev_pwr_mode_to_string(
> +			enum ufs_dev_pwr_mode state)
> +{
> +	switch (state) {
> +	case UFS_ACTIVE_PWR_MODE:	return "ACTIVE";
> +	case UFS_SLEEP_PWR_MODE:	return "SLEEP";
> +	case UFS_POWERDOWN_PWR_MODE:	return "POWERDOWN";
> +	default:			return "UNKNOWN";
> +	}
> +}
> +
> +static const char *ufschd_clk_gating_state_to_string(
> +			enum clk_gating_state state)
> +{
> +	switch (state) {
> +	case CLKS_OFF:		return "CLKS_OFF";
> +	case CLKS_ON:		return "CLKS_ON";
> +	case REQ_CLKS_OFF:	return "REQ_CLKS_OFF";
> +	case REQ_CLKS_ON:	return "REQ_CLKS_ON";
> +	default:		return "UNKNOWN_STATE";
> +	}
> +}
> +
>  static void ufshcd_ungate_work(struct work_struct *work)
>  {
>  	int ret;
> @@ -635,6 +819,9 @@ start:
>  	case REQ_CLKS_OFF:
>  		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
>  			hba->clk_gating.state = CLKS_ON;
> +			trace_ufshcd_clk_gating(dev_name(hba->dev),
> +				ufschd_clk_gating_state_to_string(
> +					hba->clk_gating.state));

Instead of wasting the ring buffer by writing the strings into the ring
buffer directly, please just write the enum (4 bytes), and use
__print_symbolic() to print out the string.

My 4.1 patch queue even has a way to convert the enum names that are
exported to user space back into their numbers such that tools like
perf and trace-cmd can still parse it.


>  			break;
>  		}
>  		/*
> @@ -645,6 +832,9 @@ start:
>  	case CLKS_OFF:
>  		scsi_block_requests(hba->host);
>  		hba->clk_gating.state = REQ_CLKS_ON;
> +		trace_ufshcd_clk_gating(dev_name(hba->dev),
> +			ufschd_clk_gating_state_to_string(
> +				hba->clk_gating.state));
>  		schedule_work(&hba->clk_gating.ungate_work);
>  		/*
>  		 * fall through to check if we should wait for this


> +++ b/include/trace/events/ufs.h
> @@ -0,0 +1,213 @@
> +/*
> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ufs
> +
> +#if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_UFS_H
> +
> +#include <linux/tracepoint.h>

#define UFS_STATES \
	{ UIC_LINK_OFF_STATE,		"OFF" }, \
	{ UIC_LINK_ACTIVE_STATE,	"ACTIVE" }, \
	{ UIC_LINK_HIBERN8_STATE,	"HIBERN8" }, \
	{ UFS_ACTIVE_PWR_MODE,		"ACTIVE" }, \
	{ UFS_SLEEP_PWR_MODE,		"SLEEP" }, \
	{ UFS_POWERDOWN_PWR_MODE,	"POWERDOWN" }, \
	{ CLKS_OFF,			"CLKS_OFF" }, \
	{ CLKS_ON:		"CLKS_ON" }, \
	{ REQ_CLKS_OFF,		"REQ_CLKS_OFF"}, \
	{ REQ_CLKS_ON,		"REQ_CLKS_ON"}

> +
> +DECLARE_EVENT_CLASS(ufshcd_state_change_template,
> +	TP_PROTO(const char *dev_name, const char *state),

TP_PROTO(const char *dev_nam, int state),

> +
> +	TP_ARGS(dev_name, state),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(state, state)

	__field(int, state)

> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(state, state);

	__entry->state = state;

> +	),
> +
> +	TP_printk("%s: state changed to %s",
> +		__get_str(dev_name),
		__print_symbolic(__entry->state, UFS_STATES)


Something like that. And after my patch set makes it into mainline
during this merge window, you can then change the above to:

#define UFS_STATES \
	EM( UIC_LINK_OFF_STATE,		"OFF" ) \
	EM( UIC_LINK_ACTIVE_STATE,	"ACTIVE" ) \
	EM( UIC_LINK_HIBERN8_STATE,	"HIBERN8" ) \
	EM( UFS_ACTIVE_PWR_MODE,	"ACTIVE" ) \
	EM( UFS_SLEEP_PWR_MODE,		"SLEEP" ) \
	EM( UFS_POWERDOWN_PWR_MODE,	"POWERDOWN" ) \
	EM( CLKS_OFF,			"CLKS_OFF" ) \
	EM( CLKS_ON:			"CLKS_ON" ) \
	EM( REQ_CLKS_OFF,		"REQ_CLKS_OFF") \
	EMe(REQ_CLKS_ON,		"REQ_CLKS_ON")

#undef EM
#undef EMe
#define EM(a, b) 	TRACE_DEFINE_ENUM(a);
#define EMe(a, b)	TRACE_DEFINE_ENUM(a);

UFS_STATES

#undef EM
#undef EMe
#define EM(a, b)	{ a, b },
#define EM(a, b)	{ a, b }

And then those enums will be converted to their actual values in the
printk formats in the format files.

-- Steve


> +);
> +
> +DEFINE_EVENT(ufshcd_state_change_template, ufshcd_clk_gating,
> +	TP_PROTO(const char *dev_name, const char *state),
> +	TP_ARGS(dev_name, state));
> +DEFINE_EVENT(ufshcd_state_change_template, ufshcd_auto_bkops_state,
> +	TP_PROTO(const char *dev_name, const char *state),
> +	TP_ARGS(dev_name, state));
> +
> +TRACE_EVENT(ufshcd_clk_scaling,
> +
> +	TP_PROTO(const char *dev_name, const char *state, const char *clk,
> +		u32 prev_state, u32 curr_state),
> +
> +	TP_ARGS(dev_name, state, clk, prev_state, curr_state),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(state, state)
> +		__string(clk, clk)
> +		__field(u32, prev_state)
> +		__field(u32, curr_state)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(state, state);
> +		__assign_str(clk, clk);
> +		__entry->prev_state = prev_state;
> +		__entry->curr_state = curr_state;
> +	),
> +
> +	TP_printk("%s: %s %s from %u to %u Hz",
> +		__get_str(dev_name), __get_str(state), __get_str(clk),
> +		__entry->prev_state, __entry->curr_state)
> +);
> +
> +DECLARE_EVENT_CLASS(ufshcd_profiling_template,
> +	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
> +		 int err),
> +
> +	TP_ARGS(dev_name, profile_info, time_us, err),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(profile_info, profile_info)
> +		__field(s64, time_us)
> +		__field(int, err)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(profile_info, profile_info);
> +		__entry->time_us = time_us;
> +		__entry->err = err;
> +	),
> +
> +	TP_printk("%s: %s: took %lld usecs, err %d",
> +		__get_str(dev_name), __get_str(profile_info),
> +		__entry->time_us, __entry->err)
> +);
> +
> +DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_hibern8,
> +	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
> +		 int err),
> +	TP_ARGS(dev_name, profile_info, time_us, err));
> +
> +DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_clk_gating,
> +	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
> +		 int err),
> +	TP_ARGS(dev_name, profile_info, time_us, err));
> +
> +DEFINE_EVENT(ufshcd_profiling_template, ufshcd_profile_clk_scaling,
> +	TP_PROTO(const char *dev_name, const char *profile_info, s64 time_us,
> +		 int err),
> +	TP_ARGS(dev_name, profile_info, time_us, err));
> +
> +DECLARE_EVENT_CLASS(ufshcd_template,
> +	TP_PROTO(const char *dev_name, int err, s64 usecs,
> +		 const char *dev_state, const char *link_state),
> +
> +	TP_ARGS(dev_name, err, usecs, dev_state, link_state),
> +
> +	TP_STRUCT__entry(
> +		__field(s64, usecs)
> +		__field(int, err)
> +		__string(dev_name, dev_name)
> +		__string(dev_state, dev_state)
> +		__string(link_state, link_state)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->usecs = usecs;
> +		__entry->err = err;
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(dev_state, dev_state);
> +		__assign_str(link_state, link_state);
> +	),
> +
> +	TP_printk(
> +		"%s: took %lld usecs, dev_state: %s, link_state: %s, err %d",
> +		__get_str(dev_name),
> +		__entry->usecs,
> +		__get_str(dev_state),
> +		__get_str(link_state),
> +		__entry->err
> +	)
> +);
> +
> +DEFINE_EVENT(ufshcd_template, ufshcd_system_suspend,
> +	     TP_PROTO(const char *dev_name, int err, s64 usecs,
> +		      const char *dev_state, const char *link_state),
> +	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
> +
> +DEFINE_EVENT(ufshcd_template, ufshcd_system_resume,
> +	     TP_PROTO(const char *dev_name, int err, s64 usecs,
> +		      const char *dev_state, const char *link_state),
> +	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
> +
> +DEFINE_EVENT(ufshcd_template, ufshcd_runtime_suspend,
> +	     TP_PROTO(const char *dev_name, int err, s64 usecs,
> +		      const char *dev_state, const char *link_state),
> +	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
> +
> +DEFINE_EVENT(ufshcd_template, ufshcd_runtime_resume,
> +	     TP_PROTO(const char *dev_name, int err, s64 usecs,
> +		      const char *dev_state, const char *link_state),
> +	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
> +
> +DEFINE_EVENT(ufshcd_template, ufshcd_init,
> +	     TP_PROTO(const char *dev_name, int err, s64 usecs,
> +		      const char *dev_state, const char *link_state),
> +	     TP_ARGS(dev_name, err, usecs, dev_state, link_state));
> +
> +TRACE_EVENT(ufshcd_command,
> +	TP_PROTO(const char *dev_name, const char *str, unsigned int tag,
> +			u32 doorbell, int transfer_len, u32 intr, u64 lba,
> +			u8 opcode),
> +
> +	TP_ARGS(dev_name, str, tag, doorbell, transfer_len, intr, lba, opcode),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(str, str)
> +		__field(unsigned int, tag)
> +		__field(u32, doorbell)
> +		__field(int, transfer_len)
> +		__field(u32, intr)
> +		__field(u64, lba)
> +		__field(u8, opcode)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(str, str);
> +		__entry->tag = tag;
> +		__entry->doorbell = doorbell;
> +		__entry->transfer_len = transfer_len;
> +		__entry->intr = intr;
> +		__entry->lba = lba;
> +		__entry->opcode = opcode;
> +	),
> +
> +	TP_printk(
> +		"%s: %s: tag: %u, DB: 0x%x, size: %d, IS: %u, LBA: %llu, opcode: 0x%x",
> +		__get_str(str), __get_str(dev_name), __entry->tag,
> +		__entry->doorbell, __entry->transfer_len,
> +		__entry->intr, __entry->lba, (u32)__entry->opcode
> +	)
> +);
> +
> +#endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
