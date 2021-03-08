Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2738C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 18:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C766148E
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 18:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHSZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 13:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhCHSZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2021 13:25:26 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FC6C06174A
        for <linux-scsi@vger.kernel.org>; Mon,  8 Mar 2021 10:25:25 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id a9so10256063qkn.13
        for <linux-scsi@vger.kernel.org>; Mon, 08 Mar 2021 10:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=RzAErjyw3pgBPJ8YE/3eyGFOavqDpiI9FWiAzHH4H/8=;
        b=Kb2G68/hoqZk+5bSXJrFAolD1jXztFEE6RK4krkkdkO1+93NzXchOM+OMq5dGmbNJ8
         zXG9QGd1u2DPlZZVfQS3n2tu6ymu7JMNELREia7XqWqkkc38g4nKkftW5swkGfZTI5Na
         hAHVohHH9qE7u9vdi/w3tuNMVeDJDBnciNOc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=RzAErjyw3pgBPJ8YE/3eyGFOavqDpiI9FWiAzHH4H/8=;
        b=FMGFUTRqW0NYbF6dXwQhbAD4w7Uldg00YgZeUme9OgJGynMBPn2IoAXhkEcf8jfAtm
         RS8Ke5QkfX8zD2+u6vRXnAZ4ybQgo0GUBkdjaHL70NsdY82CTm6SKonB9QB7jTlmvilm
         z9RAtTPgnqA0mR85ezRTupr/Bt4Vod6ozQarTMaekwzsOjsllckVMiGdqqhZy3Ve4D9K
         LsZDZmPrVWAFOxfm09QISvtCIMfv8uXR70O3Zw9nw5R/JaFZ95lAHL3YgBPwS/yzjKfR
         CydjVU2iBI0RgTwf3xYuu+3e45xARAAjjG7SLdusnATp9D0Fve4CKu1N+icxz6gWwg6v
         jMVA==
X-Gm-Message-State: AOAM530YRtHShy2rJbXVwdb6BDqZVCtGBfLjfYPSnennqrv+f8okwomI
        9gEKxX4hIJr4IS7TIlQsPuk5b43Ge+b3gflwrK4lkg==
X-Google-Smtp-Source: ABdhPJwRl6ugFe1tQrnR7SZ+vjnHJv1g7Kav9Nm9Yqbhw384sHqPT5VGtpMC8h6N9gxL/mmhO6a8lwUTwncZ0pEJ8Lo=
X-Received: by 2002:a05:620a:22ea:: with SMTP id p10mr21706680qki.27.1615227924842;
 Mon, 08 Mar 2021 10:25:24 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-5-kashyap.desai@broadcom.com> <3dcff2d5-46d2-d9fe-e7d8-21918a4efc12@suse.de>
In-Reply-To: <3dcff2d5-46d2-d9fe-e7d8-21918a4efc12@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIVk2r6yGrO96+nYWGuC86HruD4YwIZ+Yp5AaaZK8ap32HC8A==
Date:   Mon, 8 Mar 2021 23:55:22 +0530
Message-ID: <26666bbf526cf240b204500ecdfbafa0@mail.gmail.com>
Subject: RE: [PATCH 04/24] mpi3mr: add support of queue command processing
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b8ca8405bd0a8e39"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b8ca8405bd0a8e39
Content-Type: text/plain; charset="UTF-8"

> > +
> > +/**
> > + * struct mpi3mr_stgt_priv_data - SCSI device private structure
> > + *
> > + * @tgt_priv_data: Scsi_target private data pointer
> > + * @lun_id: LUN ID of the device
> > + * @ncq_prio_enable: NCQ priority enable for SATA device  */ struct
> > +mpi3mr_sdev_priv_data {
> > +	struct mpi3mr_stgt_priv_data *tgt_priv_data;
> > +	u32 lun_id;
> > +	u8 ncq_prio_enable;
> > +};
> >
> Why is there a separate 'lun_id' field?
H/W is multi lun capable and driver store lun_id so that it can pass the
same to the FW in qcmd() and other path like task management etc.

>
> >   typedef struct mpi3mr_drv_cmd DRV_CMD;
> >   typedef void (*DRV_CMD_CALLBACK)(struct mpi3mr_ioc *mrioc, @@
> > -443,12 +481,16 @@ struct scmd_priv {
> >    * @sbq_lock: Sense buffer queue lock
> >    * @sbq_host_index: Sense buffer queuehost index
> >    * @is_driver_loading: Is driver still loading
> > + * @scan_started: Async scan started
> > + * @scan_failed: Asycn scan failed
> > + * @stop_drv_processing: Stop all command processing
> >    * @max_host_ios: Maximum host I/O count
> >    * @chain_buf_count: Chain buffer count
> >    * @chain_buf_pool: Chain buffer pool
> >    * @chain_sgl_list: Chain SGL list
> >    * @chain_bitmap_sz: Chain buffer allocator bitmap size
> >    * @chain_bitmap: Chain buffer allocator bitmap
> > + * @chain_buf_lock: Chain buffer list lock
> >    * @reset_in_progress: Reset in progress flag
> >    * @unrecoverable: Controller unrecoverable flag
> >    * @logging_level: Controller debug logging level @@ -533,6 +575,9
> > @@ struct mpi3mr_ioc {
> >   	u32 sbq_host_index;
> >
> >   	u8 is_driver_loading;
> > +	u8 scan_started;
> > +	u16 scan_failed;
> > +	u8 stop_drv_processing;
> >
> >   	u16 max_host_ios;
> >
> > @@ -541,6 +586,7 @@ struct mpi3mr_ioc {
> >   	struct chain_element *chain_sgl_list;
> >   	u16  chain_bitmap_sz;
> >   	void *chain_bitmap;
> > +	spinlock_t chain_buf_lock;
> >
> >   	u8 reset_in_progress;
> >   	u8 unrecoverable;
> > @@ -557,8 +603,11 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc
> *mrioc);
> >   void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
> >   int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
> >   void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
> > +int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
> >   int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void
> *admin_req,
> >   u16 admin_req_sz, u8 ignore_reset);
> > +int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
> > +			   struct op_req_qinfo *opreqq, u8 *req);
> >   void mpi3mr_add_sg_single(void *paddr, u8 flags, u32 length,
> >   			  dma_addr_t dma_addr);
> >   void mpi3mr_build_zero_len_sge(void *paddr); @@ -569,6 +618,9 @@
> > void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
> >   void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
> >   				     u64 sense_buf_dma);
> >
> > +void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
> > +				  Mpi3DefaultReplyDescriptor_t
*reply_desc,
> > +				  u64 *reply_dma, u16 qidx);
> >   void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc);
> >   void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > b/drivers/scsi/mpi3mr/mpi3mr_fw.c index 6fb28983038e..abdf8c653e6b
> > 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -24,6 +24,23 @@ static inline void mpi3mr_writeq(__u64 b, volatile
> void __iomem *addr)
> >   }
> >   #endif
> >
> > +static inline bool
> > +mpi3mr_check_req_qfull(struct op_req_qinfo *op_req_q) {
> > +	u16 pi, ci, max_entries;
> > +	bool is_qfull = false;
> > +
> > +	pi = op_req_q->pi;
> > +	ci = op_req_q->ci;
> > +	max_entries = op_req_q->num_requests;
> > +
> > +	if ((ci == (pi + 1)) || ((!ci) && (pi == (max_entries - 1))))
> > +		is_qfull = true;
> > +
> > +	return is_qfull;
> > +}
> > + > +
>
> This needs to be protected by a lock to ensure the 'ci' and 'pi' values
won't
> change during processing; alternatively you'd need to use
> READ_ONCE() here.

I will add READ_ONCE() for op_req_q->ci.

> Please modify or add respective lockdep annotations.
I will discuss with you.

>
> >   static void mpi3mr_sync_irqs(struct mpi3mr_ioc *mrioc)
> >   {
> >   	u16 i, max_vectors;
> > @@ -282,6 +299,87 @@ static int mpi3mr_process_admin_reply_q(struct
> mpi3mr_ioc *mrioc)
> >   	return num_admin_replies;
> >   }
> >
> > +/**
> > + * mpi3mr_get_reply_desc - get reply descriptor frame corresponding
to
> > + *	queue's consumer index from operational reply descriptor queue.
> > + * @op_reply_q: op_reply_qinfo object
> > + * @reply_ci: operational reply descriptor's queue consumer index
> > + *
> > + * Returns reply descriptor frame address  */ static inline
> > +Mpi3DefaultReplyDescriptor_t * mpi3mr_get_reply_desc(struct
> > +op_reply_qinfo *op_reply_q, u32 reply_ci) {
> > +	void *segment_base_addr;
> > +	struct segments *segments = op_reply_q->q_segments;
> > +	Mpi3DefaultReplyDescriptor_t *reply_desc = NULL;
> > +
> > +	segment_base_addr =
> > +	    segments[reply_ci / op_reply_q->segment_qd].segment;
> > +	reply_desc = (Mpi3DefaultReplyDescriptor_t *)segment_base_addr +
> > +	    (reply_ci % op_reply_q->segment_qd);
> > +	return reply_desc;
> > +}
> > +
> > +
> > +static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
> > +	struct mpi3mr_intr_info *intr_info)
> > +{
> > +	struct op_reply_qinfo *op_reply_q = intr_info->op_reply_q;
> > +	struct op_req_qinfo *op_req_q;
> > +	u32 exp_phase;
> > +	u32 reply_ci;
> > +	u32 num_op_reply = 0;
> > +	u64 reply_dma = 0;
> > +	Mpi3DefaultReplyDescriptor_t *reply_desc;
> > +	u16 req_q_idx = 0, reply_qidx;
> > +
> > +	reply_qidx = op_reply_q->qid - 1;
> > +
> > +	exp_phase = op_reply_q->ephase;
> > +	reply_ci = op_reply_q->ci;
> > +
> > +	reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> > +	if ((le16_to_cpu(reply_desc->ReplyFlags) &
> > +	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
> > +		return 0;
> > +	}
> > +
> > +	do {
> > +		req_q_idx = le16_to_cpu(reply_desc->RequestQueueID) - 1;
> > +		op_req_q = &mrioc->req_qinfo[req_q_idx];
> > +
> > +		op_req_q->ci =
> > +		    le16_to_cpu(reply_desc->RequestQueueCI);
> > +
>
> This introduces an interlock with request processing; from what I can
see
> request processing is guarded by a spinlock, yet I don't see any
protection
> here.
As of now there is only one path to process reply queue (from interrupt).
Going forward, blk_mq_poll interface in this driver require interlock in
this area.

> How do you ensure a timely update of the 'ci' value if there is parallel
> execution of requests and responses (note: you cannot always assume that
> you will have a 1:1 relationship between queuepairs, CPUs, and
interrupts).
> I would have expected at least a WRITE_ONCE() here.

I will add WRITE_ONCE.
>
> Question is why you need to modify this at all; in most implementations
I
> know of the 'ci' index is modified by firmware, as really it's the
firmware
> consuming the request.
> Why not here?
Each request queue need separate memory space of queue_depth for that
particular request queue. Currently we are restricting 256 queue depth for
each request queue to get better memory utilization. If we allocate each
request queue same as can_queue, we may not have require this queue_full
check (there may be some corner case, but we can work on those.).  "ci" on
request queue is updated by FW only, but driver is reading those value to
know if there are enough space to post more request. If we see frequent
queue_full with 256 queue depth, we will increase the queue_depth value in
future.

~ Kashyap

--000000000000b8ca8405bd0a8e39
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKgiobqPVcoZjw0btR533dGrNE3s
FHJss8PIzN773LqqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDMwODE4MjUyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQC1QzNKwlQhkVyQ7MrcRqmsCmgv5WCyYEYXV3C/gIVAKGwv
MgrX5cr41PfzXQWPRzgA6RuKvesLRGXwdiaOVJ+WtGkXuFWREOhhzky2tOCYo/1ZHZVqMbATxzqd
TtMh2py8T6JIzrE7VXlFug4gDCKj4pcTV2447kLAgv8Flqqp9QzHF/eGC07zkTBHlb8adfX/TpMy
OH5S1baDXjUZAPx2gFDnz2t8wdoXgTY7kOT/pnokdT0/OceaLqbDL3vKhi71Vndz4ihQefmRhI3A
A/IzdGWNltNiSgQk3KgLdxv/bWSjPqg8Ro689WT5BOP9/TTJjlj3ouFRNO3jxpg99C2+
--000000000000b8ca8405bd0a8e39--
