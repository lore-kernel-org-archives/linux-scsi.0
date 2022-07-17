Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D53C43334
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Jul 2022 14:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiGQO6v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Jul 2022 10:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiGQO6u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jul 2022 10:58:50 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF138F6F
        for <linux-scsi@vger.kernel.org>; Sun, 17 Jul 2022 07:58:48 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so15935434pjm.2
        for <linux-scsi@vger.kernel.org>; Sun, 17 Jul 2022 07:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kn5Rd01a67rt97YjHe1LzrGdp6cWaMOd4X7pofksiUI=;
        b=o/bvBLSAMAqWD7KLcpR65cKugD4/mkLw27W8OlETbqFIR1vgr9u7hQPX0AhQTLRpl0
         3NpcaxHGlzpdDuBmy+uoeT9wfex2W2JieJCffEc9qdjV1IMQlotSKie+Mx3w02Dqhg/U
         UUBYJegBVbrQmtI5hNISXbpinp20xYvIIhi7HF6gOzqeK5g/V4OEiAwbT8n6ECu++szL
         8utFuEnNMy2v4XgF1hn0Mr++MgZBrg3hmxqeqF9VxqN/MTg7F6IOECmRmn6SD1cZ9763
         n9j/0cOKEoWN0b2ElQmm9LyK2edGlIs06YEUPOCmxjFDxhIY3XXRZ0Fs5Rux/qlaV+Kt
         toUQ==
X-Gm-Message-State: AJIora/3aXECTNzAfv3Jcfv6BwIv7prwzOyIXYZByTRg0L5/JUjL4GjG
        0IGmgpWBz5v9DUHyNjKZ6lbE9IeHMJI=
X-Google-Smtp-Source: AGRyM1sH9ibDm4sMTmT+7EbqD1fDUDVVX2JFbcOTuzYWRKNf2yJecjVEb7g/5OhY5P3n74yGxbdJBA==
X-Received: by 2002:a17:90a:bf03:b0:1ef:8fca:282c with SMTP id c3-20020a17090abf0300b001ef8fca282cmr34005484pjs.219.1658069927768;
        Sun, 17 Jul 2022 07:58:47 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id h10-20020aa79f4a000000b00528d880a32fsm7395596pfr.78.2022.07.17.07.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 07:58:46 -0700 (PDT)
Message-ID: <6e005dc0-720e-41b1-10df-cc088245bccb@acm.org>
Date:   Sun, 17 Jul 2022 07:58:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] ufs: host: ufschd-pltfrm: Hold reference returned by
 of_parse_phandle()
Content-Language: en-US
To:     Liang He <windhl@126.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20220715001703.389981-1-windhl@126.com>
 <0209504a-fdd5-5987-4772-dfb14c6ceafc@acm.org>
 <741595c3.743.1820a1c502e.Coremail.windhl@126.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <741595c3.743.1820a1c502e.Coremail.windhl@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/22 20:03, Liang He wrote:
> At 2022-07-16 21:50:08, "Bart Van Assche" <bvanassche@acm.org> wrote:
>> On 7/14/22 17:17, Liang He wrote:
>>> +static bool phandle_exists(const struct device_node *np,
>>> +						const char *phandle_name,
>>> +						int index)
>>
>> Indentation of the arguments now looks really odd :-(
> 
> Yes, Bart, I also wonder this coding style, however I learned that
> from the definition of 'of_parse_phandle' in of.h.
> 
> Is it OK if I put all of them in one line？

No. From Documentation/process/coding-style.rst (please read that 
document in its entirety): "The preferred limit on the length of a 
single line is 80 columns. [...] A very commonly used style
is to align descendants to a function open parenthesis."

Consider to use the following formatting:

static bool phandle_exists(const struct device_node *np,
			   const char *phandle_name, int index)
{
	[ ... ]
}

>>> +{
>>> +	struct device_node *parse_np = of_parse_phandle(np, phandle_name, index);
>>> +	bool ret = false;
>>> +
>>> +	if (parse_np) {
>>> +		ret = true;
>>> +		of_node_put(parse_np);
>>> +	}
>>> +
>>> +	return ret;
>>> +}
>>
>> The 'ret' variable is not necessary. If "return ret" is changed into
>> "return parse_np" then the variable 'ret' can be left out.
>>
> 
> OK, I will use 'return parse_np' in new version when you confirm above coding style.

You may want to use "return parse_np != NULL" if you want to be sure 
that nobody else will complain about an implicit conversion of a pointer 
to a boolean type.

Thanks,

Bart.
