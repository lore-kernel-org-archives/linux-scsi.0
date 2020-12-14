Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7A0C2BB48
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 22:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1DF22509
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 22:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441170AbgLNWiN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 17:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441091AbgLNWiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 17:38:13 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15AEC0613D3;
        Mon, 14 Dec 2020 14:37:32 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id j22so6871903eja.13;
        Mon, 14 Dec 2020 14:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Re4a9ic6X/qC8lw0qDnD/+52GEZaZivwedL28Be9r2Y=;
        b=awVQa3kIBFg3XgQ3iLiQoHd85wN1hZNmnRqSKJPr5nFQTqPc25ZijKUOeo/u8bm+Q6
         DJdDqUj8ULg6Zm1XBRfkG+WNh8+6bj1HPvUJJOYomwhsm4+aldPmzX9fm/9V6TNX6fUe
         SJsQiArzxHu93na/vvaWCmnsHylEvimCJECib2/v9jskzJ4pgc2oFY6ixFoyg65bHeGU
         1Vow9HTwBXK9QzhDo7y8miHxyxwNpHOZSEH2OkBGQoptzF0arjo7agQsEISmYnrg5nR/
         bk1Evt9h4bE3jqDgRPz2habnVAyWK4oIl2nkN6Xwtb5WEFmR/XnFstxcTfSQ2VeKjd4D
         Owmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Re4a9ic6X/qC8lw0qDnD/+52GEZaZivwedL28Be9r2Y=;
        b=UDY0U+7YKEqF0bCwJpOuGs1rF2DDdlsAq7VfC1AAbOKUoZpLGaRvVEOdByKdGeBpj7
         7KL0qYJQC9kDCLI7+kQD/HLGcx9YrKgU0bJqCdd/TZxrHnMPD/l4kcP+pCO1Ef36C4j6
         X5O3PxOAnwN/plzFwyc32Y5G/zGBF7GOxDG9OCW/rhug5gSbdmPB5dOHoAbrkm6hRxU8
         /y6BPRLwJSzQS6p42LQnC18hvSSIPg8iDO4DoJ//LOYj6aeVzMuJ+SFVao8NCTN3EQAz
         wQS+tElVpU3v96xIRFaaQcvWpo9madpqRBAw0MYOyPzr7D4kqhmripLCmacBVAU0GPpm
         rdTw==
X-Gm-Message-State: AOAM5328Q2YRXg9BxNqq1wgbflptFadtarJIoJTCYYe99Na3OphAR82P
        FcmFy09vhuci5c1tlONx5io=
X-Google-Smtp-Source: ABdhPJxS1PXmnH00sCgzl43n3133rCkIys8NCWRMRG9PFtsaZ8xAF/Jz5dtMftfVIW12Skqs/R9UBA==
X-Received: by 2002:a17:906:705:: with SMTP id y5mr10714139ejb.428.1607985451743;
        Mon, 14 Dec 2020 14:37:31 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id be6sm16569654edb.29.2020.12.14.14.37.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 14:37:31 -0800 (PST)
Message-ID: <01a4472065034527d57b0866750eb4ecc79b6a83.camel@gmail.com>
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
Date:   Mon, 14 Dec 2020 23:37:30 +0100
In-Reply-To: <DM6PR04MB657559FA01C44B411BBDBDBCFCC70@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201214202014.13835-1-huobean@gmail.com>
         <DM6PR04MB657559FA01C44B411BBDBDBCFCC70@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-14 at 22:13 +0000, Avri Altman wrote:
> Bean Hi,
> I support this series.
> I think it is a good idea to print the response on complete,
> But you need to change the prefix strings, otherwise you are breaking
> the current parsers.
> 
> Say that you have a trace log, generated sometime during 2020 using
> the current upiu trace.
> It would look something like:
> "send" <request upiu>
> "complete" <request upiu>
> 
> And another log generated sometime during 2021 after your change is
> merged:
> "send" <request upiu>
> "complete" < ****response upiu ****>
> 
> The current parser won't be able to differentiate between those logs.
> Just change the prefix strings to be "send_req" and "complete_rsp",
> or something,
> so the parsing tools that support the new format will be able to
> differentiate it from the old one.

Avri,
I still don't understand, this change doesn't break you current parser.
if you still trace "send", "complete", "CDB", "query_send/complte",
they are still there, doesn't change. I suggest you just run on your
system. see if there is conflict.

Regarding your suggestion:
This is not problem now, we just change this definition.

do you mean just "send" and "complete" or all?

#define
UFS_CMD_TRACE_STRINGS                                   \              
          
        EM(UFS_CMD_SEND,        "send_req")                         \  
                                  
        EM(UFS_CMD_COMP,        "complete_rsp")                     \  

below also need add "req" and "rsp"?

                                  
        EM(UFS_DEV_COMP,        "dev_complete_rsp")                 \  
                                  
        EM(UFS_QUERY_SEND,      "query_send")                   \      
                              
        EM(UFS_QUERY_COMP,      "query_complete")               \      
                              
        EM(UFS_QUERY_ERR,       "query_complete_err")           \      
                              
        EM(UFS_TM_SEND,         "tm_send")                      \      
                              
        EM(UFS_TM_COMP,         "tm_complete")                  \      
                              
        EM(UFS_TM_ERR,          "tm_complete_err")    


>   
> Also, once the parser can differentiate the new format from the old,
> whatever follows its fine: cdb / osf / tsf or whatever makes sense to
> you.
> 
> Thanks,
> Avri

