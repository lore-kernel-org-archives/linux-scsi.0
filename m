From: devnetfs <devnetfs@yahoo.com>
Subject: RE: scsi bus-reset in qlogic causes system stall
Date: Sat, 18 Jan 2003 05:08:40 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030118130840.81065.qmail@web20419.mail.yahoo.com>
References: <3679966B84813344B908D418BA3F6A4AA84088@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3679966B84813344B908D418BA3F6A4AA84088@AVEXCH01.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>, Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

Thanks Ravi and Steven for the information.
I will try the new driver you pointed out and update back.

I had couple of questions though:

1. What do you mean by "issued thru the backdoor"? I am using the
standard(?) SG_SCSI_RESET ioctl. Is there any other way of doing it?

2. Can this "Waiting for FC LIP..." be disabled (still bus resets 
work)? [sorry I am a newbie in the fiberchannel/scsi world]. The reason
I am asking this is, while doing a BUS RESET from a node all other
nodes also *wait* for FC LIP to complete -- and that makes all
the nodes on the shared scsi vulnerable to this hang/stall thing.

The way I've connected shared scsi is: Multiple nodes (each having one
qlogic 2200 FC HBA) connect to a SAN switch(brocade) to which a JBOD is
also connected.

Thanks once again,
A.

--- Ravi Anand <ravi.anand@qlogic.com> wrote:
> Please use the following link to download the latest
> driver-v6.04.00b8
> 
> http://www.qlogic.com/support/os_detail.asp?productid=125&osid=26
> 
> There has been some other fixes too in the bus reset code when issued
> through the backdoor.
> 
> Regards
> Ravi
> 
> -----Original Message-----
> From: Steven Dake [mailto:sdake@mvista.com]
> Sent: Friday, January 17, 2003 10:33 AM
> To: devnetfs
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: scsi bus-reset in qlogic causes system stall
> 
> 
> bug in qlogic driver I think this has been fixed to a
> schedule_timeout 
> in the 6.X drivers (from a spin on i/o)
> 
> I have done this same thing with the 6.x driver and the system is
> still 
> usable.  Keep in mind that the I/O's will retry until the FC LIP has 
> completed.
> 
> Thanks
> -steve
> 
> devnetfs wrote:
> 
> >Hello,
> >
> >I am running RedHat 2.4.9-13 with qlogic qla2x00 driver (ver
> 4.31.7b).
> >Trying to do a bus-reset (in an multi-initiator, shared-scsi
> scenario)
> >stalls one (or more) nodes in the system for a while. dmesg shows
> the
> >message: "Waiting for LIP to complete...", on all nodes. Everything
> >freezes for a while (around 10-40secs). It happens on UP/SMP both.
> >
> >Is this normal? or a bug in qlogic driver? 
> >
> >Thanks in advance for any insight,
> >A.
> >
> >
> >__________________________________________________
> >Do you Yahoo!?
> >Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
> >http://mailplus.yahoo.com
> >-
> >To unsubscribe from this list: send the line "unsubscribe
> linux-scsi" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >
> >  
> >
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
