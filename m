Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF17CDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 16:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbjJPQps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 12:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbjJPQpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 12:45:31 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D792E598;
        Mon, 16 Oct 2023 09:36:14 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c9d7a98abbso30669745ad.1;
        Mon, 16 Oct 2023 09:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697474173; x=1698078973;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Hn/zmefRvLZDs/4d7hyKdlyAP36ej068q+jX4GOUDM=;
        b=hFGD2fLji2CPOePPI3ytaf5VVrlHWPCO83xkMsuCoSwbzmKJ51rxSu6sgZS9WC6JRj
         JUKU9HbhGqxhT4BA2tOxeqwCeltHJmwQUmqPpHMGD1EKYbVNrjdffftgNuiI2XNTP5be
         t4LMdYho6ay+8ESYGTjPOqFNl7m+x5bv8ImQSgOrPQkFRApM4x0dE0K2m/uyeiXFJNVG
         QyNEYfwyaszjYKZHw2t50ewBakBqB9KK0NOtStkzeD1lUipbe5pyZ0tMFL/uHl3AqoS6
         uHHB4oU7pUUSXJWU3LM//raw3toSRfi41+5vWlzay9W5yHTVAXMQCyX8xDCTht3j6bUH
         oA7A==
X-Gm-Message-State: AOJu0Yz9Oko7+mMfXwC8hhSJGdR6tDuQ7cSqCZ8GpstKSNL891xqplJb
        n2YW0tnn2JxhYfcpeGe0/sZdCDNLZC3iLA==
X-Google-Smtp-Source: AGHT+IENrJynzR7Aax6sJfuQOctBIYL8EuuX/cOFVJ1GUccmBKql+ofOX2grGaRqtToIophaXlyWZg==
X-Received: by 2002:a17:903:747:b0:1ca:7879:b59e with SMTP id kl7-20020a170903074700b001ca7879b59emr2357518plb.32.1697474173337;
        Mon, 16 Oct 2023 09:36:13 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902e74600b001c9c5a1b477sm8702038plf.169.2023.10.16.09.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 09:36:12 -0700 (PDT)
Message-ID: <72e07798-0a40-41a6-89cb-11a15a4db5c5@acm.org>
Date:   Mon, 16 Oct 2023 09:36:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O priority
 bitfield
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231005194129.1882245-1-bvanassche@acm.org>
 <20231005194129.1882245-4-bvanassche@acm.org>
 <8aec03bb-4cef-9423-0ce4-c10d060afce4@kernel.org>
 <46c17c1b-29be-41a3-b799-79163851f972@acm.org>
 <b0b015bf-0a27-4e89-950a-597b9fed20fb@acm.org>
 <447f3095-66cb-417b-b48c-90005d37b5d3@kernel.org>
 <4fee2c56-7631-45d2-b709-2dadea057f52@acm.org>
 <2fa9ea51-c343-4cc2-b755-a5de024bb32f@kernel.org>
 <ZSkO8J9pD+IVaGPf@x1-carbon> <2f092612-eed0-4c4b-940f-48793b97b068@acm.org>
 <ZS0ASN6OY0KeOx+C@x1-carbon>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZS0ASN6OY0KeOx+C@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/16/23 02:20, Niklas Cassel wrote:
> So when you say:
> "It depends on how we want the user to specify the data lifetime for
> direct I/O.", do you mean that buffered I/O should use fcntl() to specify
> data lifetime, but direct I/O should used Linux IO priority API to specify
> the same?
> 
> Because, to me that seems to be how the series is currently working.
> (I am sorry if I am missing something.)

Let's drop support for passing the data lifetime in the I/O priority
field from user space as Damien proposed. The remaining question is
whether only to restore support for F_SET_RW_HINT (per inode) or also
for F_SET_FILE_RW_HINT (per file)?

Thanks,

Bart.

