Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A522C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 20:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F5C64ECE
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 20:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBAU6S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 15:58:18 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:48670 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhBAU6R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 15:58:17 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 1B2712EA084;
        Mon,  1 Feb 2021 15:57:36 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id v-OmWA89mqNO; Mon,  1 Feb 2021 15:43:04 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 925B82EA08D;
        Mon,  1 Feb 2021 15:57:35 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 0/4] io_uring iopoll in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
References: <20210201051619.19909-1-kashyap.desai@broadcom.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <ed737c08-e382-5654-09d6-0948b9411aac@interlog.com>
Date:   Mon, 1 Feb 2021 15:57:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210201051619.19909-1-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-01 12:16 a.m., Kashyap Desai wrote:
> This patch series is to support io_uring iopoll feature
> in scsi stack. This patch set requires shared hosttag support.
> 
> This patch set is created on top of 5.12/scsi-staging branch.
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/mkp/scsi/+/refs/heads/5.12/scsi-staging

Hi,
I don't understand how this patchset works. My testing shows
scsi_debug is broken and I will be sending a correcting patch
shortly (similar to the one I sent you on 20210108).

The scsi_debug driver is a simplified LLD that needs to know in
advance whether a request/command issued to it will be using the
.mq_poll callback. Perhaps you have found another way but one
simple way to find that out is this test:
    if (request->cmd_flags & REQ_HIPRI)

In the case of scsi_debug (after my patch) the delay associated with
the command is not wired up to generate an event which leads to
completion. Instead, callbacks through .mq_poll are expected and
they will check if that delay has expired, if not the callback returns
0. When the delay has expired and a .mq_poll is received then completion
occurs.

Doug Gilbert

> v3 ->
> - added reviewed-by tag
> - Fix comment provided by Hannes for below patch.
> https://patchwork.kernel.org/project/linux-scsi/patch/20201203034100.29716-3-kashyap.desai@broadcom.com/
> - Fix Functional issue of poll_queues settings not working in v2.
> 
> v2 ->
> - updated feedback from v1.
> - added reviewed-by & tested-by tag
> - remove flood of prints in scsi_debug driver during iopoll
>    reported by Douglas Gilbert.
> - added new patch to support to get shost from hctx.
>    added new helper function "scsi_init_hctx"
> 
> v1 ->
> Fixed warnings in scsi_debug driver.
> Reported-by: kernel test robot <lkp@intel.com>
> 
> Kashyap Desai (4):
>    add io_uring with IOPOLL support in scsi layer
>    megaraid_sas: iouring iopoll support
>    scsi_debug : iouring iopoll support
>    scsi: set shost as hctx driver_data
> 
>   drivers/scsi/megaraid/megaraid_sas.h        |   3 +
>   drivers/scsi/megaraid/megaraid_sas_base.c   |  87 +++++++++++--
>   drivers/scsi/megaraid/megaraid_sas_fusion.c |  42 ++++++-
>   drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +
>   drivers/scsi/scsi_debug.c                   | 130 ++++++++++++++++++++
>   drivers/scsi/scsi_lib.c                     |  29 ++++-
>   include/scsi/scsi_cmnd.h                    |   1 +
>   include/scsi/scsi_host.h                    |  11 ++
>   8 files changed, 291 insertions(+), 14 deletions(-)
> 
> 
> base-commit: a927ec3995427e9c47752900ad2df0755d02aba5
> 

