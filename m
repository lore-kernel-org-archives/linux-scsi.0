Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5711AC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 03:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3129E207CD
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 03:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="gul/nKyB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG1DQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 23:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbgG1DQt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 23:16:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3453AC0619D2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 20:16:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t15so10690563pjq.5
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2020 20:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tyXSmhsn7QCatX2okhnG1C0YXtOurTJuxXETVAxJmFQ=;
        b=gul/nKyBvS7ujATqra7vJ9my/xCJFo4FTj65YeCeVuw+ODY47SRwHLBLpaiHTf89yw
         ULgxULFpwjei2q5tPqdWBk0BUSjB4StO1FKrOLgzxZ4sCQhvEKhGZWroxi00bNVTqbOK
         /aZ7ZREe7i4dz4WU3GwJMOlPgmRzNvx129Fv90s33gUWyRtRLh8h8pbyZqJH2z3rsuXr
         CnfcapbuLOUYRaX/mMazToRh6duTrpzNHYrOnvM8J4nKkWxg7DSxahzrFPdZre+ATDe6
         PajVgmYkfOyg+HO15lKkob7JdZPZPUMb3V2xvn/aLnMT9exgmnMdsa3AMlMzPkazfhed
         twfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tyXSmhsn7QCatX2okhnG1C0YXtOurTJuxXETVAxJmFQ=;
        b=TXzlOZhvDrB11LhYONyviqhthAY+kk36kmVARBXi3/IFhjxWsKahEp8ApUGmivusFK
         kTSM5O4Bp8Y24Kb3cwpo6WRU2kIQ2l+nEAjxx7MfJSRoNFmtSpohFDchSgghRkrbBsLg
         Y/jwMsZfztc+tzpG8GZXW+OuT0Aomw3BVDeatCbeJUntxQGiSVjp6KvQLzkPbedIaA1u
         qMcJPH9JZCRK8iugaPSqHjXTkRO9tXALS4ASgELaURnAdWLy7roEqCVe5pQQy4tex8u8
         X35WMvYYohN7OhfL+8pI1yspJ0WITdoDt0pDq/z/J9frJttzxG/4+YWadh84A5zKpSR1
         Gs8w==
X-Gm-Message-State: AOAM533XvVs/moxUAfM6rdmRbBJ9v4A3WhHXR0/dCpkmLmIRzmK9g/t6
        Nl5IKEQlvACZ5yZIPxKhrPLbGQ==
X-Google-Smtp-Source: ABdhPJzMVSo6UZFalKB0SOZudI+B+Zyph8W/0YdfDVAFMXLqCL3k7GAEJrwyNptn59ySk/MMeXhDMg==
X-Received: by 2002:a17:90a:f00d:: with SMTP id bt13mr2272863pjb.109.1595906208734;
        Mon, 27 Jul 2020 20:16:48 -0700 (PDT)
Received: from houpudeMacBook-Pro.local ([103.136.220.73])
        by smtp.gmail.com with ESMTPSA id c30sm16415944pfj.213.2020.07.27.20.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 20:16:48 -0700 (PDT)
Subject: Re: [PATCH v4 0/2] iscsi-target: fix login error when receiving is
 too fast
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com
References: <20200716100212.4237-1-houpu@bytedance.com>
 <a78662d5-0bb4-8b27-125e-b4c2176b70c6@oracle.com>
From:   Hou Pu <houpu@bytedance.com>
Message-ID: <8c4539d7-c8e5-2698-6d70-f255122fc596@bytedance.com>
Date:   Tue, 28 Jul 2020 11:16:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a78662d5-0bb4-8b27-125e-b4c2176b70c6@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/7/26 10:58 上午, Mike Christie wrote:
> On 7/16/20 5:02 AM, Hou Pu wrote:
>> Hi,
>> We encountered "iSCSI Login negotiation failed" several times.
>> After enable debug log in iscsi_target_nego.c of iSCSI target.
>> Error shows:
>>    "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"
>>
>> Patch 1 is trying to fix this problem. Please see comment in patch 1
>> for details.
>>
>> Sorry for delay of v4. Version 3 of this patchset could be found here[1].
>>
>> Changes from v4:
>> * In iscsi_target_do_login_rx(), call cancel_delayed_work() if it is final
>>    login pdu. Also call cancel_delayed_work() if current negotiation is failed.
>>    This is advised by Mike Christie. See below[1] for more details.
>>
>> Changes from v3:
>> * Fix style problem found by checkpatch.pl.
>>
> Ah sorry, I thought I replied a little later about my concerns being overly paranoid and your patch being ok. I don't see it on the list so not sure what happened.
> 
> If you are still not liking the cancel call, I'm ok with v3. Add my reviewed by to either version you prefer.
> 
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
> 

It took me some time to understand how workqueue works and make sure
it is safe to cancel it. So it is delayed between v3 and v4. Sorry
for that.

I think it is necessary to cancel delayed work as your suggestion.

Thanks,
Hou
