From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v1 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Tue, 3 Feb 2015 11:53:51 -0500
Message-ID: <20150203115351.58994f7d@gandalf.local.home>
References: <1422977841-25036-1-git-send-email-gbroner@codeaurora.org>
	<1422977841-25036-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422977841-25036-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Petr Mladek <pmladek@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Vaibhav Nagarnaik <vnagarnaik@google.com>
List-Id: linux-scsi@vger.kernel.org

On Tue,  3 Feb 2015 17:37:19 +0200
Gilad Broner <gbroner@codeaurora.org> wrote:

> Add trace events to driver to allow monitoring and profilig
> of activities such as PM suspend/resume, hibernate enter/exit,
> clock gating and clock scaling up/down.
> In addition, add UFS host controller register dumps to provide
> detailed information in case of errors to assist in analysis
> of issues.
> 
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Lee Susman <lsusman@codeaurora.org>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c  |  53 +++++
>  drivers/scsi/ufs/ufshcd.c    | 509 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufshcd.h    |  49 ++++-
>  drivers/scsi/ufs/ufshci.h    |   1 +
>  include/linux/ftrace_event.h |   3 +
>  include/trace/events/ufs.h   | 227 +++++++++++++++++++



> +static inline void ufshcd_cond_add_cmd_trace(struct ufs_hba *hba,
> +					unsigned int tag, const char *str)
> +{
> +	if (FTRACE_EVENT_ENABLED(ufshcd_command))

What's this? Not mentioned at all in the change log.

> +		ufshcd_add_command_trace(hba, tag, str);
> +}
> +#else



> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 0bebb5c..54a4a63 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -606,4 +606,7 @@ perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
>  }
>  #endif
>  
> +#define FTRACE_EVENT_ENABLED(name)					\
> +	((event_##name).flags & (1 << (TRACE_EVENT_FL_WAS_ENABLED_BIT)))\
> +
>  #endif /* _LINUX_FTRACE_EVENT_H */

NACK!

Please use trace_<event>_enabled(), for instance,
trace_ufshcd_command_enabled().

This also uses jump_labels and is a nop when it is not enabled.

-- Steve
