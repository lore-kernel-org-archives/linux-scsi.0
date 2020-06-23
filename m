Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C3BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 01:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4771206C0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 01:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="F3ws3kpG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbgFWBum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 21:50:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45071 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730252AbgFWBul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 21:50:41 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200623015038epoutp0468e0fd78955209f5645adda6fefe05d8~bCToF6Jyo2100521005epoutp04l
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 01:50:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200623015038epoutp0468e0fd78955209f5645adda6fefe05d8~bCToF6Jyo2100521005epoutp04l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592877038;
        bh=dhk5mX215O36H9YO5nuIb/Bpi7FVkbbwNp+j22h+O5A=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=F3ws3kpGg5auuYuLpgtiO9frHI3Okj+o12FPoLQ8ktKJvER9H5EuOL3rgbNh5cuyT
         EdNhM1b7FQNFTlF/+diWQ0QLry57UHJtDXJkAazSC3uBGJW2dSE0EX3X3KPrDI0uek
         qR+BfRATQsg/SCTUxu5/f2p8JlxTXdnQdZcPrO0Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200623015037epcas2p3ad20564bad059b1cf6309b137c5a2bc1~bCTnrJ5oY0640706407epcas2p3W;
        Tue, 23 Jun 2020 01:50:37 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49rTkg3tPwzMqYkW; Tue, 23 Jun
        2020 01:50:35 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.17.19322.AEF51FE5; Tue, 23 Jun 2020 10:50:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200623015034epcas2p38a219afaccb31e32e759214a0d056faa~bCTknr8G10640706407epcas2p3J;
        Tue, 23 Jun 2020 01:50:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200623015034epsmtrp1206602c56d280378039a081029750ed3~bCTkm_Mbb2284122841epsmtrp1x;
        Tue, 23 Jun 2020 01:50:34 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-63-5ef15feabce8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.AB.08382.AEF51FE5; Tue, 23 Jun 2020 10:50:34 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200623015034epsmtip14c1ebc3e170381193ed3f1335431b15e~bCTkY_frV2895528955epsmtip1A;
        Tue, 23 Jun 2020 01:50:34 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>
In-Reply-To: <5ed422cb-ad63-e085-cfe4-ac7d78b1ac87@acm.org>
Subject: RE: [RFC PATCH v1 1/2] ufs: support various values per device
Date:   Tue, 23 Jun 2020 10:50:33 +0900
Message-ID: <001901d64900$af212160$0d636420$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJXX9isUct+sMsc2iUIclPJ2BwbYgFh5K9zAaNqRvACMOGsoae5j0wg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmqe6r+I9xBmcuGFo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3Jovv6DjaL5cf/MTlwely+4u1xua+XyWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwVwROXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5ua
        GRjqGlpamCsp5CXmptoqufgE6Lpl5gCdp6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUot
        SMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMno3L6DsWANa8WqRz9YGxibWboYOTkkBEwk
        Dpx/wtrFyMUhJLCDUWJD3xwWCOcTo8Sh7QvYQaqEBL4xSvx9WwnTsebldKiivYwSl7Y0M0E4
        LxglvvY1s4JUsQloS0x7uBtsrojAP0aJh8f+sIEkOAWsJb72r2QEsYUF3CT+zvsNFmcRUJXo
        3NvNBGLzClhKnNi1kBnCFpQ4OfMJ2LHMAvIS29/OYYY4Q0Hi59NlQAs4gBa4SWzeHghRIiIx
        u7ONGWSvhMBKDolP2zYwgdRICLhINL/kgGgVlnh1fAs7hC0l8bK/Dcqul9g3tYEVoreHUeLp
        vn+MEAljiVnP2hlB5jALaEqs36UPMVJZ4sgtqMv4JDoO/2WHCPNKdLQJQTQqS/yaNBlqiKTE
        zJt3oDZ5SPSea2GfwKg4C8mPs5D8OAvJM7MQ9i5gZFnFKJZaUJybnlpsVGCIHNebGMEpV8t1
        B+Pktx/0DjEycTAeYpTgYFYS4X0d8C5OiDclsbIqtSg/vqg0J7X4EKMpMNQnMkuJJucDk35e
        SbyhqZGZmYGlqYWpmZGFkjhvruKFOCGB9MSS1OzU1ILUIpg+Jg5OqQammC2mku8XBnpt4xT5
        bst6Vpw9aELTm0NXDy1JWDqxycy9PyzB8r53VvgZB48bK22PPF+Xmip3bv2sPTtvB3otME9c
        csgh5X9L9x22MpaKiUbh/gvdT06YcWCmbexPsR+Okyf9E/oj2pwlEnzkzvOkxTen9GUf+G/O
        GHu/rv0I+4lOH8dHswS9Zafkp2/Q5lv7I2+D7oV31xbNLTxw4z3fu/Upl8tOpksXXkphOblz
        8a6US//zOC/+N7Vmu2vANqOX61/Hz6MCxQeDQxiPG9m2KRx50XRHLppz0qMZWwurrbf1P+jb
        39PvUPXe/PylbzVOEv61yzTnzjt+0iiWZ8p9lUlqjrWmedI7Vu5XUtv4UImlOCPRUIu5qDgR
        ANJVdB9CBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO6r+I9xBsef8lg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWiy6sY3Jovv6DjaL5cf/MTlwely+4u1xua+XyWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwVwRHHZpKTmZJalFunbJXBldG7fwViwhrVi1aMf
        rA2MzSxdjJwcEgImEmteTgeyuTiEBHYzSjw4fI8ZIiEpcWLnc0YIW1jifssRVoiiZ4wSR/bP
        YQVJsAloS0x7uBssISLQwSTxqmMjG0RVA5PEsj+72UGqOAWsJb72rwQbJSzgJvF33m82EJtF
        QFWic283E4jNK2ApcWLXQmYIW1Di5MwnYPcxA23ofdjKCGHLS2x/OwfqPAWJn0+XAW3mANrs
        JrF5eyBEiYjE7M425gmMQrOQTJqFZNIsJJNmIWlZwMiyilEytaA4Nz232LDAMC+1XK84Mbe4
        NC9dLzk/dxMjONK0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHe1wHv4oR4UxIrq1KL8uOLSnNSiw8x
        SnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpgkgq3C/WckNnWez2AfZG9/mbHCsl80RsL
        gzwf5O65yjTdva/1zt77GTZe2i4BKZphZjcfe++X4Xdvffnm2/aGk/f/FK3Iljzw+SvXvZ3C
        cvLP52zMuLFWreTtlGsvZrtHZDDd+6QWILop+01ho8nxPUwMxrbdn9SkS2p+H8j8ffGxtIjr
        stKYLWbLjTxVWtZKmK5N/nDjqgHbOS6OM+7H0pN2OpYI+8na+LVP+jTbiu3OPMNpBmy8MfU9
        EbW1+96Eftm6YI2NRlmHgwpnklDRUbcjsiUprUKP6qOnzL+9NS70LeP/uG7Ztstx3/os1/L0
        96wItzWIy5i7MsP+/ILQ3sOXzRI0Hm1afnQK210lluKMREMt5qLiRAB7+iStIwMAAA==
X-CMS-MailID: 20200623015034epcas2p38a219afaccb31e32e759214a0d056faa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae
References: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
        <CGME20200620073914epcas2p2c788e787f4fff602de61e5f8e5fb79ae@epcas2p2.samsung.com>
        <1592638297-36155-2-git-send-email-kwmad.kim@samsung.com>
        <5ed422cb-ad63-e085-cfe4-ac7d78b1ac87@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-06-20 00:31, Kiwoong Kim wrote:
> >  #define END_FIX { }
> 
> The name of this macro is longer than its value. Additionally, this macro
> makes code harder to read instead of easier. Please include a patch to
> remove this macro from the UFS driver.
> 
> > +#define UFS_DEV_VAL(_vendor, _model, _key, _val) { \
> > +	.wmanufacturerid = (_vendor),\
> > +	.model = (_model),		\
> > +	.key = (_key),			\
> > +	.val = (_val),			\
> > +}
> 
> A macro like the above also makes code harder to read instead of easier.
> Please remove this macro definition and use the designated initialization
> style directly.
> 
> Thanks,
> 
> Bart.

Got it. Thanks !


