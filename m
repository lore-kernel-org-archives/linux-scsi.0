Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36518C4363C
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC389206C3
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 17:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ubfEdNNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgJBR1v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 13:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgJBR1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 13:27:51 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502A7C0613D0
        for <linux-scsi@vger.kernel.org>; Fri,  2 Oct 2020 10:27:51 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q123so1752984pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 02 Oct 2020 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i8HFTyo2TQEJLRrJ5eiFtN6xi543EQe3aj7gXYQXDqg=;
        b=ubfEdNNOO74Wt7RPemS6NrW8R+am38zUwJ9ByeSsJPhEpb8NTOo41U7jpsoSozVwoA
         wjYeo4qm2Vi9Z01IYVKWDfD37szEMd73bqu8XJJka0bd/lzwtgy0C1kemM/MTefyuhdr
         I2iaW3FGq0+aXlGjmy0ozO8RRNIDqrKNHDUBC69+yCxfsITELQtnmpwAUE5nCKfML7IT
         VFwUxMGNnWM4ftZ0ii6CGM/J2XjyTCH2Bt3Ova0QvCO2UiC4aTi5NfkYQHcop2a/rWw+
         5HRgDN6fJD7aDYTSPzsF2RE9u0rFQRnAF0lYbvkCj72Me2OTjZ/17D/1Fm+h2XjF5COv
         TIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i8HFTyo2TQEJLRrJ5eiFtN6xi543EQe3aj7gXYQXDqg=;
        b=qy9J61Jww3xR2OYkluabkwhNV+bA6Mi7GSyAE34ZvSHk5fyCjPe7CKe1WiYUBTXCxJ
         BN12ltl6wmyQ1Xiccmc4GNAE+2xEMevq6WofBp348TPfA6O0QVYSNaVV7CytrI2oVxVx
         7kyru1Uya2uhs0no2BwgXuPYBEZifdGKtRfmisxoTFaHeef9D2YVMWol31Zh+Upa6aOL
         FoCmsyHfki0w/Lwv0cIj1yfLobjxLJjn+x+hIyEe3r1BY0bcwzK7xfEXUsztTWUH3VxE
         v8mF61zwSd/Bcg4uDA+Q0GX4XZalXML6TKa8oRPAyKmjKu8WqBDJd8TitDihO7PM6K+1
         leXQ==
X-Gm-Message-State: AOAM5336Wrztzb+vWp7CzcGl1fOl6NKobNJWeLfjzdmNOHO2UVsDGGY7
        yF7A2z1UENzNFCFqqIlB/W4=
X-Google-Smtp-Source: ABdhPJzbHrF6aIREF0iYSJHT+ezlU+/wxBHA2m/iyGgouVekJPqXBNjBUinue1CdRgZFIl0XDKgdxw==
X-Received: by 2002:a63:104d:: with SMTP id 13mr3124842pgq.445.1601659670842;
        Fri, 02 Oct 2020 10:27:50 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gb19sm2117086pjb.38.2020.10.02.10.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 10:27:50 -0700 (PDT)
Subject: Re: [PATCH v2 0/8] scsi: Support to handle Intermittent errors
To:     Mike Christie <michael.christie@oracle.com>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, hare@suse.de
Cc:     emilne@redhat.com, mkumar@redhat.com
References: <1601268657-940-1-git-send-email-muneendra.kumar@broadcom.com>
 <4a2ed7c2-48a9-60d0-d751-d06af7fa6750@oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1ee1eeea-bb55-3630-a3a7-6222b6a20671@gmail.com>
Date:   Fri, 2 Oct 2020 10:27:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <4a2ed7c2-48a9-60d0-d751-d06af7fa6750@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/2020 10:01 AM, Mike Christie wrote:
> On 9/27/20 11:50 PM, Muneendra wrote:
>> This patch adds a support to prevent retries of all the pending/inflight
>> io's after an abort succeeds on a particular device when transport
>> connectivity to the device is encountering intermittent errors.
>>
>> Intermittent connectivity is a condition that can be detected by transport
>> fabric notifications. A service can monitor the ELS notifications and
>> take action on all the outstanding io's of a scsi device at that instant.
>>
> 
> Is the service mentioned above a new daemon or is it integrated into
> something like multipathd?
> 
> What does the part about monitoring ELS notifications mean? Is the
> service just doing something like a ELS ECHO, or is it able to watch
> the IO on the wire/card (like if you did tcpdump and watched iscsi/tcp
> traffic) or is it something completely different?
> 

For the last part.... the FC drivers, when receiving FC FPIN ELS's are 
calling a scsi transport routine with the FPIN payload.  The transport 
is pushing this as an "event" via netlink.  An app bound to the local 
address used by the scsi transport can receive the event and parse it.

This is a new daemon, specific to FC, which monitors for FPIN events, 
parses the related topology devices, then interacts with sysfs and 
possibly multipath based on what it's seeing from the fabric.

-- james

