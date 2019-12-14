Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA57C43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 12:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB46C20706
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 12:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="AI4YD0ij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfLNMfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 07:35:52 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:30895 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbfLNMfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 07:35:52 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Dec 2019 07:35:50 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576326951; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nEhgWqsCxMZod3X8xArRbg45hp9WJhR8VXPah4HQGdA=;
 b=AI4YD0ijHVwyUmJkiJJixE6XL1hVK175UUXMkH0mWntCpv88ZPh/DZpf8X9jPTornCE8z1fd
 pm/Cywl/22wEwhpSNwXemJWLD7tCkpSqnubBbzNBOlomC9Y1FhAfpVVjfC/s9TdSySY56cIQ
 qChmPitbd1iLdVs5weawHuo0n0c=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5df4d5f5.7f0a44f89a08-smtp-out-n02;
 Sat, 14 Dec 2019 12:30:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A22C1C447A3; Sat, 14 Dec 2019 12:30:45 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9749DC433CB;
        Sat, 14 Dec 2019 12:30:44 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 14 Dec 2019 20:30:44 +0800
From:   cang@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Avri Altman <Avri.Altman@wdc.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
In-Reply-To: <20191212182411.GE415177@yoga>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
 <20191212045357.GA415177@yoga>
 <0101016ef8b2e2f8-72260b08-e6ad-42fc-bd4b-4a0a72c5c9b3-000000@us-west-2.amazonses.com>
 <20191212063703.GC415177@yoga>
 <MN2PR04MB69919AA0C345E7D6620C3ADFFC550@MN2PR04MB6991.namprd04.prod.outlook.com>
 <0101016efb07efac-32cf270a-68dd-455a-b037-9fac2f3834cd-000000@us-west-2.amazonses.com>
 <20191212182411.GE415177@yoga>
Message-ID: <0baa9d993cf9cb3e6c94f4c4440e9f95@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-13 02:24, Bjorn Andersson wrote:
> On Thu 12 Dec 08:53 PST 2019, cang@codeaurora.org wrote:
> 
>> On 2019-12-12 15:00, Avri Altman wrote:
>> > > On Wed 11 Dec 22:01 PST 2019, cang@codeaurora.org wrote:
>> > > > On 2019-12-12 12:53, Bjorn Andersson wrote:
>> > > > > On Wed 11 Dec 00:49 PST 2019, Can Guo wrote:
> [..]
>> > > > And in real cases, as the UFS is the boot device, UFS driver will always
>> > > > be probed during bootup.
>> > > >
>> > >
>> > > The UFS driver will load and probe because it's mentioned in the
>> > > devicetree, but if either the ufs drivers or any of its dependencies
>> > > (phy, resets, clocks, etc) are built as modules it might very well
>> > > finish probing after lateinitcall.
>> > >
>> > > So in the even that the bsg is =y and any of these drivers are =m,
>> > > or if
>> > > you're having bad luck with your timing, the list will be empty.
>> > >
>> > > As described below, if bsg=m, then there's nothing that will load the
>> > > module and the bsg will not probe...
>> > Right.
>> > bsg=y and ufshcd=m is a bad idea, and should be avoided.
>> >
>> 
>> Yeah, I will get it addressed in the next patchset.
>> 
> 
> If you build this around platform_device_register_data() from ufshcd I
> don't see a reason to add additional restrictions on this combination
> (even though it might not make much sense for people to use this
> combination).
> 
> Regards,
> Bjorn

Agree, thanks.

Regards,
Can Guo.
