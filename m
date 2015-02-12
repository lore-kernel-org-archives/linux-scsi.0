From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Thu, 12 Feb 2015 14:55:51 -0500
Message-ID: <20150212145551.2d234fb1@gandalf.local.home>
References: <1423576735-26267-1-git-send-email-gbroner@codeaurora.org>
	<1423576735-26267-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:49732 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751573AbbBLTzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2015 14:55:55 -0500
In-Reply-To: <1423576735-26267-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>

On Tue, 10 Feb 2015 15:58:54 +0200
Gilad Broner <gbroner@codeaurora.org> wrote:

I really hate large patches like this. So much to dig through.

> -#ifdef CONFIG_DEBUG_FS
> +#define UIC_ERR_REG_HIST_LENGTH 8
> +/**
> + * struct ufs_uic_err_reg_hist - keeps history of uic errors
> + * @pos: index to indicate cyclic buffer position
> + * @reg: cyclic buffer for registers value
> + * @tstamp: cyclic buffer for time stamp
> + */
> +struct ufs_uic_err_reg_hist {
> +	int pos;
> +	u32 reg[UIC_ERR_REG_HIST_LENGTH];
> +	ktime_t tstamp[UIC_ERR_REG_HIST_LENGTH];
> +};
> +
> +/**
> + * struct ufs_stats - keeps usage/err statistics
> + * @enabled: enable tagstats for debugfs
> + * @tag_stats: pointer to tag statistic counters
> + * @q_depth: current amount of busy slots
> + * @err_stats: counters to keep track of various errors
> + * @hibern8_exit_cnt: Counter to keep track of number of exits,
> + *		reset this after link-startup.
> + * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
> + *		Clear after the first successful command completion.
> + * @pa_err: tracks pa-uic errors
> + * @dl_err: tracks dl-uic errors
> + * @nl_err: tracks nl-uic errors
> + * @tl_err: tracks tl-uic errors
> + * @dme_err: tracks dme errors
> + */
>  struct ufs_stats {
> +#ifdef CONFIG_DEBUG_FS
>  	bool enabled;
>  	u64 **tag_stats;
>  	int q_depth;
>  	int err_stats[UFS_ERR_MAX];
> +#endif

Can any of the tracepoint code be called that references these when
CONFIG_DEBUG_FS is not set? Because soon (possibly even this merge
window), tracing will no longer depend on DEBUG_FS, because it will
have its own filesystem.

-- Steve

