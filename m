Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375BEC38A2A
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 18:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F902080C
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 18:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgEJSc5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 14:32:57 -0400
Received: from smtp.infotech.no ([82.134.31.41]:54913 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgEJSc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 14:32:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id CD7DF20423B
        for <linux-scsi@vger.kernel.org>; Sun, 10 May 2020 20:32:54 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zmTAaIx2yt9K for <linux-scsi@vger.kernel.org>;
        Sun, 10 May 2020 20:32:48 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 9601C204165
        for <linux-scsi@vger.kernel.org>; Sun, 10 May 2020 20:32:48 +0200 (CEST)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: scsi_alloc_target: parent of the target (need not be a scsi host)
Message-ID: <59d462c4-ceab-041a-bbb5-5b509f13a123@interlog.com>
Date:   Sun, 10 May 2020 14:32:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This gem is in scsi_scan.c in the documentation of that function's first
argument.
"need not be a scsi host" should read "it damn well better be a scsi host"
otherwise that function will crash and burn!

I'm trying to work out why the function: starget_for_each_device() in scsi.c
does _not_ use that collection right in front of it (i.e.
scsi_target::devices). Instead, it step up to the host level, and iterates
over all devices (LUs) on that host and only calls the given function for
those devices that match the channel and target numbers. That is bizarrely
wasteful if scsi_target::devices could be iterated over instead.

Anyone know why this is?

Doug Gilbert
