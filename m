Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F4AC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AE8E2068E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MpkEXJFb";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="MwUgfEob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfKZGPI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 01:15:08 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:47944
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfKZGPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 01:15:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574748907;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=UGG0wLdU/KaEOFxGZcQLdMNAIrj7+qikMCcJHRJUVtQ=;
        b=MpkEXJFb+PDdgpUGuJDLa1cWDm9UUJTHCjmqXwOIa69AoXr99b7l23oRdc96eJHc
        c83E6pc96s0at+zXQopBuHzoc0njCye/kqWwecOvu+3ZyiViDz7IzkHvqbXHJqbQ8Xx
        t3C6iXVZ8MszzJ//jm0LzarxiHI5VCgscC4aAm50=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574748907;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=UGG0wLdU/KaEOFxGZcQLdMNAIrj7+qikMCcJHRJUVtQ=;
        b=MwUgfEobsb66wlp5raQ9FbYqBb61nepGDJD2ebc88pGaWPg+AJNbvXpUzYyhsk4L
        HV32mQJhMjOnBoad4A3DpjKrSBznJw9j5XDE3RXi2kJaCtzuU3080oqv3UBc8qJHchT
        man9jSYo5FMnYgxLs3OFnQ7PD2MszK+LDynekNV0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 26 Nov 2019 06:15:07 +0000
From:   cang@codeaurora.org
To:     Alim Akhtar <alim.akhtar@gmail.com>
Cc:     Can Guo <cang@qti.qualcomm.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, Mark Salyzyn <salyzyn@google.com>
Subject: Re: [PATCH v2 0/4] UFS driver general fixes bundle 5
In-Reply-To: <CAGOxZ50cmTgcCXfzykQtJpO8ahXjhrXioq22s2DK_-W9KMGD0Q@mail.gmail.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <CAGOxZ50cmTgcCXfzykQtJpO8ahXjhrXioq22s2DK_-W9KMGD0Q@mail.gmail.com>
Message-ID: <0101016ea6596593-5660849a-9787-469d-b92b-6544c4dde9c6-000000@us-west-2.amazonses.com>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.11.26-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-18 21:26, Alim Akhtar wrote:
> Hi Can
> 
> On Mon, Nov 18, 2019 at 9:21 AM Can Guo <cang@qti.qualcomm.com> wrote:
>> 
>> This bundle includes 4 general fixes for UFS driver.
>> 
>> Changes since v1:
>> - Incorporated review comments from Avri Altman.
>> - Removed change "scsi: ufs: Add new bit field PA_INIT to UECDL 
>> register".
>> - Updated change "scsi: ufs: Complete pending requests in host reset 
>> and restore path".
>> 
>> Asutosh Das (1):
>>   scsi: ufs: Recheck bkops level if bkops is disabled
>> 
>> Can Guo (3):
>>   scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes
>>   scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
>>   scsi: ufs: Complete pending requests in host reset and restore path
>> 
>>  drivers/scsi/ufs/ufs.h    |  4 ++--
>>  drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++----------------
>>  drivers/scsi/ufs/ufshcd.h |  2 ++
>>  3 files changed, 19 insertions(+), 18 deletions(-)
>> 
>> --
> 
> For this bundle, most of the review is done, so if you can send V3 of
> these with the addressed 2/4 patch, this can merged.
> Thanks
> 

Thank you Alim. I will do it soon.

Regards,
Can Guo.

>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
>> 
