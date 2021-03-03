Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30100C43333
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E75D64EDB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446804AbhCCMrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22445 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCCFAr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 00:00:47 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210303045948epoutp04a5b05bab0d7819c1827ee5c1b718e2ba~ovGBc72mW2821128211epoutp04W
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 04:59:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210303045948epoutp04a5b05bab0d7819c1827ee5c1b718e2ba~ovGBc72mW2821128211epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614747588;
        bh=LFpu4niTELPpIgwV+ShrXIOoHRX8q8Iwx3jpmBGZCFs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=iXx+hXce0Jcqm12VS/RzkS9d6c3oQctpidmYdort+p2yhOw8ivaNN6RwDTQuMhqX7
         asF8dCtMN79430jog0eI2GnmDptzJ0oP4+Yxb73P+aj1Y7mYMsbW6CZ3uGdIiEaPd5
         e3rr+aZcob/t8r5eyc67VsmqHkWLtGGU0isCIErU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210303045943epcas2p293ccc38448e5d85ca9804d86b62858ad~ovF9IzMTP2491124911epcas2p2W;
        Wed,  3 Mar 2021 04:59:43 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Dr1y62fFWz4x9QD; Wed,  3 Mar
        2021 04:59:42 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-be-603f17be3127
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.47.05262.EB71F306; Wed,  3 Mar 2021 13:59:42 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
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
        Javier Gonzalez <javier.gonz@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <c76cfa925ce2b91735577a030564a3c2@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210303045939epcms2p414cacf444a5dd161b441e030d48d6000@epcms2p4>
Date:   Wed, 03 Mar 2021 13:59:39 +0900
X-CMS-MailID: 20210303045939epcms2p414cacf444a5dd161b441e030d48d6000
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52TbUxTVxjHOfeW3oIpu/J6xqKwSyBioJRCy2EDIcy5EmO2sA0nZINruQKx
        lKa3EDAba9RRgWFhRHEdQ2EbZIXAeLVAFATFbpOEBRQpOCCDZcXhcEQmTHClLdPs47798zv/
        5/Xk4eHuVwlfXrZCzagUtJziunK6h4IloVd94tKFhkYSzdZ2c9GVYhOBLGu3uWho6gGBzi+v
        4ejP1gZnZBkMRobZw+jUV61cVDOiwVC5rouLfpleIVD93W4M6Ta1HDTWW8NFZRNGLmq8uYmh
        qU5X9E3XJEAl1c0cVF/Xx4n3ko6NH5SOnS3HpD36e4S0on4ASPu/bCakp7/v50gfLpg50rOd
        BiBdad8t1Q6UYW+5pmhADK2SZWXnM/6MQpabka3IjKXefedAKKL8s3JZdSyVGo5EgvBosSAy
        WiCKev+VcKFQJKb8FXQOE0sVhDqiKX+VTGl1qxlWrWJkjBWp4lk1nckIWDqHzVNkCmS5OZR/
        Pi3Ps8ZRYftishg6g1H5p8+DrPaeOqC85FYwf99AaMB1l1LgwoNkJJy43+JcClx57qQRwPrf
        arBSwOPxyZ1ww+ix5fEg4+DDER3Y0u4kBVt/0hN2LoDmuWYb55IhsNo0Y+OeZCJ8VNVky4mT
        Y1x4ckgD7MX48IJ2gWPXL8HLjV027kLugz+2VOJ2vgc+bih3aC842bREbOs/hi868njCT34e
        cXh2wtm1Pgd/EQ73LWN2/THsml4HW01A8lMAh3rMzvaHMHjnTJutCT55CJoHzto0hwyEptUy
        rt2zH07estiS4qQfvLxUg28tBSeDYWtv2JaEZAC8buZsj6Vp+5v4r8ZJN3hmaONfbqydd7QW
        BFvWWrEKEKB/tmn9c7X0z2pdArgBeDNKNieTYUXKiOc/uh3YbmDvG0ZwYWlZMAgwHhgEkIdT
        nnwfS2y6Oz+DLjzBqHLTVHlyhh0EJ6xTVuK+XrJc6xEp1GnhEqFIIo6IjIgQR4r/NxaLJBJh
        tBiJJSJE+fBZ4WyaO5lJq5njDKNkVNvFMZ6LrwZTVxZaGQj7bLHM7+X3dH1LTlWPy7WFUud+
        UheDGuaOSXoCnxz2mj8aUjB4PNFptX3ko7fLPw/QeSSYTOOlSe0pUdTRA0f4uwp7eyvn97Tt
        Ph+1kvx62vipi4G+v38r9+stfpq9WV0bVpLoXddkXFQuR08qd62vf12UNL3D955pB/3qmOJJ
        8e2i5IGbHXEzDbV3xQTUeR/b0JqPdNyoeBpkIl47GH/jr/21w0GjC2+eXD1HOn2xlvqd3klu
        OD3r6fxg5ty1qoZrMQRZdKjATzuaNEeWLCXP3FpdTJxwyx994de5FnnnnYUO7ApZFGlZEFtC
        HuVPNH0YM/UBL6Xqh4TUBJbisFl0+F5cxdL/AOpxWjDRBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210226073233epcms2p80fca2dffabea03143a9414838f757633
References: <c76cfa925ce2b91735577a030564a3c2@codeaurora.org>
        <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
        <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
        <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > @@ -1812,8 +2307,9 @@ void ufshpb_get_geo_info(struct ufs_hba *hba, u8 
> > *geo_buf)
> >  void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
> >  {
> >          struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
> > -        int version;
> > +        int version, ret;
> >          u8 hpb_mode;
> > +        u32 max_hpb_sigle_cmd = 0;
>  
> Maybe max_hpb_single_cmd?
>  
> > 
> >          hpb_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
> >          if (hpb_mode == HPB_HOST_CONTROL) {
> > @@ -1824,13 +2320,27 @@ void ufshpb_get_dev_info(struct ufs_hba *hba,
> > u8 *desc_buf)
> >          }
> > 
> >          version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
> > -        if (version != HPB_SUPPORT_VERSION) {
> > +        if ((version != HPB_SUPPORT_VERSION) &&
> > +            (version != HPB_SUPPORT_LEGACY_VERSION)) {
> >                  dev_err(hba->dev, "%s: HPB %x version is not supported.\n",
> >                          __func__, version);
> >                  hpb_dev_info->hpb_disabled = true;
> >                  return;
> >          }
> > 
> > +        if (version == HPB_SUPPORT_LEGACY_VERSION)
> > +                hpb_dev_info->is_legacy = true;
> > +
> > +        pm_runtime_get_sync(hba->dev);
> > +        ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> > +                QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_sigle_cmd);
>  
> Same here
>  
> > +        pm_runtime_put_sync(hba->dev);
> > +
> > +        if (ret)
> > +                dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query
> > request failed",
> > +                        __func__);
> > +        hpb_dev_info->max_hpb_single_cmd = max_hpb_sigle_cmd;
>  
> Same here
>  

Done.

Thanks,
Daejun
