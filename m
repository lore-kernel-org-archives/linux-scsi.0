Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21F0C3B194
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 02:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966E124650
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 02:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="IO7Hshap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgBNCsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 21:48:39 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:44213 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728305AbgBNCsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 21:48:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581648518; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UWAYJSfeXjul/xRnXFEQLy56THzmnk0AwuyzQ8fL8JE=;
 b=IO7HshapIYd3D5EGKR630Ys4k2Fv0NFMP6jNdTBy9PDatjQ+4fxc9lA2Wm9BmufwP3UjPrOe
 8n/6bHy1IG2aryycxGbpHy2Oa6a2Im5Fum44mEKvFYccRkmduH4KE0tJngTe/EekoVuv+WkE
 ZbmMNXWJ32MiHoV+ZMa1/BCc4yg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e460a85.7fb4881a2a08-smtp-out-n03;
 Fri, 14 Feb 2020 02:48:37 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 82E4FC447A0; Fri, 14 Feb 2020 02:48:36 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B368EC43383;
        Fri, 14 Feb 2020 02:48:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 Feb 2020 10:48:35 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/7] scsi: ufs: Flush exception event before suspend
In-Reply-To: <1581392451-28743-2-git-send-email-cang@codeaurora.org>
References: <1581392451-28743-1-git-send-email-cang@codeaurora.org>
 <1581392451-28743-2-git-send-email-cang@codeaurora.org>
Message-ID: <935eca44a8090631687a2fa298bcd595@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-11 11:40, Can Guo wrote:
> From: Sayali Lokhande <sayalil@codeaurora.org>
> 
> Exception event can be raised by the device when system
> suspend is in progress. This will result in unclocked
> register access in exception event handler as clocks will
> be turned off during suspend. This change makes sure to flush
> exception event handler work in suspend before disabling
> clocks to avoid unclocked register access issue.
> 
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>


Reviewed-by: Hongwu Su <hongwus@micron.com>
