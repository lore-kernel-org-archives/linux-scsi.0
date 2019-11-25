Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B59C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295EA20815
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 07:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bROoIXHf";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="Ab+qhnDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfKYHjG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:39:06 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:47134
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbfKYHjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Nov 2019 02:39:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574667545;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=uHHZK8fQ8iUvCN9hPKKy5pWhBlk+VmYWskK2YABSTbk=;
        b=bROoIXHfU9TTKdhRArjz8BqDk6VeNPb1bxiQV007IW/9l44d/hDJR0UwjTWrJo+Z
        qT/uk54udm+3Tg9AZZFXWRoBs9seDvzs+fL+B/szhmhzIpW65Vd2lVslbxg1tfrMHhR
        zWC1KXnlbJNGA6QgMfzpRjAAqwbSVTX95jMBTlpY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574667545;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=uHHZK8fQ8iUvCN9hPKKy5pWhBlk+VmYWskK2YABSTbk=;
        b=Ab+qhnDHHqNqnxu/dMIflJZDSQ+Q95fLywRQBmJKiFzez1szGuZmEp3LGf1WlwrZ
        o6/XNO+whJxkx0TK8s/4/IUnoUpZuvM+lkvSG7DKcbbA5Gwl2CNzcxS7C+dzh+jDa/z
        NTgZiF8FMFffuCwzHKa7ghk9AJYW/GBrCaMuhHXg=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 25 Nov 2019 07:39:05 +0000
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
In-Reply-To: <MN2PR04MB6991FAA95F79EFB1EE030D13FC4A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-5-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991C35EC2DBBEA17A611755FC4F0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <MN2PR04MB6991FAA95F79EFB1EE030D13FC4A0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <0101016ea17feb57-32ad658c-6c87-413b-93c4-b4a015a02499-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.25-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-25 15:22, Avri Altman wrote:
>> >
>> > During power mode change, PACP_PWR_Req frame sends
>> PAPowerModeUserData
>> > parameters (and they are considered valid by device if Flags[4] -
>> > UserDataValid bit is set in the same frame).
>> > Currently we don't set these PAPowerModeUserData parameters and
>> > hardware always sets UserDataValid bit which would clear all the DL
>> > layer timeout values of the peer device after the power mode change.
>> >
>> > This change sets the PAPowerModeUserData[0..5] to UniPro specification
>> > recommended default values, in addition we are also setting the
>> > relevant
>> > DME_LOCAL_* timer attributes as required by UFS HCI specification.
>> >
>> > Signed-off-by: Can Guo <cang@codeaurora.org>
>> Reviewed-by Avri Altman <avri.altman@wdc.com>
> BTW, I noticed that you are only updating the TC0 registers.
> Why not setting the TC1 registers as well?
> 
> Thanks,
> Avri

Hi Avri,

In the HCI spec, it goes

Currently, UFS uses TC0 only. Therefore, setting the following values 
are not needed:
 DME_ Local_FC1ProtectionTimeOutVal
 DME_ Local_TC1ReplayTimeOutVal
 DME_ Local_ AFC1ReqTimeOutVal

Best Regards,
Can Guo.
