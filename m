Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A0FC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 08:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiGRIyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 04:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGRIyl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 04:54:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1B0C46
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 01:54:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C920F373AF;
        Mon, 18 Jul 2022 08:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658134478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E0w0iwtrvbZq4zCIMbuyF6vYyQMGpazR5bEKipOeKL8=;
        b=ZSwFq8Hy8pNirbCEgzF5H0+C9mhxIDRSpZPNMweaTWJdh+lm+U15YK+gSU8Kj4XZBL+Gll
        uzaE/hwoL2hfxITSQ4o1yPbdELaIETQyrODbDTqvIe4LjXWy8LJn8SvWdQaWWB9kdHOvTE
        5bCxT50fVSlQvf7Q+944mKJj0MisSZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658134478;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E0w0iwtrvbZq4zCIMbuyF6vYyQMGpazR5bEKipOeKL8=;
        b=mVfXFpMIqQO2oAhNz3frnoFpCbBw1qs1qgrweRLbWu2P2DupLlow4mVRYJv6Lhc6+ABVgj
        PZR7NwumsaMUAyCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B002113754;
        Mon, 18 Jul 2022 08:54:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tkXzKs4f1WK2HgAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 18 Jul 2022 08:54:38 +0000
Date:   Mon, 18 Jul 2022 10:54:38 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/6] qla2xxx: Add a generic tracing framework
Message-ID: <20220718085438.mdv3rnbwc4bxfxrd@carbon.lan>
References: <20220715060227.23923-1-njavali@marvell.com>
 <20220715060227.23923-3-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715060227.23923-3-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

[adding Steven Rostedt]

On Thu, Jul 14, 2022 at 11:02:23PM -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> Adding a message based tracing mechanism where
> a rotating number of messages are captured in
> a trace structure. Disable/enable/resize
> operations are allowed via debugfs interfaces.

I really wonder why you need to this kind of infrastructure to your
driver? As far I know the qla2xxx is already able to log into
ftrace. Why can't we just use this infrastructure?

Thanks,
Daniel

> 
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.c |  12 +++
>  drivers/scsi/qla2xxx/qla_dbg.h | 140 +++++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_def.h |  31 ++++++++
>  drivers/scsi/qla2xxx/qla_dfs.c | 102 ++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/qla_os.c  |   5 ++
>  5 files changed, 290 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 7cf1f78cbaee..c4ba8ac51d27 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -2777,3 +2777,15 @@ ql_dbg_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
>  	va_end(va);
>  
>  }
> +
> +#ifdef QLA_TRACING
> +void qla_tracing_init(void)
> +{
> +	if (is_kdump_kernel())
> +		return;
> +}
> +
> +void qla_tracing_exit(void)
> +{
> +}
> +#endif /* QLA_TRACING */
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index feeb1666227f..e0d91a1f81c0 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -5,6 +5,7 @@
>   */
>  
>  #include "qla_def.h"
> +#include <linux/delay.h>
>  
>  /*
>   * Firmware Dump structure definition
> @@ -321,6 +322,145 @@ struct qla2xxx_fw_dump {
>  
>  extern uint ql_errlev;
>  
> +#ifdef QLA_TRACING
> +#include <linux/crash_dump.h>
> +
> +extern void qla_tracing_init(void);
> +extern void qla_tracing_exit(void);
> +
> +static inline int
> +ql_mask_match_ext(uint level, int *log_tunable)
> +{
> +	if (*log_tunable == 1)
> +		*log_tunable = QL_DBG_DEFAULT1_MASK;
> +
> +	return (level & *log_tunable) == level;
> +}
> +
> +static inline int
> +__qla_trace_get(struct qla_trace *trc)
> +{
> +	if (test_bit(QLA_TRACE_QUIESCE, &trc->flags))
> +		return -EIO;
> +	atomic_inc(&trc->ref_count);
> +	return 0;
> +}
> +
> +static inline int
> +qla_trace_get(struct qla_trace *trc)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&trc->trc_lock, flags);
> +	ret = __qla_trace_get(trc);
> +	spin_unlock_irqrestore(&trc->trc_lock, flags);
> +
> +	return ret;
> +}
> +
> +static inline void
> +qla_trace_put(struct qla_trace *trc)
> +{
> +	wmb();
> +	atomic_dec(&trc->ref_count);
> +}
> +
> +static inline char *
> +qla_get_trace_next(struct qla_trace *trc)
> +{
> +	uint32_t t_ind;
> +	char *buf;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&trc->trc_lock, flags);
> +	if (!test_bit(QLA_TRACE_ENABLED, &trc->flags) ||
> +	    __qla_trace_get(trc)) {
> +		spin_unlock_irqrestore(&trc->trc_lock, flags);
> +		return NULL;
> +	}
> +	t_ind = trc->trace_ind = qla_trace_ind_norm(trc, trc->trace_ind + 1);
> +	spin_unlock_irqrestore(&trc->trc_lock, flags);
> +
> +	if (!t_ind)
> +		set_bit(QLA_TRACE_WRAPPED, &trc->flags);
> +
> +	buf = qla_trace_record(trc, t_ind);
> +	/* Put an end marker '>' for the next record. */
> +	qla_trace_record(trc, qla_trace_ind_norm(trc, t_ind + 1))[0] = '>';
> +
> +	return buf;
> +}
> +
> +static inline int
> +qla_trace_quiesce(struct qla_trace *trc)
> +{
> +	unsigned long flags;
> +	u32 cnt = 0;
> +	int ret = 0;
> +
> +	set_bit(QLA_TRACE_QUIESCE, &trc->flags);
> +
> +	spin_lock_irqsave(&trc->trc_lock, flags);
> +	while (atomic_read(&trc->ref_count)) {
> +		spin_unlock_irqrestore(&trc->trc_lock, flags);
> +
> +		msleep(1);
> +
> +		spin_lock_irqsave(&trc->trc_lock, flags);
> +		cnt++;
> +		if (cnt > 10 * 1000) {
> +			pr_info("qla2xxx: Trace could not be quiesced now (count=%d).",
> +				atomic_read(&trc->ref_count));
> +			/* Leave trace enabled */
> +			clear_bit(QLA_TRACE_QUIESCE, &trc->flags);
> +			ret = -EIO;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&trc->trc_lock, flags);
> +	return ret;
> +}
> +
> +static inline void
> +qla_trace_init(struct qla_trace *trc, char *name, u32 num_entries)
> +{
> +	if (trc->recs)
> +		return;
> +
> +	memset(trc, 0, sizeof(*trc));
> +
> +	trc->name = name;
> +	spin_lock_init(&trc->trc_lock);
> +	if (!num_entries)
> +		return;
> +	trc->num_entries = num_entries;
> +	trc->recs = vzalloc(trc->num_entries *
> +				sizeof(struct qla_trace_rec));
> +	if (!trc->recs)
> +		return;
> +
> +	set_bit(QLA_TRACE_ENABLED, &trc->flags);
> +}
> +
> +static inline void
> +qla_trace_uninit(struct qla_trace *trc)
> +{
> +	if (!trc->recs)
> +		return;
> +
> +	vfree(trc->recs);
> +	trc->recs = NULL;
> +	clear_bit(QLA_TRACE_ENABLED, &trc->flags);
> +}
> +
> +#else /* QLA_TRACING */
> +#define qla_trace_init(trc, name, num)
> +#define qla_trace_uninit(trc)
> +#define qla_tracing_init()
> +#define qla_tracing_exit()
> +#endif /* QLA_TRACING */
> +
>  void __attribute__((format (printf, 4, 5)))
>  ql_dbg(uint, scsi_qla_host_t *vha, uint, const char *fmt, ...);
>  void __attribute__((format (printf, 4, 5)))
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 22274b405d01..39322105e7be 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -35,6 +35,37 @@
>  
>  #include <uapi/scsi/fc/fc_els.h>
>  
> +#define QLA_TRACING /* Captures driver messages to buffer */
> +
> +#ifdef QLA_TRACING
> +#define QLA_TRACE_LINE_SIZE		256	/* Biggest so far is ~215 */
> +#define qla_trace_ind_norm(_trc, _ind)	((_ind) >= (_trc)->num_entries ? \
> +							0 : (_ind))
> +#define qla_trace_record(_trc, __ind)	((_trc)->recs[__ind].buf)
> +#define qla_trace_record_len		(sizeof(struct qla_trace_rec))
> +#define qla_trace_start(_trc)		qla_trace_record(_trc, 0)
> +#define qla_trace_len(_trc)		((_trc)->num_entries)
> +#define qla_trace_size(_trc)		(qla_trace_record_len * \
> +						(_trc)->num_entries)
> +#define qla_trace_cur_ind(_trc)		((_trc)->trace_ind)
> +struct qla_trace_rec {
> +	char buf[QLA_TRACE_LINE_SIZE];
> +};
> +
> +struct qla_trace {
> +#define QLA_TRACE_ENABLED	0 /* allow trace writes or not */
> +#define QLA_TRACE_WRAPPED	1
> +#define QLA_TRACE_QUIESCE	2
> +	unsigned long	flags;
> +	atomic_t	ref_count;
> +	u32		num_entries;
> +	u32		trace_ind;
> +	spinlock_t	trc_lock;
> +	char		*name;
> +	struct qla_trace_rec *recs;
> +};
> +#endif /* QLA_TRACING */
> +
>  #define QLA_DFS_DEFINE_DENTRY(_debugfs_file_name) \
>  	struct dentry *dfs_##_debugfs_file_name
>  #define QLA_DFS_ROOT_DEFINE_DENTRY(_debugfs_file_name) \
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
> index c3c8b9536ef6..98c6390ad1f1 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -489,6 +489,108 @@ qla_dfs_naqp_show(struct seq_file *s, void *unused)
>  	return 0;
>  }
>  
> +#ifdef QLA_TRACING
> +static char *trace_help = "\
> +# Format:\n\
> +#   <msec> <cpu#> <message>\n\
> +#\n\
> +# Trace control by writing:\n\
> +#   'enable' - to enable this trace\n\
> +#   'disable' - to disable this trace\n\
> +#   'resize=<nlines>' - to resize this trace to <nlines>\n\
> +#\n";
> +
> +static int
> +qla_dfs_trace_show(struct seq_file *s, void *unused)
> +{
> +	struct qla_trace *trc = s->private;
> +	char *buf;
> +	u32 t_ind = 0, i;
> +
> +	seq_puts(s, trace_help);
> +
> +	if (qla_trace_get(trc))
> +		return 0;
> +
> +	seq_printf(s, "# Trace max lines = %d, writes = %s\n#\n",
> +		   trc->num_entries, test_bit(QLA_TRACE_ENABLED,
> +		   &trc->flags) ? "enabled" : "disabled");
> +
> +	if (test_bit(QLA_TRACE_WRAPPED, &trc->flags))
> +		t_ind = qla_trace_cur_ind(trc) + 1;
> +
> +	for (i = 0; i < qla_trace_len(trc); i++, t_ind++) {
> +		t_ind = qla_trace_ind_norm(trc, t_ind);
> +		buf = qla_trace_record(trc, t_ind);
> +		if (!buf[0])
> +			continue;
> +		seq_puts(s, buf);
> +	}
> +
> +	mb();
> +	qla_trace_put(trc);
> +	return 0;
> +}
> +
> +#define string_is(_buf, _str_val) \
> +	(strncmp(_str_val, _buf, strlen(_str_val)) == 0)
> +
> +static ssize_t
> +qla_dfs_trace_write(struct file *file, const char __user *buffer,
> +		    size_t count, loff_t *pos)
> +{
> +	struct seq_file *s = file->private_data;
> +	struct qla_trace *trc = s->private;
> +	char buf[32];
> +	ssize_t ret = count;
> +
> +	memset(buf, 0, sizeof(buf));
> +	if (copy_from_user(buf, buffer, min(sizeof(buf), count)))
> +		return -EFAULT;
> +
> +	if (string_is(buf, "enable")) {
> +		if (!trc->recs) {
> +			pr_warn("qla2xxx: '%s' is empty, resize before enabling.\n",
> +					trc->name);
> +			return -EINVAL;
> +		}
> +		pr_info("qla2xxx: Enabling trace '%s'\n", trc->name);
> +		set_bit(QLA_TRACE_ENABLED, &trc->flags);
> +	} else if (string_is(buf, "disable")) {
> +		pr_info("qla2xxx: Disabling trace '%s'\n", trc->name);
> +		clear_bit(QLA_TRACE_ENABLED, &trc->flags);
> +	} else if (string_is(buf, "resize")) {
> +		u32 new_len;
> +
> +		if (sscanf(buf, "resize=%d", &new_len) != 1)
> +			return -EINVAL;
> +		if (new_len == trc->num_entries) {
> +			pr_info("qla2xxx: New trace size is same as old.\n");
> +			return count;
> +		}
> +		pr_info("qla2xxx: Changing trace '%s' size to %d\n",
> +			trc->name, new_len);
> +		if (qla_trace_quiesce(trc)) {
> +			ret = -EBUSY;
> +			goto done;
> +		}
> +		qla_trace_uninit(trc);
> +		/*
> +		 * Go through init once again to start creating traces
> +		 * based on the respective tunable.
> +		 */
> +		qla_trace_init(trc, trc->name, new_len);
> +		if (!trc->recs) {
> +			pr_warn("qla2xxx: Trace allocation failed for '%s'\n",
> +				trc->name);
> +			ret = -ENOMEM;
> +		}
> +	}
> +done:
> +	return ret;
> +}
> +#endif /* QLA_TRACING */
> +
>  /*
>   * Helper macros for setting up debugfs entries.
>   * _name: The name of the debugfs entry
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 0bd0fd1042df..0d2397069cac 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -8191,6 +8191,8 @@ qla2x00_module_init(void)
>  	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
>  	BUILD_BUG_ON(sizeof(target_id_t) != 2);
>  
> +	qla_tracing_init();
> +
>  	/* Allocate cache for SRBs. */
>  	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
>  	    SLAB_HWCACHE_ALIGN, NULL);
> @@ -8269,6 +8271,7 @@ qla2x00_module_init(void)
>  
>  destroy_cache:
>  	kmem_cache_destroy(srb_cachep);
> +	qla_tracing_exit();
>  	return ret;
>  }
>  
> @@ -8287,6 +8290,8 @@ qla2x00_module_exit(void)
>  	fc_release_transport(qla2xxx_transport_template);
>  	qlt_exit();
>  	kmem_cache_destroy(srb_cachep);
> +
> +	qla_tracing_exit();
>  }
>  
>  module_init(qla2x00_module_init);
> -- 
> 2.19.0.rc0
> 
