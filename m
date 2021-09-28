Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A352DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743EA61159
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhI1Fd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:33:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13469 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234133AbhI1Fdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 01:33:55 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210928053213epoutp02e4867be2c4a3b233368564a4d1bec261~o5W-fWAm02595425954epoutp02S
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 05:32:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210928053213epoutp02e4867be2c4a3b233368564a4d1bec261~o5W-fWAm02595425954epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632807133;
        bh=XmdGgp7KH9yYpPtS/tI7O5dME0ZWilg3xqrVmIQiwug=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=JFcXODDwXF20OL+xKhU8r6X+rDrgat9w5a1qRd9QU7lOa53yxuOJsdvWQcS7iMpYM
         CDDskwikb+br7CDicHOmvRyc7PAppFG1r2gsenRgueSuVJzzKTHenDQLWOUk0C1vcT
         pu1XUmpiKrbe0IoCvTY64h/FylyaXdpk0OjwygHs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210928053210epcas2p3c4b75648fa94b3eaa4cf5dac738ca620~o5W8Pho9G1786517865epcas2p3-;
        Tue, 28 Sep 2021 05:32:10 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HJSn32jmxz4x9QY; Tue, 28 Sep
        2021 05:32:07 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.07.09717.5D8A2516; Tue, 28 Sep 2021 14:32:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210928053200epcas2p44b46bed60b7af86933170c2eda37fbc2~o5WzlFokL3276332763epcas2p4A;
        Tue, 28 Sep 2021 05:32:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210928053200epsmtrp26b92d68f1920b7a2ad766f37ad2d8e1e~o5WzkHurU1201212012epsmtrp2d;
        Tue, 28 Sep 2021 05:32:00 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-2a-6152a8d5885c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.2C.09091.0D8A2516; Tue, 28 Sep 2021 14:32:00 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210928053200epsmtip251fc8dad2d81dfe69b93b3d6d70c70ff~o5WzWzmnu1362513625epsmtip2r;
        Tue, 28 Sep 2021 05:32:00 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <adrian.hunter@intel.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
In-Reply-To: <28332c27-c5d0-b309-db15-b83bf57b3dfd@acm.org>
Subject: RE: About ufshcd_err_handling_unprepare
Date:   Tue, 28 Sep 2021 14:32:00 +0900
Message-ID: <000401d7b42a$294e9180$7bebb480$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDq2eFSTch8Rz73ZfoMyE4bCF7IGwKn0swMAlHCqtOtatOvQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmue7VFUGJBru7RSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB6L97xk8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAGc
        UTk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
        JeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoT
        cjIeLfcrWMJUserXd+YGxheMXYycHBICJhJ3Hk5i62Lk4hAS2MEosfHzPVaQhJDAJ0aJjguc
        EIlvjBKn9q8A6uAA6zi7uRAivpdR4svE7cwQzgtGibmbb7OBdLMJaEtMe7ibFSQhIvCISeJw
        1yZ2kG5OAWuJ27MkQWqEBQwkrv9ZzQwSZhFQldj0NR8kzCtgKXHp4FEmCFtQ4uTMJywgNrOA
        vMT2t3OYIa5WkPj5dBkrSKuIgJPEpgclECUiErM728DOkRC4wCExZdENNoh6F4kj655D2cIS
        r45vYYewpSQ+v9sLFa+X2De1gRWiuYdR4um+f9AgMpaY9awd7HlmAU2J9bv0IeGgLHHkFtRp
        fBIdh/+yQ4R5JTrahCAalSV+TZoMNURSYubNO1AlHhInPstOYFScheTHWUh+nIXkmVkIaxcw
        sqxiFEstKM5NTy02KjBEjudNjODkrOW6g3Hy2w96hxiZOBgPMUpwMCuJ8Aaz+CcK8aYkVlal
        FuXHF5XmpBYfYjQFBvpEZinR5HxgfsgriTc0NTIzM7A0tTA1M7JQEued+88pUUggPbEkNTs1
        tSC1CKaPiYNTqoFJ4WT1tkXFe+4Lzd7Iuk/99CkL7k+F/rrnzq7IPjyNcU5xtl9K61/P1Vcu
        6+Q/q3u3huXoClb/4/OyVNoaen5HRZiUP6hhVdjUcOP7O4VSI75dV5b+vdpj2hXFwbvccGa3
        UuzEG4Eny2dOnlW8o2+6xJvY/OaYBEMRzuD4jFo/G8bblsH9V6tfTlB+z7bydTmDtzW3c19r
        qPreNRa6ZxKV7lhPLz53Y/vCqoMLdv+Yq/tPnO9v6iZPjytZx++axp/+ubN9grTgwWkLudZu
        uZ+sbNcaebJo6leTr0diQhc3a+Qekw9e+a1jz1Z7Dp833ycmzt4282Tgvecvt2jdTDu5OF7U
        5FPKW//tSywvF8nuUGIpzkg01GIuKk4EAAJz9JdXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvO6FFUGJBrea1S1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB6L97xk8piw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAGc
        UVw2Kak5mWWpRfp2CVwZj5b7FSxhqlj16ztzA+MLxi5GDg4JAROJs5sLuxi5OIQEdjNKTN34
        nK2LkRMoLilxYudzRghbWOJ+yxFWiKJnjBInL3ezgyTYBLQlpj3cDZYQEfjEJPF24z6oql2M
        EhfeNDGDrOAUsJa4PUsSpEFYwEDi+p/VYGEWAVWJTV/zQcK8ApYSlw4eZYKwBSVOznzCAmIz
        A83vfdjKCGHLS2x/O4cZ4iAFiZ9Pl7GCjBERcJLY9KAEokREYnZnG/MERqFZSCbNQjJpFpJJ
        s5C0LGBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERyTWpo7GLev+qB3iJGJg/EQ
        owQHs5IIbzCLf6IQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwc
        nFINTMyMucGH6tN0L/KtEfi36qZh/UV52y0pk8RdfnffqWeaNPPFjJr4H7dUPsa2fdFfu6/K
        WnPBrw1nhNbvX+DC0Ldr86W31+uksnPe7T/+tpj53MMO0QlnzzzLnjxxjnbS435lMdOtmQ8U
        EhzZxPy5M3InfvGvlon4faLd6prHxq1PNhZdeqr4b0tU75GoLJ412YHFDVpNdRtEtFOvmnT0
        6sVxW30TMYmwu1NZveL5JOaOiW6vzQU8rXed1mz849nUfuL7FN5Pt1xlnhuol7zX+RZ7QW7b
        48JN83pdu3w3tx/WVTLuvLvVqeWQgNjEx29z5Jf7vHytpvS5Z/0E0f9vTtt9yEpRW3P/3fRJ
        57jT3JVYijMSDbWYi4oTAWKC0Tg4AwAA
X-CMS-MailID: 20210928053200epcas2p44b46bed60b7af86933170c2eda37fbc2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a
References: <CGME20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a@epcas2p2.samsung.com>
        <005701d7b372$dc01ad20$94050760$@samsung.com>
        <28332c27-c5d0-b309-db15-b83bf57b3dfd@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
> 
> Please help with reviewing this patch series since this series should
> resolve the issue described above:
> 
> https://lore.kernel.org/linux-scsi/20210922093842.18025-1-
> adrian.hunter@intel.com/

That's what I'm finding. Thanks.

> 
> Thanks,
> 
> Bart.

