Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2EDCDB482
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 16:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjJPQmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 12:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbjJPQlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 12:41:35 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3038A326A;
        Mon, 16 Oct 2023 09:31:47 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-27d3ede72f6so2728652a91.1;
        Mon, 16 Oct 2023 09:31:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697473907; x=1698078707;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KL3q4yZoEsvjsIInfUFjyucSavgtJVlbTvr/TIm7W9M=;
        b=DMhnF4Vl0IE9kho3rnvqFFptGvGYr6CfBIjLgW5ajqSUZLzbQ1H03gE2tNb8+ysDvn
         zQL6MrVDM0zV+pEmpzqs3XkJcbUaSjRenVv3JMVGfp2e3ofH+5eNROXtB9VnROKxaVl1
         EV7D0CRO1zYbmYL0EjOlKs2pwhiY8QS/J7CxMT7TUXVBVgr45HEU0h9MjERtnf1cYJlK
         sZ+v5Y3mDgu3FFdewq7lEtQnrmSRPoUmREf9hFDctHoIlmj9/piJb2TqJfAcWNY2Dlfp
         dlFYGtK8jCjTdxd1/9lva5LHL0C8CQk2rhpRRlk4KG68v9paEhqUPN6NWOmsnyOLp2o0
         sNbA==
X-Gm-Message-State: AOJu0YyXZeyWlu1jtQP70qmDMF9aHZ90ivK1Y69NQslvGJS/NSddMrlO
        gjUOTh03/usuy0gvMltnNFk=
X-Google-Smtp-Source: AGHT+IHBoIei1kVZRai55+z54yFvDXbDAVVCpmNJINHI0AV8rvHsDaC3rY2PGDbozVvIQ/NU9ORQ7w==
X-Received: by 2002:a17:90a:ea01:b0:27c:f845:3e3f with SMTP id w1-20020a17090aea0100b0027cf8453e3fmr17279841pjy.1.1697473906854;
        Mon, 16 Oct 2023 09:31:46 -0700 (PDT)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id rr7-20020a17090b2b4700b00268b9862343sm4917723pjb.24.2023.10.16.09.31.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 09:31:45 -0700 (PDT)
Message-ID: <afe6fc1b-89c9-44b3-aec7-eb1d32f44a5c@acm.org>
Date:   Mon, 16 Oct 2023 09:31:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/15] block: Support data lifetime in the I/O priority
 bitfield
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
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
 <94c58f6a-cdbf-4718-b60f-ba4082a040b5@acm.org>
 <69c5d947-27a1-4feb-b823-35e33d86f74c@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <69c5d947-27a1-4feb-b823-35e33d86f74c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/23 15:22, Damien Le Moal wrote:
> Given that lifetime is per file (inode) and IO prio is per process or per I/O,
> having different user APIs makes sense. The issue of not growing (if possible)
> the bio and request structures remains. For bio, you identified a hole already,
> so what about using another 16-bits field for lifetime ? Not sure for requests.
> I thought also of a union with bi_ioprio, but that would prevent using lifetime
> and IO priority together, which is not ideal.

There is a challenge: F_SET_RW_HINT / F_GET_RW_HINT are per inode and
hence submitting direct I/O with different lifetimes to a single file
by opening that file multiple times and by using F_SET_FILE_RW_HINT
won't be possible. fio supports this use case. See also fio commit
bd553af6c849 ("Update API for file write hints"). If nobody objects I
won't restore F_SET_FILE_RW_HINT support.

Furthermore, I plan to drop the bi_ioprio changes and introduce a new u8
struct bio member instead: bi_lifetime. I think 8 bits is enough since
the NVMe and SCSI data lifetime fields are six bits wide.

There is a two byte hole in struct request past the ioprio field. I'd
like to use that space for a new data lifetime member.

Thanks,

Bart.
