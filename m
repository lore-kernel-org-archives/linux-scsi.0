Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F6FC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 22:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED93D22582
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 22:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgLOWTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbgLOWS5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 17:18:57 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52401C0613D3;
        Tue, 15 Dec 2020 14:18:17 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id jx16so29920776ejb.10;
        Tue, 15 Dec 2020 14:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5Dufp+I/oN9gEvVsI5qMjQlYwjWd3gnSbx0Lh129PY=;
        b=ZWIf2yGPS9yONqFP20l2hiZaDXnmazyFhKB9gABPvvgcKUjcR6CTDNjWPxqgqaDnAW
         Le7B8d3R1fpeDDryRbWOcMcm/1a6lL9AnXI8WKbLvhG45/1iUZIcyD/N706sr7ilcGCU
         b9+KLlWqlTJUu9Zl9AsSp8RK7gvHsRzdWMyMVVFk0voZkjdOMR4zlybw86SIA8gfgbxp
         6jZmxCU9GHfPkt39F0LWYhba54RSO90DYB743zGLlYB/b06oC3TjXyLC1RHT9qGeBtBf
         KqbKL4ZJcG6YV4+7mLzR40v0VHnqJ/sQtCA9Iw0FOMKGOSEmlnWXgqUL05aVOzlsVd6T
         7ejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5Dufp+I/oN9gEvVsI5qMjQlYwjWd3gnSbx0Lh129PY=;
        b=pnMAgcaGfgiVhtt2FEJc3hQGbjM1I4VmIbNLNc+Dom32KB2PbLyjiPj77LVlYULEnZ
         6e/KEf5jRyDFsw36oKB4nVpPekexZtt4Za4OO996pFZxabcOpxDGIrk+AD4UwLcKB2Sk
         m7lT/VV4ldo4kARg8Tz2vcyr4qVf0V4/wvXnaabkUlfd3xDnP5bp4qrB0k+W506B62vg
         0IfMdk6Cqgus0PW3BzXLnV9q9IseX+bOwWTzRuhZf6u5ppKvNcPocwmA8VX3KX+1/H4r
         Mnwx0YPvKHAb4vD/3eJ5sFh/zMbvfVrKyE2BbUTNaXEmSHJYPLzXgz98qSEZ72Ook84D
         Nj2g==
X-Gm-Message-State: AOAM531QTAdUnNp8bmOSzqKUZ82qbz4DDO4AsvlenzmF2r6hs7pwu8jP
        TMlmSeHmXtRuDAb+C96p3u0=
X-Google-Smtp-Source: ABdhPJy91uePyxVTPJ3CwPdFAqW5XWZlLbIxYm/MJtc+HEkhijeLPzQ84wPs4ZOplT4ZhUuGYaZRAw==
X-Received: by 2002:a17:907:1607:: with SMTP id hb7mr27736431ejc.81.1608070696049;
        Tue, 15 Dec 2020 14:18:16 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id q25sm19443405eds.85.2020.12.15.14.18.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Dec 2020 14:18:15 -0800 (PST)
Message-ID: <d1286d29aca18c004c66924a46c70f2d03562769.camel@gmail.com>
Subject: Re: [PATCH v3 0/6] Several changes for the UPIU trace
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "joe@perches.com" <joe@perches.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Dec 2020 23:18:14 +0100
In-Reply-To: <01a4472065034527d57b0866750eb4ecc79b6a83.camel@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
         <DM6PR04MB657559FA01C44B411BBDBDBCFCC70@DM6PR04MB6575.namprd04.prod.outlook.com>
         <01a4472065034527d57b0866750eb4ecc79b6a83.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-14 at 23:37 +0100, Bean Huo wrote:
> > And another log generated sometime during 2021 after your change is
> > merged:
> > "send" <request upiu>
> > "complete" < ****response upiu ****>
> > 
> > The current parser won't be able to differentiate between those
> > logs.
> > Just change the prefix strings to be "send_req" and "complete_rsp",
> > or something,
> > so the parsing tools that support the new format will be able to
> > differentiate it from the old one.
> 
> Avri,
> I still don't understand, this change doesn't break you current
> parser.
> if you still trace "send", "complete", "CDB", "query_send/complte",
> they are still there, doesn't change. I suggest you just run on your
> system. see if there is conflict.
> 
> Regarding your suggestion:
> This is not problem now, we just change this definition.
> 
> do you mean just "send" and "complete" or all?
> 
> #define
> UFS_CMD_TRACE_STRINGS                                  
> \              
>           
>         EM(UFS_CMD_SEND,        "send_req")                        
> \  
>                                   
>         EM(UFS_CMD_COMP,        "complete_rsp")                    
> \  
> 
> below also need add "req" and "rsp"?
> 
>                                   
>         EM(UFS_DEV_COMP,        "dev_complete_rsp")                
> \  
>                                   
>         EM(UFS_QUERY_SEND,      "query_send")                  
> \      
>                               
>         EM(UFS_QUERY_COMP,      "query_complete")              
> \      
>                               
>         EM(UFS_QUERY_ERR,       "query_complete_err")          
> \      
>                               
>         EM(UFS_TM_SEND,         "tm_send")                     
> \      
>                               
>         EM(UFS_TM_COMP,         "tm_complete")                 
> \      
>                               
>         EM(UFS_TM_ERR,          "tm_complete_err") 


Hi Avri

I am waiting for your answer. How can I change these strings to back-
compatible with your tool? Tt seems only you use these strings.

Thanks,
Bean

