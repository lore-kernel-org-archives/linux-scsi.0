Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFB7C0015E
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 18:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjHASUx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 14:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjHASUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 14:20:52 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4822A2130;
        Tue,  1 Aug 2023 11:20:51 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1b8b4748fe4so38793105ad.1;
        Tue, 01 Aug 2023 11:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690914051; x=1691518851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mx0QeeCngHy8pmd0MxcJwctX6+06VaNgSrv/KxKgvSA=;
        b=SPX/acws7sboGF7OvLtTJOnXdqBQ4ZGUeEH4RVY3/UadWaGUZ4e0ZTgy/7hNYhHex0
         NYgE2mrKkJdOR1NQty9y64aTCcPVnpI0NeaEfSSX8Td0sF+HLRXK2oEHHQvolD8+wiI9
         Uqdc8lfShcq/Gx3UUXAE8kScDULyWn8KTc14cgmhwoUeLgkQ10685gu88uKUmldDu/tp
         QGSfDsTXI5lkFnMCFNQV9EDP1wEW795GibzO2HHzRuL73tGi4In3rL7SPIn0BMawniSs
         LuuSZS+6+ba94JedHyERi5iZezeFTD8+TSPa1JVN8ZSH+ZtzPww6js7GjEYu4VWa2dBa
         ZMzg==
X-Gm-Message-State: ABy/qLbFjdz8qVxjpoaODixuVhcDgbRdAThVI6BeGnyIGW6lapsuA52d
        DT3egmmAzrrNCRjBwng3qPcoc+zR2ss=
X-Google-Smtp-Source: APBJJlFiBhJU4L+649hXEC4AYZgqCKPybeuiI9xgjhWK9Py+zKHilDIeS26Nudl9vWLNqk9XjbwLuw==
X-Received: by 2002:a17:902:eccf:b0:1b8:6b17:9093 with SMTP id a15-20020a170902eccf00b001b86b179093mr15114539plh.1.1690914050632;
        Tue, 01 Aug 2023 11:20:50 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c14c00b001b86dd825e7sm10785031plj.108.2023.08.01.11.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 11:20:49 -0700 (PDT)
Message-ID: <9bb7ac58-db99-238f-0d2c-450470f05c74@acm.org>
Date:   Tue, 1 Aug 2023 11:20:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for QEMU
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>, jeuk20.kim@samsung.com
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "dlunev@chromium.org" <dlunev@chromium.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <48f05875-5255-70d2-0737-36fa95470037@intel.com>
 <20230801073750epcms2p121c08e452aaafdda301c5562f4ccff5b@epcms2p1>
 <CGME20230801073750epcms2p121c08e452aaafdda301c5562f4ccff5b@epcms2p4>
 <20230801092000epcms2p44c99d2c15bc6169e38693cb64cf946db@epcms2p4>
 <3551d65c-2295-b6cd-b5b1-9264026cff61@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3551d65c-2295-b6cd-b5b1-9264026cff61@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:12, Adrian Hunter wrote:
> I was really hoping for an explanation of "Why?" i.e.
> why does anyone want a virtual UFS device?  Why not use
> any existing virtual block device?

I hope this will enable testing of the UFS driver inside a virtual machine
on systems without UFS host controller. Jeuk, is that correct?

Thanks,

Bart.
