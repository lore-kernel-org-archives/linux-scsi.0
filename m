Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4BEC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74D32072E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 16:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgFDQIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:08:43 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50226 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgFDQIn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 12:08:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 97CE820418F;
        Thu,  4 Jun 2020 18:08:41 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5YWujgusVdr1; Thu,  4 Jun 2020 18:08:40 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id CB53B20417A;
        Thu,  4 Jun 2020 18:08:39 +0200 (CEST)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: RFC: split struct scsi_device in two
Message-ID: <5bcc1fee-e221-e54a-d754-d04a2e6fda33@interlog.com>
Date:   Thu, 4 Jun 2020 12:08:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_device structure seems to be carrying around a lot of baggage.
Assuming the object needs to be present on the SCSI fast path then
making it smaller will help in fitting one or several of them in cache
lines.

Now the effort to use xarrays is helping, but only in the order 32 bytes
at the moment. Currently we have pointers to the standard inquiry response
and several VPD pages with more VPD pages to come, I suspect.

So what about having a secondary scsi_device object (with a more
descriptive name) for all those parts of the currect scsi_device
object that aren't needed for the fast path? The secondary object
could be created in scsi_alloc_sdev() and pointed to by the
primary object (and vice versa). Then adding more context info
(e.g. more VPD pages) will not burden the fast path.

sizeof(struct scsi_device)=1976 bytes!

Comments?

Doug Gilbert

