Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ADDECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 22:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiISWBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 18:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiISWBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 18:01:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671B643608
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 15:01:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f23so506411plr.6
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 15:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=/fDIlVBd47B2jM9f1hUU3tgxPZTDFt3MweaoxgcPRcs=;
        b=Nb9Z/3eQEK4HqIVd7gPneEnwD+27OJmRYuyKVU6kG/k9Y+Ebs3cB9bNhdWZnfkooKB
         lIZHLUGvcGd7KZWUVPrwJaASaHHb4JKLKhLNrAe3S4RYQhMcPVD8qDE94QODbA3pdkqz
         GgCLJ56Mdoh8iQwcogfjBnQPQA/pIVd8X6cypB5dbvHIAy6FQf4H3BWnaNKUsvo4ToFv
         gRTUJOGhMjZJbcVyIKICJyXKBHTNiFyjPqgwRWRucj3w4b7wYurEhLWzbDhp8UM8C2gx
         ae4oUD+ec2s0XGVOvQKNYXaTvnbM8ktnqTBWIRSsshcqJiZq732gmPIwI8kNCSbh43Df
         lLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/fDIlVBd47B2jM9f1hUU3tgxPZTDFt3MweaoxgcPRcs=;
        b=CjIANwvbADGixpki2QFulQnR3zj4vR0L53AkBQpgK3VhSKVVtt8xgfywW13Ew3c6C8
         K7IxdHobjFAhV/YFFbRP6DkBVuRVnrAVk65Y0eiThWjRSgOmoNOjcryjvxu9MpZv9Nk0
         RQMW59yHNMaSz5BXAn+LkCH3CKwob10nKYtACMZwkSEM/LF/0B8XrWA7gtmR5SabHG+e
         MIT4y7LsB1iRSEakpWCBCUA6TrJ/NDNPcKAJM2VxiSADkhw0NQVXhlFbkwsCor9jML59
         UM9n1xjHfccyaDf5eQ+KmAS+9878RxfoywCD2BRjVutpMtY3EoZnZMoYaT89IYzV+sfo
         vGdA==
X-Gm-Message-State: ACrzQf008eM/LgMVRJzxLfmRpjNg4oZZ8IqUbq6v6uMew2KL68DCyUpi
        NF3O6pkLtLD6sx5vLxy16CI=
X-Google-Smtp-Source: AMsMyM5ijX8eeAJcRG/bLuKxSShGdVkCzlPok3QXXHV868d0xNzCBA205AyCXojv6DWharVSMq25RA==
X-Received: by 2002:a17:90a:c258:b0:202:b93b:cb89 with SMTP id d24-20020a17090ac25800b00202b93bcb89mr331816pjx.126.1663624871850;
        Mon, 19 Sep 2022 15:01:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902cecc00b0017305e99f00sm21428504plg.107.2022.09.19.15.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 15:01:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 19 Sep 2022 15:01:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, bhazarika@marvell.com,
        agurumurthy@marvell.com
Subject: Re: [PATCH v2 5/7] qla2xxx: Enhance driver tracing with separate
 tunable and more
Message-ID: <20220919220110.GA352230@roeck-us.net>
References: <20220826102559.17474-1-njavali@marvell.com>
 <20220826102559.17474-6-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826102559.17474-6-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 26, 2022 at 03:25:57AM -0700, Nilesh Javali wrote:
> From: Arun Easi <aeasi@marvell.com>
> 
> Older tracing of driver messages was to:
>     - log only debug messages to kernel main trace buffer AND
>     - log only if extended logging bits corresponding to this
>       message is off
> 
> This has been modified and extended as follows:
>     - Tracing is now controlled via ql2xextended_error_logging_ktrace
>       module parameter. Bit usages same as ql2xextended_error_logging.
>     - Tracing uses "qla2xxx" trace instance, unless instance creation
>       have issues.
>     - Tracing is enabled (compile time tunable).
>     - All driver messages, include debug and log messages are now traced
>       in kernel trace buffer.
> 
> Trace messages can be viewed by looking at the qla2xxx instance at:
>     /sys/kernel/tracing/instances/qla2xxx/trace
> 
> Trace tunable that takes the same bit mask as ql2xextended_error_logging
> is:
>     ql2xextended_error_logging_ktrace (default=1)
> 
> Suggested-by: Daniel Wagner <dwagner@suse.de>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>

I understand this has already been reported early September, but then
the problem disapppeared in next-20220912 and reappeared in next-20220919.

This patch results in various test build failures. Example:

Building powerpc:skiroot_defconfig ... failed
--------------
Error log:
drivers/scsi/qla2xxx/qla_os.c: In function 'qla_trace_init':
drivers/scsi/qla2xxx/qla_os.c:2854:25: error:
	implicit declaration of function 'trace_array_get_by_name'; did you mean 'trace_array_set_clr_event'?

Guenter
