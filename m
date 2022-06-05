Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70E7CCA47B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jun 2022 18:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346778AbiFESPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jun 2022 14:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiFESPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jun 2022 14:15:21 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A8C4E3A8;
        Sun,  5 Jun 2022 11:15:18 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so16076141pjl.4;
        Sun, 05 Jun 2022 11:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XSlVkyH7U19xGkYlKr/QL4qLZZfZicYNepi5FhO2rEw=;
        b=FilqbPU4Vbkp8rROaouKUX7VSkd4uz2WvmDlDJJwkGK620i8niF0GR3e6iC3piV6nI
         cW6razdzK9jeb0hjRVfmElRuBJoyCALlkzuzi4Y70WkmEpBrJVoD82o0av3kqdQC5i+x
         g4dLNeh+hS3SoGRjyEjN1lv8ypv/AvYE3oAAHiSMTBHz/rkSngj33XCGI659rbcGwOMv
         y4Qi9/KJbSmdnS/t9Dx7eNLjpDvCz2enhMwVAFYgD8q7eWZRInhiPy3xrYr7xJNLMfEI
         SpkyEfOw6noXZpyZJxcuK8c+LO8DNTeeKLKEAEmRgw2DhCWnMKoofV9KS3zDGfYnBn/B
         coWw==
X-Gm-Message-State: AOAM5339jyDm3Y8Tf+dfns0qtiU+RDfORQU6DMJvp6EOP+7rrZaPrT0r
        p+/WrkAtlj0S6PjsY4By0hc=
X-Google-Smtp-Source: ABdhPJzwmoB07s/jOnk8v4k4T/5zMb0rCKNH1kw1FFfezoahiovaXCjjQpB7yOYVhdgpQekTAqpCEA==
X-Received: by 2002:a17:902:ef49:b0:15e:b6ed:4832 with SMTP id e9-20020a170902ef4900b0015eb6ed4832mr19851455plx.173.1654452917814;
        Sun, 05 Jun 2022 11:15:17 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id y189-20020a6264c6000000b0050dc762814asm9061560pfb.36.2022.06.05.11.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jun 2022 11:15:16 -0700 (PDT)
Message-ID: <09be5981-705a-5c82-a189-dd7f0475d227@acm.org>
Date:   Sun, 5 Jun 2022 11:15:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [dm-devel] [PATCH 0/8] Use block pr_ops in LIO
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <923053d3-adf8-e4b4-9ef3-8e920ae90a79@acm.org>
 <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d18d9e19-d184-357c-9921-d024f0b50d1a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/22 09:55, Mike Christie wrote:
> libiscsi is not suitable for this type of setup.
I think that this setup can be tested as follows with libiscsi:
* Configure the backend storage.
* Configure LIO to use the backend storage on two different servers.
* On a third server, log in with the iSCSI initiator to both servers.
* Run the libiscsi iscsi-test-cu test software on the third server and
   pass the two IQNs that refer to the LIO servers as arguments.

 From the iscsi-test-cu -h output:

     iscsi-test-cu [OPTIONS] <iscsi-url> [multipath-iscsi-url]

Did I perhaps overlook or misunderstand something?

Thanks,

Bart.
