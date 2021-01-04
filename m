Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB78C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 23:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99492253D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbhADXdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 18:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbhADXdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 18:33:19 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B84EC061574;
        Mon,  4 Jan 2021 15:32:39 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u19so29190614edx.2;
        Mon, 04 Jan 2021 15:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pP3+G4ybPLsu21sUvB7IcM2g/XFhBwo1FBDDSyOqWVk=;
        b=gkiMwOx7WmqzAkBH7BIFxMD2baoJZ0d6UWXubGjQMvO13HoKMiR9S8qkuPORZhHVRS
         bjMLzwqSIQeR3iiiLexlszXwVdE2RwF6BfsQPYhXKrqRz7D7B4nt0cEL4c46C4Ezg+hy
         0z13kzHLxUdR5opz9eUbtZjaPn8gp0QbJRLy+Pivd/85DWoIyLqu9YGCrvtGU93QCXLg
         WNfnPsw9+EnI93hbe1urVHTFfPbhrmtwKEGXCvYDJRqaMXOJ+v63B/lzQqW6LXYf9Mk+
         FJ4eE1h7yG80EO4VKEbknIx7T7FDlvGQgsAZCeN6BVuc7E58ZNvFV1Qg2bJO8IcrbnF4
         IS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pP3+G4ybPLsu21sUvB7IcM2g/XFhBwo1FBDDSyOqWVk=;
        b=Mjk8mQA9CiTKISYbCdvtCGBNWm0409rkkzgR2WDHkD1s7qlkUxHufooFYm/I4Aij4M
         jhwI7gRy/72la2vjcvUqUuHaFwvaxchKWXUdq2Wn/GC0FStzTaG5oirZvkq01jz7eAIR
         ZmewAo6ikO/6YyujmXKMBFjAZgad+5N2xlpHWosryYJg4aBIBiIFoWjjsRCMLvjW9tXi
         M1wIi3l0W/5CtBQpGgJytKJPAvmTQ/yoKEKBv0sp5+o06YREPkiDa0F1fk8VUl2HX+ej
         TfxFzZYiRcVBwUajvHSnhRcd3p0lc4749IL+ZeqjK+JfINbsVCScXt6e+M/brDUADN80
         5wHQ==
X-Gm-Message-State: AOAM532FEliDCBP53W5/1OJbnznZkOV4XTtcXJT8W6/TmjxVdk1tqgEh
        UdZCDVXU+ey4Qr1Cly9620mmK+fZKMjI/w==
X-Google-Smtp-Source: ABdhPJykjk2lzJz+Mt2kEPPSwNBNknISXNNEgo6QZp1+5piD0eWg7ZzxDDaesaDQfqdwt/3K/l5/bg==
X-Received: by 2002:aa7:d1c2:: with SMTP id g2mr73854418edp.8.1609792770463;
        Mon, 04 Jan 2021 12:39:30 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id o13sm43801344edr.94.2021.01.04.12.39.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Jan 2021 12:39:29 -0800 (PST)
Message-ID: <2335e241133fe128bd3c3d70da5360b8326bb76e.camel@gmail.com>
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
Date:   Mon, 04 Jan 2021 21:39:28 +0100
In-Reply-To: <d1286d29aca18c004c66924a46c70f2d03562769.camel@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
         <DM6PR04MB657559FA01C44B411BBDBDBCFCC70@DM6PR04MB6575.namprd04.prod.outlook.com>
         <01a4472065034527d57b0866750eb4ecc79b6a83.camel@gmail.com>
         <d1286d29aca18c004c66924a46c70f2d03562769.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-15 at 23:18 +0100, Bean Huo wrote:
> On Mon, 2020-12-14 at 23:37 +0100, Bean Huo wrote:
> > > And another log generated sometime during 2021 after your change
> > > is
> > > merged:
> > > "send" <request upiu>
> > > "complete" < ****response upiu ****>
> > > 
> > > The current parser won't be able to differentiate between those
> > > logs.
> > > Just change the prefix strings to be "send_req" and
> > > "complete_rsp",
> > > or something,
> > > so the parsing tools that support the new format will be able to
> > > differentiate it from the old one.
> > 
> > Avri,
> > I still don't understand, this change doesn't break you current
> > parser.
> > if you still trace "send", "complete", "CDB", "query_send/complte",
> > they are still there, doesn't change. I suggest you just run on
> > your
> > system. see if there is conflict.
> > 
> > Regarding your suggestion:
> > This is not problem now, we just change this definition.
> > 
> > do you mean just "send" and "complete" or all?
> > 
> > #define
> > UFS_CMD_TRACE_STRINGS                                  
> > \              
> >           
> >         EM(UFS_CMD_SEND,        "send_req")                        
> > \  
> >                                   
> >         EM(UFS_CMD_COMP,        "complete_rsp")                    
> > \  
> > 
> > below also need add "req" and "rsp"?
> > 
> >                                   
> >         EM(UFS_DEV_COMP,        "dev_complete_rsp")                
> > \  
> >                                   
> >         EM(UFS_QUERY_SEND,      "query_send")                  
> > \      
> >                               
> >         EM(UFS_QUERY_COMP,      "query_complete")              
> > \      
> >                               
> >         EM(UFS_QUERY_ERR,       "query_complete_err")          
> > \      
> >                               
> >         EM(UFS_TM_SEND,         "tm_send")                     
> > \      
> >                               
> >         EM(UFS_TM_COMP,         "tm_complete")                 
> > \      
> >                               
> >         EM(UFS_TM_ERR,          "tm_complete_err") 
> 
> 
> Hi Avri
> 
> I am waiting for your answer. How can I change these strings to back-
> compatible with your tool? Tt seems only you use these strings.
> 
> Thanks,
> Bean
> 


Hi Avri
Before sending next version, double confirm with your.  I think you
just need change:

"send" to "send_req" 
"complete" to "complete_rsp"
                           

Bean





