Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55A4C47096
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 02:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1EDF61407
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 02:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFDCir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:38:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29110 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229820AbhFDCiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Jun 2021 22:38:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622774221; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=HVjZEFAyNUQ76bULMiLZjA8A7Oes5HxeX8UT2CHU+AI=;
 b=oqob2V2QIbnpT/Qo5ctmtcQewXK9lhb42bIHl8TIp8vsLZO4HMUXb+zPd303HWK/e43VxXva
 v0Q0x16sqF6+KQo4J8Hvvr79QwJm2O+/3ppRTEZxBwpzZ3dYLaQp5LATnzy4p8zzUn8o3Uus
 CW22CN8cqNJrPh7vFPUR3zvhfGU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60b991ccf726fa418820e8d4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Jun 2021 02:37:00
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0FBAFC43460; Fri,  4 Jun 2021 02:37:00 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5772AC433F1;
        Fri,  4 Jun 2021 02:36:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Jun 2021 10:36:59 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: Use UPIU query trace in devman_upiu_cmd
In-Reply-To: <aaa62a02184b590c8845183c4bbad9a0e9ab36aa.camel@gmail.com>
References: <20210531104308.391842-1-huobean@gmail.com>
 <20210531104308.391842-5-huobean@gmail.com>
 <7689e5022787716596534e9123fdc295@codeaurora.org>
 <aaa62a02184b590c8845183c4bbad9a0e9ab36aa.camel@gmail.com>
Message-ID: <9526e2c0646f8755756be5b712e5bb2a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-03 05:05, Bean Huo wrote:
> On Wed, 2021-06-02 at 10:29 +0800, Can Guo wrote:
>> >        spin_lock_irqsave(hba->host->host_lock, flags);
>> > @@ -6732,6 +6733,8 @@ static int
>> > ufshcd_issue_devman_upiu_cmd(struct
>> > ufs_hba *hba,
>> >                        err = -EINVAL;
>> >                }
>> >        }
>> > +     ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR :
>> > UFS_QUERY_COMP,
>> > +                                 (struct utp_upiu_req *)lrbp-
>> > >ucd_rsp_ptr);
>> >   out:
>> >        blk_put_request(req);
>> 
>> 
>> What about ufshcd_exec_dev_cmd()?
>> 
> 
> 
> Can,
> thanks for your veiew.
> yes, ufshcd_exec_dev_cmd() is only to send
> UPIU command frame, and doesn't include CDB. It already uses
> ufshcd_add_query_upiu_trace() to trace UPIU frame.
> 

Oh, sorry, I missed it.

Reviewed-by: Can Guo <cang@codeaurora.org>

> Kind regards,
> Bean
> 
>> Thanks,
>> 
>> Can Guo.
