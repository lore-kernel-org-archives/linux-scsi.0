Return-Path: <SRS0=UMfj=7Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B3AC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 16:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE74207ED
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Jun 2020 16:22:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GtDn19y6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgFLQW4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 12:22:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10390 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgFLQWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 12:22:55 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200612162253epoutp03d879e34f4ae4174595c4bdcae28aee7a~X2HEHo0Qw2102521025epoutp031
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2020 16:22:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200612162253epoutp03d879e34f4ae4174595c4bdcae28aee7a~X2HEHo0Qw2102521025epoutp031
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591978973;
        bh=odVw2pPAyWLK5Z88W0uV7CR8eVQ6niomkBGBqsSTZqA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=GtDn19y6HmsaNaNrT/PC+2WFlvr6GtJ5LdncDqtRLqicTWEZVBPLFFCtdPAmzId9D
         +LpUTBjz9qukVI+USpEvBsGnglzVlYPmLyax066zqC+8MpNjyw3T4xFGTqg+EbqNAO
         4DNILR68AQgBWguFGMmP8ZqhqOQRiq3h2dUTZz7s=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200612162252epcas5p4a0b01a59989e95ff9002b927bdbecb7e~X2HDOVABo3159931599epcas5p4q;
        Fri, 12 Jun 2020 16:22:52 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.93.09475.CDBA3EE5; Sat, 13 Jun 2020 01:22:52 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200612162251epcas5p17799db495a306a323dc0e1740c8397d0~X2HCYsCZi1956119561epcas5p17;
        Fri, 12 Jun 2020 16:22:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200612162251epsmtrp1c4f39db4ff9e0fc924aa272f813a0dac~X2HCXzRRN1965319653epsmtrp1g;
        Fri, 12 Jun 2020 16:22:51 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-84-5ee3abdc2a6a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.E4.08382.BDBA3EE5; Sat, 13 Jun 2020 01:22:51 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200612162246epsmtip1cef97bb576d7a094db111ff37787dfcb~X2G_Pyzcr3056430564epsmtip1G;
        Fri, 12 Jun 2020 16:22:46 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Stanley Chu'" <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <asutoshd@codeaurora.org>
Cc:     <beanhuo@micron.com>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>
In-Reply-To: <20200612151000.27639-2-stanley.chu@mediatek.com>
Subject: RE: [PATCH v1 1/2] scsi: ufs: Remove unused field in struct
 uic_command
Date:   Fri, 12 Jun 2020 21:52:45 +0530
Message-ID: <002801d640d5$b7ba7430$272f5c90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDXcguafoUh6qhsLNKe8uQEpk41JwIvpsOBAO+mpQSqucyfkA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmhu6d1Y/jDHr281icnneV2WJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvw//5vd4tqt+WwWq97sYLNYdGMbk0Xr/1fMFpseX2O1
        uLxrDpvF5eaLjBbd14Gyy4//Y7JoajG22PrpN6vF0q03GR2EPS5f8fa43NfL5LFz1l12jwmL
        DjB6bF5S79Fycj+Lx/f1HWweH5/eYvH4vEnOo/1AN1MAVxSXTUpqTmZZapG+XQJXxvF30QUb
        eCsWt29ga2Cczt3FyMkhIWAi8frCb8YuRi4OIYHdjBIrv/WwQDifGCU2bN4D5XxjlHj3+TU7
        TMuT5ROgWvYySvz9cRHKecMoMXnPRjaQKjYBXYkdi9vAbBGBbYwSR975ghQxC/xhktjRPAFo
        LgcHp4CdxOeHSSA1wgJBEm9Pf2IFsVkEVCX6Z7SA9fIKWEpM/nGHCcIWlDg58wkLiM0sIC+x
        /e0cZoiLFCR+Pl3GCjJSRMBJYlGnCESJuMTRnz3MIGslBKZzSsxpPcICUe8iseTvFlYIW1ji
        1fEtUJ9JSbzsb2MHmSMhkC3Rs8sYIlwjsXTeMahWe4kDV+aAXc8soCmxfpc+xCo+id7fT5gg
        OnklOtqEIKpVJZrfXYXqlJaY2N0NtdRDov/ZOrYJjIqzkPw1C8lfs5A8MAth2QJGllWMkqkF
        xbnpqcWmBcZ5qeV6xYm5xaV56XrJ+bmbGMFpUst7B+OjBx/0DjEycTAeYpTgYFYS4RUUfxgn
        xJuSWFmVWpQfX1Sak1p8iFGag0VJnFfpx5k4IYH0xJLU7NTUgtQimCwTB6dUA1Ni4M4W3hfL
        JwjHyj+4tu4E99QZN66veePXVRdrLMXyVGexRq9m9/Q9925PuHemQil3tvnWs5fW7z+jqF+z
        tyfdeFPklEfS5Y/e337sllZnP7Xu/0aTNmH+o44ntWTipbee9LDabzW1RXzD0Tohxk6Dsx4e
        jldF7/X6rNpbspprgRgHX9Xkyr6rYQ8MO3o2zpC96nrsI/eeYsat+/e0b+ednX3nypX3jVbu
        XaG3r8T2umXpF+pPbDFl/mMYvfDKHs5TawuDv3Uc5ew2sJwsethL1k287+h06U3uNz0utvEZ
        bT+QuF1mWdL+T8s+7eo0DH9ilLNt6czpmntsThj2VWkbX5TKkTjiLmk9a12j0RUlluKMREMt
        5qLiRAAM0mXoAgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWy7bCSnO7t1Y/jDD5s5bM4Pe8qs8XethPs
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtfh//je7xbVb89ksVr3ZwWax6MY2JovW/6+YLTY9vsZq
        cXnXHDaLy80XGS26rwNllx//x2TR1GJssfXTb1aLpVtvMjoIe1y+4u1xua+XyWPnrLvsHhMW
        HWD02Lyk3qPl5H4Wj+/rO9g8Pj69xeLxeZOcR/uBbqYArigum5TUnMyy1CJ9uwSujOPvogs2
        8FYsbt/A1sA4nbuLkZNDQsBE4snyCYxdjFwcQgK7GSWOnl7FCJGQlri+cQI7hC0ssfLfc3aI
        oleMEisebWIGSbAJ6ErsWNzGBpIQEdjDKPF92X2wKmaBLmaJrwf/sEG0HGSUmNB9F2guBwen
        gJ3E54dJIN3CAgES83bOAVvHIqAq0T+jhQ3E5hWwlJj84w4ThC0ocXLmExaQVmYBPYm2jWDl
        zALyEtvfzmGGuE5B4ufTZawgJSICThKLOkUgSsQljv7sYZ7AKDwLyaBZCINmIRk0C0nHAkaW
        VYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwfGupbmDcfuqD3qHGJk4GA8xSnAwK4nw
        Coo/jBPiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6NwYZyQQHpiSWp2ampBahFMlomDU6qB6drM
        MKXSj0euuiocrhfYNlH1Q/2amTPcjZ3T/af0ri1XXOMSOetNUeY0kWWFvh9SWAq8Zj8UNlra
        NtPWqCNq2bQWG/aJtw77H2w3e+iknXn5cnlt+cMjq3eknHXW1z+mHxTfu3G3DMO6+IlbfxlU
        3G09oHj2604/rSD3Wn/u20cYTkUV9LBEXdsnf9VVT+ol8/nZx+XtFA5sv7XBO+z5nZXLN7Q2
        3rx5r8s7hutmYri1+j//k7t/26zTWNrpXnxF/SPTh7yerRvu9//dNP9dzpW1UbO3rbryRC0o
        uCBjVtSkM2+WJ+959iuQ91LeiQ2Sj/KaRG6fORLgvk/yxd69T+60HZglvWzT6eNRMapBYRxK
        LMUZiYZazEXFiQDOPU4uZgMAAA==
X-CMS-MailID: 20200612162251epcas5p17799db495a306a323dc0e1740c8397d0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200612151010epcas5p3f667305eeef2d3ce5c05e0e87482ae7c
References: <20200612151000.27639-1-stanley.chu@mediatek.com>
        <CGME20200612151010epcas5p3f667305eeef2d3ce5c05e0e87482ae7c@epcas5p3.samsung.com>
        <20200612151000.27639-2-stanley.chu@mediatek.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley

> -----Original Message-----
> From: Stanley Chu <stanley.chu@mediatek.com>
> Sent: 12 June 2020 20:40
> To: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> avri.altman@wdc.com; alim.akhtar@samsung.com; jejb@linux.ibm.com;
> asutoshd@codeaurora.org
> Cc: beanhuo@micron.com; cang@codeaurora.org; matthias.bgg@gmail.com;
> bvanassche@acm.org; linux-mediatek@lists.infradead.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> kuohong.wang@mediatek.com; peter.wang@mediatek.com; chun-
> hung.wu@mediatek.com; andy.teng@mediatek.com;
> chaotian.jing@mediatek.com; cc.chou@mediatek.com; Stanley Chu
> <stanley.chu@mediatek.com>
> Subject: [PATCH v1 1/2] scsi: ufs: Remove unused field in struct
uic_command
> 
> Remove unused field "cmd_active" in struct ufs_command.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> bf97d616e597..814e44871ff0 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -88,7 +88,6 @@ enum dev_cmd_type {
>   * @argument1: UIC command argument 1
>   * @argument2: UIC command argument 2
>   * @argument3: UIC command argument 3
> - * @cmd_active: Indicate if UIC command is outstanding
>   * @result: UIC command result
>   * @done: UIC command completion
>   */
> @@ -97,7 +96,6 @@ struct uic_command {
>  	u32 argument1;
>  	u32 argument2;
>  	u32 argument3;
> -	int cmd_active;
>  	int result;
>  	struct completion done;
>  };
> --
> 2.18.0

