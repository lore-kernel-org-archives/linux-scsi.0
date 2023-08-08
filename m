Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD2AEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 01:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjHHBCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 21:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjHHBCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 21:02:04 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B802171E
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 18:02:01 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230808010159epoutp0353c0b5b65b289fa0329127c9fab3fc43~5Qr4I40Db0616906169epoutp03n
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 01:01:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230808010159epoutp0353c0b5b65b289fa0329127c9fab3fc43~5Qr4I40Db0616906169epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691456519;
        bh=rsgkoe4CDh8nYsFbG21130WO4uC6DFFY39IzKyqVDTw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=A2S2f1Xu3R/gPksW5BYnXvtHczeqhyJ4yfBWZyv0w97ZioEZWl2Hy8w9v3kq84q6d
         11+mY8GogmHv9h0Ufwij98KRY1n6ojsxu4Al/HjDzeczjwaXHreWFkOhTVKLVtcMJb
         wYRch48jvQWdMNSKttxqP68I1XPmCgw7vUIwO3RA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230808010158epcas2p1fd664f9169364a1edeb0d3aa5f1be964~5Qr3xdqzc1897218972epcas2p1S;
        Tue,  8 Aug 2023 01:01:58 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.68]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RKZdx5YKHz4x9Q8; Tue,  8 Aug
        2023 01:01:57 +0000 (GMT)
X-AuditID: b6c32a45-83dfd7000000c2f9-e8-64d19405db0b
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.52.49913.50491D46; Tue,  8 Aug 2023 10:01:57 +0900 (KST)
Mime-Version: 1.0
Subject: Re: [PATCH v2] scsi: ufs: ufs-pci: Add support for QEMU
Reply-To: jeuk20.kim@samsung.com
Sender: Jeuk Kim <jeuk20.kim@samsung.com>
From:   Jeuk Kim <jeuk20.kim@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e37e0d80-9ddc-5a36-44a6-22dd0e36bf8d@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230808010157epcms2p378d787756af41ec0715f056f3bdb6d5d@epcms2p3>
Date:   Tue, 08 Aug 2023 10:01:57 +0900
X-CMS-MailID: 20230808010157epcms2p378d787756af41ec0715f056f3bdb6d5d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmqS7rlIspBhPO6licfLKGzeLlz6ts
        FtM+/GS2eHlI02LRjW1MFpd3zWGz6L6+g81i+fF/TA4cHpeveHss3vOSyWPCogOMHh+f3mLx
        6NuyitHj8yY5j/YD3UwB7FHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
        uam2Si4+AbpumTlANykplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswL9IoTc4tL
        89L18lJLrAwNDIxMgQoTsjO+b2hnLfjKVrH4Vz9TA+N+1i5GTg4JAROJjmOr2boYuTiEBHYw
        SnzatYWxi5GDg1dAUOLvDmGQGmEBB4l50+8ygdhCAgoSc7Z1sEPENSWmr5/IBFLOJqAucXqh
        OcgYEYFvjBJHH7SD1TAL1EnsnvOHDWIXr8SM9qcsELa0xPblWxlBbE4Ba4md3SuZIOIaEj+W
        9TJD2KISN1e/ZYex3x+bzwhhi0i03jsLVSMo8eDnbqi4pMSpb4+h/prOKLHgvynIQRICCxgl
        fjVPh2rQl7jWsRHsCF4BX4n788+DNbMIqErc/7gDqsZF4v/cPkaIB+Qltr+dwwzyJDPQw+t3
        6YOYEgLKEkdusUBU8El0HP7LDvNiw8bfWNk75j2BelFFYnHzYdYJjMqzEAE9C8muWQi7FjAy
        r2IUSy0ozk1PLTYqMITHbXJ+7iZGcOrUct3BOPntB71DjEwcjIcYJTiYlUR45z05nyLEm5JY
        WZValB9fVJqTWnyI0RToy4nMUqLJ+cDknVcSb2hiaWBiZmZobmRqYK4kznuvdW6KkEB6Yklq
        dmpqQWoRTB8TB6dUA1NQcNnCzZZz/nxi/nDimmBFzUmp5nNy/TuUJls+8y7U/sHx4IAv35Hc
        l35Tj+8wWfXmgbVU18yLq1yPd1yecidBsXnO3Oks+w30C30OS2yb/SFyYZnehsT0XPFHWXP9
        lvJqfP4prPzs5BOjX+VSL6y6oksMWvubHGI++yxOrlNYt6+3M9126x3vnd91sotObOoK5d7+
        dDmfiZRghEhsThTTieP+XO96XkydbrS1+2OfPVNt3EMprulZE+MKKvUVvs5987X8XMZZzfuJ
        8rcX97z8mfHHs2XCyzmx7O/9hQ5fC77vFZHv+9Zus9DuSIvaSQk+MiLS1w5wnbp5Njr4pMrn
        1n1u536sl7ObM+/h01glluKMREMt5qLiRABlJCTWJgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230807013726epcms2p1c604cb8e98680aebebb7cc5ab2d580f5
References: <e37e0d80-9ddc-5a36-44a6-22dd0e36bf8d@acm.org>
        <20230807013726epcms2p1c604cb8e98680aebebb7cc5ab2d580f5@epcms2p1>
        <CGME20230807013726epcms2p1c604cb8e98680aebebb7cc5ab2d580f5@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/23, Bart Van Assche wrote:
> On 8/6/23 18:37, Jeuk Kim wrote:
>>   static const struct pci_device_id ufshcd_pci_tbl[] = {
>> +	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
>>   	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> 
> Does Red Hat agree with using device ID 0x0013 for this purpose? Is it 
> guaranteed that this device ID won't be used for any other purpose?
> 
> Thanks,
> 
> Bart.

Yes. 
Red Hat donated part of its device ID range to QEMU, which is 1b36:0001 to 1b36:00ff,
and the QEMU community has accepted UFS to use device ID 1b36:0x0013.

The document can be found at https://www.qemu.org/docs/master/specs/pci-ids.html.
As qemu.git/master is frozen for the next release, you cannot see the QEMU UFS device ID on the page now.
You will be able to see it after about 22 August.

Thanks,
Jeuk
