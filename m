Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE90C55189
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0722E20787
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="raaWlNof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDWBiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWBiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 21:38:10 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50710C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:38:10 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p8so2060680pgi.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TwYuxXyw3JtPEr7cQ9yXde/271oaI2TZTtrC9e6D0/w=;
        b=raaWlNofk3c2i4wi9Ipjc0WKJ77R3P9IFlzqS3gTUFi6xFk11ARa112jzSxPownAT+
         FI+LCH2pzMw4R6Meb2h3mb5x45cSJgJjjqWRM33tR6Fw+OUE+U7Plg86NvzdhFx1C7ei
         2TDwcb8q57sDTGQ0Q0a8D1XD6W3yTDuWUMYy2ikvCL9kKJuwNjNSLmMdBTTnW6uLVcZe
         ljw3hrUBcih0MVI+4cDcJft+avrl/VjbofPAKbU6/ilg3qhF8tL7JAFnfKEAoBo52QcS
         LCskDvborUg4l6gjwJeeFzUD3vD9jugWZqBqK+MEcVQbJx/wbXhbw6mfcou6Tygb8qJL
         nZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TwYuxXyw3JtPEr7cQ9yXde/271oaI2TZTtrC9e6D0/w=;
        b=E7Oz5et/wZdCBVw3x+vsPKF2EwJzqhmGRgeRlNwkOXqBU9JFn0HhLLZvlyZsycBibF
         tnDVs3+VX8hDImzL9mtmrd+pWs9egKcRtv729myN2dd5SLwIaGe3G5bCu1Lx1PW42SCP
         H7VWCZCY0REWZpCd+Gn+8feXfaTwumAKXxwQK7CIeFE1cLq7huWeSN0mKiVcPKzx++S/
         uYGeV3kqJUbWILr39wRXUzq4/0Yqg+4Qx5R+DuRBT0HLNslihFcu2eHr3WtaN37SL3h4
         RdFJ8XguVQSaDK+QzxWgRAcIKIYINBTPihjHsOoReGoUO98kxmyxZBvfvOSHVS+Bu1e5
         rBCQ==
X-Gm-Message-State: AGi0PubsuIoVcc5EZ4dWFWIFpu4mpwZLl6/S6e26ztzkxlfegMY8mUnt
        ZDn+omHF6cZu2wUJtxHXbyk=
X-Google-Smtp-Source: APiQypIH+qSKudhBBiBFO969TPosLkZbEX5BN5ZEcC5NKEZ57+uFNGm6zzmWudCt15OG9sZOMwRtPg==
X-Received: by 2002:aa7:990f:: with SMTP id z15mr1510754pff.132.1587605889922;
        Wed, 22 Apr 2020 18:38:09 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o68sm803438pfb.206.2020.04.22.18.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 18:38:09 -0700 (PDT)
Subject: Re: [PATCH v3 13/31] elx: libefc: Fabric node state machine
 interfaces
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-14-jsmart2021@gmail.com>
 <86cf1199-b29e-4955-1027-e3c2ba5056c4@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <df6b24c3-02e8-05c4-5dae-473dbefd4e4e@gmail.com>
Date:   Wed, 22 Apr 2020 18:38:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <86cf1199-b29e-4955-1027-e3c2ba5056c4@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 11:37 PM, Hannes Reinecke wrote:
> What is going on here?
> Why do you declare all function as 'void *', but then continue to return 
> only NULL pointer?
> 
> Is this some weird API logic or are these functions being fleshed out in 
> later patches to return something else but NULL?
> 
> But as it stands I would recommend to move all of these functions to 
> simple 'void' functions, and updating the function prototypes once they 
> can return anything else than 'NULL'.
> 
> Cheers,
> 
> Hannes

We will convert to void functions. Agree with your comments.

-- james
