Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415F1C3524D
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 07:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1658020702
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 07:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ksLV6O8l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgBEHiQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 02:38:16 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:61322 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgBEHiQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 02:38:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580888295; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Xj0iTt8/DaPDdtkod2jYgapACAYlKveoYf6/iq9s5GM=;
 b=ksLV6O8lGcmwjo44vZxHMuvriBdqBeOS089RCBkDtoEDU5GYYmVJqjD7/3dN2Exm0TQV/FCO
 zhxxVytGfSXjbhkbRcSjaXaxjm+g8Uh4lU/6WyNrksOKpSCbk2Y2xC2lWsJDdm4qXjJVKKXi
 /JnYNsS/J3SkUuZbr+9J1LczwGI=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3a70e2.7f6a043aec00-smtp-out-n03;
 Wed, 05 Feb 2020 07:38:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1E478C433A2; Wed,  5 Feb 2020 07:38:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C4FDC433CB;
        Wed,  5 Feb 2020 07:38:07 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 05 Feb 2020 15:38:07 +0800
From:   hongwus@codeaurora.org
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pedro Sousa <sousa@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v5 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
In-Reply-To: <BN7PR08MB5684198FAD001E147CEFA904DB030@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-9-git-send-email-cang@codeaurora.org>
 <BN7PR08MB5684198FAD001E147CEFA904DB030@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <f1a77a5e5af9f1d284dd194836dbe9cc@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-04 23:26, Bean Huo (beanhuo) wrote:
> Hi, Can
> 
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> 
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> 
> Thanks,
> 
> //Bean

Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
