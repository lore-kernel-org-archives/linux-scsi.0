Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF04DCA9EC9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 23:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 831A32089C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 23:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fra9XPM7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mbmm+1/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfKDXq7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 18:46:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60986 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729595AbfKDXq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 18:46:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 680E160DA5; Mon,  4 Nov 2019 23:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572911218;
        bh=hoNtDpdUb63QZe31CDdxv8jGYZ+HzZXfW1E5NKxIcRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fra9XPM7qIIJ1NIxh52toYCiCLS0v+XkMUAJV1gCwbGWOwCnP2BxTOXRkF7CiM45e
         6AeGG4NHE7CDkE1W8MwQOoi5VwMjpYqXpXBoevDAhDKjh4Aq79TsAs1vbKEOL1ZdQD
         igKTalnicTUj+RK5zUvcX0TU2UdzlrRzKdF87hno=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id CF1166090F;
        Mon,  4 Nov 2019 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572911216;
        bh=hoNtDpdUb63QZe31CDdxv8jGYZ+HzZXfW1E5NKxIcRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mbmm+1/9ED6/9uPxCHuA4l21R4/jD/o48i+OKjhmc7+M3inr8tH7vhwWdhdjxMj1N
         eYf3QhB9u8tcDf58OB24yvrtKlrzoWPpU5N20DWRX1SYT5DDr/kqHVnifx4yf/jjjp
         NgC1wKm9DaCo/sTbFYo02NGYMt9CMI/PabEeEwCI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Nov 2019 07:46:56 +0800
From:   cang@codeaurora.org
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] RE: [PATCH v1 1/2] scsi: ufs: Introduce a vops for
 resetting host controller
In-Reply-To: <BN7PR08MB568495A62486DBDFDEDE9F20DB7F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69911784473463D0926AE3B5FC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <BN7PR08MB568495A62486DBDFDEDE9F20DB7F0@BN7PR08MB5684.namprd08.prod.outlook.com>
Message-ID: <66e04095315ec02598ebc12136add80d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-04 22:34, Bean Huo (beanhuo) wrote:
> Hi, Can
> 
> I agree with Avri, you can add this series patches to your bundle, and
> that is also easy to review for us.
> Otherwise, we are confused by somehow crossing different series 
> patches.
> Thanks,
> 
> //Bean

Hi Bean,

I moved the two changes to fix bundle 3. The vops is not needed anymore.
Meanwhile I find it inappropriate to put the host controller reset 
inside
the device reset vops. So you can check the new changes in fix bundle 3.

Regards,
Can Guo.

>> 
>> Hi,
>> >
>> > Some UFS host controllers need their specific implementations of
>> > resetting to get them into a good state. Provide a new vops to allow
>> > the platform driver to implement this own reset operation.
>> >
>> > Signed-off-by: Can Guo <cang@codeaurora.org>
>> Did you withdraw from this patches and insert them to one of your fix 
>> bundle?
>> I couldn't tell.
>> As this is a vop, in what way its functionality can't be included in 
>> the device reset
>> that was recently added?
>> 
>> Thanks,
>> Avri
