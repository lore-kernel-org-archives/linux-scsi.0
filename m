Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CEAC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E30FA22D3E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgLUCfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:35:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16089 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgLUCfx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:35:53 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201221023509epoutp04071e40b890ec18260d16f221a00d5599~SmrLHhvsm0580405804epoutp04L
        for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2020 02:35:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201221023509epoutp04071e40b890ec18260d16f221a00d5599~SmrLHhvsm0580405804epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608518109;
        bh=+hrrCcXeklB4D+Y+GCTWQ60S2HVCtiSEjuw4QOKK0SM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=RqDl351igWDlns5M4rZzfQj9sm5rTwgOgvY86L46YEgjn52uK0mCD9qUqbp5v6BEz
         BGhtyma4CJvb06S5Y+b8gpbG9uXP1uLRrgN++MXsdg72CjP7q2gR1vZcy5gcW2VW3p
         OQEMwDP4/Va12Vbgbqz3NhRBzhxtD7qMBJgIuhnk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201221023508epcas2p4f23eafdc0fe8c216c33c54e44917072a~SmrKIrBV42096020960epcas2p4L;
        Mon, 21 Dec 2020 02:35:08 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Czk8V6SWVz4x9QB; Mon, 21 Dec
        2020 02:35:06 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-31-5fe009da7803
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.A6.52511.AD900EF5; Mon, 21 Dec 2020 11:35:06 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v16 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <X93XuJ4lsQbBgnU+@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201221023506epcms2p68be86df197976d1da2775f93709659c6@epcms2p6>
Date:   Mon, 21 Dec 2020 11:35:06 +0900
X-CMS-MailID: 20201221023506epcms2p68be86df197976d1da2775f93709659c6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmme4tzgfxBuub9S023n3FavFg3jY2
        i71tJ9gtXv68ymZx+PY7dotpH34yW3xav4zV4uUhTYtVD8ItmhevZ7OYc7aByaK3fyubxaIb
        25gsLu+aw2bRfX0Hm8Xy4/+YLG5v4bJYuvUmo0Xn9DUsFosW7mZxEPG4fMXb43JfL5PHzll3
        2T0mLDrA6LF/7hp2j5aT+1k8Pj69xeLRt2UVo8fnTXIe7Qe6mQK4onJsMlITU1KLFFLzkvNT
        MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CeU1IoS8wpBQoFJBYXK+nb2RTl
        l5akKmTkF5fYKqUWpOQUGBoW6BUn5haX5qXrJefnWhkaGBiZAlUm5GTc3nGDpaCdtWJP6yOm
        BsZPzF2MHBwSAiYSJxeZdTFycQgJ7GCUmDVvFjtInFdAUOLvDuEuRk4OYQFHiU1Pv7CD2EIC
        ShLrL85ih4jrSdx6uIYRxGYT0JGYfuI+WKuIQJDE5WkGICOZBVaxSexYuRSsXkKAV2JG+1MW
        CFtaYvvyrWC9nAKaEl+3XmCCiGtI/FjWywxhi0rcXP2WHcZ+f2w+I4QtItF67yxUjaDEg5+7
        oeKSEsd2f4CaUy+x9c4vRpAjJAR6GCUO77zFCpHQl7jWsRHsCF4BX4nuh4/ZQGwWAVWJLXM2
        QC1zkfiw+RtYPbOAvMT2t3PAYcUMdOj6XfqQYFOWOHKLBeatho2/2dHZzAJ8Eh2H/8LFd8x7
        AnWamsS6n+uZJjAqz0IE9Cwku2Yh7FrAyLyKUSy1oDg3PbXYqMAEOWo3MYKTuZbHDsbZbz/o
        HWJk4mA8xCjBwawkwmsmdT9eiDclsbIqtSg/vqg0J7X4EKMp0JcTmaVEk/OB+SSvJN7Q1MjM
        zMDS1MLUzMhCSZw3dGVfvJBAemJJanZqakFqEUwfEwenVAOTv1zUtcwNa9WZp9k2PGzt23rw
        QY5W+7MZh7evrOCZsPAf18Jl/+eE3Eqz03VakPHWUmIG9+zqP3/+zY487sKR5GkVIzbByTai
        wLzF0rL9YYLj//TbgUXK3Wr1R8rvegbmH9jkdWUeI+fGPt5HBsF1C/b6pZ07wXvvULHrOr1p
        m6YVbzFucg29qrN65ek834lFzlFpOxwmx9z9Z7snwedoaejF6F0eockrP079OE3McPX63h/c
        J4vy7SzlKyziyvZGfj8+6dYXrnCB3VlTUyXfPWiSUshUm1/QNvn16hWTbrlKruENZM2v3KEe
        Wa+dUl8UzHA4cm6G3tbDrr+SH5YnaljcOCUaJX+iNcqP/54SS3FGoqEWc1FxIgA+Vsh6bwQA
        AA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae
References: <X93XuJ4lsQbBgnU+@kroah.com>
        <20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
        <20201219091847epcms2p7afeebd03c47eed0b65f89375a881233e@epcms2p7>
        <CGME20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Greg,

> > +static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
> > +{
> > +	struct ufshpb_lu *hpb;
> > +	struct scsi_device *sdev;
> > +	bool init_success;
> > +
> > +	init_success = !ufshpb_check_hpb_reset_query(hba);
> > +
> > +	shost_for_each_device(sdev, hba->host) {
> > +		hpb = sdev->hostdata;
> > +		if (!hpb)
> > +			continue;
> > +
> > +		if (init_success) {
> > +			dev_info(hba->dev, "set state to present\n");
> 
> Why be noisy?  Why does userspace need to see this all the time,
> shouldn't only errors be printing something?

I will remove needless dev_info printings in this patch.

Thanks,
Daejun
