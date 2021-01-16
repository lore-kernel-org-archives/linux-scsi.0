Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08902C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 03:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74CE238E7
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 03:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbhAPDLk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 22:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbhAPDLj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 22:11:39 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B77CC061757;
        Fri, 15 Jan 2021 19:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=f3VFn3XLoSqxEhcxeei5wuxLk3zPSGgAfwM3CAh7KLE=; b=1ED2wGU3guJDV2XQSCGH3TbjTl
        J0ot6CcGcDZefW3iUPcnvztgWZYyFKyC4S1OSfQCTlG2xm++eXOZOQagUKnLJelvuulWv6iSnri/8
        YnD2xVfi5dRcF0ih+BC8EoBCrsI+0yyVNz1Fg/Rj/HIdN3nfmL8nmrxdxXkLSNgAHNnmw6n5R7Ja1
        1dEW3/YWta4hDQaGBDWZUt8MvpZ49rblqxyq5LoMAko8rfSLdBrQf7i6qMBnS2HPUA77B875yK+xS
        8URiiMV5zcugT+aS6MM7EocST7oyHFnU9Qm7Oe8gdcGLHnyac2rHjCSvYF53Vx3tsdKw4Snd9vVha
        X+y42xYQ==;
Received: from [2601:1c0:6280:3f0::9abc]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l0bzM-00070p-Js; Sat, 16 Jan 2021 03:10:57 +0000
Subject: Re: Changing sd device from read only to read/write fails in 5.10
 (BLKROSET)
To:     Michael Katzmann <vk2bea@gmail.com>, linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <CAMyt5OTrOuqoiEsWn2c7pMquZayVExgNKqzDt_XrqK6pLQ=32Q@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <661c31aa-2648-d189-d92b-84fc342b25dd@infradead.org>
Date:   Fri, 15 Jan 2021 19:10:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAMyt5OTrOuqoiEsWn2c7pMquZayVExgNKqzDt_XrqK6pLQ=32Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[adding linux-scsi mailing list:
Does linux-usb need to added also?]

On 1/15/21 7:03 PM, Michael Katzmann wrote:
> I have USB devices that have a write enable/write protect feature.
> A vendor specific SCSI command write enables a write protected drive.
> In kernels prior to 5.10 I have been able to write-enable the drive
> (by sending the vendor specific command to the SCSI generic device)
> and then change the read only state of the sd block device by clearing
> the read only state with BLKROSET.
> 
> This code used to work to tell the kernel that the device is
> read/write (once enabled at the SCSI level). As of kernel 5.10 it does
> not.
> 
> --------------------------
> 
> // other routine opens SCSI generic device
> // like /dev/sg1 and sends vendor specific commands to change
> // device from read only to read/write.
> // The bit in the SCSI Mode Sense is read to confirm device is R/W
> 
> int readOnly = 0;
> DeviceFD = open( /dev/sdb, O_RDONLY );
> // Clear the RO flag in the block device
> rtn0 = ioctl( DeviceFD, BLKROSET, &readOnly );
> // This re-reads the device so the OS knows that it is now write-enabled
> rtn1 = ioctl( DeviceFD, BLKRRPART, 0 );
> close( DeviceFD );
> // not sure this is necessary
> chmod( /dev/sdb, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH);
> 
> if( (DeviceFD = open( /dev/sdb, O_RDWR )) == ERROR ) {
>    printf("success\n"); // <== use to work (open R/W)
> } else {
>    printf("failure");   // <== now fails under kernel 5.10
> }
> close( DeviceFD );
> 
> --------------------------
> 
> Can anyone tell me if the setting of the R/W state of the block device
> has changed or if the method of signaling to the system that the write
> state has changed is different in 5.10?
> 


-- 
~Randy
You can't do anything without having to do something else first.
-- Belefant's Law
