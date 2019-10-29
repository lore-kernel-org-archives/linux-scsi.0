Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9761CA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C5B20862
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 02:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ie1MOmbg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZFqIiXjP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfJ2Chs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 22:37:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbfJ2Chr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 22:37:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 00DC360D90; Tue, 29 Oct 2019 02:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572316667;
        bh=SpU3CouSAnfBg2a8tqmWgQF4wwGKcI6vsq0WXo5HUl4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ie1MOmbgTAeYF+m8vDl1wmUKSVVpG9QzjFDquymWY+eL+3yB+55bJxNXC64SNRl2B
         lk1/4a7CPWoQGLPKucl7QYyKQ69X2p+tihcN/DrwjpT008rwhxkvviKF7lQCv3LYiF
         oMYb5FB8Dft367WR6p9pt0mQsclaEedxzsEFq1zQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 86D5A6092D;
        Tue, 29 Oct 2019 02:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572316665;
        bh=SpU3CouSAnfBg2a8tqmWgQF4wwGKcI6vsq0WXo5HUl4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZFqIiXjPMPXRBiaOU6BWJKwUP6zRSxUi3It+FSBQIJGrQczlInzJ2e41kUonmyE3+
         HwK1ckJNXOtI7CSwQ0FVxzn3X3FRC3ZbWlkZdIKgV9Ep/QZCsDXjB/nnkmIRfXJqIp
         jLQE5fDcNDmdqT5N8i0qL9i4fJt03/bV2lpmKHuE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Oct 2019 10:37:45 +0800
From:   cang@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "Winkler, Tomas" <tomas.winkler@intel.com>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
In-Reply-To: <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
 <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
 <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <01eb3c55e35738f2853fbc7175a12eaa@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-23 18:33, Avri Altman wrote:
>> 
>> > Add the necessary infrastructure to keep timestamp history of
>> > commands, events and other useful info for debugging complex issues.
>> > This helps in diagnosing events leading upto failure.
>> 
>> Why not use tracepoints, for that?
> Ack on Tomas's comment.
> Are there any pieces of information that you need not provided by the
> upiu tracer?
> 
> Thanks,
> Avri

In extreme cases, when the UFS runs into bad state, system may crash. 
There may not be a chance to collect trace. If trace is not collected 
and failure is hard to be reproduced, some command logs prints would be 
very helpful to help understand what was going on before we run into 
failure.

Thanks,
Can Guo

