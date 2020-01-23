Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4504FC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 00:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13DA224125
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 00:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="sArOujgG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAWAUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 19:20:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbgAWAUo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 19:20:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00N0EdBE021367;
        Wed, 22 Jan 2020 16:20:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=uEyKC9cLQy38VzZP42o4TbIF5I2DTWG6JE8xGl2L8tY=;
 b=sArOujgGxc68KnaMZIY8oVxjBOKsVtrAl86XqBHby8c+6SdjU13dXGi64mJaVaXTGcC7
 Cg7aC722GkUvKlTu01HRCVWIGgaeZZnLJjHYV1m0iHhrAVZF6BCZB78B40Q7zQDm7y3F
 wrSMakpKp2lqxn+hfA/oODKvWMlmqU1SjYyPj3WgE0CC29BT9MGX5Vhls6742O0v3DLr
 qKD4DYW1A94mLm4C+0cKNPOvJ4xA+ZHIL57iBBQ+89sz9MMnEj+Ildc7YGcuRNALgBse
 gBGgCqwTK/Bkew84oBvCsihC+TXAQrCrRvhKpo+rqPpxTVoC1n3GopLn+APImwHggrIF bg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xpm9037hx-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 16:20:40 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jan
 2020 16:20:19 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 22 Jan 2020 16:20:18 -0800
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id E92D93F7040;
        Wed, 22 Jan 2020 16:20:18 -0800 (PST)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 00N0KH96018996;
        Wed, 22 Jan 2020 16:20:18 -0800
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 22 Jan 2020 16:20:17 -0800
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
CC:     Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v4] qla2xxx: Fix unbound NVME response length
In-Reply-To: <DF4PR8401MB1241B973AEE70A60D1D08133AB0C0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
Message-ID: <alpine.LRH.2.21.9999.2001221611360.15850@irv1user01.caveonetworks.com>
References: <20200121192710.32314-1-hmadhani@marvell.com>
 <DF4PR8401MB1241B973AEE70A60D1D08133AB0C0@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for the review, Robert. Response inline..

On Wed, 22 Jan 2020, 3:59pm, Elliott, Robert (Servers) wrote:

> 
> 
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> > On Behalf Of Himanshu Madhani
> > Sent: Tuesday, January 21, 2020 1:27 PM
> > Subject: [PATCH v4] qla2xxx: Fix unbound NVME response length
> ...
> > We discovered issue with our newer Gen7 adapter when response length
> > happens to be larger than 32 bytes, could result into crash.
> ...
> >  drivers/scsi/qla2xxx/qla_isr.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> ...
> > +		if (unlikely(iocb->u.nvme.rsp_pyld_len >
> > +		    sizeof(struct nvme_fc_ersp_iu))) {
> > +			WARN_ONCE(1, "Unexpected response payload length %u.\n",
> > +			    iocb->u.nvme.rsp_pyld_len);
> 
> Do you really need a kernel stack dump for this error, which the WARN
> macros create? The problem would be caused by firmware behavior, not
> something wrong in the kernel.

The intent was to bring this to the tester's notice. My expectation is 
that this would be removed once the root cause is known. The issue was not 
reproducible internally.

> 
> If this function runs in interrupt context (based on the filename),
> then printing lots of data to the slow serial port can cause soft
> lockups and other issues.

In retrospect, this should have been under the driver debug tunable (which 
is set usually by testers).

> 
> > +			ql_log(ql_log_warn, fcport->vha, 0x5100,
> > +			    "Unexpected response payload length %u.\n",
> > +			    iocb->u.nvme.rsp_pyld_len);
> > +			iocb->u.nvme.rsp_pyld_len =
> > +			    sizeof(struct nvme_fc_ersp_iu);
> > +		}
> 
> If the problem is due to some firmware incompatibility and every
> response is long, the kernel log will quickly become full of
> these messages - per-IO prints are noisy. The handling implies
> the driver thinks it's safe to proceed, so there's nothing that
> is going to keep the problem from reoccurring. If the handling was
> to report a failed IO and shut down the device, then the number
> of possible error messages would quickly cease.
> 
> Safer approaches would be to print only once and maintain a count
> of errors in sysfs, or use ratelimited print functions.

I can post a follow on patch, with the WARN/log message under driver 
debug.

Regards,
-Arun

> 
> 
> 
