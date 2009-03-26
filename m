From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Stale devices in sysfs
Date: Thu, 26 Mar 2009 21:44:48 +0000
Message-ID: <1238103888.3342.67.camel@localhost.localdomain>
References: <635936.80425.qm@web32508.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43750 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757877AbZCZVor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 17:44:47 -0400
In-Reply-To: <635936.80425.qm@web32508.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ahmed A <ahmedcali@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-03-26 at 11:51 -0700, Ahmed A wrote:
> 
> 
> --- On Thu, 3/26/09, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Subject: Re: Stale devices in sysfs
> > To: "Ahmed A" <ahmedcali@yahoo.com>
> > Cc: linux-scsi@vger.kernel.org
> > Date: Thursday, March 26, 2009, 10:41 AM
> > On Thu, 2009-03-26 at 10:16 -0700,
> > Ahmed A wrote:
> > > Hello,
> > > 
> > > I have a two port FC hba in my system.  The hba
> > is properly connecting
> > > to a Target, and I can tell it seems all the LUNs
> > exported to it.
> > > However, when I browse through the
> > /sys/class/scsi_host/...
> > > directory , and output of "lsscsi", I can see "sd"
> > mappings that are
> > > old and invalid (cannot write to them).  In my
> > ouput below,
> > > sd[e/f/g/h] and sd[c/d] are invalid.
> > > 
> > > 1. Is there an command I an issue to flush out the
> > older mappings?
> > > 
> > > 2. Is this a bug in the FC driver?
> > > 
> > > [root@pe850 ~]# lsscsi
> > > [2:0:0:10]   disk    3PARdata
> > VV           
> >    0000  /dev/sde
> > > [2:0:0:11]   disk    3PARdata
> > VV           
> >    0000  /dev/sdf
> > > [2:0:0:254]  enclosu 3PARdata SES   
> >           0000  -   
> >    
> > > [2:0:1:10]   disk    3PARdata
> > VV           
> >    0000  /dev/sdg
> > > [2:0:1:11]   disk    3PARdata
> > VV           
> >    0000  /dev/sdh
> > > [2:0:1:254]  enclosu 3PARdata SES   
> >           0000  -   
> >    
> > > [2:0:2:10]   disk    3PARdata
> > VV           
> >    0000  /dev/sdi
> > > [2:0:2:11]   disk    3PARdata
> > VV           
> >    0000  /dev/sdj
> > > [2:0:2:254]  enclosu 3PARdata SES   
> >           0000  -   
> >    
> > > [3:0:0:10]   disk    3PARdata
> > VV           
> >    0000  /dev/sdc
> > > [3:0:0:11]   disk    3PARdata
> > VV           
> >    0000  /dev/sdd
> > > [3:0:0:254]  enclosu 3PARdata SES   
> >           0000  -   
> >    
> > > [3:0:1:10]   disk    3PARdata
> > VV           
> >    0000  /dev/sdk
> > > [3:0:1:11]   disk    3PARdata
> > VV           
> >    0000  /dev/sdl
> > > [3:0:1:254]  enclosu 3PARdata SES   
> >           0000  -   
> >    
> > > [root@pe850 ~]# 
> > 
> > It's very hard to tell anything without knowing which fibre
> > HBA or
> > looking in the logs.  However, I'd say you've had some
> > disconnect event
> > which exceeded the devloss timeout twice on HBA 2 and once
> > on HBA 1 ...
> > this causes LUNs to be re-presented in exactly this fashion
> > (with the
> > target number incrementing).
> > 
> > It sounds like the problem is whatever event caused this,
> > and there's
> > insufficient information to make any guesses about that.
> > 
> > James
> > 
> > 
> > 
> 
> Hi James, 
> 
> Thank you for your reply.  It is an Emulex 2 port FC hba (LPE11002),
> using the inbox driver version 8.2.0.33.3p.  Yes, there have been some
> disconnect, initiatied by me by disabling / enablling the port on the
> target.  Even in these situations, wouldn't the driver remove the
> old/stale mappings?  I am guessing from you response, there is no way
> for me to clean-up the old ones.

The delete caused by rport removal is supposed to remove them.  There
should be a message in the logs, something like :

blocked FC remote port time out: removing target and saving binding

You can delete any of the devices by just doing

echo 1 > /sys/class/scsi_device/<h:c:t:l>/device/delete


> As to figure out which ones are real, just use the sd mapping with the
> latest target number, right?

Yes, the transport class allocates them from a per host incrementing
variable.

James


