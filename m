Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE53C35242
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 19:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44EE021569
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 19:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="S65KcoNI";
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="Hg/zT6U1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbgBKTOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 14:14:41 -0500
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:25304 "EHLO
        mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729934AbgBKTOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Feb 2020 14:14:41 -0500
X-Greylist: delayed 785 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Feb 2020 14:14:40 EST
Received: from pps.filterd (m0075033.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01BIw5Pt040737
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 14:01:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=proofpoint;
 bh=esHMiUeSwXjyvPJP53vh2XpvLViXxDIgD26JWyQ2GCI=;
 b=S65KcoNIMjLVtR98ZVSi94LI5EfSNce0FZsWNFTCN6Zr1uIAfoepw1xTK71Qf1JQu6Mn
 TED7/zXcYcXk6dNiWCJUhEXScOIMyA/d8xvhfBkhAUE6rLSJwylNkrc+fn6FPwyBOwm3
 sxi3UBT4uKK7Npw5JSA9ziMcP/an1GfZHHgUvqSZDrjVKrZ2EbHxcGsefwx2t3nAvs5s
 6RI0f55YYrLUIKE0bz5mo12aFVFi40cD/PI5E3A56ZikYigsgFw86TXBPun1MWWcGP2U
 BQrNZ+2k6ReV30JuMe9EF1vyWeKPZY76zLtRj0UUJPEjg5GnY7EblO6oo2eckrFpMLXq mg== 
Authentication-Results: seagate.com;
        dkim=pass header.s=google header.d=seagate.com
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        by mx0b-00003501.pphosted.com with ESMTP id 2y2b03ux2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 14:01:34 -0500
Received: by mail-wr1-f69.google.com with SMTP id t6so7410326wru.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2020 11:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seagate.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=esHMiUeSwXjyvPJP53vh2XpvLViXxDIgD26JWyQ2GCI=;
        b=Hg/zT6U1geDZ1DJi7INZpQOfCx1H1s8YKIjFIYrxBE7U5J1kJ2gS2q93lTfr7Z5TDl
         zhZIGkryOhaj41CMdZmBNT6+mTONSN7nTlKbPJ2iXvru810uG/mxkbAXLrlmN5k33UyY
         oRydwoKwmuYAlXASTvGIQnQqgjn6Y8R2BP0+wcoC6WhzJKyxLiPS1bPKRPzU7+qWeD8b
         eftpNOzX+Z2QFvFj7oKutXcJ1XnCR5F37y/nupXQvQUetUIbeLXsk6ko3PkRhDY4YnKV
         RFRNGnTt70gWI/bVMN59NlMove56w5ThqCVe/JYa5EiqKDK707Dpm72H7sx0bISh9i08
         UEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=esHMiUeSwXjyvPJP53vh2XpvLViXxDIgD26JWyQ2GCI=;
        b=Dd5U/Dd8vuoofr2VJO6fe0+vYnWhKqAJj/GQh58QgxWJNp6WGQdqPRNA8IwliYtHIh
         6FxNbqKhKod3UxyYAXPkOnk+09jVkBVXEDLHX1P8/r2/aAC+7iYTKSbWid8Ypvkij+4D
         F/z+8iuR2kgVO3gTZydHvwPsyn1kqDKZiZnm8tHPhNvuItUSazDK/cnRZnblRR7staBS
         W3XqSImnE7DtPCtUZGNQCZBIlSP0TMBwOLVY9f8CacFnWmQXGvHffLxc3o7tg/oaB/mW
         0Itk4IF56CHNAC6JVG1zz6RezcC0x68JlCXfkwv4ep75hCSRpHndGkTMRAcFM2i5a+Dt
         jLxA==
X-Gm-Message-State: APjAAAVYEyDF8Ag7v8IrVpmUZE6gMWcIIm+jdJaCfQ5vPIYMp5oreVOO
        njXo8r3FesAqwiyH1/akq5Ilueha8YkEXOiaYhDGjZX8eAukWJpscaGLVRpgi75MTtzcY+JMYIo
        CLet/6F4sfdcDY0cs1xrp2SRGIRHf/+O8PpTOO+Sr4S5kJH8+JXDLyalTc/KG8Bg=
X-Received: by 2002:a05:6000:192:: with SMTP id p18mr9882355wrx.218.1581447692154;
        Tue, 11 Feb 2020 11:01:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHfJbVEQUane7A9MspJwRA/aOOQTH6DO+weUnfDXUEjV3EmBBcCyAsrVfB8ClNI3/WlIgji5XI59VpkUPkqmM=
X-Received: by 2002:a05:6000:192:: with SMTP id p18mr9882325wrx.218.1581447691811;
 Tue, 11 Feb 2020 11:01:31 -0800 (PST)
MIME-Version: 1.0
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
In-Reply-To: <20200211122821.GA29811@ming.t460p>
From:   Tim Walker <tim.t.walker@seagate.com>
Date:   Tue, 11 Feb 2020 14:01:18 -0500
Message-ID: <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-PolicyRoute: Outbound
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-11_05:2020-02-11,2020-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002110128
X-Proofpoint-Spam-Policy: Default Domain Policy
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> > Background:
> >
> > NVMe specification has hardened over the decade and now NVMe devices
> > are well integrated into our customers=E2=80=99 systems. As we look for=
ward,
> > moving HDDs to the NVMe command set eliminates the SAS IOC and driver
> > stack, consolidating on a single access method for rotational and
> > static storage technologies. PCIe-NVMe offers near-SATA interface
> > costs, features and performance suitable for high-cap HDDs, and
> > optimal interoperability for storage automation, tiering, and
> > management. We will share some early conceptual results and proposed
> > salient design goals and challenges surrounding an NVMe HDD.
>
> HDD. performance is very sensitive to IO order. Could you provide some
> background info about NVMe HDD? Such as:
>
> - number of hw queues
> - hw queue depth
> - will NVMe sort/merge IO among all SQs or not?
>
> >
> >
> > Discussion Proposal:
> >
> > We=E2=80=99d like to share our views and solicit input on:
> >
> > -What Linux storage stack assumptions do we need to be aware of as we
> > develop these devices with drastically different performance
> > characteristics than traditional NAND? For example, what schedular or
> > device driver level changes will be needed to integrate NVMe HDDs?
>
> IO merge is often important for HDD. IO merge is usually triggered when
> .queue_rq() returns STS_RESOURCE, so far this condition won't be
> triggered for NVMe SSD.
>
> Also blk-mq kills BDI queue congestion and ioc batching, and causes
> writeback performance regression[1][2].
>
> What I am thinking is that if we need to switch to use independent IO
> path for handling SSD and HDD. IO, given the two mediums are so
> different from performance viewpoint.
>
> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.or=
g_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iolanthe.rowla=
nd.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJ=
ZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DtsnF=
P8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D
> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.or=
g_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=3DIGDlg0lD=
0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_u=
QQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSbytUjuRrrQgZpvV3b=
xZYFDHe4&e=3D
>
>
> Thanks,
> Ming
>

I would expect the drive would support a reasonable number of queues
and a relatively deep queue depth, more in line with NVMe practices
than SAS HDD's typical 128. But it probably doesn't make sense to
queue up thousands of commands on something as slow as an HDD, and
many customers keep queues < 32 for latency management.

Merge and elevator are important to HDD performance. I don't believe
NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort
within a SQ without driving large differences between SSD & HDD data
paths?

Thanks,
-Tim

--=20
Tim Walker
Product Design Systems Engineering, Seagate Technology
(303) 775-3770
