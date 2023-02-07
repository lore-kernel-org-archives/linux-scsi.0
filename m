Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7DFC636CC
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 23:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBGXLx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 18:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGXLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 18:11:52 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0615DC648
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 15:11:51 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id x10so480752pgx.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2023 15:11:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOQ0yI/0N++HamuO/wHG+PtESqK1M06+84RevsPhEt4=;
        b=kD1GB4rtjzgHmh06tIVLe7U3woGF1rND23laPBMfYzlNZj9c0xnNpzPKYLeDkV74dt
         K6/Fgu10Vr/qPACHT9+MaVeXUe+g9BZBBVQ243js+Q/sBsqSjXPOsgd449imVZ+xBJKB
         yEqPDaKK2qgqWh8hIWOSHyFYRqd6OATvuJdmRUKGshirNcgmFdsd4ON3NbirW27vfwSl
         X1BNPB3YYTd7NUeGbt+or9mvEvLb/61gHLtyxd4ggFUIHlD6RopmCIZ+kmE8HGmbvGVM
         ze5SLZrWh6SAco0IBftalAP8eNV54vYid5BuP24PV0OPYbGiCFSCzU8PO6XqWByj+kku
         hLVA==
X-Gm-Message-State: AO0yUKX5VqLTqm/9Kr0g/byqaWqurcoSIpwWkBpW+qUy7EE+M3bLaq9w
        3rpyi+1l172aAzfNmzkDiJI=
X-Google-Smtp-Source: AK7set9kDBU0nJZZkpGIei5ONVhrKKUAzYOMLjqvoVnCQGCzOncBs1utwD/hBllHCKTq0OLEMHTE4w==
X-Received: by 2002:a62:8415:0:b0:5a8:25c8:f375 with SMTP id k21-20020a628415000000b005a825c8f375mr404435pfd.17.1675811510209;
        Tue, 07 Feb 2023 15:11:50 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:1000:8a4b:e165:69ed? ([2620:15c:211:201:1000:8a4b:e165:69ed])
        by smtp.gmail.com with ESMTPSA id d131-20020a621d89000000b0059393d46228sm10095863pfd.144.2023.02.07.15.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 15:11:48 -0800 (PST)
Message-ID: <5d293df3-6f94-d3a6-5bfb-35b191808582@acm.org>
Date:   Tue, 7 Feb 2023 15:11:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] scsi: ufs: probe hba and add lus synchronously
Content-Language: en-US
To:     Adrien Thierry <athierry@redhat.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230202182116.38334-1-athierry@redhat.com>
 <0e955a31-1d3a-beca-4581-dbcdefc47674@acm.org> <Y91xPMM+/BfaRLle@fedora>
 <90e4fb52-6b09-00d9-7591-7140b859ed15@acm.org> <Y914yu4rSqvpSoRZ@fedora>
 <Y+LWi3MrLQV/se/j@fedora>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y+LWi3MrLQV/se/j@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/7/23 14:54, Adrien Thierry wrote:
> Do you think this could be an acceptable compromise for boot time? It
> should not slow things down too much since the really time-consuming parts
> (ie. UFS initialization) would still be in the async routine.

Hi Adrien,

That sounds good to me. Thank you for having suggested an alternative 
solution.

Bart.

