Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E52C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 03:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4942561206
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 03:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238777AbhI1DEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 23:04:13 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20320 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238710AbhI1DEL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 23:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632798153; x=1664334153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=agGgQqNkLlc6+tu9Eynd0Bir3G+Cuh1eFcuafHVYpJ0=;
  b=d1DLgr+1MQ0Enmrnxg020oZOBOQasa/E3Wb4J5Zn+54ZbGVSXXAboHqf
   fsHAOyCILf3EwokE1TUdfBIa1Ovm9Z16zLOEYkzD+5S2Fyf8AELYURZw8
   2qrtfC+ZNDhQuYFFGd88jkbjeKoB+3L9CU+VWsHqkTrFD95I0mOR5D1DM
   9iF4qKxBmolEDj9zFSZ+BkrpgLl8EiephsZ9n93KwrTPqaQA3qmJgpG1O
   k9uUvWMrLqHJrv0yQ+yKctSLn2rMNeYK/QciwSZyhI5dhrrqDZRFzqVqV
   Gk6TTx2ThK9MWCQQb00eQMcWZzSeC7ZHVDJMU4p1go+6+DaPh5BPxZLM5
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,328,1624291200"; 
   d="scan'208";a="181749351"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2021 11:02:11 +0800
IronPort-SDR: 1kBQbL9UdDsYMhTSgtONCMiSoVtX8I4g83wuvNTT2feuigmlwcYmPCL45LO66KKzl5pO6Zzr0Y
 hhyb0BGTVVnyPg+nT/5mANw1nT2bMT3Pfk2KP5lKucEBFdBCO+tZfLdXyjRXIDebW/7rpTofmW
 zxsH9ULKy3FgviyW5UdS75dKwtI7hxVbaarUe9QHGE3+ENwimdxKtxPIdd6DHOoiQC9sOC7oml
 Db4nn2RaE/Xt1tFL9nYDATFTeR76NgHzWO1SKcMoHf6FvmRvST0elngser1q+Xa6SOauMfecNF
 RBvY8VG+2L1cCg+7afowUmkI
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 19:36:43 -0700
IronPort-SDR: kXkuwWmgGVR+43dZwiIKj++fEG5XjNMF+4b5AmT4LFv4Nw5HDCGJTSITjR4CYjXOHZ11pt/D/U
 5DX/Hy0sm8qk/0K3Uc2IeMSmrOcmV09HjJ7FHSiF3XL4q/2GrcrAeAHgocdREBgDgKhwGFK/DU
 xbwT928nfR/rGBf0ZWFvJvaWRjH6DbgUdi7LiDeKp/ukz4xGLgmM7Z9+KGw/scXTEx9kirq89g
 QTujx9jrQ1AgC25OFxS3TwpFVGw/NK7ft8w9dR7QRR0wTya9UqdHvacH2E6iaxP8wc2YVuYFKp
 h3g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 20:02:10 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HJPS214rhz1SHvt
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 20:02:10 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1632798128; x=1635390129; bh=agGgQqNkLlc6+tu9Eynd0Bir3G+Cuh1eFcu
        afHVYpJ0=; b=FVsJC3WE/4KlggfG8u/MjbFALytEqp1iYoLpfrZj9p00lOjh+m5
        8r0xcRiv0cCfOPF5LV5q8Uzb7SmRf1DLLvLVGqwUlRECnwpYPBtmA5rIUnLHgErI
        F4+jjAM/yhDH5G23ottzfZnQxxiLhwDqNje8ZEIMsYXgIWiImuwYeqDtKfwlEFJu
        zKwLEXL8NGxG3pa/uTQ9La/0n//l+98lB3uSZmpoy2pSd+ZeYGVeS7IbpazSWZiQ
        nrTT5YJExytmzGVAd3FchwElAdfELDzkeop/dwgd0w4/ozySJSmgqjUWXa42EDyu
        3/D4MOSd/eS5Gr/LbkMI3ngQsP2AN8EcvBQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kZcVKLEcwJmZ for <linux-scsi@vger.kernel.org>;
        Mon, 27 Sep 2021 20:02:08 -0700 (PDT)
Received: from [10.225.54.48] (jpf009086.ad.shared [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HJPRz3z95z1RvTg;
        Mon, 27 Sep 2021 20:02:07 -0700 (PDT)
Message-ID: <c5c8f1bd-10aa-28ab-9e78-0b583bb3452c@opensource.wdc.com>
Date:   Tue, 28 Sep 2021 12:02:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.2
Subject: Re: [PATCH v20 45/46] sg: add statistics similar to st
Content-Language: en-US
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
References: <20210915223305.256429-1-dgilbert@interlog.com>
 <20210915223305.256429-46-dgilbert@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20210915223305.256429-46-dgilbert@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/09/16 7:33, Douglas Gilbert wrote:
> Using the existing statistics gathering framework from the st
> driver, collect statistics for access via sysfs. The sysstat
> package already has a utility called tapestat for presenting
> st statistics. Its author is keen to use the existing
> tapestat code for showing sg statistics (rather than write a
> new utility).
> 
> In keeping with the sg driver being SCSI command agnostic, the
> "read" statistics are compiled for requests that have "data-in"
> user data while write statistics are compiled for requests that
> have "data-out" user data.
> 
> A new module/driver load time parameter called "comp_stats" has
> been added. It is boolean, the default (true or 1) is to collect
> statistics.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/sg.c | 268 ++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 236 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 3b3af2e6a195..0b72f7f8a71e 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -143,6 +143,7 @@ int sg_big_buff = SG_DEF_RESERVED_SIZE;
>   */
>  static int def_reserved_size = -1;	/* picks up init parameter */
>  static int sg_allow_dio = SG_ALLOW_DIO_DEF;	/* ignored by code */
> +static bool sg_comp_stats = true;
>  
>  static int scatter_elem_sz = SG_SCATTER_SZ;
>  
> @@ -213,7 +214,7 @@ struct sg_request {	/* active SCSI command or inactive request */
>  	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
>  	u8 cmd_opcode;		/* first byte of SCSI cdb */
>  	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */
> -	u64 start_ns;		/* starting point of command duration calc */
> +	ktime_t start_dur;	/* start time if before completion */
>  	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
>  	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
>  	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
> @@ -256,8 +257,10 @@ struct sg_device { /* holds the state of each scsi generic device */
>  	u32 index;		/* device index number */
>  	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
>  	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
> +	spinlock_t stats_lck;

Nit: spell out lock here, for code clarity ?

>  	char name[DISK_NAME_LEN];
>  	struct cdev *cdev;
> +	struct sg_dev_stats *statsp;	/* NULL when comp_stats=false */
>  	struct xarray sfp_arr;
>  	struct kref d_ref;
>  };
> @@ -275,6 +278,19 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
>  	const u8 __user *u_cmdp;
>  };
>  
> +struct sg_dev_stats {	/* copied from drivers/scsi/st.h scsi_tape_stats */
> +	u64 read_byte_cnt;	/* data-in bytes */
> +	u64 write_byte_cnt;	/* data-out bytes */
> +	u64 read_cnt;		/* Count of data-in requests */
> +	u64 write_cnt;		/* Count of data-out requests */
> +	u64 other_cnt;		/* Count of non-data requests */
> +	u64 resid_cnt;		/* Count of cmds with resid_len > 0 */
> +	u64 tot_read_time;	/* time spent completing data-in_s */
> +	u64 tot_write_time;	/* time spent completing data-out_s */

data-in_s and data-out-s here are unclear. What are they ?
why not simply:

/* time spent completing data-in requests */
/* time spent completing data-out requests */

> +	u64 tot_io_time;	/* ktime spent doing any I/O */
> +	s32 in_flight;		/* Number of I/Os in flight */

Why signed ?

> +};
> +
>  /* tasklet or soft irq callback */
>  static void sg_rq_end_io(struct request *rq, blk_status_t status);
>  /* Declarations of other static functions used before they are defined */
> @@ -306,6 +322,8 @@ static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
>  static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
>  static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
>  			     int loop_count);
> +static u32 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
> +		      bool *is_durp);
>  #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
>  static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
>  #endif
> @@ -1019,7 +1037,16 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
>  	is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
>  	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
>  	SG_LOG(3, sfp, "%s: is_v4h=%d\n", __func__, (int)is_v4h);
> -	srp->start_ns = ktime_get_boottime_ns();
> +	if (sg_comp_stats) {
> +		struct sg_device *sdp = sfp->parentdp;
> +
> +		spin_lock(&sdp->stats_lck);
> +		++sdp->statsp->in_flight;

Why not "sdp->statsp->in_flight++;" ?
I personally find that more readable.

> +		spin_unlock(&sdp->stats_lck);

In any case, why not make statsp->in_flight an atomic to avoid taking the
spinlock only for the increment ?

> +		WRITE_ONCE(srp->start_dur, ktime_get_boottime());
> +	} else {
> +		WRITE_ONCE(srp->start_dur, 0);
> +	}
>  	srp->duration = 0;
>  
>  	if (!is_v4h && srp->s_hdr3.interface_id == '\0')
> @@ -1193,11 +1220,49 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
>  	return sb_len_ret;
>  }
>  
> +static void
> +sg_do_stats(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
> +{
> +	int dir = v4_active ? srp->s_hdr4.dir : srp->s_hdr3.dxfer_direction;
> +	ktime_t kt = READ_ONCE(srp->start_dur);
> +	u64 ns = (kt > 0) ? ktime_to_ns(kt) : 0;
> +	struct sg_device *sdp = sfp->parentdp;
> +	struct sg_dev_stats *statsp = sdp->statsp;
> +
> +	if (!statsp)
> +		return;
> +	spin_lock(&sdp->stats_lck);
> +	if (dir == SG_DXFER_TO_DEV) {		/* data-out, write-like */
> +		statsp->tot_write_time += ns;
> +		statsp->tot_io_time += ns;

You could do without accounting the total io time here by modifying io_ns_show()
to do:

sysfs_emit(buf, "%llu",
	   sp->tot_io_time + sp->tot_read_time + sp->tot_write_time);

That saves one addition in the hot path.


> +		++statsp->write_cnt;
> +		statsp->write_byte_cnt += srp->sgat_h.dlen;
> +	} else if (dir == SG_DXFER_FROM_DEV) {	/* data-in, read-like */
> +		statsp->tot_read_time += ns;

Same comment as above.

> +		statsp->tot_io_time += ns;
> +		++statsp->read_cnt;
> +		statsp->read_byte_cnt += srp->sgat_h.dlen;
> +		if (srp->in_resid > 0)
> +			++statsp->resid_cnt;
> +	} else {	/* no data transfer (e.g. TEST UNIT READY) */
> +		statsp->tot_io_time += ns;
> +		++statsp->other_cnt;
> +	}
> +	--statsp->in_flight;

statsp->in_flight--; ? (easier to read in my opinion).

> +	spin_unlock(&sdp->stats_lck);
> +}
> +
>  static int
>  sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
>  {
>  	u32 rq_res = srp->rq_result;
>  
> +	if (sg_comp_stats) {
> +		const enum sg_rq_state sr_st = SG_RS_BUSY;
> +
> +		sg_do_stats(sfp, srp, v4_active);
> +		srp->duration = sg_get_dur(srp, &sr_st, NULL);
> +	}
>  	if (unlikely(srp->rq_result & 0xff)) {
>  		int sb_len_wr = sg_copy_sense(srp, v4_active);
>  
> @@ -1625,49 +1690,41 @@ sg_calc_sgat_param(struct sg_device *sdp)
>  	sdp->max_sgat_sz = sz;
>  }
>  
> -static u32
> -sg_calc_rq_dur(const struct sg_request *srp)
> -{
> -	ktime_t ts0 = ns_to_ktime(srp->start_ns);
> -	ktime_t now_ts;
> -	s64 diff;
> -
> -	if (ts0 == 0)
> -		return 0;
> -	if (unlikely(ts0 == S64_MAX))	/* _prior_ to issuing req */
> -		return 999999999;	/* eye catching */
> -	now_ts = ktime_get_boottime();
> -	if (unlikely(ts0 > now_ts))
> -		return 999999998;
> -	/* unlikely req duration will exceed 2**32 milliseconds */
> -	diff = ktime_ms_delta(now_ts, ts0);
> -	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;
> -}
> -
> -/* Return of U32_MAX means srp is inactive state */
>  static u32
>  sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
>  	   bool *is_durp)
>  {
>  	bool is_dur = false;
> -	u32 res = U32_MAX;
> +	s64 dur_ns;
> +	ktime_t start_dur = READ_ONCE(srp->start_dur);
>  
> +	if (ktime_to_ns(start_dur) <= 0) {
> +		is_dur = true;
> +		dur_ns = 0;
> +		goto fini;
> +	}
>  	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {
> -	case SG_RS_INFLIGHT:
>  	case SG_RS_BUSY:
> -		res = sg_calc_rq_dur(srp);
> +		if (test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
> +			dur_ns = ktime_to_ns(start_dur);
> +			is_dur = true;
> +			break;
> +		}
> +		dur_ns = 1;
> +		break;
> +	case SG_RS_INFLIGHT:
> +		dur_ns = ktime_sub(ktime_get_boottime(), start_dur);
>  		break;
>  	case SG_RS_AWAIT_RCV:
>  	case SG_RS_INACTIVE:
> -		res = srp->duration;
> +		dur_ns = ktime_to_ns(start_dur);
>  		is_dur = true;	/* completion has occurred, timing finished */
>  		break;
> -	default:
> -		break;
>  	}
> +fini:
>  	if (is_durp)
>  		*is_durp = is_dur;
> -	return res;
> +	return ktime_to_ms(ns_to_ktime(dur_ns));
>  }
>  
>  static void
> @@ -1678,8 +1735,6 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
>  
>  	xa_lock_irqsave(&sfp->srp_arr, iflags);
>  	rip->duration = sg_get_dur(srp, NULL, NULL);
> -	if (rip->duration == U32_MAX)
> -		rip->duration = 0;
>  	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
>  	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
>  	rip->problem = !!(srp->rq_result & SG_ML_RESULT_MSK);
> @@ -2477,6 +2532,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
>  	int a_resid, slen;
>  	u32 rq_result;
>  	unsigned long iflags;
> +	ktime_t start_tm;
>  	struct sg_request *srp = rqq->end_io_data;
>  	struct scsi_request *scsi_rp = scsi_req(rqq);
>  	struct sg_device *sdp;
> @@ -2503,7 +2559,9 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
>  
>  	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__, srp->pack_id,
>  	       rq_result);
> -	srp->duration = sg_calc_rq_dur(srp);
> +	start_tm = READ_ONCE(srp->start_dur);
> +	if (start_tm > 0)
> +		WRITE_ONCE(srp->start_dur, ktime_sub(ktime_get_boottime(), start_tm));
>  	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&
>  		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
>  		u32 scsi_stat = rq_result & 0xff;
> @@ -2651,9 +2709,12 @@ sg_add_device_helper(struct scsi_device *scsidp)
>  		kfree(sdp);
>  		return ERR_PTR(error);
>  	}
> +	spin_lock_init(&sdp->stats_lck);
>  	return sdp;
>  }
>  
> +static const struct attribute_group *sg_dev_groups[];
> +
>  static int
>  sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
>  {
> @@ -2678,6 +2739,9 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
>  		error = PTR_ERR(sdp);
>  		goto out;
>  	}
> +	if (sg_comp_stats)
> +		sdp->statsp = kzalloc(sizeof(*sdp->statsp), GFP_KERNEL);
> +		/* don't worry if NULL, probably a lot of devices */
>  
>  	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
>  	if (error)
> @@ -2687,6 +2751,8 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
>  	if (sg_sysfs_valid) {
>  		struct device *sg_class_member;
>  
> +		if (sg_comp_stats)
> +			sg_sysfs_class->dev_groups = sg_dev_groups;
>  		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
>  						MKDEV(SCSI_GENERIC_MAJOR,
>  						      sdp->index),
> @@ -2713,6 +2779,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
>  	return 0;
>  
>  cdev_add_err:
> +	kfree(sdp->statsp);
>  	write_lock_irqsave(&sg_index_lock, iflags);
>  	idr_remove(&sg_index_idr, sdp->index);
>  	write_unlock_irqrestore(&sg_index_lock, iflags);
> @@ -2740,6 +2807,7 @@ sg_device_destroy(struct kref *kref)
>  	 */
>  
>  	xa_destroy(&sdp->sfp_arr);
> +	kfree(sdp->statsp);
>  	write_lock_irqsave(&sg_index_lock, flags);
>  	idr_remove(&sg_index_idr, sdp->index);
>  	write_unlock_irqrestore(&sg_index_lock, flags);
> @@ -3881,6 +3949,140 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
>  }
>  #endif
>  
> +static ssize_t read_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->read_cnt);

sysfs_emit() ? Same for all other attributes below.

> +}
> +static DEVICE_ATTR_RO(read_cnt);
> +
> +static ssize_t read_byte_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->read_byte_cnt);
> +}
> +static DEVICE_ATTR_RO(read_byte_cnt);
> +
> +static ssize_t read_ns_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->tot_read_time);
> +}
> +static DEVICE_ATTR_RO(read_ns);
> +
> +static ssize_t write_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->write_cnt);
> +}
> +static DEVICE_ATTR_RO(write_cnt);
> +
> +static ssize_t write_byte_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->write_byte_cnt);
> +}
> +static DEVICE_ATTR_RO(write_byte_cnt);
> +
> +static ssize_t write_ns_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->tot_write_time);
> +}
> +static DEVICE_ATTR_RO(write_ns);
> +
> +static ssize_t in_flight_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", sp->in_flight);
> +}
> +static DEVICE_ATTR_RO(in_flight);
> +
> +static ssize_t io_ns_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->tot_io_time);
> +}
> +static DEVICE_ATTR_RO(io_ns);
> +
> +static ssize_t other_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->other_cnt);
> +}
> +static DEVICE_ATTR_RO(other_cnt);
> +
> +static ssize_t resid_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct sg_device *sdp = dev_get_drvdata(dev);
> +	struct sg_dev_stats *sp = sdp->statsp;
> +
> +	if (!sdp || !sp)
> +		return -EINVAL;
> +	return scnprintf(buf, PAGE_SIZE, "%llu\n", sp->resid_cnt);
> +}
> +static DEVICE_ATTR_RO(resid_cnt);
> +
> +static struct attribute *sg_stats_attrs[] = {
> +	&dev_attr_read_cnt.attr,
> +	&dev_attr_read_byte_cnt.attr,
> +	&dev_attr_read_ns.attr,
> +	&dev_attr_write_cnt.attr,
> +	&dev_attr_write_byte_cnt.attr,
> +	&dev_attr_write_ns.attr,
> +	&dev_attr_in_flight.attr,
> +	&dev_attr_io_ns.attr,
> +	&dev_attr_other_cnt.attr,
> +	&dev_attr_resid_cnt.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group sg_stats_group = {
> +	.name = "stats",
> +	.attrs = sg_stats_attrs,
> +};
> +
> +static const struct attribute_group *sg_dev_groups[] = {
> +	&sg_stats_group,
> +	NULL,
> +};
> +
>  #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
>  
>  #define SG_SNAPSHOT_DEV_MAX 4
> @@ -4585,6 +4787,7 @@ static void sg_dfs_exit(void) {}
>  module_param_named(scatter_elem_sz, scatter_elem_sz, int, 0644);
>  module_param_named(def_reserved_size, def_reserved_size, int, 0644);
>  module_param_named(allow_dio, sg_allow_dio, int, 0644);
> +module_param_named(comp_stats, sg_comp_stats, bool, 0644);
>  
>  MODULE_AUTHOR("Douglas Gilbert");
>  MODULE_DESCRIPTION("SCSI generic (sg) driver");
> @@ -4595,5 +4798,6 @@ MODULE_ALIAS_CHARDEV_MAJOR(SCSI_GENERIC_MAJOR);
>  MODULE_PARM_DESC(scatter_elem_sz, "scatter gather element size (default: max(SG_SCATTER_SZ, PAGE_SIZE))");
>  MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
>  MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow)); now ignored");
> +MODULE_PARM_DESC(comp_stats, "compile per device statistics (default: true)");

Nit: s/comp_stats/gather_stats ?

It may be my English lacking a little, but "compile" here sounds a little out of
context. "gather" is easier to understand and remember.

>  module_init(init_sg);
>  module_exit(exit_sg);
> 


-- 
Damien Le Moal
Western Digital Research
