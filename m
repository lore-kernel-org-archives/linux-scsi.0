From: David Strand <dpstrand@gmail.com>
Subject: read ahead imposes an i/o size cap
Date: Mon, 24 Sep 2012 16:56:32 -0700
Message-ID: <CACMme1yuwFeiYcP_vZ=sOuVVV8n_v2Sedc3r9ma+8Otik0WGzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33800 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2IXX4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 19:56:33 -0400
Received: by obbuo13 with SMTP id uo13so5291061obb.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2012 16:56:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I recently discovered that if I disable read ahead via writing a 0 to
/sys/class/block/XXX/queue/read_ahead_kb that regardless of issuing a
large read request (512kb for example), the actual i/o on the wire is
fragmented into multiples of 4kb (or whatever the read ahead value is
set to if non 0) causing far lower than expected throughput. I assumed
this must be a bug, so I tested 2.6.37 as well as 3.4, and confirmed
identical behavior on each. Is this the expected result?
