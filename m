Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE16C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 01:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D82B20768
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 01:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bKo57I6F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgFWBv5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 21:51:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28024 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgFWBv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 21:51:57 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200623015154epoutp02304f159788decca86e98d31bc7d20775~bCUu377IK2796527965epoutp02Z
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 01:51:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200623015154epoutp02304f159788decca86e98d31bc7d20775~bCUu377IK2796527965epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592877114;
        bh=CwNvjv0sJGvrkIiumrLM2QgQkCLxAG1/Z+cYoktqcVc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=bKo57I6FhHgblQXAA2TsE4V1FxTeacoBYd4n74OsyDzrdpOyTHAqBzNweUIv3cZrT
         OSk5XBluUb/xofgl1wxEZrUowY592go5N5Z08ILV3DZY+c7rIl/Dx8tKl0kpMUg4H/
         c28+oFFbnL86bTs27x2TKamNQAXE4XlkKlqK/GFM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200623015153epcas2p173e6b846a7ba2eb334627492c2c241ef~bCUuac_x50088100881epcas2p1O;
        Tue, 23 Jun 2020 01:51:53 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49rTm74p3BzMqYkb; Tue, 23 Jun
        2020 01:51:51 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.24.27441.73061FE5; Tue, 23 Jun 2020 10:51:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200623015151epcas2p34e70239054f389d918f1e80f31014dd6~bCUsT4HRi0439804398epcas2p3o;
        Tue, 23 Jun 2020 01:51:51 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200623015151epsmtrp2204a7c3ec231fb7ca6085c803a090888~bCUsTKszy3251332513epsmtrp2J;
        Tue, 23 Jun 2020 01:51:51 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-23-5ef16037d001
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.DB.08382.73061FE5; Tue, 23 Jun 2020 10:51:51 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200623015151epsmtip18d4173aaa0bd7bd7d4d149d1f673f8b2~bCUsHW-X02895528955epsmtip1j;
        Tue, 23 Jun 2020 01:51:51 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>
In-Reply-To: <eaaeecfd-832f-a08f-12c0-679c360ce973@acm.org>
Subject: RE: [RFC PATCH v1 2/2] ufs: change the way to complete fDeviceInit
Date:   Tue, 23 Jun 2020 10:51:50 +0900
Message-ID: <001a01d64900$dd07ec80$9717c580$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJXX9isUct+sMsc2iUIclPJ2BwbYgFLA/eJAvlDYNcC2tTqdKeqSROg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmma55wsc4g8/fFSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZk0X19B5vF8uP/mBw4PS5f8fa43NfL5DFh0QFG
        j+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQI4onJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403N
        DAx1DS0tzJUU8hJzU22VXHwCdN0yc4DOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUW
        pOQUGBoW6BUn5haX5qXrJefnWhkaGBiZAlUm5GRsm+NWsIGpYuLejYwNjM8Yuxg5OSQETCQe
        zt0NZHNxCAnsYJRY39rGDuF8YpSYsvoUE4TzjVGis2ExC0zL5Jk9zCC2kMBeRokrd6wgil4w
        Sizuv8cKkmAT0JaY9nA3K0hCROAfo8TDY3/YQBKcAtYS8+d8AFsuLOAt8evrQ7BJLAKqEj3P
        N4Jt4BWwlLg8aTIrhC0ocXLmE7A4s4C8xPa3c5ghrlCQ+Pl0GViNiICbxOyVv6BqRCRmd7Yx
        gyyWEFjKIXF+0S6gBAeQ4yLR/iARoldY4tXxLewQtpTE53d72SDseol9UxtYIXp7GCWe7vsH
        DSVjiVnP2hlB5jALaEqs36UPMVJZ4sgtqLV8Eh2H/7JDhHklOtqEIBqVJX5Nmgw1RFJi5s07
        UFs9JLY1bmGewKg4C8mTs5A8OQvJM7MQ9i5gZFnFKJZaUJybnlpsVGCMHNebGMEpV8t9B+OM
        tx/0DjEycTAeYpTgYFYS4X0d8C5OiDclsbIqtSg/vqg0J7X4EKMpMNgnMkuJJucDk35eSbyh
        qZGZmYGlqYWpmZGFkjhvsdWFOCGB9MSS1OzU1ILUIpg+Jg5OqQYm89dhNfVJrAc1QwIXZQpz
        /knasvqDXx63xeETP87pcO1Uf7brzv/aVsm3lwKZglpvbt6txHMnzjf+0TVrhsUJsxJzX9w3
        sY2fldYW4Sz90vtE6Izop5Jp0UcvrZU87MtlNO/He9dd4ZdC3s9Ie+ASNWeWwTSOVGOj3VZt
        d0zfnOTnP7N3+5tnHyrcdG7H/rz6YOH/gu8Mjx+qKVgE5tZz+J/2DjXqON2698IJy813UyeI
        aZwoNWu5wf1tRpyvuNPqOv2lCx/u5X5lvPffDMFL0jeLZtvwms+1PbiY5clkrYzoyui7Tddr
        t658upJx0n+PC47LQkV37lfafTAhacrLTdrMaleWar5as1D8RHjmESWW4oxEQy3mouJEALew
        5AlCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnK55wsc4gx8fuC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLRbd2MZk0X19B5vF8uP/mBw4PS5f8fa43NfL5DFh0QFG
        j+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQI4orhsUlJzMstSi/TtErgyts1xK9jAVDFx70bG
        BsZnjF2MnBwSAiYSk2f2MHcxcnEICexmlGja95kdIiEpcWLnc6giYYn7LUdYIYqeMUrM+PqD
        GSTBJqAtMe3hbrCEiEAHk8Srjo1sEFUNTBJLbnaCjeIUsJaYP+cD2ChhAW+JX18fgnWzCKhK
        9DzfyAJi8wpYSlyeNJkVwhaUODnzCVicGWhD78NWRghbXmL72znMECcpSPx8ugysXkTATWL2
        yl9Q9SISszvbmCcwCs1CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0
        veT83E2M4EjT0tzBuH3VB71DjEwcjIcYJTiYlUR4Xwe8ixPiTUmsrEotyo8vKs1JLT7EKM3B
        oiTOe6NwYZyQQHpiSWp2ampBahFMlomDU6qBKV7cfSVL4qH6IzrFHz9+Fi48NcN/ydUzOtd2
        ev36fuX0Mh9NrbLX0x9ZKLrLpya9WLpcP40nKOyLh17ihtaP6QzmqWuaLrPsaNhiq/TmZ+ld
        rxneddyLD3ft2WrWzp/Y9GtlYEHOicy80kUb/0eLFqyynrIm7a2xWdim7P/P0kp+lfE56c1r
        1X9iyHTk89+EM5krlDoUwjhkppXFa4g/5zYO2ztz+foA46anqxIFQqO3fz94Z55nFGNJjlq3
        3AItg0nhf1x5JKYFzC1tlQn2fMIi1JPz3PisYkq1ofrETxqtH4KXrdJz38FQo1BpFfrW+5k8
        454zEXZPT9ayRbR/uNTzZn9I83nZS/LHRDqVWIozEg21mIuKEwEecwgTIwMAAA==
X-CMS-MailID: 20200623015151epcas2p34e70239054f389d918f1e80f31014dd6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620073916epcas2p4cb1a2d9e70d3b06adc539ba15db8ef60
References: <1592638297-36155-1-git-send-email-kwmad.kim@samsung.com>
        <CGME20200620073916epcas2p4cb1a2d9e70d3b06adc539ba15db8ef60@epcas2p4.samsung.com>
        <1592638297-36155-3-git-send-email-kwmad.kim@samsung.com>
        <eaaeecfd-832f-a08f-12c0-679c360ce973@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-06-20 00:31, Kiwoong Kim wrote:
> >  static struct ufs_dev_value ufs_dev_values[] = {
> > +	UFS_DEV_VAL(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
> > +			DEV_VAL_FDEVICEINIT, 2000),
> >  	END_FIX
> >  };
> 
> Can this array be declared 'const'?
> 
> Thanks,
> 
> Bart.

Sure. Thanks !

