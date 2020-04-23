Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BCBC5518A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF5E2073A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:17:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsbNwwlX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgDWDRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 23:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgDWDRC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 23:17:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21DFC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:17:00 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n4so3549958ejs.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oy+QfqxOE5/4mrd5AZzX4QBZYQPsvDVLVJismexQIg0=;
        b=FsbNwwlXqnoHwSdwGZ2ppe87KpVyL+1RAl9RRCmcBLGmWsGKU5RQsJyD0b+XJa2GAK
         QsPsMT2kKUMAZBkg41+5nwxM050roInZRYw5e6zsTA5SMv3+VDLTnvaJAUr6e0cTmDiu
         jMM6OV4Ik2lviXCdwITbVOe2cjZt5kh8O1OlG7AwMoM+0MVu/2gQ4wS5jpxUvptXcmX/
         Ln4MxTEyri4NSHlTYDH0Hg1IlC4MipGLiEwyjd0+ZPbrrg6y59l3eqPmLYVy5W57u8ir
         llDQ0P2MTXbOrTCD0suQ9seGC5GRZNkwp677jcvL6srBkIMjo4xGNxLO2Sttp15/coyv
         XZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oy+QfqxOE5/4mrd5AZzX4QBZYQPsvDVLVJismexQIg0=;
        b=Wii3NdE9NimqYvcgj0BuRo6eTKDYY4vh6hR2QTWjaj7GGYz91+ar99o6RVqc1nBdnU
         7q5SGb79z5rQjxnZ/q/q3qDaCQeoOrRZwADkc13ASXIfbE1rb5YBY2jVjygyw04u3ToK
         NJl1QMtljjINX4iMcDtyeYg+eF5X3uh4+EM0N+AbK6/05ijzk6um6sLlye9fJmyhTxfA
         3qFdMPyFEQvWaQ2j1NOCJTSCOOfLittQFzVDgWz334dbL2Z23Z+pYjSfXTO5KH8WLyJB
         HNGoa3rEHKWpCo2pC1s5RqwNfXsxdThzEijA3Oq6VTMBrJojPolOTqTiU6myaYS8HICM
         KLgw==
X-Gm-Message-State: AGi0PuZWxBFwpKi6Ddj+x/pCSXYMxdJ1CHkVtNQRx3HOeI6vwkzmDOvV
        kSQo3hbrzrzsrxfqmtOlFvQ=
X-Google-Smtp-Source: APiQypJqrTM5qmR15S5j+ZgTKyWcSA4lD4zC6dgcnVWz7Fg9X8SKndC5NIm5GDoYUWLSAJTteZLehg==
X-Received: by 2002:a17:907:9484:: with SMTP id dm4mr1086282ejc.240.1587611819767;
        Wed, 22 Apr 2020 20:16:59 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id p22sm259349ejd.24.2020.04.22.20.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:16:59 -0700 (PDT)
Subject: Re: [PATCH v3 18/31] elx: efct: RQ buffer, memory pool allocation and
 deallocation APIs
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-19-jsmart2021@gmail.com>
 <f9aa3ecc-5d59-e3ce-57d7-f7aceb460679@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <6f5c00cc-7f6d-bbed-2511-0a0a9e5a954d@gmail.com>
Date:   Wed, 22 Apr 2020 20:16:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f9aa3ecc-5d59-e3ce-57d7-f7aceb460679@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/2020 12:24 AM, Hannes Reinecke wrote:
...
> But now you go and spoil it all again.
> At the very least use a mempool here; not sure how frequent these calls 
> are, but we're talking to the hardware here, so I assume it'll happen 
> more than just once.

we will move to a mempool

Agree with the rest of the comments and will address them.

-- james

