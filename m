Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBA0C35240
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 23:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C443207FF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 23:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L8FY28kZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgAWXV4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 18:21:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729274AbgAWXV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2020 18:21:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579821715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c7UEGeEpZsZ0ORA6OLKIvGl+QiPX0yRNqpxuQVwGo3w=;
        b=L8FY28kZFieYQmq7050FFQybEg4IRWYTXx+qXTTreV/O7Mt0IpaSXePWBK7+Y242LMInNo
        +WUtQ0RyhZdXL3LYMlSYgIjYM2T6VwAxhrVMFE4nKElYMZExKfgWgutp/WhaNvybTGcr6u
        jBNnEV/pMX7FHyLGkdKRiNd44ilOU38=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-8QgirkNpMPaCKQJaDh9LJw-1; Thu, 23 Jan 2020 18:21:51 -0500
X-MC-Unique: 8QgirkNpMPaCKQJaDh9LJw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5F781005514;
        Thu, 23 Jan 2020 23:21:49 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AC495D9E2;
        Thu, 23 Jan 2020 23:21:49 +0000 (UTC)
Message-ID: <adeced6da0dbdf33ac39fcfd8c16bf696e3a96d0.camel@redhat.com>
Subject: Re: [PATCH v4] qla2xxx: Fix unbound NVME response length
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Arun Easi <aeasi@marvell.com>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Thu, 23 Jan 2020 18:21:48 -0500
In-Reply-To: <alpine.LRH.2.21.9999.2001221611360.15850@irv1user01.caveonetworks.com>
References: <20200121192710.32314-1-hmadhani@marvell.com>
         <DF4PR8401MB1241B973AEE70A60D1D08133AB0C0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
         <alpine.LRH.2.21.9999.2001221611360.15850@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-01-22 at 16:20 -0800, Arun Easi wrote:
> Thanks for the review, Robert. Response inline..
> 
> On Wed, 22 Jan 2020, 3:59pm, Elliott, Robert (Servers) wrote:
> 
> > 
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> > > On Behalf Of Himanshu Madhani
> > > Sent: Tuesday, January 21, 2020 1:27 PM
> > > Subject: [PATCH v4] qla2xxx: Fix unbound NVME response length
> > ...
> > > We discovered issue with our newer Gen7 adapter when response length
> > > happens to be larger than 32 bytes, could result into crash.
> > ...
> > >  drivers/scsi/qla2xxx/qla_isr.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> > ...
> > > +		if (unlikely(iocb->u.nvme.rsp_pyld_len >
> > > +		    sizeof(struct nvme_fc_ersp_iu))) {
> > > +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> > > +			    iocb->u.nvme.rsp_pyld_len);
> > 
> > Do you really need a kernel stack dump for this error, which the WARN
> > macros create? The problem would be caused by firmware behavior, not
> > something wrong in the kernel.
> 
> The intent was to bring this to the tester's notice. My expectation is 
> that this would be removed once the root cause is known. The issue was not 
> reproducible internally.

We have a reproducible test case, so testing the patch was
not a problem.  I agree the log message should be restricted
or suppressed though, once would be enough.

The problem appeared to be that an extra bit was set (because
the length was too long by 16K) and our testing worked OK with
the ersp_iu data truncated to the correct structure size.

-Ewan

> 
> > If this function runs in interrupt context (based on the filename),
> > then printing lots of data to the slow serial port can cause soft
> > lockups and other issues.
> 
> In retrospect, this should have been under the driver debug tunable (which 
> is set usually by testers).
> 
> > > +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> > > +			    "Unexpected response payload length %u.\n",
> > > +			    iocb->u.nvme.rsp_pyld_len);
> > > +			iocb->u.nvme.rsp_pyld_len =
> > > +			    sizeof(struct nvme_fc_ersp_iu);
> > > +		}
> > 
> > If the problem is due to some firmware incompatibility and every
> > response is long, the kernel log will quickly become full of
> > these messages - per-IO prints are noisy. The handling implies
> > the driver thinks it's safe to proceed, so there's nothing that
> > is going to keep the problem from reoccurring. If the handling was
> > to report a failed IO and shut down the device, then the number
> > of possible error messages would quickly cease.
> > 
> > Safer approaches would be to print only once and maintain a count
> > of errors in sysfs, or use ratelimited print functions.
> 
> I can post a follow on patch, with the WARN/log message under driver 
> debug.
> 
> Regards,
> -Arun
> 
> > 
> > 

