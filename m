Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD67AC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 16:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E2C611BD
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 16:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245476AbhEQQh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 12:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245214AbhEQQht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 12:37:49 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E3AC0816F6
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 08:37:54 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 76so6105848qkn.13
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 08:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=Cgp2QAooSaPUksPUQXpJeJh/ngbrxXbU9xvOzjmFSuI=;
        b=BV7AiCv1t/GQ+Thlcr3EiM06T0gw9iH6WWEZy8YDDw0vQ5+dySDW2bGMZzVu2TQ4kw
         zUUd1QYkSxXn+sRPnzaVnTzbLHRwTHGUDPqYZNiApBilAHxDFh10WrYIQO3QSM2kxXPf
         uyd8XsQGF5mv5NRiGnQiJG6SaYhB1YCifSFOA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=Cgp2QAooSaPUksPUQXpJeJh/ngbrxXbU9xvOzjmFSuI=;
        b=UBlYGhnebnWUt6WecHFVAJnKY0jTbXN8xuBuVqChM8KppHlOdDUl8V66gGkDZBXZsc
         vtWL565f9gNB6PVNXeo1tP7fkh/575d36XtOk0xts81VpGJqcm7PJhT/dz4C2u5PYuSx
         RpwCgaEMh4pyzusBxYLs8jHcw9Mt5npBJ46L3VfAQBg850y+zBqQfmMcqgG6AkvuKW4u
         chReR+dVZ3L3keYdITc4nmy6I7fkH5ZZ6bsLYFkK/tWSppA+rAeN6LEzylQgdzxR13me
         dZZE0jGtl5OWgAPa4iYeXGa6d4daS+089xc2srziTnpOIiIAJ9EWOtPWeBUlGSaaTvJH
         LWXA==
X-Gm-Message-State: AOAM530UENf1h6qWXSxSBdQowqbVHK8eTZOetn+6QcJ5mz3qchusO/1J
        cs7AuSv2m5vxxi/X+yYAR4rvCi0UwwMGBiDloJZ1Iw==
X-Google-Smtp-Source: ABdhPJzqc/h6trF7QZbv9g9Tcz4dVtZjQCutUQSQKd+G0HVkS3KACFfjHI+1ykEhkIrgUEDynBUCkh2E6hha1eo02Wg=
X-Received: by 2002:a37:aa0b:: with SMTP id t11mr483967qke.70.1621265872456;
 Mon, 17 May 2021 08:37:52 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
 <20210513083608.2243297-5-kashyap.desai@broadcom.com> <07cd627d-b661-a4a9-0929-00a594b0e8d0@suse.de>
In-Reply-To: <07cd627d-b661-a4a9-0929-00a594b0e8d0@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQDmoXnWqw/wahd+DgUMU/8U4h6NGAGiCgV6AWUt59GssOMCsA==
Date:   Mon, 17 May 2021 21:07:50 +0530
Message-ID: <5f74d8f861417c8a34b90030d4c19f80@mail.gmail.com>
Subject: RE: [PATCH v5 04/24] mpi3mr: add support of queue command processing
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006fd9a505c2886094"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006fd9a505c2886094
Content-Type: text/plain; charset="UTF-8"

> > +		if (reply_dma)
> > +			mpi3mr_repost_reply_buf(mrioc, reply_dma);
> > +		num_op_reply++;
> > +
> > +		if (++reply_ci == op_reply_q->num_replies) {
> > +			reply_ci = 0;
> > +			exp_phase ^= 1;
> > +		}
> > +
> > +		reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> > +
> > +		if ((le16_to_cpu(reply_desc->reply_flags) &
> > +		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=
> exp_phase)
> > +			break;
> > +
> > +	} while (1);
> > +
>
> Is this loop bounded by something?
> The way it looks like we might end up having to process at lot of replies,
> causing a bogus hangcheck trigger.
> Have you check for that condition?


Hi Hannes -

You are correct. There can be a bogus CPU lockup issue here.  We could have
use irq_poll interface as we used in mpt3sas, megaraid_sas driver.
Since we have used hybrid threaded ISR in mpi3mr driver, we have covered
this scenario using threaded ISR. See patch #0017. We have below check to
handle CPU lockup -

if (num_op_reply > mrioc->max_host_ios) {
                intr_info->op_reply_q->enable_irq_poll = true;
                 break;
}

>
> > +	writel(reply_ci,
> > +	    &mrioc->sysif_regs-
> >oper_queue_indexes[reply_qidx].consumer_index);
> > +	op_reply_q->ci = reply_ci;
> > +	op_reply_q->ephase = exp_phase;
> > +
> > +	return num_op_reply;
> > +}
> > +
> >  static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)  {
> >  	struct mpi3mr_intr_info *intr_info = privdata; @@ -1302,6 +1395,74
> > @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
> >  	return retval;
> >  }
> >
> > +/**
> > + * mpi3mr_op_request_post - Post request to operational queue
> > + * @mrioc: Adapter reference
> > + * @op_req_q: Operational request queue info
> > + * @req: MPI3 request
> > + *
> > + * Post the MPI3 request into operational request queue and
> > + * inform the controller, if the queue is full return
> > + * appropriate error.
> > + *
> > + * Return: 0 on success, non-zero on failure.
> > + */
> > +int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
> > +	struct op_req_qinfo *op_req_q, u8 *req) {
> > +	u16 pi = 0, max_entries, reply_qidx = 0, midx;
> > +	int retval = 0;
> > +	unsigned long flags;
> > +	u8 *req_entry;
> > +	void *segment_base_addr;
> > +	u16 req_sz = mrioc->facts.op_req_sz;
> > +	struct segments *segments = op_req_q->q_segments;
> > +
> > +	reply_qidx = op_req_q->reply_qid - 1;
> > +
> > +	if (mrioc->unrecoverable)
> > +		return -EFAULT;
> > +
> > +	spin_lock_irqsave(&op_req_q->q_lock, flags);
> > +	pi = op_req_q->pi;
> > +	max_entries = op_req_q->num_requests;
> > +
> > +	if (mpi3mr_check_req_qfull(op_req_q)) {
> > +		midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(
> > +		    reply_qidx, mrioc->op_reply_q_offset);
> > +		mpi3mr_process_op_reply_q(mrioc, &mrioc-
> >intr_info[midx]);
> > +
> > +		if (mpi3mr_check_req_qfull(op_req_q)) {
> > +			retval = -EAGAIN;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	if (mrioc->reset_in_progress) {
> > +		ioc_err(mrioc, "OpReqQ submit reset in progress\n");
> > +		retval = -EAGAIN;
> > +		goto out;
> > +	}
> > +
>
> Have you considered a different error code here?
> reset in progress and queue full are two different scenarios; especially
> the
> latter might warrant some further action like decreasing the queue depth,
> which is getting hard if you have the same error ...

There is really no difference if we  use different error code, because
caller of mpi3mr_op_request_post checks zero or non-zero.
I got your point that we should have some better error code (if possible) in
case of controller is in reset.
I am thinking of  using scsi_block_requests/scsi_unblock_requests pair in
controller reset path. We want stable first out of mpi3mr and also such
changes require additional testing, I will accommodate changes in this area
in next series.
Is it OK with you ?

> > +	switch (ioc_status) {
> > +	case MPI3_IOCSTATUS_BUSY:
> > +	case MPI3_IOCSTATUS_INSUFFICIENT_RESOURCES:
> > +		scmd->result = SAM_STAT_BUSY;
> > +		break;
> > +	case MPI3_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
> > +		scmd->result = DID_NO_CONNECT << 16;
> > +		break;
> > +	case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
> > +		scmd->result = DID_SOFT_ERROR << 16;
> > +		break;
> > +	case MPI3_IOCSTATUS_SCSI_TASK_TERMINATED:
> > +	case MPI3_IOCSTATUS_SCSI_EXT_TERMINATED:
> > +		scmd->result = DID_RESET << 16;
> > +		break;
> > +	case MPI3_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
> > +		if ((xfer_count == 0) || (scmd->underflow > xfer_count))
> > +			scmd->result = DID_SOFT_ERROR << 16;
> > +		else
> > +			scmd->result = (DID_OK << 16) | scsi_status;
> > +		break;
> > +	case MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN:
> > +		scmd->result = (DID_OK << 16) | scsi_status;
> > +		if (sense_state == MPI3_SCSI_STATE_SENSE_VALID)
> > +			break;
> > +		if (xfer_count < scmd->underflow) {
> > +			if (scsi_status == SAM_STAT_BUSY)
> > +				scmd->result = SAM_STAT_BUSY;
> > +			else
> > +				scmd->result = DID_SOFT_ERROR << 16;
> > +		} else if ((scsi_state & (MPI3_SCSI_STATE_NO_SCSI_STATUS))
> ||
> > +		    (sense_state !=
> MPI3_SCSI_STATE_SENSE_NOT_AVAILABLE))
> > +			scmd->result = DID_SOFT_ERROR << 16;
> > +		else if (scsi_state & MPI3_SCSI_STATE_TERMINATED)
> > +			scmd->result = DID_RESET << 16;
> > +		else if (!xfer_count && scmd->cmnd[0] == REPORT_LUNS) {
> > +			scsi_status = SAM_STAT_CHECK_CONDITION;
> > +			scmd->result = (DRIVER_SENSE << 24) |
> > +			    SAM_STAT_CHECK_CONDITION;
> > +			scmd->sense_buffer[0] = 0x70;
> > +			scmd->sense_buffer[2] = ILLEGAL_REQUEST;
> > +			scmd->sense_buffer[12] = 0x20;
> > +			scmd->sense_buffer[13] = 0;
> > +		}
>
> Huh? A separate error handling just for REPORT LUNS?
> Did you mess up your firmware?
> And if you know REPORT LUNS is not supported, by bother sending it to the
> firmware and not completing it straightaway in queuecommand()?

This special case handling ported from past solution we used in mpt3sas. I
am not sure but it was due to mix of FW and Kernel behavior.
Some older kernel had lots of prints if we do not have above special
handling in driver.  We will remove above check from mpi3mr driver and based
on any actual issue, we can add fix in future.
I will handle it in V6 submission.

Kashyap

--0000000000006fd9a505c2886094
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJILVdWNa6MVNBhsjFnvVC1biq2J
Gk9JcZqKRsDknj2NMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxNzE1Mzc1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQAkKigJJfRw9PLeP79j+iqJNmkXl8bnDWNpEk807gzCbIpM
LL/B4On0ZhKa9IqVgFV6/GkYjVbuXgObTcOhjlW+yKr/j37WRwFIVIANt7uBXnO/0RqUlyl3Mu9X
dmIiO/Vr6j6yPEr7PfmHdoeN6BRlokzEVbDKJOAPjdogigfNCWmRKVui+SK/hUL/qanL9q2EGaUg
OPfggku4TBv5WtXhsih5ggJxsMX1bOyQq3826n2/pbxMlAZZRakVrBgctlKVjlkNtrsWbam1LUDh
uVU4fU6k61zj/nWzJCRTw+3OY3N/6lYaixlZ1Dwb3k/pVAKqcFZjJLEu4jM3173jonAm
--0000000000006fd9a505c2886094--
