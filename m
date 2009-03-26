From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Stale devices in sysfs
Date: Thu, 26 Mar 2009 17:41:38 +0000
Message-ID: <1238089298.3342.39.camel@localhost.localdomain>
References: <566532.22288.qm@web32501.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53952 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345AbZCZRlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 13:41:37 -0400
In-Reply-To: <566532.22288.qm@web32501.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ahmed A <ahmedcali@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-03-26 at 10:16 -0700, Ahmed A wrote:
> Hello,
> 
> I have a two port FC hba in my system.  The hba is properly connecting
> to a Target, and I can tell it seems all the LUNs exported to it.
> However, when I browse through the /sys/class/scsi_host/...
> directory , and output of "lsscsi", I can see "sd" mappings that are
> old and invalid (cannot write to them).  In my ouput below,
> sd[e/f/g/h] and sd[c/d] are invalid.
> 
> 1. Is there an command I an issue to flush out the older mappings?
> 
> 2. Is this a bug in the FC driver?
> 
> [root@pe850 ~]# lsscsi
> [2:0:0:10]   disk    3PARdata VV               0000  /dev/sde
> [2:0:0:11]   disk    3PARdata VV               0000  /dev/sdf
> [2:0:0:254]  enclosu 3PARdata SES              0000  -       
> [2:0:1:10]   disk    3PARdata VV               0000  /dev/sdg
> [2:0:1:11]   disk    3PARdata VV               0000  /dev/sdh
> [2:0:1:254]  enclosu 3PARdata SES              0000  -       
> [2:0:2:10]   disk    3PARdata VV               0000  /dev/sdi
> [2:0:2:11]   disk    3PARdata VV               0000  /dev/sdj
> [2:0:2:254]  enclosu 3PARdata SES              0000  -       
> [3:0:0:10]   disk    3PARdata VV               0000  /dev/sdc
> [3:0:0:11]   disk    3PARdata VV               0000  /dev/sdd
> [3:0:0:254]  enclosu 3PARdata SES              0000  -       
> [3:0:1:10]   disk    3PARdata VV               0000  /dev/sdk
> [3:0:1:11]   disk    3PARdata VV               0000  /dev/sdl
> [3:0:1:254]  enclosu 3PARdata SES              0000  -       
> [root@pe850 ~]# 

It's very hard to tell anything without knowing which fibre HBA or
looking in the logs.  However, I'd say you've had some disconnect event
which exceeded the devloss timeout twice on HBA 2 and once on HBA 1 ...
this causes LUNs to be re-presented in exactly this fashion (with the
target number incrementing).

It sounds like the problem is whatever event caused this, and there's
insufficient information to make any guesses about that.

James


