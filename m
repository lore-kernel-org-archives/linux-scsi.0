Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE666C49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B956613F2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 17:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhFXR3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 13:29:42 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:40564 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229573AbhFXR3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 13:29:42 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 242974244B;
        Thu, 24 Jun 2021 17:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-type:content-type
        :content-language:accept-language:in-reply-to:references
        :message-id:date:date:subject:subject:from:from:received
        :received:received:received; s=mta-01; t=1624555641; x=
        1626370042; bh=0azvXi0tVbaBc9x9cnLK2kI5DckMx0jtgixtgYnLhcs=; b=B
        +5eMxEZ3vTl+S2N7+B9PVX0RIrjTl/2ytVIEbLjtOQ4aOYpRs96Cas2WLlfajD4C
        pshbG3RONF0k8W4Aqr5CXstJcldfja9CpT7sWjZ+M0Pr1siWTjhJytLk8yJb/4Am
        szU3/Z9JaWAWey0eQFX6VPS7Bwd+Do+Bc0fUZTPhNw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kCuJ7nBGOoVl; Thu, 24 Jun 2021 20:27:21 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id EF52A42C03;
        Thu, 24 Jun 2021 20:27:20 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 24 Jun 2021 20:27:20 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Thu, 24 Jun 2021 20:27:20 +0300
From:   Sergey Samoylenko <s.samoylenko@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: RE: [PATCH 1/1] scsi: target: core: Fix sense key for invalid XCOPY
 request
Thread-Topic: [PATCH 1/1] scsi: target: core: Fix sense key for invalid XCOPY
 request
Thread-Index: AQHXaOr0HC/8j5iIqkSi3dBQXUYXPKsjHzmAgABFBmA=
Date:   Thu, 24 Jun 2021 17:27:20 +0000
Message-ID: <ddf079075d234fc09e524e5485b84ec7@yadro.com>
References: <20210624111926.63176-1-s.samoylenko@yadro.com>
 <20210624111926.63176-2-s.samoylenko@yadro.com>
 <5981680f-96ad-3c4e-6640-c3cca709a57c@acm.org>
In-Reply-To: <5981680f-96ad-3c4e-6640-c3cca709a57c@acm.org>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.199.0.253]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thank you Bart,

I used API (target_complete_cmd_with_sense) which is not in
mainline kernel. I need to change the patch.
Sorry, this is my mistake.

Sergey.

>On 6/24/21 4:19 AM, Sergey Samoylenko wrote:
>> +	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, sense: %u,"
>> +		" XCOPY operation failed\n", rc, sense_rc);
>
>Please do not split format strings across multiple lines. Checkpatch
>should have complained about this.
>
>Thanks,
>
>Bart.
