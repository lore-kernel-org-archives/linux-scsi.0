Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94720C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 01:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64381207D0
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 01:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W0DQIWLK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgGQBuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 21:50:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13725 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgGQBuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 21:50:23 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200717015017epoutp026b21e5f794c04e07bef36302d745c094~iZyL0qA5q3033730337epoutp02N
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2020 01:50:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200717015017epoutp026b21e5f794c04e07bef36302d745c094~iZyL0qA5q3033730337epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594950617;
        bh=qdjULQp3ZZR65z/qcwBuzTZHFQcxGD6qLQ1iEDE5gmk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=W0DQIWLKJ7KTOFEU2icuI/bRORIeU5/JF8B/PmkCdAjPwmAf/MAWwl+tCOF+soDXy
         2Dg+jzmMtYE36+DDbWa1xfaYuIMIDGKn7rgL/B/NCJ9/YeHxm2ePjaMcXdT9jNKSAs
         EsTqEIqQYyUfpXhMjvfRfCcvV0P2LD21ut03Aeu4=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200717015017epcas5p417f7194ad5145ba2eb26402f3ba7b5b6~iZyLCJ5Id1286012860epcas5p4i;
        Fri, 17 Jul 2020 01:50:17 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.BA.09467.8D3011F5; Fri, 17 Jul 2020 10:50:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200716164524epcas5p310db2c23bbc82adf365112ae673a5209~iSWbc2z9K0203802038epcas5p31;
        Thu, 16 Jul 2020 16:45:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200716164524epsmtrp1d758bdc50442e6a5c771eab7205ca0c2~iSWbXQRd71958019580epsmtrp1a;
        Thu, 16 Jul 2020 16:45:24 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-4b-5f1103d84f22
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.62.08303.324801F5; Fri, 17 Jul 2020 01:45:23 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200716164519epsmtip2489569e9c4cb5042564c431e03c45d00~iSWXLwRzG1317113171epsmtip2b;
        Thu, 16 Jul 2020 16:45:19 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avi Shchislowski'" <Avi.Shchislowski@wdc.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        <daejun7.park@samsung.com>, "'Avri Altman'" <Avri.Altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <asutoshd@codeaurora.org>, <beanhuo@micron.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <tomas.winkler@intel.com>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sang-yoon Oh'" <sangyoon.oh@samsung.com>,
        "'Sung-Jun Park'" <sungjun07.park@samsung.com>,
        "'yongmyung lee'" <ymhungry.lee@samsung.com>,
        "'Jinyoung CHOI'" <j-young.choi@samsung.com>,
        "'Adel Choi'" <adel.choi@samsung.com>,
        "'BoRam Shin'" <boram.shin@samsung.com>
In-Reply-To: <SN6PR04MB3872FBE1EAE3578BFD2601189A7F0@SN6PR04MB3872.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Date:   Thu, 16 Jul 2020 22:15:17 +0530
Message-ID: <001301d65b90$8012c3e0$80384ba0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNTAwbo7R95v2Jv+B+oDyvdEhuZkAJ3qsxbAEskZzgCs8hfhQGhYIDUpdhZ7/A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMKsWRmVeSWpSXmKPExsWy7bCmuu4NZsF4g2lnLSw23n3FarG37QS7
        xdddC5gtXv68ymZx8GEni8Xh2+/YLaZ9+Mls8Wn9MlaLVQ/CLXr7t7JZLLqxjcni8q45bBbd
        13ewWSw//o/JYsLLJSwWS7feZLTonL6GxeJDT53FooW7WRyEPS5f8fa43NfL5LF4z0smjwmL
        DjB6tJzcz+LxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAFcUl01Kak5mWWqRvl0CV8bjhuCC
        B/IVbZ//MzYwNkh1MXJySAiYSPw9Npmli5GLQ0hgN6PEyePvmCGcT4wSs6d+Y4NwPjNKdD++
        xgrT8ukMTGIXo0Tb3vtQ/W8YJY4tW8wMUsUmoCuxY3EbWJWIwG0miY9ze9hBHGaBC0wS977f
        BpvFKRArsWb9JyYQW1jAW+L32xlsIDaLgKrE5pvHwOK8ApYS7x9dZIGwBSVOznwCZjMLaEss
        W/iaGeImBYmfT5eBzRQR8JO4tvoaI0SNuMTRnz1gH0kI9HNKTN+xAKrBRWL7nE9sELawxKvj
        W9ghbCmJl/1tQDYHkJ0t0bPLGCJcI7F03jEWCNte4sCVOSwgJcwCmhLrd+lDhGUlpp5axwSx
        lk+i9/cTJog4r8SOeTC2qkTzu6tQY6QlJnZ3s05gVJqF5LNZSD6bheSDWQjbFjCyrGKUTC0o
        zk1PLTYtMMxLLdcrTswtLs1L10vOz93ECE6XWp47GO8++KB3iJGJg/EQowQHs5II7/yXAvFC
        vCmJlVWpRfnxRaU5qcWHGKU5WJTEeZV+nIkTEkhPLEnNTk0tSC2CyTJxcEo1MGWJnSlU0l2+
        W3ORfHKfoSf/krfzn0S4SK7l+vv1l7bRCj65ffalFsvb3x885nlpfqCavaBHeM+T/FWZc3Om
        7nm9bqHo+a2i8TX5Br9SmExfFf8KEHx67IHYESW5pKD+j1lbFp+vmdfSo8ClHl6SLHu9bQpX
        o7FKkuFDB4OlIldXlYRmX+SuK57k1mWqqfDDJ+jETA3l1DrfBRbK7Pq9zN9Tex4Ly9RMmNxi
        wcJQKX4jbOujtPAyoy+fDBetKrT7F3ayL1jffeakcIYEbe/5MlfL/E7GqFs//Ht1r9qy11qv
        lAvy2JOaJj2yjVuz9F4Qz9cIPV/1U9oP71768/3gyW8fZvzlPfRghvJDdb06JZbijERDLeai
        4kQASRTo4wYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsWy7bCSvK5Ki0C8QZumxca7r1gt9radYLf4
        umsBs8XLn1fZLA4+7GSxOHz7HbvFtA8/mS0+rV/GarHqQbhFb/9WNotFN7YxWVzeNYfNovv6
        DjaL5cf/MVlMeLmExWLp1puMFp3T17BYfOips1i0cDeLg7DH5SveHpf7epk8Fu95yeQxYdEB
        Ro+Wk/tZPL6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiuKySUnNySxLLdK3S+DKmN9mUbBI
        vmLB57usDYzrJLsYOTkkBEwkPp35xgZiCwnsYJSY8jECIi4tcX3jBHYIW1hi5b/nQDYXUM0r
        Rom/+5ezgCTYBHQldixuYwNJiAg8Z5I4sewLE4jDLHCNSeLPx89sEC1XmST+LfzECNLCKRAr
        sWb9JyYQW1jAW+L32xlgu1kEVCU23zwGFucVsJR4/+giC4QtKHFy5hMwm1lAW6L3YSsjjL1s
        4WtmiPsUJH4+XcYKYosI+ElcW30NqkZc4ujPHuYJjMKzkIyahWTULCSjZiFpWcDIsopRMrWg
        ODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjmtbR2MO5Z9UHvECMTB+MhRgkOZiURXh4u3ngh
        3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MNXKpPzIFp9q
        fvukSOfMmGyt7k3XbzpynX7JOevw9Hdb1+/+qc6mJvv03h+V8Elrfl86U5Uxo2nmNv5ZigV9
        mkIbu7/eCXzzR+q61JmaR1MLvDS+ZcpMsC17U76Zv3BqC7OftePKxNhziQeefpVlV17x2dj5
        NPN2SfdjtzNEJ3awhv5p2vugc3E4z+/ca7dMKq+brBS89T/+wmr/e1vlW7uvTfsTzlilNe+x
        vBJzl/f/NxrrjMLuXb+s+z085QLfypSeXRFHll6ZM3/3NeO3E77I5u759JK30OWs2Qkbu39T
        Jk1duimm1Mx5R06iS11G6vvDTjpRjZEOm6Yt1vJMYn5jHJQ4vU9YOPX8947rjlOUWIozEg21
        mIuKEwFA8W5maAMAAA==
X-CMS-MailID: 20200716164524epcas5p310db2c23bbc82adf365112ae673a5209
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
        <SN6PR04MB38720C3D8FC176C3C7FB51B89A7E0@SN6PR04MB3872.namprd04.prod.outlook.com>
        <4174fcf4-73ec-8e3f-90a5-1e7584e3e2d0@acm.org>
        <SN6PR04MB3872FBE1EAE3578BFD2601189A7F0@SN6PR04MB3872.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avi,

> -----Original Message-----
> From: Avi Shchislowski <Avi.Shchislowski=40wdc.com>
> Sent: 16 July 2020 15:31
> To: Bart Van Assche <bvanassche=40acm.org>; daejun7.park=40samsung.com; A=
vri
> Altman <Avri.Altman=40wdc.com>; jejb=40linux.ibm.com;
> martin.petersen=40oracle.com; asutoshd=40codeaurora.org;
> beanhuo=40micron.com; stanley.chu=40mediatek.com; cang=40codeaurora.org;
> tomas.winkler=40intel.com; ALIM AKHTAR <alim.akhtar=40samsung.com>
> Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org; Sang-yo=
on Oh
> <sangyoon.oh=40samsung.com>; Sung-Jun Park
> <sungjun07.park=40samsung.com>; yongmyung lee
> <ymhungry.lee=40samsung.com>; Jinyoung CHOI <j-young.choi=40samsung.com>;
> Adel Choi <adel.choi=40samsung.com>; BoRam Shin
> <boram.shin=40samsung.com>
> Subject: RE: =5BPATCH v6 0/5=5D scsi: ufs: Add Host Performance Booster S=
upport
>=20
>=20
>=20
> > -----Original Message-----
> > From: Bart Van Assche <bvanassche=40acm.org>
> > Sent: Thursday, July 16, 2020 4:42 AM
> > To: Avi Shchislowski <Avi.Shchislowski=40wdc.com>;
> > daejun7.park=40samsung.com; Avri Altman <Avri.Altman=40wdc.com>;
> > jejb=40linux.ibm.com; martin.petersen=40oracle.com;
> > asutoshd=40codeaurora.org; beanhuo=40micron.com;
> stanley.chu=40mediatek.com;
> > cang=40codeaurora.org; tomas.winkler=40intel.com; ALIM AKHTAR
> > <alim.akhtar=40samsung.com>
> > Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org;
> > Sang-yoon Oh <sangyoon.oh=40samsung.com>; Sung-Jun Park
> > <sungjun07.park=40samsung.com>; yongmyung lee
> > <ymhungry.lee=40samsung.com>; Jinyoung CHOI <j-
> young.choi=40samsung.com>;
> > Adel Choi <adel.choi=40samsung.com>; BoRam Shin
> <boram.shin=40samsung.com>
> > Subject: Re: =5BPATCH v6 0/5=5D scsi: ufs: Add Host Performance Booster
> > Support
> >
> > CAUTION: This email originated from outside of Western Digital. Do not
> > click on links or open attachments unless you recognize the sender and
> > know that the content is safe.
> >
> >
> > On 2020-07-15 11:34, Avi Shchislowski wrote:
> > > My name is Avi Shchislowski, I am managing the WDC's Linux Host R&D
> > > team
> > in which Avri is a member of.
> > > As the review process of HPB is progressing very constructively, we
> > > are getting
> > more and more requests from OEMs, Inquiring about HPB in general, and
> > host control mode in particular.
> > >
> > > Their main concern is that HPB will make it to 5.9 merge window, but
> > > the host
> > control mode patches will not.
> > > Thus, because of recent Google's GKI, the next Android LTS might not
> > > include
> > HPB with host control mode.
> > >
> > > Aside of those requests, initial host control mode testing are
> > > showing
> > promising prospective with respect of performance gain.
> > >
> > > What would be, in your opinion, the best policy that host control
> > > mode is
> > included in next Android LTS?
> >
> > Hi Avi,
> >
> > Are you perhaps referring to the HPB patch series that has already been
> posted?
> > Although I'm not sure of this, I think that the SCSI maintainer
> > expects more
> > Reviewed-by: and Tested-by: tags. Has anyone from WDC already taken
> > the time to review and/or test this patch series?
> >
> > Thanks,
> >
> > Bart.
>=20
> Yes, I am referring to the current proposal which I am replying to:
> =5BPATCH v6 0/5=5D scsi: ufs: Add Host Performance Booster Support This p=
roposal
> does not contains host mode, hence our customers concern.
> What would be, in your opinion, the best policy that host control mode is
> included in next Android LTS  assuming it will be based on kernel v5.9 ?
>=20
This series has nothing to do with Host mode control, this series is target=
ed for device mode control. General consensus here is to land this series a=
s it is (unless someone has more review comments) and lets add/enhance what=
ever need to be done for adding Host mode controls as well as other HPB2.0 =
related changes.

> Thanks,
> Avi

