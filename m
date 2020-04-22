Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9FCAC55181
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 05:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8617A20747
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 05:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gusgFJdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgDVFMS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 01:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgDVFMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 01:12:17 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D71C061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 22:12:17 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so772867wrs.9
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 22:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iM4n7w3pLzkO8EepnhadCf47VmPg1J5qN7gqd3HXMk4=;
        b=gusgFJdCSgU3QWa9yuEBxRip6IN8lBQG5DUqllW1IKTugOzAdGOw605pada7CXYBNP
         RqipxwCvnkV9c0kEcJb0XGvohi6r9EhHvQ3d+z4kcsvX65LdLf74fl81nMYbrbRfD2/R
         kn8ADoO76BFRtBtr/z+tQ4DvYU14Hs08jvpL+r2FX7Z/7gp3ItxWAwJS1vqo3yWhxNx9
         OIGyki7O12ZpTtqAfbi92LJ8wo61zIpwuyn81j0XZI1zJZxoEBCRnaD4c0J92VVtWTwz
         V7eg4VSUobQqx2TmGsNeZcPqSvZlerI4UoffoW6MIwa14LQIQ396BrUgLiW7saYlYG/I
         eA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iM4n7w3pLzkO8EepnhadCf47VmPg1J5qN7gqd3HXMk4=;
        b=UuitsH6l/stFvRHjwq9Ia6EYZOWp61EMk7Et8uIReDChI9K3mj1IoKf38a0uwV2Efk
         u7DjkuS2iarTcqvFdRkpKI3xjCY/AAxsu6VvT2s4AQPlgaRTNTN6sgteU422pSMzc7L0
         eBPpmJvhu+XElMtj+o3MFAZN8K+lcXA50w/aXI+4lYD+Lh3Zmjd+KcrrKp1XUaPG5FdF
         lawghRNxIVf18mzL0m/g5FxuV6wZ6aBqURERHyXKxIRjr6BZhK6f9hpCASYAlrMXBBrb
         dhJpXLnAsjKLToYZNA3THTQK7ThbHOuvLo8PyxsfOIHEa3WwsAL3CSNqcTo5x7qIxIS9
         epUg==
X-Gm-Message-State: AGi0Pubfo6V2uxgVRDTgT7hHXEzvK1va5/uBpM4Lf4oNkBWldzM1/0xO
        frK75tYBeKhBbFpUUqyxyPM=
X-Google-Smtp-Source: APiQypJmqYKsXZjjGGBq5BNBzzUab2UFgusuleXN0Emc8tAT1kxjsoeKevHnSBf8o6F+RtTUljd0zA==
X-Received: by 2002:a5d:4b04:: with SMTP id v4mr29171027wrq.358.1587532336362;
        Tue, 21 Apr 2020 22:12:16 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p6sm6522981wrt.3.2020.04.21.22.12.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 22:12:15 -0700 (PDT)
Subject: Re: [PATCH v3 06/31] elx: libefc_sli: bmbx routines and SLI config
 commands
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-7-jsmart2021@gmail.com>
 <20200415161043.3iih2znpn6xhnx3l@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <6e2d0780-cc5c-3c82-60ea-690f134d8da8@gmail.com>
Date:   Tue, 21 Apr 2020 22:12:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200415161043.3iih2znpn6xhnx3l@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 9:10 AM, Daniel Wagner wrote:
...
>> +	/* write buffer location to bootstrap mailbox register */
>> +	val = SLI4_BMBX_WRITE_HI(sli4->bmbx.phys);
>> +	writel(val, (sli4->reg[0] + SLI4_BMBX_REG));
> 
> Is the access to the register serialized by a lock?

The BMBX is used only at adapter initialization start. The 
Initialization sequence serializes access.

Agree with rest of comments and will address.

-- james
