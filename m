Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBF0C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 21:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8790D6198A
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 21:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhC2VRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 17:17:08 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:37855 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231300AbhC2VRF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 17:17:05 -0400
Received: from [192.168.0.2] (ip5f5aef67.dynamic.kabel-deutschland.de [95.90.239.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7B0EA206479C0;
        Mon, 29 Mar 2021 23:16:59 +0200 (CEST)
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
To:     Don.Brace@microchip.com, john.garry@huawei.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        joseph.szczypek@hpe.com, POSWALD@suse.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        buczek@molgen.mpg.de, gregkh@linuxfoundation.org,
        ming.lei@redhat.com
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
 <160763254769.26927.9249430312259308888.stgit@brunhilda>
 <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
 <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
 <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
 <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
 <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
 <SN6PR11MB2848ECDD666F0BF867AE04DFE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
 <6fea70bb-1718-ad02-789b-8e908f57951e@huawei.com>
 <SN6PR11MB2848D1442DE98A85A7B8B89EE18D9@SN6PR11MB2848.namprd11.prod.outlook.com>
 <c0d94b4d-b8d8-0b1a-a096-81eac68b4af4@molgen.mpg.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <00a52885-62d8-7bfd-cc78-3321a717b5ca@molgen.mpg.de>
Date:   Mon, 29 Mar 2021 23:16:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <c0d94b4d-b8d8-0b1a-a096-81eac68b4af4@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[Resent from correct address.]

Am 29.03.21 um 23:15 schrieb Paul Menzel:
> Dear Linüx folks,
> 
> 
> Am 10.02.21 um 17:29 schrieb Don.Brace@microchip.com:
>> -----Original Message-----
>> From: John Garry [mailto:john.garry@huawei.com]
>> Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
>>
>>> I think that this can alternatively be solved by setting .host_tagset 
>>> flag.
>>>
>>> Thanks,
>>> John
>>>
>>> Don: John, can I add a Suggested-by tag for you for my new patch 
>>> smartpqi-use-host-wide-tagspace?
>>
>> I don't mind. And I think that Ming had the same idea.
> 
>> Don: Thanks for reminding me. Ming, can I add your Suggested-by tag?
> 
> It looks like, iterations 4 and 5 of the patch series have been posted 
> in the meantime. Unfortunately without the reporters and discussion 
> participants in Cc. Linux upstream is still broken since version 5.5.
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> [1]: https://lore.kernel.org/linux-scsi/161540568064.19430.11157730901022265360.stgit@brunhilda/
> [2]: https://lore.kernel.org/linux-scsi/161549045434.25025.17473629602756431540.stgit@brunhilda/
