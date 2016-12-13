From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 02/12] scsi: ufs: add tracing support
Date: Tue, 13 Dec 2016 15:10:21 -0500
Message-ID: <20161213151021.217fef28@gandalf.local.home>
References: <1481658529-31807-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481658529-31807-1-git-send-email-subhashj@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Sahitya Tummala <stummala@codeaurora.org>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 13 Dec 2016 11:48:45 -0800
Subhash Jadavani <subhashj@codeaurora.org> wrote:

> This change adds the ftrace support for following:
> 1. UFS initialization time
> 2. Clock gating states
> 3. Clock scaling states
> 4. Power management APIs latency
> 5. BKOPs enable/disable
> 
> Usage:
> 	echo 1 > /sys/kernel/debug/tracing/events/ufs/enable
> 	cat /sys/kernel/debug/tracing/trace_pipe
> 
> Reviewed-by: Sahitya Tummala <stummala@codeaurora.org>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c  | 133 ++++++++++++++++++++++++++++++++++++----
>  include/trace/events/ufs.h | 149 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 270 insertions(+), 12 deletions(-)
>  create mode 100644 include/trace/events/ufs.h
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fe516b2..73c5937 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -45,6 +45,9 @@
>  #include "ufs_quirks.h"
>  #include "unipro.h"
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/ufs.h>
> +
>  #define UFSHCD_REQ_SENSE_SIZE	18
>  
>  #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
> @@ -721,6 +724,40 @@ static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
>  		devfreq_resume_device(hba->devfreq);
>  }
>  
> +static const char *ufschd_uic_link_state_to_string(
> +			enum uic_link_state state)
> +{
> +	switch (state) {
> +	case UIC_LINK_OFF_STATE:	return "UIC_LINK_OFF_STATE";
> +	case UIC_LINK_ACTIVE_STATE:	return "UIC_LINK_ACTIVE_STATE";
> +	case UIC_LINK_HIBERN8_STATE:	return "UIC_LINK_HIBERN8_STATE";
> +	default:			return "UNKNOWN_STATE";
> +	}
> +}
> +
> +static const char *ufschd_ufs_dev_pwr_mode_to_string(
> +			enum ufs_dev_pwr_mode state)
> +{
> +	switch (state) {
> +	case UFS_ACTIVE_PWR_MODE:	return "UFS_ACTIVE_PWR_MODE";
> +	case UFS_SLEEP_PWR_MODE:	return "UFS_SLEEP_PWR_MODE";
> +	case UFS_POWERDOWN_PWR_MODE:	return "UFS_POWERDOWN_PWR_MODE";
> +	default:			return "UNKNOWN_STATE";
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

A much better way than the above is to use the TRACE_DEFINE_ENUM()
macros in the include/trace/events/ufs.h header. In fact, that's what
it was made for. Not only will it be much faster to record, it wont
waste as much space in the ring buffer.

.e.g.

#define UFS_LINK_STATES	\
	EM( UIC_LINK_OFF_STATE ) \
	EM( UIC_LINK_ACTIVE_STATE ) \
	EMe(UIC_LINK_HIBERN8_STATE )

#define UFS_PWR_MODES \
	EM( UFS_ACTIVE_PWR_MODE ) \
	EM( UFS_SLEEP_PWR_MODE ) \
	EM( UFS_POWERDOWN_PWR_MODE) \
	EMe(UFS_POWERDOWN_PWR_MODE)

#define UFSCHD_CLK_GATING_STATES \
	EM( CLKS_OFF) \
	EM( CLKS_ON) \
	EM( REQ_CLKS_OFF) \
	EMe(REQ_CLKS_ON)

#undef EM
#undef EMe

#define EM(a)	TRACE_DEFINE_ENUM(a);
#define EMe(a)	TRACE_DEFINE_ENUM(a);

UFS_LINK_STATES
UFS_PWR_MODES
UFSCHD_CLK_GATING_STATES

#undef EM
#undef EMe

#define EM(a)	{ a, #a },
#define EMe(a)	{ a, #a }


DECLARE_EVENT_CLASS(ufshcd_template,
	TP_PROTO(const char *dev_name int err, s64 usecs,
		 int state, int link_state);

	[..]

	TP_printk(
		"%s: took %lld, dev_state: %s, link_state: %s, err %d",
		get_str(dev_name),
		__entry->usecs,
		__print_symbolic(__entry->state, UFS_PWR_MODES),
		__print_symbolic(__entry->link_state, UFS_LINK_STATES),
		__entry->err
	)

Not to mention, I think some of the strings may not be matching what
was passed in.

-- Steve



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
> +#endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
