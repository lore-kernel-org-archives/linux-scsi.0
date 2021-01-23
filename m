Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED76C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 08:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27250207A3
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 08:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbhAWIsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Jan 2021 03:48:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61178 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbhAWIsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jan 2021 03:48:52 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210123084809epoutp01a1f7314af2849756c8c91289def15aaf~c0DRL6Jtf0718607186epoutp01w
        for <linux-scsi@vger.kernel.org>; Sat, 23 Jan 2021 08:48:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210123084809epoutp01a1f7314af2849756c8c91289def15aaf~c0DRL6Jtf0718607186epoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611391689;
        bh=rwHGfPHisMe4uVRM7jQ9k3+JhKc3Y3lcabvW6GPINX8=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=CSqBz0KWIzUTXQx2A3Rwk4c6rn6/u4aYVJC7m7f3kYeMKU0SWJ595182SfhSBaOxF
         NYGZtIoczpMsAgK6fq71olaGhco/h6vykYH63ZiHU/yWVHCwV8bZsQU5h2c/q9YuNR
         XEG6y830eDMVwVnw/LRT32nsvZjAoZzMwisIJkv8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210123084808epcas2p3f161beb3ddf2a29f5ea8054cd9852858~c0DQFlKsG1442614426epcas2p3Q;
        Sat, 23 Jan 2021 08:48:08 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DN8sd6f3Rz4x9Pv; Sat, 23 Jan
        2021 08:48:05 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.84.10621.5C2EB006; Sat, 23 Jan 2021 17:48:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210123084804epcas2p3427c43e9e34f56b789cb320b533d50a2~c0DMibZ1w1442614426epcas2p3P;
        Sat, 23 Jan 2021 08:48:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210123084804epsmtrp24cc9fc3802513d249ac1176fa18fb149~c0DMehV1z0830008300epsmtrp2k;
        Sat, 23 Jan 2021 08:48:04 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-8f-600be2c56f97
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CC.C1.13470.4C2EB006; Sat, 23 Jan 2021 17:48:04 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210123084804epsmtip1cda1698d6aa2cdfed758f297d53db2ca~c0DMPW7Tp2199621996epsmtip1h;
        Sat, 23 Jan 2021 08:48:04 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <BY5PR04MB6705BAC53F69C879EDF695CAFC2A0@BY5PR04MB6705.namprd04.prod.outlook.com>
Subject: RE: [PATCH v7 2/2] ufs: exynos: introduce command history
Date:   Sat, 23 Jan 2021 17:48:04 +0900
Message-ID: <000001d6f164$76c2f480$6448dd80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI9m2pPvBlNyiZ+Yntf8KOEqAVjmgIkRPppAe/Mpe8Bd3AEWqk7NX9A
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmhe7RR9wJBp/OGlo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAIyrHJiM1
        MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoZCWFssScUqBQ
        QGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgaFhgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7G8vX7
        WQo+ilesazzH2sC4SLCLkZNDQsBEon/xA3YQW0hgB6PExJ+sXYxcQPYnRokvFzZAJb4BOYsr
        YRoO7m5lgyjayyjxbvUHKOcFo8SaC+eYQarYBLQlpj3cDTZKROA+k8SRnQ9YQBKcArESU/+e
        YAKxhQWcJHrXrWEDsVkEVCU+3r4IFucVsJTo+rKLGcIWlDg58wlYL7OAvMT2t3OYIc5QkPj5
        dBkriC0i4Cbx+O1RVogaEYnZnW3MIIslBE5wSJz90QPV4CJx8dJ7dghbWOLV8S1QtpTE53d7
        2SDseol9UxtYIZp7GCWe7vvHCJEwlpj1rB3I5gDaoCmxfpc+iCkhoCxx5BbUbXwSHYf/skOE
        eSU62oQgGpUlfk2aDDVEUmLmzTtQWz0kHpyayTaBUXEWki9nIflyFpJvZiHsXcDIsopRLLWg
        ODc9tdiowBA5sjcxgpOzlusOxslvP+gdYmTiYDzEKMHBrCTC+8iSI0GINyWxsiq1KD++qDQn
        tfgQoykw3CcyS4km5wPzQ15JvKGpkZmZgaWphamZkYWSOG+xwYN4IYH0xJLU7NTUgtQimD4m
        Dk6pBiZHzy0vPk+eEbbjj8vT/1unz9ox49lliWNL3y9+9MNDjvnNlMg5uwpEG7qdl5l0Nb/d
        bn5HuuzNctkay9fnUjZ43JoTqXvle1BkerKA7IK9c/Pnxe+o+FDZYPRVyOb36eSKedPj/0Q6
        6y8LXHJqn3rVOSOhJ4fdN/bEillYP3ge4Pjya/acuIWux7JjNqut55Ji/Lcg3GnnvQrNpwvm
        CL+4KKTWfLNHTV36xlIxrlcWLnJRspU28pe+XmJ+sqws/mhV4TTpiOsnDHa4BK3dI3Ms243F
        9W/e/C+LBVxPP8jhmNzysWxi+tWNO97dffXiVE7rq/qgNvu1WVvlLOZvFy9KXXVYpmPVxN5V
        rEs8TIR8lViKMxINtZiLihMBHwaioFcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnO6RR9wJBn8OKlk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MFl13bzBa
        LP33lsWB1+PyFW+Py329TB4TFh1g9Pi+voPN4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoErY/n6/SwFH8Ur1jWeY21gXCTYxcjJISFgInFwdytbFyMXh5DAbkaJvmsPWCAS
        khIndj5nhLCFJe63HGGFKHrGKHFpRRMbSIJNQFti2sPdYAkRgbdMEnduX2aCqFrNJLFq5yqw
        Kk6BWImpf08wgdjCAk4SvevWgMVZBFQlPt6+CBbnFbCU6PqyixnCFpQ4OfMJ2BnMQBue3nwK
        ZctLbH87hxniJAWJn0+XsYLYIgJuEo/fHmWFqBGRmN3ZxjyBUWgWklGzkIyahWTULCQtCxhZ
        VjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMekluYOxu2rPugdYmTiYDzEKMHBrCTC
        +8iSI0GINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGplLv
        PYeq+JiLhWImO5ROXmx172veAznj2vrMllsyNW09AsUmXOL2HfdVbmuer4gQW3mQcXFTX62d
        wwb7gwmWF2KW6FXfzAjv/zZjo2Vf6jFZRr0dsl1d21zNpK/7s1ffaKvwfWc793TrDs8e68L7
        D691Lhe/+k32/8YktYSpocdlNEwCgue+Uz0hfPXuhQKvg/nPuhbVxsueeRgfaL9XTOHC2sJv
        n0uy8/edXf/UlyOnWr0z/lxk8MrZvOsXN+q3NWX8+1Ii3f6WjWVN4tZ5/AKaayf9K32Xf2rK
        Nhb2L33FF9Ytt7qx/mGp+rLPdcdEGjcu716xoP/Gy6A7t39ca+n83pGtG7vynuDRgpNySizF
        GYmGWsxFxYkANb61/TgDAAA=
X-CMS-MailID: 20210123084804epcas2p3427c43e9e34f56b789cb320b533d50a2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200905055618epcas2p3216a11a97948f3605f1f2a0622927850
References: <cover.1599284713.git.kwmad.kim@samsung.com>
        <CGME20200905055618epcas2p3216a11a97948f3605f1f2a0622927850@epcas2p3.samsung.com>
        <369148aae7680f558ab1f603a225e99416340b84.1599284713.git.kwmad.kim@samsung.com>
        <BY5PR04MB6705BAC53F69C879EDF695CAFC2A0@BY5PR04MB6705.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > When you turn on CONFIG_SCSI_UFS_EXYNOS_CMD_LOG,
> I guess you meant CONFIG_ SCSI_UFS_EXYNOS_DBG
Okay 

> 
> 
> > +struct ufs_cmd_info {
> > +       u32 total;
> > +       u32 last;
> > +       struct cmd_data data[MAX_CMD_LOGS];
> > +       struct cmd_data *pdata[MAX_CMD_LOGS];
> What is the use of pdata?
> Looks like it is just a copy of data, is it?
Yes

> 
> > +
> > +#ifdef CONFIG_SCSI_UFS_EXYNOS_DBG
> Not needed inside exynos-dbg
> 
> > +static void ufs_s_print_cmd_log(struct ufs_s_dbg_mgr *mgr, struct
> > +device
> > *dev)
> > +{
> > +       struct ufs_cmd_info *cmd_info = &mgr->cmd_info;
> > +       struct cmd_data *data;
> > +       u32 i, idx;
> > +       u32 last;
> > +       u32 max = MAX_CMD_LOGS;
> > +       unsigned long flags;
> > +       u32 total;
> > +
> > +       spin_lock_irqsave(&mgr->cmd_lock, flags);
> > +       total = cmd_info->total;
> > +       if (cmd_info->total < max)
> > +               max = cmd_info->total;
> > +       last = (cmd_info->last + MAX_CMD_LOGS - 1) % MAX_CMD_LOGS;
> > +       spin_unlock_irqrestore(&mgr->cmd_lock, flags);
> > +
> > +       dev_err(dev, ":--------------------------------------------------
> -\n");
> > +       dev_err(dev, ":\t\tSCSI CMD(%u)\n", total - 1);
> > +       dev_err(dev, ":--------------------------------------------------
> -\n");
> > +       dev_err(dev, ":OP, TAG, LBA, SCT, RETRIES, STIME, ETIME,
> > + REQS\n\n");
> > +
> > +       idx = (last == max - 1) ? 0 : last + 1;
> cmd_info->last points to the current index which is the oldest data in
> your circular buffer.
> Why not just idx = cmd_info->last ?
> And then a better name for cmd_info->last would be cmd_info->pos or
> cmd_info->current, Or did I get it wrong?

The member 'last' means a next available slot.
I agree this name is a little bit confusing and will change it.

> 
> I would also not worried about max and total - so the first round after
> platform boot time it might print zeros.
> Really don't worth the unnecessary compilation.
> 
> > +       data = &cmd_info->data[idx];
> > +       for (i = 0 ; i < max ; i++, data = &cmd_info->data[idx]) {
> > +               dev_err(dev, ": 0x%02x, %02d, 0x%08llx, 0x%04x, %d,
> > + %llu, %llu,
> > 0x%llx",
> > +                       data->op, data->tag, data->lba, data->sct, data-
> >retries,
> > +                       data->start_time, data->end_time, data-
> >outstanding_reqs);
> > +               idx = (idx == max - 1) ? 0 : idx + 1;
> > +       }
> > +}
> 
> 
> > diff --git a/drivers/scsi/ufs/ufs-exynos-if.h
> > b/drivers/scsi/ufs/ufs-exynos-if.h
> > new file mode 100644
> > index 0000000..c746f59
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-exynos-if.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * UFS Exynos debugging functions
> So this header contains a single struct with an opaque pointer.
> If it is just for debugging, why  not ufs-exynos-dbg.h?
Okay. 

> 
> 
> Thanks,
> Avri

