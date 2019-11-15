Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2217AC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB0052072D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 06:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NXZEDtxA";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UzJJL6r6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfKOGBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 01:01:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfKOGBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 01:01:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E18DF6119A; Fri, 15 Nov 2019 06:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573797684;
        bh=vFqY/oN8QIMlspIG1CEoNcPzEthWXbyMO9RsePuR1Vs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NXZEDtxAdxIrSDBfVsZqb+wrHRVv790+W+JfcTvy6NHyvTERm2sge/0Q+AFoQpDS3
         dJMFms7THRILhfM8O6mpPcNP6D/iC2sHxNX8qhiAfkD3+I/GL9HuDZUxF6G9j/Wndw
         EI5IdeYPXNf0npg4fNXcGDM3t7unOZjONZYlxZzU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 32416610DB;
        Fri, 15 Nov 2019 06:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573797679;
        bh=vFqY/oN8QIMlspIG1CEoNcPzEthWXbyMO9RsePuR1Vs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UzJJL6r654PBc14brdISZ/DMcMmfSnHORMjEjBU28YpXdK+JpY9Yi3s2Q5bHUNakT
         qGlCA8ADeEpVzluPXQA2DlmAjutvfmT+wUmXmjHdAi7G6gW/uW4YBrucjkrWn1WUHf
         kJgIDKUeT5ZsWl6fRwRelMmGV+gTQMz9YsDhl2oo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 15 Nov 2019 14:01:18 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
In-Reply-To: <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
Message-ID: <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-15 00:11, Bart Van Assche wrote:
> On 11/13/19 8:03 AM, Bean Huo (beanhuo) wrote:
>> I think, you are asking for comment from Can.  As for me, attached 
>> patch is better.
>> Removing ufshcd_wait_for_doorbell_clr(), instead of reading doorbell 
>> register, Now
>> using block layer blk_mq_{un,}freeze_queue(), looks good. I tested 
>> your V5 patches,
>> didn't find problem yet.
>> 
>> Since my available platform doesn't support dynamic clk scaling, I 
>> think, now seems only
>> Qcom UFS controllers support this feature. So we need Can Guo to 
>> finally confirm it.
> 
> Hi Can,
> 
> Do you agree with this patch series if patch 4 is replaced by the
> patch attached to my previous e-mail? The entire (revised) series is
> available at https://github.com/bvanassche/linux/tree/ufs-for-next.
> 
> Thanks,
> 
> Bart.

Hi Bart,

After ufshcd_clock_scaling_prepare() returns(no error), all request 
queues are frozen. If failure
happens(say power mode change command fails) after this point and error 
handler kicks off,
we need to send dev commands(in ufshcd_probe_hba()) to bring UFS back to 
functionality.
However, as the hba->cmd_queue is frozen, dev commands cannot be sent, 
the error handler shall fail.

Thanks,

Can Guo.
