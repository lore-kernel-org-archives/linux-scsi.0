Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0512AC83F18
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 20:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbjH2UtS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 16:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjH2Uss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 16:48:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3EA1BE
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 13:48:45 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99bcc0adab4so641175566b.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 13:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693342124; x=1693946924; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NhxrzIBjg5IUspbOP9K+8/9qaQAAb0yJHRB1SYLGEeo=;
        b=E2Bj9okjrjki30wbEqIiJk1Um+X0C1pacGCpAPFvS9b1SYNSEcq7G38tOWzDFLqhmL
         3RF8M0OwarZf4t06qpMv6Fxbtf74mHbLP1/Hxa5/DI3jKiKUWA2myiD6LBGzEAVJXlAU
         85nQld3/Bfyu6B++FHKdcgRhqZSvaX/y4sgtH1prTpR4oQCrzDi3TiJJl7ghU/urpv+e
         u/fmDpS1PG/I5YoH0PllHqVBaNI/ECLBM2KVWm5q5OOycYUTKfbxBcbZW1Y0AapL9so5
         M+lSPM6dZFSUvXLT3g1RNTKyYgfo8GvbDOFBWIVPt8HuPQTyFJoak3iPq2XwlZIAubH2
         zHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693342124; x=1693946924;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NhxrzIBjg5IUspbOP9K+8/9qaQAAb0yJHRB1SYLGEeo=;
        b=Br9cipAWoaVTbfYHZnpY63Z+d86vIveqAWEs+FfqRMNzz885FyNFusmWcjUHhHYpuC
         k3c4gqticiBxeTtdFIW+3Td3q1xrxftybo76ZKeUJnSShRf8DuxgNXbz8efya8XhpqeN
         2OBh1F79lU1TRzJAPaFx1Or4DrykPt/jsBKxO7wdnFqV4q+mIqujVAWkVnzpAfdRc9Zy
         Ec/QWInwt7/JITy7z+UEIalNGNocf3NZ5HtAXuiY2gbaCpl+vRjb4s1nDs8ZXNLfpCSI
         zmfVkSUu/bh3NsFeG3YXtITWicVUptka+H9IpfJOJXPfYRwfqxDLTM44huspYKSNN08t
         sBBg==
X-Gm-Message-State: AOJu0YzEOA5jp4HXmnfgY5h6+ua7vhoNJbdiL+waX6ItKdWy9iMchSjH
        j8wBep35BE+2mifeu9rJ3Mg=
X-Google-Smtp-Source: AGHT+IGmtBxbm4NAllcQT9eX/SaUfpM/wOYy+7VFRo10QDSDXN+tzwgwEHQ9AnacBe0N7mKeEWMTxg==
X-Received: by 2002:a17:906:8466:b0:9a5:c4ae:9fd4 with SMTP id hx6-20020a170906846600b009a5c4ae9fd4mr102038ejc.59.1693342123493;
        Tue, 29 Aug 2023 13:48:43 -0700 (PDT)
Received: from ?IPV6:2003:c5:8732:de59:6f4e:b30c:5b21:3b45? (p200300c58732de596f4eb30c5b213b45.dip0.t-ipconnect.de. [2003:c5:8732:de59:6f4e:b30c:5b21:3b45])
        by smtp.gmail.com with ESMTPSA id b10-20020a170906490a00b009a1be9c29d7sm6439098ejq.179.2023.08.29.13.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 13:48:42 -0700 (PDT)
Message-ID: <3bf3d4ef-1046-d35b-e220-fcde29e744a5@gmail.com>
Date:   Tue, 29 Aug 2023 22:48:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: ufs: Fix the build for the old ARM OABI
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20230829163547.1200183-1-bvanassche@acm.org>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230829163547.1200183-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 29.08.23 6:35 PM, Bart Van Assche wrote:
> All structs and unions are word aligned when using the OABI. Mark the union
> in struct utp_upiu_header as packed to prevent that the compiler inserts
> padding bytes.
>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Reported-by: kernel test robot<lkp@intel.com>
> Closes:https://lore.kernel.org/oe-kbuild-all/202308251634.tuRn4OVv-lkp@intel.com/
> Fixes: 617bfaa8dd50 ("scsi: ufs: Simplify response header parsing")
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Thanks for the prompt fix!

Reviewed-by: Bean Huo <beanhuo@micron.com>



