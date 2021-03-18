Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BC7C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E2464EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhCRTLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:11:12 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:44971 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbhCRTLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 15:11:09 -0400
Received: by mail-pj1-f48.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso3619338pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 12:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jAih+WZwOR16pW9SR3AUNWLZSpj/icFIYz7NkN2IFeE=;
        b=rGvvHuQvnDlq7NuETtANEMEyPsmIUn0l0+uNLQTrggyh/zfgwgc3JRhhcUY6gmxrI/
         LTlhSSCcTtCEQADQ6LmlTUGkdoTUR6dI1/z5U/tdiJx5uOTZhYBHjNXDRSs1iqD3dVmM
         DrCFbN3EQMkJfvK59RTp66ZzovAb29DQ2mJR1JN6u85OniVaJueGX4Ft01w4rc13rKd5
         j1dpgMpQPsSzzaaSxRpMgNLDIvrG2aLENpEJdnRESByp5azd6PEHuDSCDSBLfKuvYSlU
         g61/Ou5hemmatF7tCaBETNNYHcwJ+kK7uEufhtLPYzAker4VPB69koQ1TU+gKaZmiVCp
         ag5w==
X-Gm-Message-State: AOAM533GoEQ11AjqMhnALdLAX+pemhp0z++zyybbQh8LfUsKjbxnfCXV
        SeQ9ZMzLpBNCiyNNMF8+8U2UiIpVBNM=
X-Google-Smtp-Source: ABdhPJzKzjyudzrgRfrSnFDTvEkWfL4FiiZCxbEn8YB1eHde22chD3zD1JAea2Zq20R81Mj+vGRMwg==
X-Received: by 2002:a17:90a:bd90:: with SMTP id z16mr6046188pjr.123.1616094668598;
        Thu, 18 Mar 2021 12:11:08 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:e363:cf60:5c8:c27b? ([2601:647:4000:d7:e363:cf60:5c8:c27b])
        by smtp.gmail.com with ESMTPSA id i10sm7862496pjm.1.2021.03.18.12.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 12:11:07 -0700 (PDT)
Subject: Re: [PATCH v2 6/6] qla2xxx: Always check the return value of
 qla24xx_get_isp_stats()
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-7-bvanassche@acm.org>
 <20210318080816.a2fkja2ovlry4qxc@beryllium.lan>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c288c2a8-4acb-7cb2-421e-56b212d9a57a@acm.org>
Date:   Thu, 18 Mar 2021 12:11:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210318080816.a2fkja2ovlry4qxc@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/18/21 1:08 AM, Daniel Wagner wrote:
> On Wed, Mar 17, 2021 at 08:28:40PM -0700, Bart Van Assche wrote:
>> @@ -2873,7 +2875,9 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
>>  		}
>>  
>>  		/* reset firmware statistics */
>> -		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
>> +		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
>> +		ql_log(ql_log_warn, vha, 0x70d9,
>> +		       "Resetting ISP statistics failed: rval = %d\n", rval);
> 
> Is there not an 'if' missing?
> 
> 	if (rval)
> 		ql_log(...)

Right, I will add an if-statement.

Thanks,

Bart.


