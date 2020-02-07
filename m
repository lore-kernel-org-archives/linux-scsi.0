Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E875C35247
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 02:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33FE121927
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 02:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KBa3eIUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGC4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 21:56:45 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:56052 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgBGC4p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 21:56:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581044205; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Z2ngNi5NIR7v5uodoWYsy15J0gqkfXzftyHIU77ZYU8=;
 b=KBa3eIUUvqUS8rV43wU6TLkx8L4Hxu7jmSwx5GJSRO4fUGt4dPmDKcbKk4VvavIuhWk2BjG+
 U628+gT4aHFsUf/6sfbjrrtcB8bB2Kj+GuBiDmkPpU9Yoh+hfZxCJv1E1k6D8XXrLN1jbAws
 yJq7Dc0P/LEduy+kpXML6lJPYbQ=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3cd1e5.7f789ea755a8-smtp-out-n03;
 Fri, 07 Feb 2020 02:56:37 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C3E06C43383; Fri,  7 Feb 2020 02:56:37 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E36AC433CB;
        Fri,  7 Feb 2020 02:56:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 Feb 2020 10:56:36 +0800
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
In-Reply-To: <MN2PR04MB6991EA027BB31FA58EEBDA81FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580978008-9327-1-git-send-email-cang@codeaurora.org>
 <1580978008-9327-9-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991EA027BB31FA58EEBDA81FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <08101e2924d6262579beec488fcbd93f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-06 21:20, Avri Altman wrote:
> Hi Can,
> 
> 
>> ADAPT is added specifically for HS Gear4 mode only, select INITIAL 
>> adapt
>> before do power mode change to G4 and select no adapt before switch to
>> non-G4 modes.
> 
> UFSHCI 3.0 says:
> 7.4.1 Adapt
> The use of Adapt isn't mandatory but the specification provides some
> guidelines on its use.
> The HCI should perform an Initial Adapt in the following cases if the
> link is running at HS-G4
> speed:
>  - If DME_RESET is initiated.
>  - If an unused line is activated for HS-G4.
>  - If UECDME.EC is triggered with bit 3 set to '1'.
>  - If a change between Rate A and Rate B in HS-G4 is performed.
> 
> If it's not mandatory - why are we setting this for all vendors on all
> platforms?
> Or am I miss-reading the spec?
> 
> Thanks,
> Avri

Hi Avri,

Yes, it is not mandatory, but I don't know a flash vendor that
refuses to use ADAPT so far, it is even recommended by flash vendors.
So there is no meaning of adding a specific quirk for it, as all flash
vendors need this quirk. Otherwise, we would need to add another vops
to allow platform vendors to control it before send PMC.

Any other suggestions?

FYI, ADAPT sequence is used to train an M-RX equalizer. It gives both
sides better signal integrity against the influence caused by
temperature and voltage variations. ADAPT is also used by Quality of
Service Monitoring for HS-G4.

As for the usage of it, here is just setting the type of it before
PMC to HS-G4, HW will use ADAPT, only if both sides support ADAPT,
when it is required as what the spec is saying.

Thanks,

Can Guo.
