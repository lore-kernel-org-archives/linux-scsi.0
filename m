Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D340C433E4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 01:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02A620791
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 01:29:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cr6sTEgr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgGPB3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 21:29:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48734 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgGPB3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 21:29:08 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200716012905epoutp049b917448d983d413b630ca1ef01c63ea~iF2YwKpUT1000610006epoutp041
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2020 01:29:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200716012905epoutp049b917448d983d413b630ca1ef01c63ea~iF2YwKpUT1000610006epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594862945;
        bh=zJAofxopHC79zQoylSIOCNiUOlixBr/fMm5A5jguGag=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cr6sTEgrDyJs7JdFPYKOvIvV+wvsaE5YN/VWHlqTjbAjbcy17E1+2iebkMk9ogdWl
         9T9JSjXvVWCqqAijuRczGn9kcbkDAOpA8xu6+xGR1GPXqU/QJfguusMOqwfscBm1gu
         5Ag/KzyulWI6CCgnZmdHt4qqcTr4raYkytyrmZqQ=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200716012905epcas5p204deaf7e5976678fc2ba273493f3b109~iF2YYM6EA0226702267epcas5p26;
        Thu, 16 Jul 2020 01:29:05 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.1A.09467.16DAF0F5; Thu, 16 Jul 2020 10:29:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200716010507epcas5p39199ecd12a90acc5fd78638b81da8c7b~iFhc4Ll_o1595915959epcas5p3k;
        Thu, 16 Jul 2020 01:05:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200716010507epsmtrp218aca61e5835c9e7fd938c3f5140c3e4~iFhc3M6wz1822418224epsmtrp2N;
        Thu, 16 Jul 2020 01:05:07 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-7d-5f0fad61209f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.CA.08303.2C7AF0F5; Thu, 16 Jul 2020 10:05:06 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200716010502epsmtip28c10b8dedc26391bce95c358131414f9~iFhY88V8K2786027860epsmtip2I;
        Thu, 16 Jul 2020 01:05:02 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     <daejun7.park@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <asutoshd@codeaurora.org>, <beanhuo@micron.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <tomas.winkler@intel.com>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sang-yoon Oh'" <sangyoon.oh@samsung.com>,
        "'Sung-Jun Park'" <sungjun07.park@samsung.com>,
        "'yongmyung lee'" <ymhungry.lee@samsung.com>,
        "'Jinyoung CHOI'" <j-young.choi@samsung.com>,
        "'Adel Choi'" <adel.choi@samsung.com>,
        "'BoRam Shin'" <boram.shin@samsung.com>
In-Reply-To: <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
Subject: RE: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Date:   Thu, 16 Jul 2020 06:35:00 +0530
Message-ID: <077301d65b0d$24d79920$6e86cb60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNTAwbo7R95v2Jv+B+oDyvdEhuZkAJ3qsxbpfxVr7A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmlm7iWv54gzMzuC023n3FarG37QS7
        xcufV9ksDj7sZLE4fPsdu8W0Dz+ZLT6tX8ZqsepBuEVv/1Y2i0U3tjFZXN41h82i+/oONovl
        x/8xWUx4uYTFYunWm4wWndPXsFh86KmzWLRwN4uDkMflK94el/t6mTwW73nJ5DFh0QFGj5aT
        +1k8vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCK4rJJSc3JLEst0rdL4MrY2LiVraCds+JX
        6zrmBsaH7F2MnBwSAiYSPUs/MnYxcnEICexmlJhzbAczhPOJUeLEx79Qmc+MEvferoFreb31
        GJgtJLCLUWJbozZE0RtGif1f1rKAJNgEdCV2LG5jA0mICLQwSRyf0g42l1ngApPEve+3WUGq
        OAXsJT7+n8UGYgsLeEv8fjsDzGYRUJX4fPow2ApeAUuJQ59+skHYghInZz4B28AsoC2xbOFr
        ZoiTFCR+Pl0GNlNEwEpiy7E57BA14hJHf/ZA1TRzStxt8YKwXSSutvexQdjCEq+Ob4F6TUri
        87u9QHEOIDtbomeXMUS4RmLpvGMsELa9xIErc1hASpgFNCXW79KHCMtKTD21jgliK59E7+8n
        TBBxXokd82BsVYnmd1ehxkhLTOzuZp3AqDQLyWOzkDw2C8kDsxC2LWBkWcUomVpQnJueWmxa
        YJiXWq5XnJhbXJqXrpecn7uJEZwitTx3MN598EHvECMTB+MhRgkOZiURXh4u3ngh3pTEyqrU
        ovz4otKc1OJDjNIcLErivEo/zsQJCaQnlqRmp6YWpBbBZJk4OKUamJKv8/Ue7opik5dNvfGf
        S++qr5vUuo7DHHyb/gW9OVS58x6/yiK9NU+/KTZrc6mdmdc6971RVMkdN81nEas/n8ve9lz6
        10ru7XK3KhMXr6xVnu8hZf67K7ZOZ8+NXWGB3xLYZfWkUnnFhCV7Ge1O/Pt/u3kmr0/V/aa1
        PJM9dp2e1cxtU9UzIVGlqs1ro1W0+HOhnduOvefhXhYROWWrXIA2y632yaaHOHTsznqs5XB6
        Y1F9M1ytfuN6v1ez1fvCPsSX64oxsM/IUo/ivfKH7V/is99XNxxSOHzv8/xDgbuD7zxheiUx
        NSX+rJ1Pp9ehG8bMwq903pw+serR/fjVTN/mLrjAzXjV0yafQ2SijRJLcUaioRZzUXEiAEoh
        ZqYABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7bCSvO6h5fzxBhO3m1hsvPuK1WJv2wl2
        i5c/r7JZHHzYyWJx+PY7dotpH34yW3xav4zVYtWDcIve/q1sFotubGOyuLxrDptF9/UdbBbL
        j/9jspjwcgmLxdKtNxktOqevYbH40FNnsWjhbhYHIY/LV7w9Lvf1Mnks3vOSyWPCogOMHi0n
        97N4fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMAVxWWTkpqTWZZapG+XwJUx6d1ypoJrHBW3
        b/xmb2DcxN7FyMkhIWAi8XrrMSCbi0NIYAejRNOkA1AJaYnrGydA2cISK/89hyp6xShx/dhl
        NpAEm4CuxI7FbWwgCRGBCUwSE2d8YgVxmAWuMUn8+fgZrEpIoIVRYs8tThCbU8Be4uP/WWBx
        YQFvid9vZ4DZLAKqEp9PHwZbxytgKXHo0082CFtQ4uTMJywgNrOAtsTTm0/h7GULXzNDnKcg
        8fPpMlYQW0TASmLLsTnsEDXiEkd/9jBPYBSehWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWG
        BUZ5qeV6xYm5xaV56XrJ+bmbGMHRrqW1g3HPqg96hxiZOBgPMUpwMCuJ8PJw8cYL8aYkVlal
        FuXHF5XmpBYfYpTmYFES5/06a2GckEB6YklqdmpqQWoRTJaJg1OqgUlh/cTuQ+VvZs6YpSwj
        78VqZNC3atLc5c0Kvmnlb7cL+JxpmbF3z+x55wqL7ST+2P6tXrBH5ZJIYrQdx/domwfuMl0M
        1VtcbwS7JR5e+DSuQyNpG69rm0d0dpykQOj66w8y7907uvH/lPhF/nw7pQ8Vcn674Pg+4bxD
        xqfEXKvb/9/a9c6rfvRltqHxrj8SG/cw5De/8MkyvcEkln35jOx/g/jFPt2B9RuVbqcUmF21
        LCxpvB/IdyHBY41T2KprM5543ih99ue6cmXvH+OHvuyu/ZPYF5npMaRynF7y6YTcPONNAibX
        jvN6BbNvjL4/Idw1zuY9W5lPiG/xt4TSDI0zS5qils0ymt8gsLq/R4mlOCPRUIu5qDgRAMSm
        rkNlAwAA
X-CMS-MailID: 20200716010507epcas5p39199ecd12a90acc5fd78638b81da8c7b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
        <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> -----Original Message-----
> From: Daejun Park <daejun7.park=40samsung.com>
> Sent: 13 July 2020 16:04
> To: avri.altman=40wdc.com; jejb=40linux.ibm.com; martin.petersen=40oracle=
.com;
> asutoshd=40codeaurora.org; beanhuo=40micron.com;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; bvanassche=40acm.org;
> tomas.winkler=40intel.com; ALIM AKHTAR <alim.akhtar=40samsung.com>; Daeju=
n
> Park <daejun7.park=40samsung.com>
> Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org; Sang-yo=
on Oh
> <sangyoon.oh=40samsung.com>; Sung-Jun Park
> <sungjun07.park=40samsung.com>; yongmyung lee
> <ymhungry.lee=40samsung.com>; Jinyoung CHOI <j-young.choi=40samsung.com>;
> Adel Choi <adel.choi=40samsung.com>; BoRam Shin
> <boram.shin=40samsung.com>
> Subject: =5BPATCH v6 0/5=5D scsi: ufs: Add Host Performance Booster Suppo=
rt
>=20
> Changelog:
>=20
> v5 -> v6
> Change base commit to b53293fa662e28ae0cdd40828dc641c09f133405
>=20
If no further comments, can this series have your Reviewed-by or Acked-by t=
ag, so that this can be taken for 5.9?
Thanks=21

> v4 -> v5
> Delete unused macro define.


