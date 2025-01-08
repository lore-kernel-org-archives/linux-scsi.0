Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C376A1A0BED
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 09:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328939; cv=none; b=hgSH06B1yrB3At+jhSK9TDOq2FyspsJGGIq03DJTIHGmZLW4DQaoFql6YGZXMEsr7K0n8PFx3P9arj1XiJEOMiK4sBRgi9y1t0CexwMk0FJeCU0VDHg8o3Te6HIaURWN5wSgYXF1jUx/KGPPahfAMGXlHMQfgK2W/L+pbzIzkiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328939; c=relaxed/simple;
	bh=l3PCIEIelthuqSR/jv3i+CQPS9ryNqQSVLw9c6AHRlU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LKW2jceT92d2Lg7Ft/JFl/0CH6LEAvZAyiTS1e/8cgYWfolbrzPXSRmqqrQ0khBDdTt89kthr4CVa1ATD+cqCfCoCtn8vWfW2kd/XJZB/IwnMTuVh7xpDe3Oe5Vl0Kgnl0HCncgnmvNqmjQe/NaSPn6G6XAFyLZ15adsAX6o15w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nc0RiNjb; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nc0RiNjb"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-385de59c1a0so9819310f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jan 2025 01:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736328936; x=1736933736; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1gOlSbqAtJLbCepP7eHZHaLXruDphs2i+XBgu9g4oDQ=;
        b=Nc0RiNjbetn0jLT4RKxWjA/kp7eE0bfHntv2RB/6ZNRAHQ5n7B1+jBxodXWvaNzyWd
         +qYDg3it4ylI+0TC3DweiIxhM7ToaMME7HwvQVPCjFFiG6sSk7JCU07rSNZAEL4h96QE
         mz9ecwNmwVRYqlQC5EP35fosYJ4dNvOp+HXLKB0bLHn5yT7O4Ysr8NTcpc6PRkmtW1Tn
         qb1o4B6CcxI5JIdIHC5B7VOz3XWos+Fc1d5SIAbZjuLmVvGQkMh04tTzsZqUhsBPIl4B
         iyEDWixUcFNpaAktARgf5aIinhg94iI4soViwqNL/Mr2nBoNbn3/DjQawdrxv8zr3ZoC
         VnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736328936; x=1736933736;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1gOlSbqAtJLbCepP7eHZHaLXruDphs2i+XBgu9g4oDQ=;
        b=T8qJnXcr5rx6ylESisQEUZCdyAOP1d803nh2ltepNNID/P53efo0Lhw0VIThbLr3mg
         maPv2hZUZ+O7TTeskzcwBLN7inaounu/hPebmI1vmJDywTzqpH8B9lwVEB21N2miLrSQ
         ZBBfGzbjav5FatDYFxbKr2VpOoogm66EHSPO3PNloOpGHF8Yj665/N4CXVDwRaCAr9/v
         HlfPWsjDbhHZO+1jcCjE6fbkdiS199keRwakKrqKo3XOIOITz4x2gw1hLrPKlzSB4niS
         wUoCOHnwlI+vCXt0/yYxkp0F8UTery67syx8JDUU4NT+RJ0HEq8C4X0r3NO7IwFEYSja
         Jjgg==
X-Gm-Message-State: AOJu0YzbRG3WcCVWEIAY+Mw32Xa4WjGiqCYqhSnTh/5AGRT82iP66FWU
	Pc12jHscQ56BwoHfTHi21vWQ9KTkWSWbgmtWUl2ScUPd/SAOYe0WrmQy/3vnT0o=
X-Gm-Gg: ASbGncu3qq+95fblDQlNsoBOZFDjK9PvTpMBZ9Pdc0wkuuQ4VEjudzgSx3+0boPSNFU
	k5dzu32GzLlVxC80pOv/xhO59WEJR65sXk3fpot0soKQeOollqqStnujRw3ZHKY5E/R+NqkxDls
	gaaoykJrjfUXH2dXdXuVbx7E9Gdr3vwpIp1gLOP6uPPFhd9rc3+KIvt9LhIdc+RAJXugsHNlL+r
	ZTk+0f3E4V8RSI+2YgbSvFkP5kgdL3euuyfGxhIovWvegCzD5wx2EiCTws+tw==
X-Google-Smtp-Source: AGHT+IFNcDTgv1su7hVk4FdVvjUjDk5eBwbICda4rJdAZ3sEKQMJiPzFTtUWJMDOUNvBGUxU1Q0fDg==
X-Received: by 2002:a05:6000:1849:b0:385:e5d8:3ec2 with SMTP id ffacd0b85a97d-38a8730b535mr1604117f8f.28.1736328936122;
        Wed, 08 Jan 2025 01:35:36 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8330d4sm51844229f8f.29.2025.01.08.01.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 01:35:35 -0800 (PST)
Date: Wed, 8 Jan 2025 12:35:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Bikash Hazarika <bhazarika@marvell.com>
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: qla2xxx: Add support for mailbox passthru
Message-ID: <6505482d-b861-4f66-8c61-f5dca867f844@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Bikash Hazarika,

Commit 9e1c3206960f ("scsi: qla2xxx: Add support for mailbox
passthru") from Sep 8, 2021 (linux-next), leads to the following
Smatch static checker warning:

	drivers/scsi/qla2xxx/qla_bsg.c:3241 qla2x00_mailbox_passthru()
	warn: sizeof(void)

drivers/scsi/qla2xxx/qla_bsg.c
    3205 int qla2x00_mailbox_passthru(struct bsg_job *bsg_job)
    3206 {
    3207         struct fc_bsg_reply *bsg_reply = bsg_job->reply;
    3208         scsi_qla_host_t *vha = shost_priv(fc_bsg_to_shost(bsg_job));
    3209         int ret = -EINVAL;
    3210         int ptsize = sizeof(struct qla_mbx_passthru);
    3211         struct qla_mbx_passthru *req_data = NULL;
    3212         uint32_t req_data_len;
    3213 
    3214         req_data_len = bsg_job->request_payload.payload_len;
    3215         if (req_data_len != ptsize) {
    3216                 ql_log(ql_log_warn, vha, 0xf0a3, "req_data_len invalid.\n");
    3217                 return -EIO;
    3218         }
    3219         req_data = kzalloc(ptsize, GFP_KERNEL);
    3220         if (!req_data) {
    3221                 ql_log(ql_log_warn, vha, 0xf0a4,
    3222                        "req_data memory allocation failure.\n");
    3223                 return -ENOMEM;
    3224         }
    3225 
    3226         /* Copy the request buffer in req_data */
    3227         sg_copy_to_buffer(bsg_job->request_payload.sg_list,
    3228                           bsg_job->request_payload.sg_cnt, req_data, ptsize);
    3229         ret = qla_mailbox_passthru(vha, req_data->mbx_in, req_data->mbx_out);
    3230 
    3231         /* Copy the req_data in  request buffer */
    3232         sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
    3233                             bsg_job->reply_payload.sg_cnt, req_data, ptsize);
    3234 
    3235         bsg_reply->reply_payload_rcv_len = ptsize;
    3236         if (ret == QLA_SUCCESS)
    3237                 bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
    3238         else
    3239                 bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_ERR;
    3240 
--> 3241         bsg_job->reply_len = sizeof(*bsg_job->reply);

bsg_job->reply is a void pointer so the sizeof() is 1.  Even if this is
correct, it would be more clear to say size(u8) or something.

    3242         bsg_reply->result = DID_OK << 16;
    3243         bsg_job_done(bsg_job, bsg_reply->result, bsg_reply->reply_payload_rcv_len);
    3244 
    3245         kfree(req_data);
    3246 
    3247         return ret;
    3248 }

regards,
dan carpenter
