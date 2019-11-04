Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A5DCA9EBB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 00:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69533222D0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 00:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aC5BlMVT";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DK0BjRtq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfKDA7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 19:59:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfKDA7N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Nov 2019 19:59:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8B13A60DA5; Mon,  4 Nov 2019 00:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572829152;
        bh=3OZKugvU5r90IVw10fKacd+KlmfjYAe93AmL/gppu84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aC5BlMVTLRtQNv4OM+sWSF+w1oYc7TNHtKU7LhR2Bum8Osm+7Hd0yynRyqEDR2Mrx
         gbLqmfXPlq3nxL9Mmy5tlymPD+Tp5usnrEuxashkql0b2WtLqTwvWvPn/ozw09zwXc
         FVsnnpqqLb/8SICk6UoOTlefY8nRpGVOHb7xJuWc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 7671560DA5;
        Mon,  4 Nov 2019 00:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572829151;
        bh=3OZKugvU5r90IVw10fKacd+KlmfjYAe93AmL/gppu84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DK0BjRtqjPexLP0drlJkQb0K9BEt2CQll6sS5Nva6u/FSXCUG1MeORtEQHX1tXtbS
         De724GQOgf/zEhj40OzfgwQ082wr3BWkBu90sWd7WQz8fEh99qck5rFzrrRZ8ScyYL
         Nk99h5f7W73ese4G8wVr8yAmFlIPFxluWJmgzGZw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 04 Nov 2019 08:59:11 +0800
From:   cang@codeaurora.org
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v1 1/6] scsi: ufs: Add device reset in link recovery
 path
In-Reply-To: <BN7PR08MB56845B4A5F206A319CAFD3B1DB7C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
 <1572671016-883-2-git-send-email-cang@codeaurora.org>
 <BN7PR08MB56845B4A5F206A319CAFD3B1DB7C0@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <d46aa74f8623cc0b61b94bd4fcc25ce4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-04 05:48, Bean Huo (beanhuo) wrote:
> Hi, Can Guo
> 
>> In order to recover from hibern8 exit failure, perform a reset in link 
>> recovery
>> path before issuing link start-up.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c 
>> index
>> c28c144..525f8e6 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -3859,6 +3859,9 @@ static int ufshcd_link_recovery(struct ufs_hba 
>> *hba)
>>  	ufshcd_set_eh_in_progress(hba);
>>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>> +	/* Reset the attached device */
>> +	ufshcd_vops_device_reset(hba);
>> +
>>  	ret = ufshcd_host_reset_and_restore(hba);
>> 
> There is time consumption in reset,  It is true that reset can
> hide/solve some issues.
> I don't know if you experienced issue resulting from an absent reset
> in this case mentioned in
> Patch commit comment.
> 

Hi Bean,

Yes, we did see some issues without this device reset here. For example,
link start-up failure and/or NOP-IN timeout during probe stage.

Best regards,
Can Guo.

>>  	spin_lock_irqsave(hba->host->host_lock, flags);
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>> Forum,
>> a Linux Foundation Collaborative Project
