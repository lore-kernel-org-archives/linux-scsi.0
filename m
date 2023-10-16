Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A0CCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 17:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjJPRsP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 13:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjJPRsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 13:48:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E405D83;
        Mon, 16 Oct 2023 10:48:12 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9bf0ac97fdeso323113066b.2;
        Mon, 16 Oct 2023 10:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697478491; x=1698083291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2u/sE5tw3JkSJIFO6XP0kmxdG/J8eciXhjToE7NHk6E=;
        b=C+Pvi5h8pZt6EXmfnWtxJnN6n7AipTsgMyHt9YBvdczVgXpyKiMyRB3adQnLfxz8Nl
         hb0s0uR20m1DxNU48QTTqudgxNfPZFZzakDir629CV/jRZIfFqfDENGmNMJQH37jkk/e
         eqxipZ2N8a47vZKoPgAZ0IyAiNB3V4peStmnGb3VadkIRHWZOU3JhhygsX/wmcQZNjRS
         S5M/HdjDoipI8lSA1CTRZb3q8fnW/NCm/0WKLLam4nT9sSpEs21D1fFNrsiHANFdOmQu
         OLgSIFeuhGIpFjKpY33DTVscvK/ccS44jcgm6ll5LR78sGOUpxIQOy5Lzk8rxKrILTHm
         UxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697478491; x=1698083291;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2u/sE5tw3JkSJIFO6XP0kmxdG/J8eciXhjToE7NHk6E=;
        b=D9vhB/INqKABLwqcHKKi4FYZzGoxgY0wgwB9nbhoejwdbJEDs23Th6ZE1FM50spWS7
         oA8zgpzwIswxB97fZTFCq3xSIkgisrAKfQmi162sKIQ+04hJ2EF6ejvo6PAbs/Mf64aP
         ng7otwQ4HbAp0lCi+5jWk1I9YOTooWvW2yB64UT21HngMZ7BtX0NdIRqrp60BlnkGBNt
         f4dDsmkT7V1tvLGk2f0CvvPuUA4+qKxP3qbixoNOtAJ4pqXJGzC0n1RjH5KU2Lub/VpO
         MTPgJMxR8oznjp2A9lETRq7+nziftPm33ppxEqOusMLvx+h7boAGEedrfsR28yrkGCos
         tH7A==
X-Gm-Message-State: AOJu0YxU1KBulSIg8JrzUJgKb7ozNmnonhF7LSv9FDDLwflw8SJrLNtG
        YSGAwqRGRZ12gWk+CF9sitA=
X-Google-Smtp-Source: AGHT+IF/j27OOocKm/EUh+Kvnuesvd3gXUzreHaMWD6iLDTAJezkE3jKbCbZchn5wk/ESazEwAccJQ==
X-Received: by 2002:a17:907:3e0b:b0:9c3:730e:6941 with SMTP id hp11-20020a1709073e0b00b009c3730e6941mr4787888ejc.66.1697478490980;
        Mon, 16 Oct 2023 10:48:10 -0700 (PDT)
Received: from [192.168.2.30] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id c22-20020a170906155600b009adc81bb544sm4464023ejd.106.2023.10.16.10.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 10:48:10 -0700 (PDT)
Message-ID: <3a7d0305-5405-438a-9e5c-28ae2da0830b@gmail.com>
Date:   Mon, 16 Oct 2023 19:48:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] usb-storage,uas: Support OPAL commands on USB
 attached devices.
Content-Language: en-US
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        oneukum@suse.com
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
 <76575d36-15d3-491b-944e-71253907cfac@rowland.harvard.edu>
From:   Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <76575d36-15d3-491b-944e-71253907cfac@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 19:33, Alan Stern wrote:
> On Mon, Oct 16, 2023 at 09:25:57AM +0200, Milan Broz wrote:
>> This patchset adds support for OPAL commands (self-encrypted drives)
>> through USB-attached storage (usb-storage and UAS drivers).
> 
> This is version 2 of the proposed patch set, but you didn't include the
> version number in the email Subject: lines and you didn't include the
> summary of differences from v1 below the "---" lines of the various
> patches.

Hi,

well, the first patchset was RFC, so I sent is as "the first real version".
Perhaps not the correct way, sorry for that.

Anyway, if you see the discussion about OPAL change on SCSI list, another
solution (inside USB storage driver) is needed.

So, please ignore patch 6/7, these will be needed, but I have to rewrite
SCSI logic to USB glue/UAS driver.

But for the generic 64-bit flags (patch 1-5), if you see this useful, please review it.

Common requirement is that kernel patch need an user for merge
(and my flag is currently no going to be used without rewrite).

But that time will come one day, and if I can save people time to reinvent
the 64-bit quirks logic, it would be nice to merge it.

Thanks,
Milan



> 
> Patches 5, 6, and 7 look okay.  You can add my Reviewed-by: to each of
> them.
> 
> I've got some additional comments on patch 4 (in a separate email).
> 
> Alan Stern
