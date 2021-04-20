Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B77CC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 16:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2542613C8
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 16:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhDTQM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:12:59 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:39806 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhDTQM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 12:12:59 -0400
Received: by mail-pl1-f173.google.com with SMTP id u7so18122425plr.6
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 09:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SliyMK4dOi9P4wNw+DJs3Fc9v1CD5e7Lc3QWlmdI19A=;
        b=DYhp6HDIW0hLr9s7qt2elC/OlrN6eIujN/AxTJKeB5ICkteeVejz8anFKXkWePqzJJ
         k4LzFWjs8MkPhx5voFP1BEBSwUd2WjgkVWtoHXQh3HGTuLWkNV2qLyEb7iZg0NSzKRwA
         KPNoaqq4p4mMjPXvBxaRu/t8TJfx5ovxqtWkik02xL+m3wEJUFAdNP8D/kVNMAPo0pcY
         Jc9t0vLRgtD8acFlxBnOpqnSPjsfLN7Q93UD8PJmFlSiGvVVBlBW4+Hn/f1QOFQ+iRPK
         rIvKN5/R7PM9i1UeXw5posw0warz/lqM7ihZFbFZDL7Nb1mr67QCu8Pgq4RTRLMa7lWP
         z7eA==
X-Gm-Message-State: AOAM531wclvPDvEmOATVWh/Dz3tO7ttYV/GpQrQpJlaxxHGMQ19cuaOS
        ImHrJOYteCH06iqWwpWYCds=
X-Google-Smtp-Source: ABdhPJxI/4BQR7XkSAiLmnAokzrLajyIVi/bqKjJ2lJPrimJiu5JhMe5S+UYpWd3UuxKVQC3OoV7yQ==
X-Received: by 2002:a17:90a:a103:: with SMTP id s3mr5908303pjp.158.1618935147093;
        Tue, 20 Apr 2021 09:12:27 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b389:6c06:5046:89e? ([2601:647:4000:d7:b389:6c06:5046:89e])
        by smtp.gmail.com with ESMTPSA id c16sm6528215pgl.79.2021.04.20.09.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 09:12:26 -0700 (PDT)
Subject: Re: [PATCH 000/117] Make better use of static type checking
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <7eaf77e8-ca4f-c0db-e94a-5fa3e16e3b51@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5c194446-e145-9d6d-3bc2-23254f0058b9@acm.org>
Date:   Tue, 20 Apr 2021 09:12:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <7eaf77e8-ca4f-c0db-e94a-5fa3e16e3b51@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 11:04 PM, Hannes Reinecke wrote:
> We should not try to preserve the split SCSI result value with its four
> distinct fields.

I don't think that we have the freedom to drop the four byte SCSI result
entirely since multiple user space APIs use that data structure. The
four-byte SCSI result value is embedded in the following user space API
data structures (there may be others):
* struct sg_io_v4, the SG_IO header includes the driver_status
(driver_byte()), transport_status (host_byte()) and device_status
(scsi_status & 0xff) (the message byte is not included).
* struct fc_bsg_reply.
* struct iscsi_bsg_reply.
* struct ufs_bsg_reply.

> I'd rather have the message byte handling moved into the SCSI parallel
> drivers (where really it should've been in the first place).
> The driver byte can go entirely as the DRIVER_SENSE flag can be replaced
> with a check for valid sense code, DRIVER_TIMEOUT is pretty much
> identical to DID_TIMEOUT (with the semantic difference _who_ set the
> timeout), and DRIVER_ERROR can be folded back into the caller.
> All other values are unused, allowing us to drop driver error completely.
> 
> With that we're only having two fields (host byte and status byte) left,
> which should be treated as two distinct values.
> 
> As it so happens I do have a patchset for this; guess I'll be posting it
> to demonstrate the idea.

This patch series does not prevent the conversion described above.
Although I think that the changes described above would help, I have a
few concerns:
- Some drivers use the result member of struct scsi_cmnd for another
purpose than storing SCSI result values. See e.g. the CAM_* values
defined in drivers/scsi/aic7xxx/cam.h and the use of these values in
drivers/scsi/aic7xxx/aic79xx_osm.c. From the master branch:

        [ ... ]
	cmd->scsi_done = scsi_done;
	cmd->result = CAM_REQ_INPROG << 16;
	rtn = ahd_linux_run_command(ahd, dev, cmd);
        [ ... ]

        [ ... ]
	if ((cmd->result & (CAM_DEV_QFRZN << 16)) != 0) {
		cmd->result &= ~(CAM_DEV_QFRZN << 16);
		dev->qfrozen--;
	}
        [ ... ]

Converting this driver could be challenging and may end up in rewriting
this driver.
- The SCSI drivers that do something meaningful with the message byte
are parallel SCSI drivers. Parallel SCSI is a technology that was
popular 20-30 years ago but that is no longer popular today. Finding
test hardware may be a big challenge.
- The parallel SCSI technology is no longer commercially relevant. It
may be challenging to motivate people (including yourself) to convert a
significant number of parallel SCSI drivers that each have a small user
base.

Although I appreciate it that you have shared this proposal and also
that you have proposed to lead this effort, I'm not convinced that this
proposal will be implemented soon. So I propose to proceed with this
patch series.

Thanks,

Bart.

