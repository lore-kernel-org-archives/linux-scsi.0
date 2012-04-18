From: "." <desire@gmail.com>
Subject: increasing scsi command timeout vs implementing ERC for drives
 performing deep error recovery in an array
Date: Wed, 18 Apr 2012 19:05:04 +0800
Message-ID: <CAAevFRR1gbvgS0=5jq5c-6Lw9a3TDFNmq7T95XT=SNV-E4gs6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2DRLFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 07:05:25 -0400
Received: by iagz16 with SMTP id z16so10285206iag.19
        for <linux-scsi@vger.kernel.org>; Wed, 18 Apr 2012 04:05:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm trying to understand what causes a drive performing a deep
recovery cycle to get kicked out of a linux software raid array, and
whether setting an ERC limit is the only option, or whether increasing
the scsi command timeout is a reasonable alternative.

As I understand it, if the deep recovery goes on for long enough, the
scsi command timeout would be exceeded. This causes the SCSI error
handler to attempt to abort the command and reset the device/bus/host.
If these error handlers fail, the drive is set offline (which I assume
is what kicks the drive out).

ERC helps in this scenario as the drive will return an error before
the timeout is exceeded.  The scsi layer will return an error to the
md/raid layer, which can take the appropriate action (retry operation
/ recover data from redundant source and rewrite it / kick disk or
whatever).

I have also read that the SCSI command timeout can be tuned via
/sys/block/.../device/timeout, and defaults to 30 seconds.  Would
raising this timeout to a large value likewise prevent deep recovery
cycles from causing the SCSI layer to set the drive offline?  Does
anyone know what is the maximum time taken for a deep recovery cycle?

Or, might it be a situation where there will be lots of commands
queued behind the access to the bad sector, and increasing the scsi
command timeout would only help with the first command, and the rest
of the queued commands will be exponentially delayed such that it is
not feasible to avoid this by increasing the timeout value?

Appreciate your comments and corrections if I've made mistaken
assumptions above.  Thanks!
