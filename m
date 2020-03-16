Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79523C1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B0E2071C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="exWBVc2r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgCPHKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 03:10:01 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:34278 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729776AbgCPHKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Mar 2020 03:10:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584342600; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=KJZiL0sdohMQeVpJmkN38lZ6qU33N/oMM0pvgkF9gnc=;
 b=exWBVc2rvsptixYx81mXjnzIUSsYxXbOki4OtT8fPNSy22G1YZofY058j73321qWtMNYn02s
 RI1hYFGeUnDkyncpuF01gye5jifXF9LX+/5n3q4vUNSTj4TwgIFkp9Fw+475uRhv0FC1jByR
 SJJv+Hay2uwIM+yvUjxzXXfUEA4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e6f2647.7fec271ead18-smtp-out-n02;
 Mon, 16 Mar 2020 07:09:59 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3E808C44792; Mon, 16 Mar 2020 07:09:57 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5390EC433D2;
        Mon, 16 Mar 2020 07:09:56 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Mar 2020 15:09:56 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     bvanassche@acm.org, linux-scsi@vger.kernel.org,
        andy.teng@mediatek.com, jejb@linux.ibm.com,
        chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com,
        linux-kernel@vger.kernel.org, avri.altman@wdc.com,
        martin.peter~sen@oracle.com, linux-mediatek@lists.infradead.org,
        peter.wang@mediatek.com, alim.akhtar@samsung.com,
        matthias.bgg@gmail.com, asutoshd@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
Subject: Re: [PATCH v5 2/8] scsi: ufs: remove init_prefetch_data in struct
 ufs_hba
In-Reply-To: <1584342487.14250.11.camel@mtksdccf07>
References: <20200316034218.11914-1-stanley.chu@mediatek.com>
 <20200316034218.11914-3-stanley.chu@mediatek.com>
 <51fde835f4f03fcca6e83ba6d3579f2e@codeaurora.org>
 <1584342487.14250.11.camel@mtksdccf07>
Message-ID: <29d75c7ff1a5c7fb54ee145049daa5da@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-03-16 15:08, Stanley Chu wrote:
> Hi Can,
> 
> On Mon, 2020-03-16 at 14:25 +0800, Can Guo wrote:
>> On 2020-03-16 11:42, Stanley Chu wrote:
>> > Struct init_prefetch_data currently is used privately in
>> > ufshcd_init_icc_levels(), thus it can be removed from struct ufs_hba.
>> >
>> > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>> > Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
>> > Reviewed-by: Avri Altman <avri.altman@wdc.com>
>> 
>> Hi Stanley,
>> 
>> Earlier, I have one similar patch for this, but it does more than 
>> this.
>> Please check the mail I just sent.
>> 
>> Thanks,
>> Can Guo.
> 
> OK! Thanks to remind me this. Then I can drop this cleanup patch #2 in
> its series to not conflict with your proposed one.
> 
> Thanks,
> Stanley Chu

Sure, thank you for your quick response.

Best regards,
Can Guo
