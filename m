Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4310C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 23:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiG1XV6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 19:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiG1XV5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 19:21:57 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75331785A2;
        Thu, 28 Jul 2022 16:21:56 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d3so3092665pls.4;
        Thu, 28 Jul 2022 16:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U3pJdNhePEo9hth/113iycczw4DBBeF7BiqgKMucFx0=;
        b=udXC4RaAl5AnkXflId+v86Q7hwMa8IG9mXOJXdHgT4CkTClYaiWDF6drvpv+97xsUW
         W5lDn2/8ZsOoYyPujpJdhxUPY1jMPL87yOe9iZaQFBuWMqBuuaRdQS07jOrnX4rjzLe8
         JayA791kbSPr4Pl6nJcaTQnuNfYcmvunnDWTpKbPbysr245PYeTBYDs8YZs3ar+HAgvA
         kQcpyjegR7i8oXD7ZnZKC9QGfOHXMWSGERNFql2Zm5IUE9P6rye7/AeTZr6m2GnSp1l0
         Vxf1AOZUi+04unYRkFNqjHAWGm+8mAeSEm8VetFeDe1nDMLtrrwc9n3u250I1QzKQSet
         Y6Jw==
X-Gm-Message-State: ACgBeo050KTZyOdxRIXBKaBvcTOHEmktHfDLAKQBGgjZjMctadsohkCP
        dXVBZQoldpSFreaH9aERIQs=
X-Google-Smtp-Source: AA6agR6uFt4omG0uhKsDhbZHvcoRf9RopZi9V4vaDiRjjcIdnqDGAcmX0bdaC6ELq/Vt3mqp6jKLEA==
X-Received: by 2002:a17:903:2351:b0:16d:9468:bb02 with SMTP id c17-20020a170903235100b0016d9468bb02mr1080309plh.82.1659050515776;
        Thu, 28 Jul 2022 16:21:55 -0700 (PDT)
Received: from ?IPV6:2620:0:1000:2514:ec20:15e1:edc2:6f55? ([2620:0:1000:2514:ec20:15e1:edc2:6f55])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b0016dbaf3ff2esm2001469plg.22.2022.07.28.16.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 16:21:55 -0700 (PDT)
Message-ID: <30eea4f3-65b7-688a-ef55-69d589d62b00@acm.org>
Date:   Thu, 28 Jul 2022 16:21:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ufs: core: print capabilities in controller's sysfs node
Content-Language: en-US
To:     Daniil Lunev <dlunev@chromium.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220728144710.1.Id612b86fd30936dfd4c456b3341547c15cecf321@changeid>
 <28005e66-ba90-8986-1b8f-b76bba46064c@acm.org>
 <CAONX=-d-_2bXqf0TCjdJ1u+B3cU3ZkP9WCu3QxqSZT-v3E_4BQ@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAONX=-d-_2bXqf0TCjdJ1u+B3cU3ZkP9WCu3QxqSZT-v3E_4BQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/28/22 16:08, Daniil Lunev wrote:
> On Thu, Jul 28, 2022 at 11:37 PM Bart Van Assche <bvanassche@acm.org> wrote:
>> This code change includes all of the UFSHCD_CAP_* constants in the
>> kernel ABI. Is that really what we want? I'm wondering whether it
>> perhaps would be better only to export those capabilities to user space
>> that user space needs to know about.
> Adding the filtering would introduce an extra maintenance burden and
> will likely go out
> of sync. I don't see harm in exposing all capabilities, both intrinsic
> to the controller and
> negotiated with the device. Do you see any scenario where that would be harmful?

Please only export what you need instead of exporting all capabilities.

Thanks,

Bart.

