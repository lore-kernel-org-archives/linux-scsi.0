Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E32C35242
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 19:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 777F320718
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 19:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YSzUg3W1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390996AbgAXTl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 14:41:26 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42433 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390664AbgAXTlZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 14:41:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so3377563wro.9
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2020 11:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=KIoPgyD/uHdbw/hRYTLjyyF+abTVqKoC6UW0RlLuccs=;
        b=YSzUg3W1HrCe+bgYHDU9A0rFSo+FDvP0TNM2cdGv2aU850+fH2rOc0kr+f4tAwTuKK
         kXOpry1/o1XfYoJsz10jBzghAUIEvWJxoCwxppP+RhN0/YG3QoXP0eFOgNKr0qI5aUGL
         V+hNCqsvRf5qAriFUeJFu/DXbUMa/BSlhMmOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=KIoPgyD/uHdbw/hRYTLjyyF+abTVqKoC6UW0RlLuccs=;
        b=gPPmkCJNrLtDgYyxHU41ndpxeaDcIQDDX/AedzPGvDHIXJKpYKRvmBUtEyjA1fRLtz
         Z2732eJm81HomyNlB+7nvIGQwKUUulce6XTteZftmSoKmz3iX93c5zFod/U9CstOBPY1
         QUIFbC3d6seDTU0oKVS6XWaBP2kDxp2q1DpGpPWqxEZ/Xht6DDANNB8VnC1UzbrrT8R8
         WwnCAbt7RSTi+CoxqqOssKuqKZy4q4vZhb9CscYvDwkmBcoOw1siWWxl4oXUjqEtUFLI
         BJ+vRZoDzLQttKm33tZT2EjJ7/iLqm9LDxMVfaqNkE81RYVnBOa9bI+2ixz9xE9FVUQN
         /wEA==
X-Gm-Message-State: APjAAAX8l/BhrveMQAyzeGdNeisJX5OZ8OrEdpKgQ8vah0Tk+sOfJzCi
        aVEPPF/T1jh/8ELvrJQvKv1Cu1cWsrP2H6TfYvF/5g==
X-Google-Smtp-Source: APXvYqyhuBrPE/e3gFMMRLeHpcFhRXQfqhqgPcw7PaiCrm6PIHL+eijqzcE8xi4WLy1ltHKdOS5umamvzo+dv6cSptA=
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr5922428wrp.236.1579894883745;
 Fri, 24 Jan 2020 11:41:23 -0800 (PST)
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>        <20200119071432.18558-6-ming.lei@redhat.com>
 <yq1y2u1if7t.fsf@oracle.com>   <ab676c4c-03fb-7eb9-6212-129eb83d0ee8@broadcom.com>
 <yq1iml1ehtl.fsf@oracle.com>
In-Reply-To: <yq1iml1ehtl.fsf@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMGKWhM81/SGNPryz/MgrKjfT/XowLUtWFaAjRd+LcBvgdOhwHnm/r4pVQPsFA=
Date:   Fri, 24 Jan 2020 12:41:20 -0700
Message-ID: <f4f06cf8459c21749335c6b7a4cfe729@mail.gmail.com>
Subject: RE: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD
 when HBA needs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Sumit Saxena <sumit.saxena@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

>> Please read what I proposed. megaraid VDs don't report QUEUE_FULL so
you would not trigger the device_busy counter.

Yes, megaraid does not use set track_queue_depth, and never reports
QUEUE_FULL . Instead of relying on QUEUE_FULL and some complex heuristics
of when to start tracking device_busy, why can't we simply use  "
track_queue_depth" ( along with the other flag that Ming added) to decide
which devices need queue depth tracking, and track device_busy only for
them?

>>Something like not maintaining device_busy until we actually get a
>>QUEUE_FULL condition. And then rely on the existing queue depth ramp up
>>heuristics to determine when to disable the busy counter again.

I am not sure how we can suddenly start tracking device_busy on the fly,
if we do not know how many IO are already pending for that device? Won't
device_busy have a high chance of getting negative ( or at least wrong
value) when pending IOs start getting completed?

Thanks,
Sumanesh


-----Original Message-----
From: Martin K. Petersen <martin.petersen@oracle.com>
Sent: Thursday, January 23, 2020 6:59 PM
To: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: linux-scsi@vger.kernel.org; Martin K. Petersen
<martin.petersen@oracle.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for
SSD when HBA needs


Sumanesh,

> The high-end controllers might expose a SCSI interface, but can have
> all kind of devices (NVMe/SCSI/SATA) behind it, and has its own
> capability to queue IO and feed to devices as needed. Those devices
> should not be penalized with the overhead of the device_busy counter,
> just because they chose to expose themselves has SCSI devices (for
> historical and backward compatibility reasons).

Please read what I proposed. megaraid VDs don't report QUEUE_FULL so you
would not trigger the device_busy counter.

-- 
Martin K. Petersen	Oracle Linux Engineering
