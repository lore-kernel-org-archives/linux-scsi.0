Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEF2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 08:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7FF161493
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 08:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBRIO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 03:14:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35692 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhBRIKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 03:10:11 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210218080919epoutp03b7272aadf34ea3bd3ed35a0f3405512c~kySyCJYKz1366613666epoutp03J
        for <linux-scsi@vger.kernel.org>; Thu, 18 Feb 2021 08:09:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210218080919epoutp03b7272aadf34ea3bd3ed35a0f3405512c~kySyCJYKz1366613666epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613635759;
        bh=t+7TBlhqJIKhwHO1/hb5acfFK9qbGtjvOoSzMAg9LjM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=DFJVmynQ+optLLx1yBo5moeZvbmLs0yM5GWLVInQ9rbnd0mwjUCH0g/SRxAwZUdpT
         W/pTDQJh7qHUCAdF3he0oNal5GRfZEWXZgT45v1x1QrtfdWpz4mwsYx5XsXkwSTDdA
         lerXXmP3dYArhwDg+JMdKxZCe8oUsxGWg2RCv49I=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210218080918epcas2p4edadcdd8b9b25aae57efc2da75071c53~kySxS3Z-B1896718967epcas2p47;
        Thu, 18 Feb 2021 08:09:18 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Dh6ms2DMSz4x9Q7; Thu, 18 Feb
        2021 08:09:17 +0000 (GMT)
X-AuditID: b6c32a46-777d6a800000dbf8-fd-602e20adea89
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.DF.56312.DA02E206; Thu, 18 Feb 2021 17:09:17 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v20 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575D2FEEE0EC784BF44E3C8FC859@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210218080916epcms2p84297368f9ee92aa4b6577d2a8f8622d9@epcms2p8>
Date:   Thu, 18 Feb 2021 17:09:16 +0900
X-CMS-MailID: 20210218080916epcms2p84297368f9ee92aa4b6577d2a8f8622d9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xbVRzHc+693FuIJYf3ETZXLm4REGjrWg8ThlGcjRsJczN7qIEObijQ
        x7UXFp9ZByoDhIGbgrgni0AYrG6hUCAOBgoYRxAYcxQcKAODZqMIRHkqheIW//uc7/md3/f3
        +51zRKTnPdpflKrP4Ix6tZal3aj69mBlWK0kPFFqyxfj0XP1NP7m4y4GT84P0Lh96AGDP7fP
        k/hPc4ULnmwLxtWjB3D2JTONz3SbCFxw0kLjseEZBpffqSfwyZUcCvc3naFx/k9WGld2rhB4
        qM4Nf2UZBDi3pIbC5Rebqed9VP23dqv6CwsIVWPZz4yqqLwVqFrO1jCqD79voVTT4zZKVVhX
        DVQz155Q5bTmE/Fuh7VRGk6dzBklnD7JkJyqT4lmd+9LeDFBoZTKwmSR+FlWolfruGg2dk98
        2K5U7WqHrOSoWpu5KsWrBYGN2BllNGRmcBKNQciIZjk+WcvLZHy4oNYJmfqU8CSDbodMKpUr
        ViMTtZqzDVUM30m9vTBWwZhALZUHXEUIbkfHs1rIPOAm8oRWgAbnipk8IBKJoQdatno5Yrxg
        DLJfuk442BOyyNxbxqzr4cj2Sw1wMA2fRiVdI4wjjzesolDvQh/tWJBwgUBdY3aw7iZGpTnj
        TucA1FBpWdNd4Zvo+Mwdcl1/Cv1dUeBkHzR4+T6zwVMd5515vNFHd7udMR5odL7ZqT+OOprt
        xDofQ5bhBeAoAsFPAGpvtLmsb0Sg2yeurhUhhnHo+uUHtIMpuBWVXuhwFheLBlZuriUiYSiq
        uPgH6ZgKCYORuSnCgQgGoW9t1EZbpquLzP+ZhO7oRPvyf7r13D1nadvQlXkzUQSCyh6OuuwR
        r7KHXhcAWQ18OV7QpXCCnJc/ervXwNpzD9llBafv28PbACECbQCJSNZbzMyEJHqKk9XvvMsZ
        DQnGTC0ntAHFapfFpL9PkmH1v+gzEmQKuVIpjVRghVKOWT+xIB1N8IQp6gwuneN4zrhxjhC5
        +puI/W7HDlROmebSiopN+80j218PDdirWz7V9t6PvNe+lzb7nTra0frGbOSNJ3+73VOwJ6g0
        wKN04NUjrxW+tfMfiVx72uJxxbLYafGN+TWpr2gy7zNrIJ/1RUOsuyatNaw8m+x75ct0rW/a
        +Wyuu+fuUuAzcT9snm0dqmRc9sbX8lWbGnPeTy4JXeqeXlz69K8xnxLphItf7yYm9mZ03vi2
        ng8OxfGs10i/Tp773MEbMfB3c5Qt0A5iDnHD04fp4am6W/ZZom8L7a5pYtq9V3Z8/bLSMDa/
        1LNlYuuQ7rGDE1Gm/srvsuBcYY6R9KgLbihWtMhhemq0kI2P5FpfKIAToUQXSwkatSyENArq
        fwEPskX1dwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8
References: <DM6PR04MB6575D2FEEE0EC784BF44E3C8FC859@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p1>
        <20210217091517epcms2p1a5ff04e9c1fff2641e7914032c5fa5e7@epcms2p1>
        <CGME20210217090853epcms2p17db2903a3a0c1a13e4ee071b9a39dbc8@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry for previous mail. Please just ignore that.

> >=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*=C2=A0for=C2=A0pre_re=
q=C2=A0*/=0D=0A>=20>=C2=A0+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hpb->p=
re_req_min_tr_len=C2=A0=3D=C2=A0HPB_MULTI_CHUNK_LOW;=0D=0A>=20This=C2=A0act=
ually=C2=A0needs=C2=A0to=C2=A0be=C2=A0bMAX_DATA_SIZE_FOR_HPB_SINGLE_CMD.=0D=
=0A=C2=A0OK,=0D=0A>=20Also=C2=A0wasn't=C2=A0able=C2=A0to=C2=A0find=C2=A0any=
=C2=A0reference=C2=A0to=C2=A0fHPBen?=0D=0A=C2=A0OK,=20I=20will=0D=0A=0D=0AT=
hanks,=0D=0ADaejun=0D=0A=C2=A0=0D=0A=C2=A0=0D=0A=C2=A0=C2=A0
