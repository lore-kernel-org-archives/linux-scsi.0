Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD24C34021
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0BB0207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ksiFiqHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgBQNmw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:42:52 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:39340 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727270AbgBQNmw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Feb 2020 08:42:52 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581946971; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=SEXnp9cA3paejZ0P2RnhQ/ZYaeBEJbJoIBgTZMX7VMg=;
 b=ksiFiqHs+w7E3dWzXMfZRTlC2UTPfhxhZbVe2LdJrfuwlxnaV/6wblGzcFOSUVDhmt32zh8M
 NoDEnkPPgZPoz0rytJ4u1I3yKn90pZicPSvohtNEyit9+qUtk3QaKs29wYDQ+vt1Twxsd9+Z
 qacgWRRv3HNOrofjccV7yc/uNLQ=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4a984e.7f6e5de44180-smtp-out-n03;
 Mon, 17 Feb 2020 13:42:38 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B4B2AC447A4; Mon, 17 Feb 2020 13:42:36 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E4707C43383;
        Mon, 17 Feb 2020 13:42:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Feb 2020 21:42:35 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 1/2] scsi: ufs: add required delay after gating
 reference clock
In-Reply-To: <1581946449.26304.15.camel@mtksdccf07>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
 <20200217093559.16830-2-stanley.chu@mediatek.com>
 <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
 <1581945168.26304.4.camel@mtksdccf07>
 <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
 <1581946449.26304.15.camel@mtksdccf07>
Message-ID: <56c1fc80919491d058d904fcc7301835@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-17 21:34, Stanley Chu wrote:
> Hi Can,
> 
> On Mon, 2020-02-17 at 21:22 +0800, Can Guo wrote:
>> On 2020-02-17 21:12, Stanley Chu wrote:
>> > Hi Can,
>> >
>> >
>> >> >  			} else if (!on && clki->enabled) {
>> >> >  				clk_disable_unprepare(clki->clk);
>> >> > +				wait_us = hba->dev_info.clk_gating_wait_us;
>> >> > +				if (ref_clk && wait_us)
>> >> > +					usleep_range(wait_us, wait_us + 10);
>> >>
>> >> Hi St,anley,
>> >>
>> >> If wait_us is 1us, it would be inappropriate to use usleep_range()
>> >> here.
>> >> You have checks of the delay in patch #2, but why it is not needed
>> >> here?
>> >>
>> >> Thanks,
>> >> Can Guo.
>> >
>> > You are right. I could make that delay checking as common function so
>> > it
>> > can be used here as well to cover all possible values.
>> >
>> > Thanks for suggestion.
>> > Stanley
>> 
>> Hi Stanley,
>> 
>> One more thing, as in patch #2, you have already added delays in your
>> ufshcd_vops_setup_clocks(OFF, PRE_CHANGE) path, plus this delay here,
>> don't you delay for 2*bRefClkGatingWaitTime in ufshcd_setup_clocks()?
>> As the delay added in your vops also delays the actions of turning
>> off all the other clocks in ufshcd_setup_clocks(), you don't need the
>> delay here again, do you agree?
> 
> MediaTek driver is not using reference clocks named as "ref_clk" 
> defined
> in device tree, thus the delay specific for "ref_clk" in
> ufshcd_setup_clocks() will not be applied in MediaTek platform.
> 
> This patch is aimed to add delay for this kind of "ref_clk" used by any
> future vendors.
> 
> Anyway thanks for the reminding : )
> 
>> 
>> Thanks,
>> Can Guo.
> 
> 
> Thanks,
> Stanley

Hi Stanley,

Then we are unluckily hit by this change. We have ref_clk in DT, thus
this change would add unwanted delays to our platforms. but still we
disable device's ref_clk in vops. :)

Could you please hold on patch #1 first? I need sometime to have a
dicussion with my colleagues on this.

Thanks.
Can Guo.
