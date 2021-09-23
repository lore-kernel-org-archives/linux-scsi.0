Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97389C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 00:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E0D961269
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 00:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhIWAlX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:41:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34259 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbhIWAlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 20:41:23 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210923003951epoutp04f2d4a3ffbd58c2f8ca075a5ab471bd35~nTJShzOUw2276222762epoutp04A
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 00:39:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210923003951epoutp04f2d4a3ffbd58c2f8ca075a5ab471bd35~nTJShzOUw2276222762epoutp04A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632357591;
        bh=lHPuX5SyFqAHpJoNRX+Q2q7lA+c+sD6gENGVKvKID9I=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=FsA8DCrBeT/gAbDTHQoOBIePoLJzZEcM/8le1Tr1vQ86f9hYaO7EsS6szyzFyVtJS
         ynAukQ1Ce/EA4KtQ8MYC7WPq+ePm5gotaEw9zPr/DTtG91iR7R5sGI6UWpr/8a6rFd
         7c4Qny1khhEnc3N0e+NEpGt0kTmmg5zxgtLRbk44=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210923003950epcas2p271a26dee2fe321661cceeca9801b1ea1~nTJRlU70w1859318593epcas2p2c;
        Thu, 23 Sep 2021 00:39:50 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HFGX45wh8z4x9Q0; Thu, 23 Sep
        2021 00:39:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.B3.09816.3DCCB416; Thu, 23 Sep 2021 09:39:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210923003947epcas2p34cb7861f13845a4d2534bed6b548c3b9~nTJO3TiRj0741007410epcas2p3d;
        Thu, 23 Sep 2021 00:39:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923003947epsmtrp1c2bda833e8b2547f2adb0cef7a23ebed~nTJOyTpzb0432704327epsmtrp12;
        Thu, 23 Sep 2021 00:39:47 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-24-614bccd3f6e0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.EA.09091.2DCCB416; Thu, 23 Sep 2021 09:39:46 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923003946epsmtip15d9ba3a7890288e217e135911ba2b7f4~nTJOf2RjC1784617846epsmtip1j;
        Thu, 23 Sep 2021 00:39:46 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <YUuKJj7+wmJd7DSe@robh.at.kernel.org>
Subject: RE: [PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Date:   Thu, 23 Sep 2021 09:39:46 +0900
Message-ID: <000701d7b013$8237ef50$86a7cdf0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQIApKS6Ans9QPYBmW2HKKnX1z7Q
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0wTdxznd3e9tk7cWR77rQGtp84AA9rO4pXIZoDgZTDXTBfjtggXuAFa
        rl2vMNkyBZbxWId0hqgU6pCJMjRreITHBoaCG2PMLQsOEDdkGwxrUuRhHBiQlV7N+O/zfXzy
        +Xx+Dwkqm8blkmzOzJo4Rk/iG7C2vrCYyKGfkhmlq2EPNTB5DacmLrThlGvpN5xy/lmGUWdn
        l1Bq3nFZRH3WmUANWusQatJhQ6m60TaEanIvItTt1u8w6vwv1xHKMtKBU1f6nyDUaleHeB9B
        D91Kpm0F5Tg9dLocoVsawukvu1wI3dxYhtPWuh5A/+soxem5qTGMPt3aCOiF5i10SY8F0W18
        S783i2UyWJOC5dINGdlcZhyZfDA1IVUTo1RFqrTUHlLBMTlsHJmYootMytZ7MpGKPEaf62np
        GJ4no1/eazLkmllFloE3x5GsMUNvVKmMUTyTw+dymVHphpxYlVKp1ng20/RZVx+1osYB5MSD
        hXviAlCEfAqkEkjshp3Ljz14g0RGdAA42LIqEop5ALvnxnCheASge96NPaX80zfno3QD6Fxu
        8VHuAbh8swdf28KJaOgqbROt4UBiJyyyTWBrSyhRKYJn7jjB2kBKqOHFDrvXSQBxBP6xUOPF
        mIdw3vmxd8ef0MKvrDO4gDfDgapJrw2U2Arb3TWoYEkBl6Yui4R+IKwuK0YF4SQ4Ud/kzQCJ
        EikcnbmDC4REWGRx+PIEwPv9rWIBy6GrolgsECwAfvLXqm9wFcCywhQBvwIfn2v1qEk8amHQ
        8U30GoTEdnhjzOdtEyztWxELbX9YWiwTiLtgT/s5n2ootNQsiKyAtK1LZluXzLYuje1/rVqA
        NYJg1sjnZLK82qhef93NwPviw5M6QKV7NqoXIBLQC6AEJQP9F0ZfZWT+GUz+B6zJkGrK1bN8
        L9B4zvpzVB6UbvB8Gc6cqtKoY2KUWg2liVFT5HP+9ifxjIzIZMzscZY1sqanPEQilRcgh1qu
        a9wh+RWJxy6ErTZ17twRoMvTSg5zW/uPdu8gHH6vH0x0bhtn9p9UHlX6/XgprarlI3tl/odB
        hZu6Ck+FfHs2XF2yOvw3VfX1+8eOz/z6QDphT3hGfH823o+TtZfUYFsuDdAPsera9Ihu4DoV
        uXLki3f8Muqnu4JfMqenhPeeVBtGHpa/EHq3XWS3DFfUD1gOLJbyOil/S7sNz027/YZ9OET7
        Q9Ouze+dyG/rlNfe2B6VMzg+/lpSfN3G+Ni3NRHRd0esiy+uTFbPdV+brhsPSAt8N5brrJJN
        BT3b8LP48Pdv+jndV4LzdBGW/Yg89HfnoZshgbuNWvGZfe7C5+0KrpbE+CxGFY6aeOY/dNQn
        /noEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWy7bCSnO6lM96JBucOalucfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtejZ6WxxesIiJosn62cxWyy6sY3JYuPbH0wWN7ccZbGY
        cX4fk0X39R1sFsuP/2Oy+L9nB7uDgMflK94esxp62Twu9/UyeWxeoeWxeM9LJo9NqzrZPCYs
        OsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBPFJdNSmpOZllqkb5dAlfG6m9bmAtOMlW8
        //yCvYGxiamLkZNDQsBE4tnhj0A2F4eQwG5GiZ9f3zNDJGQlnr3bwQ5hC0vcbznCClH0jFHi
        15l5LCAJNgF9iZcd21hBbBEBVYmmWQ9YQIqYBeaxSuw+u44RouM1o8SH02fBqjgFjCQW7pgL
        tI+DQ1ggXKJhIdggFqDmGQebGUFsXgFLiZUT3rFB2IISJ2c+YQEpZxbQk2jbCFbCLCAvsf3t
        HKhDFSR+Pl3GChEXkZjd2cYMcY+bxIOlG9kmMArPQjJpFsKkWUgmzULSvYCRZRWjZGpBcW56
        brFhgWFearlecWJucWleul5yfu4mRnCca2nuYNy+6oPeIUYmDsZDjBIczEoivJ9veCUK8aYk
        VlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwLTNli1ni6PwtA/z
        e6cqTLmXIHP+SJtY1JnCLPEb7u5Kikx2d7sWnF1Uee7asshTs/o6461KOn75Rqp/WJPJNeXz
        7zVrzdeyR3BtWj9Fa4mFR8LRqN4So6rdpvkBzZEND8+0VZoX/j+yP9Odw+LKi5fLnde4cii8
        5Vjf/T5n575Ff9sLDaKVPvdfsTQN2bk49V74i0esVesVXXhmmSU9S/rQ5N4zO9mmbuq/mtLS
        8CtB4m2vy9c9Wv7kvUdvZID0k8idonuCH1kxSJyNmNF9tibVMmpF4tNj+kXffs6f+tXn82mu
        VrUbXVqTWWcvcb1ZunLPa1HZmxkZr4Nsz3yX6OZQS76ecPsiv4FGBnd/qRJLcUaioRZzUXEi
        AMjUmIdiAwAA
X-CMS-MailID: 20210923003947epcas2p34cb7861f13845a4d2534bed6b548c3b9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10@epcas2p4.samsung.com>
        <20210917065436.145629-7-chanho61.park@samsung.com>
        <YUuKJj7+wmJd7DSe@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >  drivers/scsi/ufs/ufs-exynos.c | 5 +++++
> > drivers/scsi/ufs/ufs-exynos.h | 1 +
> >  2 files changed, 6 insertions(+)
> 
> This patch is a nop... Fold it into the patch using sysreg.

I separated them to be reviewed easily by different maintainers. I'll squash
them on next patchset.

Best Regards,
Chanho Park

