Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5FDC48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 07:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FADB613E4
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 07:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhFOH7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 03:59:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31828 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhFOH7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 03:59:09 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210615075702epoutp03b21cdbfa6463ffec7513c04d39db9c6f~IsmdJx4B40202102021epoutp03g
        for <linux-scsi@vger.kernel.org>; Tue, 15 Jun 2021 07:57:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210615075702epoutp03b21cdbfa6463ffec7513c04d39db9c6f~IsmdJx4B40202102021epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623743822;
        bh=dKH11hfK95xnTwGMooBEmQc88rykEhrmZOSyDXNc2LU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=NiEZaZZIlUDigb0pR93NdgA8Se0Sumj6wglNwvazSVSSOGy4akjYlRqODXt3ndBU9
         zqgZMkxZSXSnCb3qpC5KWaCAJk2SJwR4JAJa97ZSet2cvplosxczLhGqFbHa15jWjJ
         ZUxZUb1JPgEnfobGrI2M7AG1iB7Pl1+zDXJ/4vs8=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210615075702epcas2p20fe8f6e6c431ce7c18af52dc6148e945~Ismc310m50866408664epcas2p2a;
        Tue, 15 Jun 2021 07:57:02 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4G40yg0Gghz4x9Q0; Tue, 15 Jun
        2021 07:56:59 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.95.09694.A4D58C06; Tue, 15 Jun 2021 16:56:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210615075657epcas2p3e9b482b9b386899eecd8cc39e646f264~IsmZF1RxK1898318983epcas2p3b;
        Tue, 15 Jun 2021 07:56:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210615075657epsmtrp1e88059bf3fb14f4b6d14fc8e4885aa95~IsmZE6Mse0050300503epsmtrp1i;
        Tue, 15 Jun 2021 07:56:57 +0000 (GMT)
X-AuditID: b6c32a46-e01ff700000025de-f8-60c85d4a2101
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.99.08163.94D58C06; Tue, 15 Jun 2021 16:56:57 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210615075657epsmtip208ef73e4a2f3b2f6517117ccbd8b8424~IsmY3n8301658216582epsmtip2k;
        Tue, 15 Jun 2021 07:56:57 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>
In-Reply-To: <69eaab403c178024dd45ac3c27f2c1bf@codeaurora.org>
Subject: RE: Question about coherency of comand context between ufs and scsi
Date:   Tue, 15 Jun 2021 16:56:57 +0900
Message-ID: <001301d761bc$03eb57e0$0bc207a0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQF6XgAqk3Fx+LaZOAGK4yxrD/S9QwI7RbX6Adb8dOqrrikHoA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmua5X7IkEgycfpSxe/rzKZnHwYSeL
        xbQPP5ktPq1fxmrxZP0sZovu6zvYHNg8Ll/x9rjc18vksWlVJ5vH9/UdbB6fN8l5tB/oZgpg
        i8qxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6Qkmh
        LDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZ
        kJOx/+435oLDrBX/Px1nb2DcwtLFyMkhIWAicejnIfYuRi4OIYEdjBIte3sZIZxPjBLXlj2A
        cj4zSry58JQJpmXWsXNMEIldjBJnvj+E6n/BKHGr+zgzSBWbgLbEtIe7WUFsEQFViXet59lA
        ipgF9jFKnO1rAurg4OAUsJNYdyYHpEZYwEdi9pSJYEexANX/btjGDmLzClhKPD34hBnCFpQ4
        OfMJWA2zgIHE+3PzmSFseYntb+cwQ1ynIPHz6TKovU4SLVd2MkHUiEjM7mxjBrlBQmAih8Sj
        zp+sIDdICLhI/HsqCNErLPHq+BZ2CFtK4mV/G5RdL7FvagMrRG8Po8TTff8YIRLGErOetTNC
        zFGWOHIL6jY+iY7Df9khwrwSHW1CENXKEr8mTYbqlJSYefMO+wRGpVlIPpuF5LNZSD6bheSD
        BYwsqxjFUguKc9NTi40KjJCjexMjOI1que1gnPL2g94hRiYOxkOMEhzMSiK8h+uPJwjxpiRW
        VqUW5ccXleakFh9iNAUG9kRmKdHkfGAizyuJNzQ1MjMzsDS1MDUzslAS5+VgP5QgJJCeWJKa
        nZpakFoE08fEwSnVwMTE6Bz/SO+vxaUPR67o8C8pzv5+4uDPxHMLPJL04+YdvLBIzs+TbVqF
        qGeMZ9ivjfvWt/NUiGXNYtEJ0mm+1PVesMPr29fIuS8uc+5i79Ku7/Xa9EOh69PsWcW7MpT+
        zOiPyLZ901ZQdYB5xf4fWZ7t6sF/Gv/VHjBI5pjx+ELfrZyqHScLJgmZy61Z+4V5o8yVRo56
        gxmJrcEXC5xuOx8TlimQ21qg+H3KZbflvy7vv5LFZFlzp8+x0z/+9lTZ64udZ6f+25RXr3DC
        70F6nmf7hHqFjebCN99dbfB4VT397bMfmSKrwwN8X/2xTWRW+M2xaT1/+o8fTy51uWk51x+7
        oX5k/0aeLcsvXDRI9lJiKc5INNRiLipOBACk4GyMLAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJXtcz9kSCwePlphYvf15lszj4sJPF
        YtqHn8wWn9YvY7V4sn4Ws0X39R1sDmwel694e1zu62Xy2LSqk83j+/oONo/Pm+Q82g90MwWw
        RXHZpKTmZJalFunbJXBl7L/7jbngMGvF/0/H2RsYt7B0MXJySAiYSMw6do6pi5GLQ0hgB6PE
        nZu9TBAJSYkTO58zQtjCEvdbjrBCFD1jlJj8aAYbSIJNQFti2sPdrCC2iICqxLvW82BxZoFD
        QJNuCYPYQgJ7GSXO36jsYuTg4BSwk1h3JgckLCzgIzF7ykSwI1iAWn83bGMHsXkFLCWeHnzC
        DGELSpyc+YQFYqSRxLlD+6HGy0tsfzuHGeI2BYmfT5dBneAk0XJlJxNEjYjE7M425gmMwrOQ
        jJqFZNQsJKNmIWlZwMiyilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJa0tHYw7ln1
        Qe8QIxMHI9C7HMxKIryH648nCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1
        tSC1CCbLxMEp1cDUuUruZ0h185Mnr9qtGTMdOFnaI8+czOg+5mHT86pqiz1bTtplxcub/zZ0
        L7Ld5xEuPzHsoVHbiWCj6jxvv2vOUX/5A/bxrVu579tNuaZ/zRFP1i2dfWvFO/2971JnWgkv
        mHquvXYxl1GT3oQ5JfrCcx4qnXWQ3BjK0+80cetfpbONns96FNR5GpSZrp1XfBV28Ulew6PU
        nWe2/VmbtdhSzi5/qriEj/qxM72LTnpFOV5Y7Wrvo73pcnTQqpN/v1ZtPiqnXRF94+mjeas/
        6DPZ/PuXNUOmZPmeSRHB62f+knX5+f2WrNO7yCOfdnNePSH59uzxnWvOftjypPbZ1as3thj+
        Md7y3t/ay2f6q8hXYUosxRmJhlrMRcWJAOz4HVQUAwAA
X-CMS-MailID: 20210615075657epcas2p3e9b482b9b386899eecd8cc39e646f264
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210614095245epcas2p2e8512382423332786f584d5ef1e225d3
References: <CGME20210614095245epcas2p2e8512382423332786f584d5ef1e225d3@epcas2p2.samsung.com>
        <000001d76103$06c3cb50$144b61f0$@samsung.com>
        <69eaab403c178024dd45ac3c27f2c1bf@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> If scsi added it into its error command list and wakes-up scsi_eh 
> though the command is actually completed, scsi_eh will invoke 
> eh_abort_handler and the symptom will be duplicated, I think
> 
> Otherwise, is there anyone who know how to guarantee the coherency?

> In 5.13 kernel, it is scsi_print_command(cmd) in ufshcd_abort(), while in
> 5.12 and earlier kernel, it is scsi_print_command(hba->lrb[tag].cmd).
> Which kernel are you using here?
> 
> Thanks,
> Can Guo. 

Thank you for your information. I'm seeing 5.4.
Yes, for null pointer, you're right.
Then, what do you think?
In the situation I told, is there still the possibility that I suggested?

Thanks.
Kiwoong Kim

