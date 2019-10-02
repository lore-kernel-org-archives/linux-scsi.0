Return-Path: <SRS0=821a=X3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB32C352AA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F1B21A4C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Oct 2019 15:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfJBPno convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 11:43:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46676 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfJBPno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 11:43:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id q5so10533674pfg.13
        for <linux-scsi@vger.kernel.org>; Wed, 02 Oct 2019 08:43:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HNgWT9WwJmcSloLxNg+3pwgGvlaFLpQ3a/35gsjSEco=;
        b=U8aMFqNbpwowln44iClNL4kkj0MjR30XkJ0tsHpUFZDZxaB5/4wup0iFvX1SDu0tUu
         aXd77BJOqUL7vx/IopbiZHcZob/lMTM0g3ENbGFK36KcfDPMcCw3OnsTMs4aOZrP6Dgj
         tXFuwK09o1S1ZDN0RshJxQGBOGIb5Bbf9os5CS6E+pusb43fyy5HryCiSQY9mlN7exxM
         f6yBEMCv1n6Cao9vJoP8BT0Nfe3pCcucIpUEIVVhaHuWFWGk7XF15LfkGY33GwqhNBey
         Vztgtgta2fnvLMbeIBu04S1bOai6FHmp+Q83q93vbf44m2yp4kzx2lcENIWX0IKMne1y
         tZfw==
X-Gm-Message-State: APjAAAXqPcCNWnH5Hq+F3q+q+gR7hSpk3MoZm49tinUw2f1MjtSyfwn8
        4L4IhH0/hOXmH+o83rVEDj4=
X-Google-Smtp-Source: APXvYqxamCe+ISPDaTU49C6Kd9BcJIqpKBOArZiBCuF1GFwTtaGF6vSh7g+MBh1n59UHPFrDjqgoiQ==
X-Received: by 2002:aa7:9a94:: with SMTP id w20mr5197954pfi.77.1570031023723;
        Wed, 02 Oct 2019 08:43:43 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id e3sm5043633pjs.15.2019.10.02.08.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 08:43:42 -0700 (PDT)
Subject: Re: [PATCH] fixup "qla2xxx: Optimize NPIV tear down process"
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "qutran@marvell.com" <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "dwagner@suse.de" <dwagner@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>
References: <20191002143426.20123-1-martin.wilck@suse.com>
 <e89e0963-e6ca-d67d-0402-1a22ed5c5d3e@acm.org>
 <adc7f755ef21b151fc555167117456038b95ac4c.camel@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <eedb09c4-a600-682a-30dd-577aa3173403@acm.org>
Date:   Wed, 2 Oct 2019 08:43:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <adc7f755ef21b151fc555167117456038b95ac4c.camel@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/19 8:25 AM, Martin Wilck wrote:
> On Wed, 2019-10-02 at 08:17 -0700, Bart Van Assche wrote:
>>
>> Both loops check the loop termination condition twice. Has it been
>> considered to write these loops such that the loop termination
>> condition
>> is only tested once, e.g. using the following pattern?
>>
>> for (i = 0; i < 10; i++)
>> 	if (wait_event_timeout(...) > 0)
>> 		break;
>>
> 
> Right, that's probably better. This was just meant as a minimal,
> temporary fix for the already applied patch. I expect Himanshu or Quinn
> to follow up anyway.
> 
> I also still think that it'd be better to get the wake_up() calls
> right and not have to loop over wait_event_timeout() at all.

Such a loop is most useful if some status information is reported during
every iteration. An example from the SCSI target code:

do {
	ret = wait_event_timeout(se_sess->cmd_list_wq,
			percpu_ref_is_zero(&se_sess->cmd_count),
			180 * HZ);
	list_for_each_entry(cmd, &se_sess->sess_cmd_list, se_cmd_list)
		target_show_cmd("session shutdown: still waiting for ",
				cmd);
} while (ret <= 0);

Bart.

