From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: sd: add new match array for cache_type
Date: Tue, 30 Jan 2018 22:22:41 -0500
Message-ID: <yq1lggeempq.fsf@oracle.com>
References: <20180123144439.GA15247@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbeAaDWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 22:22:52 -0500
In-Reply-To: <20180123144439.GA15247@localhost.didichuxing.com> (weiping
        zhang's message of "Tue, 23 Jan 2018 22:44:44 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


Weiping,

> add user friendly command strings sd_wr_cache to enable/disable
> write&read cache. user can enable both write and read cache by one of
> the following commands:

I remain unconvinced that introducing redundant option strings is a
benefit.

These shorthand forms may seem obvious to you, but not to everyone
else. Adding to the murkiness is that fact that write cache must be
*enabled* and read cache *disabled* in the protocol. The fact that the
??rN and RCD columns below contain inverse values just emphasizes that
point that "0" and "1" are not a particularly good interface either.

It is also confusing that the existing longhand forms will be printed
when the user subsequently queries the state instead of what they used
to toggle it.


This, however, is pretty much what I was looking for:

> Encoding                          | WCE RCD | Write_cache Read_cache
> --------------------------------------------------------------------
> write through              / w0r1 | 0   0   | off         on
> none                       / w0r0 | 0   1   | off         off
> write back                 / w1r1 | 1   0   | on          on
> write back, no read (daft) / w1r0 | 1   1   | on          off

Please drop the w?r? options and submit a patch with this table and a
note about the "temporary" prefix. Put it in
Documentation/scsi/sd-parameters.txt or something to that effect.

Bonus points for also documenting the remaining sd sysfs attributes and
their options.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
