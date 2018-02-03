From: Laurence Oberman <loberman@redhat.com>
Subject: All scsi_debug devices in the scsi_debug driver share the same RAM
 space
Date: Sat, 03 Feb 2018 14:43:12 -0500
Message-ID: <1517686992.18584.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:37166 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752026AbeBCTnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2018 14:43:16 -0500
Received: by mail-qk0-f182.google.com with SMTP id z65so365712qka.4
        for <linux-scsi@vger.kernel.org>; Sat, 03 Feb 2018 11:43:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: John Pittman <jpittman@redhat.com>, Jon Magrini <jmagrini@redhat.com>

Hello Doug

I had emailed you earlier about this issue forgetting to copy others.

All test devices in the scsi_debug driver share the same ram space so
we cannot really have individual devices for testing stuff like md-
raid.

I bumped into this a few times already and I think it would be useful
to make each device an individual RAM entry so we can create multiple
unique devices.

Of course this means also now having to maybe start using attributes
for each device do we can selectively choose which devices get the
fault injections.

I know its adding complexity here but wanted to get input about the
possibility of changing this.

For a particular fault injection case this morning I had to use 5
regular drives and 1 scsi-debug drive to inject faults to reproduce an
md-raid issue.

I also wanted a different start sector and range and sent an earlier
patch for that.

So is this something worth considering ?
If so, i will start working on it.

Regards
Laurence
