Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B473C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 00:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9106501B
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 00:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhCEAdN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 19:33:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:57531 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhCEAdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 19:33:12 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210305003310epoutp02d47ddf749d83bd88a6b27bedc3b5ee38~pSvyt78T31933819338epoutp02Y
        for <linux-scsi@vger.kernel.org>; Fri,  5 Mar 2021 00:33:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210305003310epoutp02d47ddf749d83bd88a6b27bedc3b5ee38~pSvyt78T31933819338epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614904390;
        bh=W3Yyib3d4Z8bsLk2t+fAqQZUSnNEXUnqT71+4elqVgw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=SO8NHNX90eDO7PzXtXHM70RLJMpBln6BohVqCwPYoj8/2moIo/scGKQX2zWFW6A4Y
         v0CK/KhqQrPDnhAMGWy/T5Jw3JeWhqPSrFHH6S0tYmk0HWjii0W4aQQQO+x12HyHe3
         Clb5n3fQ1A9h/HrwNaEnYnhy39Tl6HD65aihdOsk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210305003307epcas2p27bf2e1a616b1204d847e5c7710a2116e~pSvwGsJP20106701067epcas2p2L;
        Fri,  5 Mar 2021 00:33:07 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Ds7xZ3BQ3z4x9Pt; Fri,  5 Mar
        2021 00:33:06 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-c1-60417c3f0983
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        82.D3.05262.F3C71406; Fri,  5 Mar 2021 09:33:03 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v26 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e7f7d153cfca15ad7705935b30979a26@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210305003302epcms2p2fd0c5ebd9e9f63dde010f2c0a49b9f07@epcms2p2>
Date:   Fri, 05 Mar 2021 09:33:02 +0900
X-CMS-MailID: 20210305003302epcms2p2fd0c5ebd9e9f63dde010f2c0a49b9f07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmua59jWOCwaaJihYP5m1js9jbdoLd
        4uXPq2wWh2+/Y7eY9uEns8Wn9ctYLV4e0rRY9SDconnxejaLOWcbmCx6+7eyWTy+85ndYtGN
        bUwW/f/aWSwu75rDZtF9fQebxfLj/5gsbm/hsli69SajRef0NSwOIh6Xr3h7XO7rZfLYOesu
        u8eERQcYPfbPXcPu0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBXVI5NRmpiSmqRQmpecn5K
        Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBzSgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqEnIxnU44xF1znqZh5oZut
        gXElZxcjJ4eEgInErVcrWLoYuTiEBHYwSkxvWMDaxcjBwSsgKPF3hzBIjbCAvcTL96uYQGwh
        ASWJ9RdnsUPE9SRuPVzDCGKzCehITD9xHywuIuAp8XXyalaQmcwCy9kkGpftZ4VYxisxo/0p
        C4QtLbF9+VawZk4BO4nPy/qgajQkfizrZYawRSVurn7LDmO/PzafEcIWkWi9dxaqRlDiwc/d
        UHFJiWO7PzBB2PUSW+/8YgQ5QkKgh1Hi8M5bUAv0Ja51bAQ7glfAV+LskTawBhYBVYn1H5ZD
        DXKROD5pDxuIzSwgL7H97RxmUKAwC2hKrN+lD2JKCChLHLnFAvNWw8bf7OhsZgE+iY7Df+Hi
        O+Y9gTpNTWLdz/VMExiVZyFCehaSXbMQdi1gZF7FKJZaUJybnlpsVGCMHLmbGMEJXct9B+OM
        tx/0DjEycTAeYpTgYFYS4RV/aZsgxJuSWFmVWpQfX1Sak1p8iNEU6MuJzFKiyfnAnJJXEm9o
        amRmZmBpamFqZmShJM5bbPAgXkggPbEkNTs1tSC1CKaPiYNTqoEp5vvJrK/Wnw7dMTlecPJQ
        /MxHCx/6XPjz78OS/yyO2U9Pbbb+32C82ep84iuFgpqap9c2yKw+evzT/hXyM0Mf3SpauDw9
        wPBCUMVhrc/WO/h93wQGi9xXOGSU5y/0TqtQrfDOgc9vu16o5k6byMo5Y/fMWoct7cYKDO8m
        PJzyueBJ58amRzmnzQr/WWj6y55M3/Wj5f3/G+8zXpy4dL5gwbbKAp2QXyva/avUTh0QWn86
        0Wx6yml/m4p5xhL+ty45J8Z1/nthLXj24ttpX4XWl8pLzNLfXvk2p1nT8qjj3R3h2pVpjPvP
        rspZ97hsnXtBlPHjpLVbj589+KZhp8GGzstb93AflLxyt8M9oGOX9hMlluKMREMt5qLiRAD6
        lZx6cQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e
References: <e7f7d153cfca15ad7705935b30979a26@codeaurora.org>
        <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
        <20210303062926epcms2p6aa6737e5ed3916eed9ab80011aad3d83@epcms2p6>
        <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can Guo

> > diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> > b/drivers/scsi/ufs/ufs-sysfs.c
> > index 2546e7a1ac4f..00fb519406cf 100644
> > --- a/drivers/scsi/ufs/ufs-sysfs.c
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -841,6 +841,7 @@ out:                                                                        \
> >  static DEVICE_ATTR_RO(_name)
> > 
> >  UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
> > +UFS_ATTRIBUTE(max_data_size_hpb_single_cmd, _MAX_HPB_SINGLE_CMD);
> >  UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
> >  UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
> >  UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
> > @@ -864,6 +865,7 @@ UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
> > 
> >  static struct attribute *ufs_sysfs_attributes[] = {
> >          &dev_attr_boot_lun_enabled.attr,
> > +        &dev_attr_max_data_size_hpb_single_cmd.attr,
> >          &dev_attr_current_power_mode.attr,
> >          &dev_attr_active_icc_level.attr,
> >          &dev_attr_ooo_data_enabled.attr,
> > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> > index 957763db1006..e0b748777a1b 100644
> > --- a/drivers/scsi/ufs/ufs.h
> > +++ b/drivers/scsi/ufs/ufs.h
> > @@ -123,12 +123,13 @@ enum flag_idn {
> >          QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN                 = 0x0F,
> >          QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
> >          QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
> > +        QUERY_FLAG_IDN_HPB_EN                                = 0x12,
>  
> Also add this flag to sysfs?

Sure, I will do.

Thanks,
Daejun
