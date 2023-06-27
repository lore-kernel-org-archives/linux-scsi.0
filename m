Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAB8EB64D7
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 02:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjF0CpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 22:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjF0CpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 22:45:08 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977D6173A
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 19:45:05 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230627024502epoutp036e9e9f32ede349e2ee1316e98231fb27~sY-3n5DYs2953829538epoutp03A
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 02:45:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230627024502epoutp036e9e9f32ede349e2ee1316e98231fb27~sY-3n5DYs2953829538epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1687833902;
        bh=5xF9qATyEbuVpKO5ICntt2LMXKMAsCC0Hky1uFD2Srw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UGi+npRURQnqM4v06CPHjHQNKsH/JQGXx9cimJAOvKGay1ZbfOy1Dib7PatMURXYP
         j9iYsXG6BzRMnRj979+b73NmnReb3scy69UVmsNErst9h2Bm+qiCxr4VBkbdVDwngz
         rN7doNdUzGmXCZeflWhbuXnWfBj4klkaFQYhf5uU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20230627024501epcas2p49665994285ec58f2943942c4c425d15d~sY-2-_Zoc1459014590epcas2p4X;
        Tue, 27 Jun 2023 02:45:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4QqpwF5m0Hz4x9Q2; Tue, 27 Jun 2023 02:45:01 +0000
        (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c~sX7t2-n6k1698116981epcas2p1I;
        Tue, 27 Jun 2023 01:26:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230627012659epsmtrp2c181dcfc0f86b76ddab8c17ad2a90b06~sX7t1_F0Z0247602476epsmtrp2U;
        Tue, 27 Jun 2023 01:26:59 +0000 (GMT)
X-AuditID: b6c32a29-187ff700000086bb-b4-649a3ae2cf6f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.1D.34491.2EA3A946; Tue, 27 Jun 2023 10:26:58 +0900 (KST)
Received: from KORCO118546 (unknown [10.229.38.108]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230627012658epsmtip16e2575c58a61c7396fbb7a62017e3b1d~sX7tm9prw0260002600epsmtip1A;
        Tue, 27 Jun 2023 01:26:58 +0000 (GMT)
From:   "hoyoung seo" <hy50.seo@samsung.com>
To:     <bvanassche@acm.org>
Cc:     <Arthur.Simchaev@wdc.com>, <JBottomley@Parallels.com>,
        <adrian.hunter@intel.com>, <athierry@redhat.com>,
        <avri.altman@wdc.com>, <beanhuo@micron.com>, <jaegeuk@kernel.org>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <quic_asutoshd@quicinc.com>,
        <quic_ziqichen@quicinc.com>, <santoshsy@gmail.com>,
        <stanley.chu@mediatek.com>, <cpgs@samsung.com>,
        <sc.suh@samsung.com>, <kwmad.kim@samsung.com>,
        <kwangwon.min@samsung.com>, <sh425.lee@samsung.com>
Subject: Re: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
Date:   Tue, 27 Jun 2023 10:26:58 +0900
Message-ID: <1891546521.01687833901791.JavaMail.epsvc@epcpadp3>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdmolIzTQZ3izrwYT5mB18BArYMXvQ==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWy7bCSnO4jq1kpBn8f2FicfLKGzaJz4jJW
        i4dbnrJavPx5lc3i4MNOFotpH34yW7w8pGnxZP0sZotLvUtYLRbd2MZksfXGThaLm1uOslh0
        X9/BZrH8+D8mi4Udc1ksfn+fBNQ69wy7RdfdG4wWS/+9ZbFYuvUmo4OIx+Ur3h47Z91l91i8
        5yWTx6ZVnWweExYdYPRoObmfxeP7+g42j49Pb7F4nJz3k81j4p46j/f7rrJ59G1ZxejxeZOc
        R/uBbqYAvigum5TUnMyy1CJ9uwSujKN/n7IWXGGt6Hkyha2B8SpLFyMnh4SAicS1m0+AbC4O
        IYHdjBL7X31kh0hISPxf3MQEYQtL3G85wgpR9JxR4tzfB2BFbAJaEv1vt7CB2CJADQcm3AGb
        xCzQySJx8MpHZpCEsICDxMMD7xlBbBYBVYm3q6+BTeUVsJT4tG8VC4QtKHFy5hMwm1lAW6L3
        YSsjjL1s4WtmiCsUJH4+XcYKsUxPYtO2H6wQNSISszvbmCcwCs5CMmoWklGzkIyahaRlASPL
        KkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4LjX0tzBuH3VB71DjEwcjIcYJTiYlUR4
        xX5MTxHiTUmsrEotyo8vKs1JLT7EKM3BoiTOK/6iN0VIID2xJDU7NbUgtQgmy8TBKdXAxHD+
        /U0bpfveEpq+h20EPx7NfBdt3nvlMY9z+SMNNqfSO//45R261q4RX3M6/7LfjV1X/z+e9PCH
        66GDJQ02nSmW29ynZB0TkuS6W9h038+x5lF8Hl/KI7veWaHLF/f+3nZ3bdNiu8b0j8tUvwkd
        Ug1c9Nn8VTLzDp6fpp3+B1TkT+2Rtb0prVXQeKj9yKEMsyO2XgdbOYJsV3bvKtPaIXrhwdNL
        cvu2rKmK5rRiq/TpsTSbkFWgzGU4o2qu6IdCO0FO3/R5r+Y9D5FlSe2dcO3w/+ZqDp9ZoTKK
        B/kKMm6GVUs8yl35ufCso8zq8ta/p57dvf2ut2nj6VjnW51c128+VHFwvNA0b6EUX/VCJZbi
        jERDLeai4kQAnYTKumoDAAA=
X-CMS-MailID: 20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c
References: <CGME20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

@@ -5408,7 +5406,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *h=
ba,
 =09struct scsi_cmnd *cmd =3D lrbp->cmd;
=20
 =09scsi_dma_unmap(cmd);
-=09lrbp->cmd =3D NULL;=09/* Mark the command as completed. */
 =09ufshcd_release(hba);
 =09ufshcd_clk_scaling_update_busy(hba);
 }

Hi,
Is there any reason to delete "lrbp->cmd =3D NULL"?
As far as I know, clear to NULL to indicate that cmd is completed.

When the UFS MCQ mode is activated, check that lrbp->cmd is NULL to check t=
he completion of the command.
https://lore.kernel.org/linux-scsi/f0d923ee1f009f171a55c258d044e814ec0917ab=
.1685396241.git.quic_nguyenb@quicinc.com/

If there is no special reason, why don't you add "lrb->cmd =3D NULL" again?


