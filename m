From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Question: 2.4.X and BLIST_SINGLELUN
Date: Wed, 23 Jun 2004 10:55:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Jun23.105523edt.332334@cyborg.cybernetics.com>
References: <04Jun22.155126edt.332331@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:40965 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S266249AbUFWOzZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2004 10:55:25 -0400
In-Reply-To: <04Jun22.155126edt.332331@cyborg.cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> I want to add a BLIST_SINGLELUN blacklist entry to scsi_scan.c
> (kernel 2.4.X) for a device that happens to have distinct inquiry
> strings for LUNs 0 and 1.  Ideally, I would like to add just one entry
> using the inquiry string for LUN 1.  Will this work, or does the
> blacklist entry have to match the inquiry string for LUN 0?  I can
> guarantee that all LUNs will be scanned, so I don't need
> BLIST_FORCELUN.  I can't experiment with it because I don't have the
> device here with me.

To answer my own question, I set up an experiment with a different
device.  As it turns out, it is necessary to have a BLIST_SINGLELUN
blacklist entry for _both_ inquiry strings.  With a single
BLIST_SINGLELUN blacklist entry that matches only one LUN's inquiry
string, the kernel will plug the command queue but not unplug it, so
commands will be blocked forever.

Anthony J. Battersby
Cybernetics

