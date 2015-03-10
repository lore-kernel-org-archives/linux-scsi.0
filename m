From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 3/3] scsi: ufs: add trace events and dump prints for
 debug
Date: Tue, 10 Mar 2015 10:43:57 -0400
Message-ID: <20150310104357.0165cab6@gandalf.local.home>
References: <1425988035-966-1-git-send-email-gbroner@codeaurora.org>
	<1425988035-966-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1425988035-966-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 10 Mar 2015 13:47:15 +0200
Gilad Broner <gbroner@codeaurora.org> wrote:


> +++ b/include/trace/events/ufs.h
> @@ -0,0 +1,227 @@
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
> +
> +TRACE_EVENT(ufshcd_clk_gating,
> +
> +	TP_PROTO(const char *dev_name, const char *state),
> +
> +	TP_ARGS(dev_name, state),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(state, state)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(state, state);
> +	),
> +
> +	TP_printk("%s: gating state changed to %s",
> +		__get_str(dev_name), __get_str(state))
> +);

This and the auto_bkops_state is pretty much the same. Can't you use
the same TP_printk() and just have a DECLARE_EVENT_CLASS? The trace
point name is printed with the event to see different events.

At least use DEFINE_EVENT_PRINT() that lets you override a EVENT_CLASS
TP_printk(). This saves memory.

-- Steve


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
> +TRACE_EVENT(ufshcd_auto_bkops_state,
> +
> +	TP_PROTO(const char *dev_name, const char *state),
> +
> +	TP_ARGS(dev_name, state),
> +
> +	TP_STRUCT__entry(
> +		__string(dev_name, dev_name)
> +		__string(state, state)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(dev_name, dev_name);
> +		__assign_str(state, state);
> +	),
> +
> +	TP_printk("%s: auto bkops - %s",
> +		__get_str(dev_name), __get_str(state))
> +);
> +
