From: Evan Felix <evan.felix@pnl.gov>
Subject: Re: HSV : ghosts & multipath
Date: Tue, 12 Aug 2003 09:23:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060705427.5188.16.camel@e-linux>
References: <3F3820C9.4060004@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlas.pnl.gov ([130.20.248.194]:45726 "EHLO atlas.pnl.gov")
	by vger.kernel.org with ESMTP id S270764AbTHLQTJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2003 12:19:09 -0400
Received: from vscan2.pnl.gov ([130.20.64.141]) by pnl.gov (PMDF V6.1-1 #30581)
 with SMTP id <0HJI00BMVLBWH7@pnl.gov> for linux-scsi@vger.kernel.org; Tue,
 12 Aug 2003 09:19:08 -0700 (PDT)
In-reply-to: <3F3820C9.4060004@free.fr>
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: linux-scsi@vger.kernel.org

Doh!..  i forgot to answer your second question:

On Mon, 2003-08-11 at 16:03, christophe varoqui wrote:
> More generally, how do you manage access to your HSV LUNs ? I personnaly 
> would hate to use SecurePath which locks the user to one distribution 
> and has not passed the "community peer-review test". Any alternative 
> applicable in a dual fabric, dual attached hosts & controlers (4 
> paths/host including 2 ghosts : 2 paths through the left fabric, 2 paths 
> through the right) ?
> 

I Do not have a full solution yet, but the things we have looked at are:

1. Qlogic 2300 failover driver, which did seem to work fairly well when
you have two active paths.  does not understand the ghost issues at all.

2. The linux md multipath driver works fairly reliable, but also does
not understand ghost devices.

3. Do nothing.  This is actually what we are doing now, as we
investigate the other options.  In a failure situation the plan is to
re-load the qlogic modules, re-run scsidev which will remap the failed
disks to the correct position.

I am still waiting on a usuable version of SecurePath for IA64, and have
not seen even the beta yet....  since HP is supporting our box we may be
able to get more access to the code and have them tailor a version for
our specific kernel and software config.  Maybe.

Hope that helps.

Evan
