Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2654C001DC
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 20:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjGZUKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 16:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjGZUKk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 16:10:40 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1F112D54;
        Wed, 26 Jul 2023 13:10:13 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1152)
        id 79DC12383121; Wed, 26 Jul 2023 13:10:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 79DC12383121
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1690402213;
        bh=v9Ru5Fve35C7Z1Toy6pZJ0CeTADZeQV0Hv8hBNlOAh4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=mDffDAlNHmkg7IieLpRPyms9IEYX0q80BejfwEuKgb7OfLvEqWpkAiPibufKSh0PH
         zCEGOPML5eVhLJiLI13On9L4qm+iSrfosSuag0nwmZoelxd0NRkVdCzxjNkZIgKxcU
         JgedsL4M0TWWCNZdAez+D/i6A3EAHr6WpN1aG2L8=
Received: from localhost (localhost [127.0.0.1])
        by linux.microsoft.com (Postfix) with ESMTP id 768F13070325;
        Wed, 26 Jul 2023 13:10:13 -0700 (PDT)
Date:   Wed, 26 Jul 2023 13:10:13 -0700 (PDT)
From:   Shyam Saini <shyamsaini@linux.microsoft.com>
To:     Randy Dunlap <rdunlap@infradead.org>
cc:     linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, linux-scsi@vger.kernel.org,
        =?ISO-8859-15?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Tyler Hicks <code@tyhicks.com>,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>,
        Paul Moore <paul@paul-moore.com>,
        Allen Pais <apais@linux.microsoft.com>
Subject: Re: [RFC, PATCH 1/1] rpmb: add Replay Protected Memory Block (RPMB)
 driver
In-Reply-To: <233853ab-235b-d4dd-cd69-588d1a83ce4f@infradead.org>
Message-ID: <e727c5c9-58c1-5d14-99c1-5d9a62998b5@linux.microsoft.com>
References: <20230722014037.42647-1-shyamsaini@linux.microsoft.com> <20230722014037.42647-2-shyamsaini@linux.microsoft.com> <233853ab-235b-d4dd-cd69-588d1a83ce4f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Hi Randy,

Thank you for the reviews.

> Hi--
>
> On 7/21/23 18:40, Shyam Saini wrote:
>> diff --git a/drivers/rpmb/Kconfig b/drivers/rpmb/Kconfig
>> new file mode 100644
>> index 000000000000..f2a9ebdc4435
>> --- /dev/null
>> +++ b/drivers/rpmb/Kconfig
>> @@ -0,0 +1,11 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2015-2019, Intel Corporation.
>> +
>> +config RPMB
>> +	tristate "RPMB partition interface"
>> +	help
>> +	  Unified RPMB partition interface for RPMB capable devices such as
>> +          eMMC and UFS. Provides interface for in kernel security controllers to
>
> Indent the line above with one tab + 2 spaces instead of many spaces.
>> +	  access RPMB partition.
>> +
>> +	  If unsure, select N.
>
> Do we want a separate subdir in drivers/ for various "misc" drivers?
> with only one driver in it?
>
> Will there be other drivers in rpmb?
>

There may be others as the usage of rpmb driver grow over time but for 
now, this is the only  driver.
Should i keep it like this ?[A

Thanks,
Shyam

