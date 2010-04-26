From: brem belguebli <brem.belguebli@gmail.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Mon, 26 Apr 2010 23:52:01 +0200
Message-ID: <1272318721.16254.7.camel@localhost>
References: <20100422164739.GA15813@lsil.com>
	 <1271964275.2480.1.camel@localhost> <4BD1A071.2010202@emulex.com>
	 <j2o29ae894c1004230922le8baf635y563e50e3edc53bc3@mail.gmail.com>
	 <4BD226F4.6070908@emulex.com> <1272109999.2983.30.camel@localhost>
	 <4BD5D258.8030309@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:22687 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0DZTvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2010 15:51:50 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2203365fgg.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Apr 2010 12:51:49 -0700 (PDT)
In-Reply-To: <4BD5D258.8030309@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org

Hi James,

On Mon, 2010-04-26 at 13:50 -0400, James Smart wrote:
> Brem,
> 
> I'm not understanding you.
> 
> 
> brem belguebli wrote: 
> > We have sg3_utils installed , and I think we ran sg_verify on one or
> > 2
> > unresponsive /dev/sd and it didn't give the hand back.
> >   
> what do you mean "give the hand back" ?    was the operation
> successful or not ?
> 
When I say it didn't give the hand back, I mean the one or 2 processes
got stuck in D state, thus not returning success .
> > It was exactly
> > cd /sys/block
> > for DEV in `ls -1d dev*`; do
> > echo ${DEV}
> >         dd if =/dev/${DEV} of=/dev/null bs=1024 count=1 &
> >         echo
> > done
> > 
> > And yes it really works, never seen any kind of preemption of DM-MP over
> > direct sd access. I've cc'ed dm-devel may be some DM guru could give his
> > opinion on this.
> > 
> > Next time, I'll use a sg_dd instead of dd, to bypass any cache effect
> > (by the way, does VFS cache anything when addressing /dev/X devices ?)
> >   
> ok - by "works" means "dd successfully read 1 block from the device" -
> right ?
> 
Yes, the devices on which dd was successful were the ones from FABRIC1,
dd completed successfully by reading the first 1024 bytes to copy them
to /dev/null
  
> > > The most interesting for the lpfc driver would be the lpfc module
> > > parameter "lpfc_log_verbose=4115"
> > > which turns on discovery log messages, els messages, link events, and
> > > FCP i/o error messages.
> > >     
> > 
> > As our DWDM ring switch is on the less optimal path, there will be a
> > switch back to nominal soon.
> > 
> > I'll activate this log level on the HBA's and check the firmware
> > versions you gave me .
> >   
> ok. I believe that the shost for the adapters in question, have a
> sysfs variable for lpfc_log_verbose, that sets the log level on the
> individual adapter. This would not require you to unload/reload the
> driver to set the option.
> 
I'll tell you tomorrow (was off today) if the parameter exists for these
HBA's.
> > Hopefully, we will be able to provide you something deeper to
> > investigate.
> > 
> > Brem
> >   
> 
> ok.
> 
> -- james
> 
> 
Thanks


