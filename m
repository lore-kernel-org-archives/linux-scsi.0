Return-Path: <SRS0=/4AA=4F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B443BC34021
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CC972070B
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Feb 2020 13:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="iTInWS/E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgBQNWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:22:55 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:55090 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728054AbgBQNWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Feb 2020 08:22:55 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581945774; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=zYaEbtFkXfhmP+oRysQ8QVN5kHY6AaSc1zt8CAGAK7k=;
 b=iTInWS/EmjGYC3QHz06mZl6YiMRgKZlPeC0RkNuFy10qLfpgi7nP7NqImsK+uI833aPppkl5
 geMQVBpS4+lCEDa7TudN/xqQ/yssm/LdLYZy8/lH4SQ/8xGfilARykUfWgnxEu/XyljFA5+s
 HKLBJI3S6KdyDQQhLrlTp8U/jCU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e4a93aa.7fafa2a52dc0-smtp-out-n01;
 Mon, 17 Feb 2020 13:22:50 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 26136C447A3; Mon, 17 Feb 2020 13:22:50 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 512E8C4479D;
        Mon, 17 Feb 2020 13:22:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Feb 2020 21:22:49 +0800
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
In-Reply-To: <1581945168.26304.4.camel@mtksdccf07>
References: <20200217093559.16830-1-stanley.chu@mediatek.com>
 <20200217093559.16830-2-stanley.chu@mediatek.com>
 <c6874825dd60ea04ed401fbd1b5cb568@codeaurora.org>
 <1581945168.26304.4.camel@mtksdccf07>
Message-ID: <e518c4d1d94ec15e9c4c31c34a9e42d1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-17 21:12, Stanley Chu wrote:
> Hi Can,
> 
> 
>> >  			} else if (!on && clki->enabled) {
>> >  				clk_disable_unprepare(clki->clk);
>> > +				wait_us = hba->dev_info.clk_gating_wait_us;
>> > +				if (ref_clk && wait_us)
>> > +					usleep_range(wait_us, wait_us + 10);
>> 
>> Hi St,anley,
>> 
>> If wait_us is 1us, it would be inappropriate to use usleep_range() 
>> here.
>> You have checks of the delay in patch #2, but why it is not needed 
>> here?
>> 
>> Thanks,
>> Can Guo.
> 
> You are right. I could make that delay checking as common function so 
> it
> can be used here as well to cover all possible values.
> 
> Thanks for suggestion.
> Stanley

Hi Stanley,

One more thing, as in patch #2, you have already added delays in your
ufshcd_vops_setup_clocks(OFF, PRE_CHANGE) path, plus this delay here,
don't you delay for 2*bRefClkGatingWaitTime in ufshcd_setup_clocks()?
As the delay added in your vops also delays the actions of turning
off all the other clocks in ufshcd_setup_clocks(), you don't need the
delay here again, do you agree?

Thanks,
Can Guo.
