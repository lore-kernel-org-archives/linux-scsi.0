Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8F8C35247
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 18:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 693D521741
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 18:58:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vE5jPIF+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgBES57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 13:57:59 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42819 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbgBES57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 13:57:59 -0500
Received: by mail-pl1-f195.google.com with SMTP id e8so1244315plt.9
        for <linux-scsi@vger.kernel.org>; Wed, 05 Feb 2020 10:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RWdQ8yl/RnVcAK/b669+JQmsUqlAIl/N5/E/PIuikZo=;
        b=vE5jPIF+TRJB+ZVTUD1YshTODa4rYD2EOOk8REgPiAXbTi78SDIQ3vQ6cLCeDTnnzE
         0wNifGtIOiHvFqA8mPSYhtZiAJDBNjDSyifJaIRHdW4RaMRVpYGUDEcl7dmdQ5jEWmIs
         Chzk7cgptGY1pzUc+GLJHReQIKYRMIbOTQr4gsmmi+oL5ASGJExoV5OvSAWTji/3hGky
         QxR+FsfYq8l8LNcWKq2MgV+bVqIYozi8m9cNftW/qmrzagIR0yxR1xtzZ3Uw+uZWZQaQ
         832jWLCfIkMQF9k1/yxWdcH4+Q9OKaN+vQIed4OmLkFvfSCyWc343xBxopQHwL2kQ1+b
         LBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RWdQ8yl/RnVcAK/b669+JQmsUqlAIl/N5/E/PIuikZo=;
        b=RfOkpdBvgqO5Qrd8ULFeDvBjkP8nVsjTfJ0q0p4Sz6TGAxVe7T1OdQWodtw02+VMit
         5FkndxBOTN14jATH6c8RLOZLoZ+4mHMSk9SlvBCsn05Oq/wDzN6l+16f2g08NHprm6kN
         uHigobsswl5iOyUWXHkJfQpRSJmEmVFpwLaSGQyS445BV1tFN7Ok3HMIyeE0+jJVAfnM
         deqID4/RsaxTLxi79lA+Jcs/Y/nNKiCON8375mGBVx7jslhNpMmb6fV5gTqErdgPEWZy
         FDaCF3fyHsrV1hEMvUpxKEtmRec+wr4eXu2dq1SVUEnkjQL3T4/pQ7ehHCQ/Fif6ZDvq
         OhsA==
X-Gm-Message-State: APjAAAWFBVqh2iLfKXfZODnCnUSEuZtC6YD4cGPG/0bHkyZKyXAbmkY4
        wLE2IOqG3h5z5J/992VbsDI=
X-Google-Smtp-Source: APXvYqyTjucOAdufKZYJaYnUc9uWROcYOs9amLQIWca/j54q6Hnf7CS+6SeMW4mg3fpWlj4OrdHryA==
X-Received: by 2002:a17:902:7d86:: with SMTP id a6mr36962983plm.212.1580929079071;
        Wed, 05 Feb 2020 10:57:59 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l10sm546160pjy.5.2020.02.05.10.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 10:57:58 -0800 (PST)
Subject: Re: [PATCH v3 0/3] scsi: add attribute to set lun queue depth on all
 luns on shost
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, bvanassche@acm.org
References: <20200124230115.14562-1-jsmart2021@gmail.com>
 <yq1v9olzqr3.fsf@oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <b42ca35c-64ef-d9fb-a40a-eea482c9d30b@gmail.com>
Date:   Wed, 5 Feb 2020 10:57:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <yq1v9olzqr3.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/2020 6:56 PM, Martin K. Petersen wrote:
> 
> James,
> 
>> There has been a desire to set the lun queue depth on all luns on an
>> shost. Today that is done by an external script looping through
>> discovered sdevs and set an sdev attribute. The desire is to have a
>> single shost attribute that performs this work removing the
>> requirement for scripting.
> 
> I'd like you to elaborate a bit on this.
> 
>   - Why is scripting or adding a udev rule inadequate?

Simply put, admins don't want to create them, mod the system for them, 
nor concern themselves with finding/changing each of the lun devices 
that connect to a particular port. They have been comfortable changing 
the driver's initial lun queue depth via module parameter. Given that 
was at driver load, it changed everything at time of initial discovery 
so it was fine. But, if the system won't boot for days/weeks, they want 
to do something as simple as the module parameter and with only "1 echo 
command". Thus we wanted to make the parameter be rw rather than ro. 
However, the only interface available to the lldd was 
scsi_change_queue_depth(), which changes the depth but does not change 
the devices max value (which it does do if written via the per-device 
attribute). So although the now writeable attribute allows the driver 
value to change, it would only be applied to storage devices discovered 
after the change. Existing devices would not have their max changed 
unless the per-device attribute were changed.  This new interface gave 
the lldd a new routine, which would find all the devices and apply the 
new max/value to the devices - as if the per-device attributes had been 
called.

> 
>   - Why is there a requirement to statically clamp the queue depth
>     instead of letting the device manage it?

You are misreading it, and perhaps my description led things astray. It 
doesn't "clamp" it at a fixed/unchangable depth. It sets the max to a 
new value and changes the current queue depth to that new value. These 
are the same actions that the per-device attribute does if written to. 
The management of queue depth depth beyond that point is the same as it 
was - meaning queue fulls ramp it down, there is ramp up, and so on. So 
it is the device managing it, just with perhaps a small blip if it 
actually raised vs it's current level, or a pause if its current level 
was higher and it drains down to the new levels.

-- james


