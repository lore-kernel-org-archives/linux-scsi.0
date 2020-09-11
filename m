Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EEAC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 02:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0731421582
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 02:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lq0ZvNev";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="cRdlaA9O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIKCQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:16:56 -0400
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:43534
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgIKCQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Sep 2020 22:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599790614;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=YMEAwuxsKMbLrfJEl/H5qAgOFNr352yvsM3+o99v2c4=;
        b=Lq0ZvNevaASbSNlxPbbQ2YDYBxoXEGDUtM5KeMakFxHGoEce8ISXze2cwYxLsYg2
        0coRbDapO8Upnzaqy913m5Sc26a2PG6W4IN3SszLztdkC7O/TlMj1XPHZLQJ0f4TKH5
        zQ+BN5X3FNI3s+a5/wPn+tayHa7pPAW0tobUFyKU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599790614;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=YMEAwuxsKMbLrfJEl/H5qAgOFNr352yvsM3+o99v2c4=;
        b=cRdlaA9OjSRxXEiZGQoMDiLVs98De3ztYAAt+YtVo1hYYyskea96NB8ZF4FJDLpP
        teQgg732HFTnD+33Xkr0aRKplzm9k5iMCo7T9Zsk5ps9oHrUizZGQorl5M3BdinbvSY
        zddWzQlD9MIGFRyYbbT7ffShsfBlewUjRFFaCR6Y=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Sep 2020 02:16:54 +0000
From:   Can Guo <cang@codeaurora.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
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
In-Reply-To: <1599754148.3575.4.camel@HansenPartnership.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
 <1599099873-32579-2-git-send-email-cang@codeaurora.org>
 <1599627906.10803.65.camel@linux.ibm.com>
 <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
 <1599706080.10649.30.camel@mtkswgap22>
 <1599718697.3851.3.camel@HansenPartnership.com>
 <1599725880.10649.35.camel@mtkswgap22>
 <1599754148.3575.4.camel@HansenPartnership.com>
Message-ID: <010101747af387e9-f68ac6fa-1bc6-461d-92ec-dc0ee4486728-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2020.09.11-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James and Stanley,

On 2020-09-11 00:09, James Bottomley wrote:
> On Thu, 2020-09-10 at 16:18 +0800, Stanley Chu wrote:
> [...]
>> > + 	if (!err) {
>> >  +cleanup:
>> 
>> Yeah, considering Bean Huo's patch "scsi: ufs: No need to send Abort
>> Task if the task in DB was cleared", "cleanup" label shall be added
>> back here.
>> 
>> So your resolution looks good to me.
>> 
>> Thanks so much : )
> 
> You're welcome ... but just remember I have to explain this to Linus
> when the merge window opens.  It would be a lot easier if this hadn't
> happened so please don't make it any worse ...
> 
> James

Sorry that my changes got you confused and thank you for help resolve 
the
conflicts. My change ("scsi: ufs: Abort tasks before clearing them from
doorbell") is to serve my fixes to ufs error recovery which only got 
picked
up on scsi-queue-5.10. So I checked out to scsi-queue-5.10 and made my
changes on the tip of scsi-queue-5.10, below 2 changes were not even
present in scsi-queue-5.10 back that time.

scsi: ufs: Clean up completed request without interrupt notification
scsi: ufs: No need to send Abort Task if the task in DB was cleared

Is there anything wrong with my work flow above? Please let me know the
right process so that I can avoid such conflicts in my next changes, 
which
also touch the func ufshcd_abort(). Thanks!

Regards,

Can Guo.
