Return-Path: <SRS0=CaZB=WP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2556CC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 13:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2C0B20644
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 13:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfHSNic (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:38:32 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:60463 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727332AbfHSNic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 09:38:32 -0400
X-UUID: 30897bbcf3934c34b4f9f992b6a4368b-20190819
X-UUID: 30897bbcf3934c34b4f9f992b6a4368b-20190819
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0707 with TLS)
        with ESMTP id 226625839; Mon, 19 Aug 2019 21:38:24 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 19 Aug 2019 21:38:26 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 19 Aug 2019 21:38:25 +0800
Message-ID: <1566221906.15377.3.camel@mtkswgap22>
Subject: RE: [PATCH v2 0/3] scsi: ufs: fix broken hba->outstanding_tasks
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Avri Altman <Avri.Altman@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>
Date:   Mon, 19 Aug 2019 21:38:26 +0800
In-Reply-To: <1564044737.7235.9.camel@mtkswgap22>
References: <1563947418-16394-1-git-send-email-stanley.chu@mediatek.com>
         <MN2PR04MB69914824302B84E144137869FCC10@MN2PR04MB6991.namprd04.prod.outlook.com>
         <1564044737.7235.9.camel@mtkswgap22>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On Thu, 2019-07-25 at 16:52 +0800, Stanley Chu wrote:
> Hi Avri,
> 
> On Thu, 2019-07-25 at 07:54 +0000, Avri Altman wrote:
> > Stanly,
> > 
> > > 
> > > Currently bits in hba->outstanding_tasks are cleared only after their
> > > corresponding task management commands are successfully done by
> > > __ufshcd_issue_tm_cmd().
> > > 
> > > If timeout happens in a task management command, its corresponding
> > > bit in hba->outstanding_tasks will not be cleared until next task
> > > management command with the same tag used successfully finishes.
> > I'm sorry - I still don't understand why you just can't release the tag either way,
> > Just like we do in device management queries tags,
> > Instead of adding all this unnecessary code.
> > 
> > I will not object to your series -
> > just step down and let other people review you patches.

Sorry for late response due to these busy days.

I just got your point and agreed with you: previous proposal may be too
tricky. Simple always wins. So I will provide a short solution in next
version.

Many thanks!
Stanley


