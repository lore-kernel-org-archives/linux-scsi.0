Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32283C4741F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 17:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD30D214D8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 17:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y6SArI91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgI1Rct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 13:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1Rcs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 13:32:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0C8C061755;
        Mon, 28 Sep 2020 10:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=iUaPMsxKFJbBK6PNihcbdt4xuWt8lQ7QQ63bF1TVpO8=; b=Y6SArI91fVZTs8vTp80WZZUBdL
        ZzAqTOyuF16BcgpyE6KTxcA5DdQ48QwnRrY0M/PJyNfeuYIzIR9ijI+drslyHwhuhQLPIAZKb83zJ
        /CZgiBzK6Sr2Liq5zeZIOupPvY5HWMOv4AZP1yoJ2V++Ev2pT+DfWlvVGjhyT3qNi91+XSFWs8co9
        jSvlafo4X4nJRwCqICL9k6oSfoM0qQgmxidbfY9o3PV0juuJUwfy8H+qfjGY4UdYdrZG0ciFtXMeA
        DfPT20ZEmhQ1uS29NtvA5rCjlRDJ/HNo+/vRZN3ASFyf2Mr8RQoDMXKPcFc4oiDUG21xH1Fa+/YBw
        QPzb+hiA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kMx14-0008Nt-GX; Mon, 28 Sep 2020 17:32:46 +0000
Subject: Re: [v5 08/12] Add durable_name_printk
To:     tasleson@redhat.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org
References: <20200925161929.1136806-1-tasleson@redhat.com>
 <20200925161929.1136806-9-tasleson@redhat.com>
 <fbd1b019-04ee-5fda-11c8-95fecf031113@infradead.org>
 <0e091001-a260-856c-1e6c-9b6fb7350d26@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4349d3b5-1ae7-cc11-4fde-33aa27039a88@infradead.org>
Date:   Mon, 28 Sep 2020 10:32:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0e091001-a260-856c-1e6c-9b6fb7350d26@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/20 8:52 AM, Tony Asleson wrote:
> On 9/26/20 6:53 PM, Randy Dunlap wrote:
>> I suggest that these 2 new function names should be
>> 	printk_durable_name()
>> and
>> 	printk_durable_name_ratelimited()
>>
>> Those names would be closer to the printk* family of
>> function names.  Of course, you can find exceptions to this,
>> like dev_printk(), but that is in the dev_*() family of
>> function names.
> 
> durable_name_printk has the same argument signature as dev_printk with
> it's intention that in the future it might be a candidate to get changed
> to dev_printk.  The reason I'm not using dev_printk is to avoid changing
> the content of the message users see.
> 
> With this clarification, do you still suggest the rename or maybe
> suggest something different?

Since you seem to bring it up, "durable_name" is a bit long IMO.

But yes, I still prefer printk_durable_name() etc. The other order seems
backwards to me. But that's still just an opinion.


> dev_id_printk
> id_printk
> ...
> 
> I'm also thinking that maybe we should add a new function do everything
> dev_printk does, but without prepending the device driver name and
> device name to the message.  So we can get the metadata adds without
> having the content of the message change.

thanks.
-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
