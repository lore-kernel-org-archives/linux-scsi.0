Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799C7C352A3
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 05:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5074022522
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 05:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="a8V5yyND"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgBGFKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 00:10:40 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:27822 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgBGFKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 00:10:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581052239; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=p+IeH4SGi1r0YN2Gbqakkkdvr0f2lVt6cKftto4BSS0=;
 b=a8V5yyNDG924DsMGM8MLlsE8J+pBLKVsseLp98fSCdlzvy26K9N+01Uv47C0IU67Llp1EACq
 KwaNS2RkpzwwtPzn4lzXhXUlpGCoWhrsgtob5NCpoCj0X+nv37PjlE7O2m/pjrngzed/2sLl
 7SYaBTQpbpnTuCDoh4mn7eNFBcE=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3cf14e.7fa315918c38-smtp-out-n03;
 Fri, 07 Feb 2020 05:10:38 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 994F3C447A3; Fri,  7 Feb 2020 05:10:36 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF1EDC433CB;
        Fri,  7 Feb 2020 05:10:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 Feb 2020 13:10:35 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pedro Sousa <sousa@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
In-Reply-To: <08101e2924d6262579beec488fcbd93f@codeaurora.org>
References: <1580978008-9327-1-git-send-email-cang@codeaurora.org>
 <1580978008-9327-9-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991EA027BB31FA58EEBDA81FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <08101e2924d6262579beec488fcbd93f@codeaurora.org>
Message-ID: <ebbaf825f4a78b1a21da347e8c6d5531@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-07 10:56, Can Guo wrote:
> On 2020-02-06 21:20, Avri Altman wrote:
>> Hi Can,
>> 
>> 
>>> ADAPT is added specifically for HS Gear4 mode only, select INITIAL 
>>> adapt
>>> before do power mode change to G4 and select no adapt before switch 
>>> to
>>> non-G4 modes.
>> 
>> UFSHCI 3.0 says:
>> 7.4.1 Adapt
>> The use of Adapt isn't mandatory but the specification provides some
>> guidelines on its use.
>> The HCI should perform an Initial Adapt in the following cases if the
>> link is running at HS-G4
>> speed:
>>  - If DME_RESET is initiated.
>>  - If an unused line is activated for HS-G4.
>>  - If UECDME.EC is triggered with bit 3 set to '1'.
>>  - If a change between Rate A and Rate B in HS-G4 is performed.
>> 
>> If it's not mandatory - why are we setting this for all vendors on all
>> platforms?
>> Or am I miss-reading the spec?
>> 
>> Thanks,
>> Avri
> 
> Hi Avri,
> 
> Yes, it is not mandatory, but I don't know a flash vendor that
> refuses to use ADAPT so far, it is even recommended by flash vendors.
> So there is no meaning of adding a specific quirk for it, as all flash
> vendors need this quirk. Otherwise, we would need to add another vops
> to allow platform vendors to control it before send PMC.
> 
> Any other suggestions?
> 
> FYI, ADAPT sequence is used to train an M-RX equalizer. It gives both
> sides better signal integrity against the influence caused by
> temperature and voltage variations. ADAPT is also used by Quality of
> Service Monitoring for HS-G4.
> 
> As for the usage of it, here is just setting the type of it before
> PMC to HS-G4, HW will use ADAPT, only if both sides support ADAPT,
> when it is required as what the spec is saying.
> 
> Thanks,
> 
> Can Guo.

Hi Avri,

I will drop this one for now as it may take some time to nail down it.
I will come back with a separate patch series for it later.

Thanks for the review.

Can Guo.
