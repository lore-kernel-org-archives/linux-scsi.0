Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30385C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 03:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E135820897
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 03:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="LoVXD1cn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgIODOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 23:14:23 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:45314 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726093AbgIODOU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Sep 2020 23:14:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600139660; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QxjINoDGZVmrQAg4UwCNgFbElvBYGScfRzCvwRPrrLA=;
 b=LoVXD1cnRsc9xy3DuVUlkXnoHQpjBdz09QV6Es4btGnwHmIl5SiJJJMWLdX5rtRaV/G9QYGI
 s7z3uQFcVLtQVxW4BCCFBSmS10M15I4CI0DLO3aOwGT62oIVVX2TQ5P65f/AaNMjUxqX1Ci3
 UmrLvlL6cmbMWyvSiRlwDM3KkX0=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f60318a4ba82a82fddfdb25 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Sep 2020 03:14:18
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3CFE1C433F1; Tue, 15 Sep 2020 03:14:18 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E316C433C8;
        Tue, 15 Sep 2020 03:14:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Sep 2020 11:14:17 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
In-Reply-To: <d151d6a2b53cfbd7bf3f9c9313b49c4c404c4c5a.camel@gmail.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
 <1599099873-32579-2-git-send-email-cang@codeaurora.org>
 <1599627906.10803.65.camel@linux.ibm.com>
 <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
 <1599706080.10649.30.camel@mtkswgap22>
 <1599718697.3851.3.camel@HansenPartnership.com>
 <1599725880.10649.35.camel@mtkswgap22>
 <1599754148.3575.4.camel@HansenPartnership.com>
 <010101747af387e9-f68ac6fa-1bc6-461d-92ec-dc0ee4486728-000000@us-west-2.amazonses.com>
 <d151d6a2b53cfbd7bf3f9c9313b49c4c404c4c5a.camel@gmail.com>
Message-ID: <4017d039fa323a63f89f01b5bf4cf714@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean,

On 2020-09-11 17:09, Bean Huo wrote:
> On Fri, 2020-09-11 at 02:16 +0000, Can Guo wrote:
>> > >
>> > > So your resolution looks good to me.
>> > >
>> > > Thanks so much : )
>> >
>> > You're welcome ... but just remember I have to explain this to
>> > Linus
>> > when the merge window opens.  It would be a lot easier if this
>> > hadn't
>> > happened so please don't make it any worse ...
>> >
>> > James
>> 
>> Sorry that my changes got you confused and thank you for help
>> resolve
>> the
>> conflicts. My change ("scsi: ufs: Abort tasks before clearing them
>> from
>> doorbell") is to serve my fixes to ufs error recovery which only got
>> picked
>> up on scsi-queue-5.10. So I checked out to scsi-queue-5.10 and made
>> my
>> changes on the tip of scsi-queue-5.10, below 2 changes were not even
>> present in scsi-queue-5.10 back that time.
> 
> I mentioned here https://patchwork.kernel.org/patch/11734713/

Do you know when can this change be picked up in scsi-queue-5.10?
If I push my fixes to ufshcd_abort() on scsi-queue-5.10, they will
run into conflicts with this one again, right? How should I move
forward now? Thanks.

Regards,

Can Guo.

> 
> this change (scsi: ufs: Abort tasks before clearing them from doorbell)
> has conflicts with the scsi-fixes branch. I don't know which branch is
> the main branch we should focus on.
> 
> 
> Bean
