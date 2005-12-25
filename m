From: James Smart <James.Smart@Emulex.Com>
Subject: Re: More FC Transport Issues
Date: Sat, 24 Dec 2005 20:02:31 -0500
Message-ID: <43ADEFA7.8070204@emulex.com>
References: <43AB36BC.8000003@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41387 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750769AbVLYBDE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Dec 2005 20:03:04 -0500
In-Reply-To: <43AB36BC.8000003@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>


Michael Reed wrote:
> Hello,
> 
> I installed 2.6.15-rc6-git3 on my ia64 test system and the system hung during
> startup.  There were "recursion depth exceeded" messages.
> 
> The fabric was coming online at the time of hba startup and the targets
> hadn't yet been discovered by the switch.  Consequently, the hbas saw
> loop up but no targets, then the switch generates a state change notification
> and the driver for the hbas discovers the targets in parallel.
> 
> So, there appears to be another recursion issue with the new fc transport.

FYI - you would not see the recursion issue with the lpfc driver. This is a
combination of the qla2xxx driver and the fc transport both using work queue
entries on add/delete.  The lpfc driver uses a background thread rather than
work queue entries.

I'll see if there's something similar to what I did before that could be
applied. Otherwise, we'll have to change either the calling rules or the api.
This is one of those things where the micro view looked simple and
straight-forward, but the macro view is showing the inefficiencies of
black-box design.

-- james s

