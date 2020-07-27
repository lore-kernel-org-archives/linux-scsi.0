Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B4AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A093F2072E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 11:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hBen2JLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgG0L1t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:27:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43705 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgG0L1r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 07:27:47 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200727112744epoutp03eae4289a9c8cc7b69e397199ea7e157f~lmHNyv6tK1108011080epoutp03U
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 11:27:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200727112744epoutp03eae4289a9c8cc7b69e397199ea7e157f~lmHNyv6tK1108011080epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595849264;
        bh=l+gAf2yh/db6/nIT0i89yLN+pjxdyNdP4q2SLtd27Oc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=hBen2JLBVKN2feRSiiL2TlbT+5WAQHEI+bZ7X+8ZXgm2fQBgWDe7cLjKc8Qt3U2Bh
         sCAFHhyrg3wFAPzZVeui1jLfTxq7hBPeLpwOC0Rpzg7QkGMlLho0jn6TtjFaxpMcmP
         j+zWrxt/becQMFbOtqqqcCr3u4SPG2EJS3ZfNI1E=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200727112743epcas2p3f30eb3c971475d4cd5c4308884d238fb~lmHM4jQZc2505125051epcas2p33;
        Mon, 27 Jul 2020 11:27:43 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BFcwr62GCzMqYkX; Mon, 27 Jul
        2020 11:27:40 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.BB.19322.C2ABE1F5; Mon, 27 Jul 2020 20:27:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200727112740epcas2p35921d787697f93ca6e2c6760c112c724~lmHJxCjz32505125051epcas2p3x;
        Mon, 27 Jul 2020 11:27:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727112740epsmtrp2f276d593e7316b124c002fb056696dd3~lmHJwSONY2041020410epsmtrp2P;
        Mon, 27 Jul 2020 11:27:40 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-20-5f1eba2cc917
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.D0.08303.C2ABE1F5; Mon, 27 Jul 2020 20:27:40 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200727112740epsmtip24cecd9cf7b5126ea290c13b561e879b4~lmHJhfEY_2543425434epsmtip2N;
        Mon, 27 Jul 2020 11:27:39 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <SN6PR04MB4640B30915D3D402B3B47F79FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When
 ufs reset and restore, need to disable write booster
Date:   Mon, 27 Jul 2020 20:27:39 +0900
Message-ID: <074001d66408$efdc5a80$cf950f80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHLP/cB05Q6MF8BaP7+redz0q/FGgLfFFEPASU1gksBdMSJPAFM0QFRAfHkSm+o69LYYA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmha7OLrl4g3lTDSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ2PFjFPMBRtZKpad3cbawLiNuYuR
        k0NCwETi9t0DTF2MXBxCAjsYJfZu/csI4XxilJhz+S0rhPOZUeL0pr/sMC1nf/WyQCR2MUrM
        2/MBqv8lo8SmbwdYQarYBEwl+ratAGsXEZjGJLH71yImkASnQKzE/E1nwIqEBRqA5j636WLk
        4GARUJVYeDYeJMwrYClx4ncrK4QtKHFy5hMWEJtZQF5i+9s5UIcrSOw4+5oRxBYRCJP4PucT
        O0SNiMTszjZmkL0SAjs4JNYsmccG0eAiMeVvAxOELSzx6vgWqHekJD6/2wtVUy8x5d4qFojm
        HkaJPStOQDUYS8x61s4IciizgKbE+l36IKaEgLLEkVtQt/FJdBwGhRBImFeio00IolFJ4szc
        21BhCYmDs3Mgwh4S/5e9ZpnAqDgLyZOzkDw5C8kzsxDWLmBkWcUollpQnJueWmxUYIgc2ZsY
        welXy3UH4+S3H/QOMTJxMB5ilOBgVhLh5RaViRfiTUmsrEotyo8vKs1JLT7EaAoM9YnMUqLJ
        +cAMkFcSb2hqZGZmYGlqYWpmZKEkzpureCFOSCA9sSQ1OzW1ILUIpo+Jg1OqgWl2lsBBloLa
        nbpHZZu4FgWtYC4OWRP9cb2s+003Vz/hWwceTV6wer5hnZvk5/uic8yuGyk0PVBf7DdPdEuS
        v4u8RMwuJcYdi7a1Gvn0M71teZXBeuvfpzNfdX2j04K/C502fubhzPSvoG3CwT9Gr8LsuJYe
        2+/+/Jha8KQXIjz9JkVJD6NjwpZ++Pdj2xanySdP8mt/mqnv8ffW/Wes/SL5gn3G8ecV7uhf
        eXxUVkhB+cyiK02bhO6bMwSU23PoN1oov36yb/FiJ+3WrbvatmaxZ7xXn7Vvy1suqc3PzI8m
        fLP6572KJ2DzrA1/C+TKvnhb+8x/8MTt8RkOHdfujQ4HGernvEh4/KXyuMqVY9lKLMUZiYZa
        zEXFiQCNOOGmSAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvK7OLrl4g0O97BYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WHRjG5NF9/UdbBbLj/9jcuDyuHzF2+NyXy+T
        x4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0H+hmCuCI4rJJSc3JLEst0rdL4MpYMeMUc8FG
        loplZ7exNjBuY+5i5OSQEDCROPurl6WLkYtDSGAHo8TkVZcYIRISEv8XNzFB2MIS91uOsEIU
        PWeUOLbmEStIgk3AVKJv2wqwhIjAAiaJR6v3M0FUrWCW2L5jIVgVp0CsxPxNZ8BsYYE6ia5f
        zUD7ODhYBFQlFp6NBwnzClhKnPjdygphC0qcnPmEBcRmFtCW6H3Yyghhy0tsfzsH6mwFiR1n
        X4PFRQTCJL7P+cQOUSMiMbuzjXkCo9AsJKNmIRk1C8moWUhaFjCyrGKUTC0ozk3PLTYsMMpL
        LdcrTswtLs1L10vOz93ECI45La0djHtWfdA7xMjEwXiIUYKDWUmEl1tUJl6INyWxsiq1KD++
        qDQntfgQozQHi5I479dZC+OEBNITS1KzU1MLUotgskwcnFINTDNZbwn/CTjCHdit+IH9IPPT
        LQUC5/c/TlxXl/47p8B4056sL2mZr0Xf5E28/X5GWsz+i98Ou7jWLm1T83oV7qX5S9Dt4Zx1
        NyrXhU2qbcqYk2gqZPT0vH0f/7bQH1x/FRv85MPW9SnJnrpQc0Ym1kDjt2hfX2LE1Px1dvMO
        iKzeGf4vhSGx6zzvkQXuosZhs/buz/u0MV7uinXjlb3zNyn0T3+j2JiZd33V34sv7nWkv53G
        vE07o3TPm4+1H/JesDsV7xacP7tlZfmJfU2G8yUWR86VDIu/sVI97ELprwNPc53eVh9UnX3v
        iHnzFElbriTF83MrbrdPuR6avPPI83nuL95z3b/ySrvtk8HKXDElluKMREMt5qLiRADuKxgU
        KAMAAA==
X-CMS-MailID: 20200727112740epcas2p35921d787697f93ca6e2c6760c112c724
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095653epcas2p4575db5cbcd8897662ad19465339128b2
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
        <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
        <SN6PR04MB4640E7CB5A7F2E406323CFBAFC750@SN6PR04MB4640.namprd04.prod.outlook.com>
        <071e01d663fc$f6bce010$e436a030$@samsung.com>
        <SN6PR04MB4640B30915D3D402B3B47F79FC720@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> >
> > > This patch is not really needed - just squash it to the previous one.
> > Why you said this patch is not really needed?
> > I don't understand
> > Our WB device need to disable WB when called
> > ufshcd_reset_and_restore() func.
> > Please explain reason.
> This patch only change the names of some functions defined in the first
> patch.
> Squash it to the first one.

"Asutosh Das (asd) <asutoshd@codeaurora.org>" said this function not clearly.
So I modify this function name.
I think this name is clear than the previous name.

