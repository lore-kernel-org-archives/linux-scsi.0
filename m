Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E08C2D0CE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 05:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D8242072C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 05:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgAXF40 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 00:56:26 -0500
Received: from relay.sw.ru ([185.231.240.75]:51164 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726695AbgAXF4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 00:56:25 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iurx5-0007jW-5P; Fri, 24 Jan 2020 08:56:19 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 0/1] snic: seq_file .next functions should increase position
 index
To:     linux-scsi@vger.kernel.org
Cc:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Message-ID: <48bbb2cf-35ed-62f9-7a4b-c8813db41c99@virtuozzo.com>
Date:   Fri, 24 Jan 2020 08:56:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In Aug 2018 NeilBrown noticed 
commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
"Some ->next functions do not increment *pos when they return NULL...
Note that such ->next functions are buggy and should be fixed. 
A simple demonstration is
   
dd if=/proc/swaps bs=1000 skip=1
    
Choose any block size larger than the size of /proc/swaps.  This will
always show the whole last line of /proc/swaps"

Described problem is still actual. If you make lseek into middle of last output line 
following read will output end of last line and whole last line once again.

$ dd if=/proc/swaps bs=1  # usual output
Filename				Type		Size	Used	Priority
/dev/dm-0                               partition	4194812	97536	-2
104+0 records in
104+0 records out
104 bytes copied

$ dd if=/proc/swaps bs=40 skip=1    # last line was generated twice
dd: /proc/swaps: cannot skip to specified offset
v/dm-0                               partition	4194812	97536	-2
/dev/dm-0                               partition	4194812	97536	-2 
3+1 records in
3+1 records out
131 bytes copied

There are lot of other affected files, I've found 30+ including
/proc/net/ip_tables_matches and /proc/sysvipc/*

Following patch fixes the problem in snic-related file

https://bugzilla.kernel.org/show_bug.cgi?id=206283

Vasily Averin (1):
  snic_trc_seq_next should increase position index

 drivers/scsi/snic/snic_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

-- 
1.8.3.1

