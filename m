Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F4CC11D0C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 17:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D87B206F4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 17:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBTRJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:09:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:57502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgBTRJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 12:09:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 42E7CAEE2;
        Thu, 20 Feb 2020 17:09:54 +0000 (UTC)
Subject: Re: ioctl seems to change errno behaviour in 5.6.0rc2
To:     dgilbert@interlog.com
Cc:     linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <68516393-f24a-dbb5-4c81-99fb1b70bb6f@suse.de>
 <3b6cf3fb-675e-fdea-590e-31d73ccab4cd@interlog.com>
From:   Antonio Larrosa <alarrosa@suse.de>
Autocrypt: addr=alarrosa@suse.de; prefer-encrypt=mutual; keydata=
 mQGiBD8pc34RBADax1+cDEPv04aOUxFQ1N947ZeER5rbOwA4THsMnFbdJd3cQealCk3SkGx/
 1CkHCAp8MKmIFWg73zDWBjyWJ4OMPkfhsSZRSW2LgQ6XAEylnZJjrmldBOF/6mrvaGhtTtrs
 F0FXsqO12QpljCb5O0pqKZbsUcaZETqkFcMM9/9ijwCgxVq/f3znU/gbfKcKs2dKwWdD4UkE
 AKQZoP0WIlGplrWLd+FVY0ElvxPqamKrGLsEnoSfjk7N+hjo5QqWRhNMhjhIE+ghur2EP9lD
 PmCHXuXuPfg9O26SdW3ea6zxeUsj7tfsN3loEbTZ45oEULwVv6FM3Jnk7sYr8+GwUoar0ZjY
 W+MtEnV5tLLQv9v1b72QT4YDrpAiA/9W7FNMmN8g6a9YM1vzjUO17xEA0xOe0UgraiFe3Ag4
 IMKoICvll666LjHCwqATjYtYoZ9Bvmc4EMyAHyIlj3/gwQGTfabmNzt70uUu0/+rmdF683KK
 48riI/tEw4QWDQvKShSuVNlwa8Q+2ZhLGTY3xByHBvU9yT6PS9398gobZbQrQW50b25pbyBM
 YXJyb3NhIEppbcOpbmV6IDxhbGFycm9zYUBzdXNlLmRlPohjBBMRAgAjBQJSAKP/AhsDBwsJ
 CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQ3mWkZZAItZAMJACfePOU9E2m5r8UKeuhoOUV
 ov8VE+AAoLfpxeB3YJAD5Sk8g0XEQ6U/IRSnuQINBD8pc4cQCACaRlpl+4QHEOcT4BdHFvwl
 rUYIPkHkQGqFQdBx1+9lo7F1FMRVnqe1HF4MTNPaWIjcze3TbeTh5XMhNgdT3zEyilPu3oQ7
 HcKvBigQOqfzLLhs3ay+2A+Rhv2HJd+V8RUb5go0SK4VnOyFtmA4P7t805HYVvLiV9c8dyOt
 kpuazNKqzpmz0bWIcoTli0FWekPkEmzwiU0AcRPO0ftRYVv4oIf/Rf7ReeQN1EK2gYRc902R
 W6mVRZthfllUXtAVb1M/hXTagu9s/jXYngE7ld7FtJ4ZicFwkrx14ko/08ZnbY/Vpfgu4QU3
 ze72Dl/4gNksLKIM47V+xprtMyNr5rg7AAMFB/9KPipiSB6Kxh8loHb9Wki2SzPnK5JQxU2s
 IBYXa88M8az2qjq3SkrBP7ckHGiqswzIF70gdUYrH4q7jNMpAikI1ABo+sHnCMYRgamZnfft
 EJSsrGKhnj0+VsYTlf9d+YxoWHfi4bkhidySD7evA/kmW4lQoX8zTjw1sqgqIFxeBmYizhMy
 prlxBBc7AGPy+ZSH0kvgH3XgiAz5+iUw5XibccJha7SfHztmMM/swxTQNLSp0bOyWfrR56lw
 D43kfUVx0SFSy/YqtEUN/PwW0n5pxa5mOmZMdFwKih/31kL2F7EwN5pmN+D6ECkKCiJMeYCn
 YEq8X+S1iZzz8rms4lUYiEYEGBECAAYFAj8pc4cACgkQ3mWkZZAItZA0QQCdGIzCpf1tHypW
 +d3i2kPyMOeZ80MAmwZBSIo8R9KruBK9rohkjiDfFDvV
Message-ID: <ed84f68e-b002-6e65-9eae-c05ccf9fb1c3@suse.de>
Date:   Thu, 20 Feb 2020 18:09:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3b6cf3fb-675e-fdea-590e-31d73ccab4cd@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/2/20 17:30, Douglas Gilbert wrote:
> Antonio,
> A fix is in the works for this, see:
>    [PATCH] compat_ioctl, cdrom: Replace .ioctl with .compat_ioctl in four
> appropriate places
> 
> by Arnd Bergmann on the linux-scsi list.
> 

Ah, perfect. Thanks!

-- 
Antonio Larrosa
