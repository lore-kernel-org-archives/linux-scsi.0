From: Tom Yan <tom.ty89@gmail.com>
Subject: Why does sd "assume write through" instead of "write back"?
Date: Wed, 17 Feb 2016 08:53:58 +0800
Message-ID: <CAGnHSEk2+EmV1rct9OpqpnJ5=sC_5FO__+vh_h9x7dyE+WLdBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:35845 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513AbcBQAx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2016 19:53:59 -0500
Received: by mail-yw0-f181.google.com with SMTP id e63so1190864ywc.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Feb 2016 16:53:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Currently the scsi disk driver would "assume write through" (i.e. no
writeback cache on the disk) when the disk fail to report the
availablity of writeback cache (e.g. no caching mode page), then spam
an error through kernel messages.

Although there is a switch to change that "assumption", but it's only
available as a quirk for USB disks.

So why shouldn't we make "assume write back" as the general default
instead? Apparently all it triggers are SYNCHRONIZE CACHE commands,
which I don't suppose to be dangerous on any disks, no matter it
actually has writeback cache available/enabled or not? Probably not
even performance impact?

In case there are any drives that are "allegic" to SYNCHRONIZE CACHE
(I mean serious issue like the drive will be frozen once it receive
that command, not something like invalid opcode), shouldn't there be
quirk written for them, instead of generally falling back to what we
consider "dangerous" and spam error for every drives that doesn't have
a caching mode page (which are pretty common)?
