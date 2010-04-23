From: James Smart <james.smart@emulex.com>
Subject: Re: lpfc SAN/SCSI issue
Date: Fri, 23 Apr 2010 09:28:17 -0400
Message-ID: <4BD1A071.2010202@emulex.com>
References: <20100422164739.GA15813@lsil.com> <1271964275.2480.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:48316 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755814Ab0DWN2l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2010 09:28:41 -0400
In-Reply-To: <1271964275.2480.1.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brem belguebli <brem.belguebli@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Brem,

We're looking at the lpfc driver as to whether this matches anything we are 
aware of.

Please send me the system console log during this time frame. No messages 
whatsoever would be very odd.  Sending us the output of the shost, rport, and 
sdev sysfs parameters, as well as DM configuration values would also help. 
It won't necessarily be i/o timers that would fire, but other timers should.

-- james s


brem belguebli wrote:
> I have a server (RHEL 5.3) connected to 2 SAN extended fabrics (across 2
> sites, distance 1 ms, links are ISL with 100 km long distance buffer
> credits) via 2 lpfc HBA's (LPe1105-HP FC with the RHEL 5.3 shipped LPFC
> driver 8.2.0.33.3p.)
>  
> A SAN FABRIC reconfiguration (DWDM Ring failover from worker to
> protection)  occured yesterday  after some intersite telco link switch
> that lasted less than 0,3 ms. 
>  
> Only one FABRIC was impacted, named FABRIC2 
>  
> Our server is connected to the FABRICs thru 2 edge switches, so not
> directly connected to the core switches on which the link failure
> occured. 
>  
>>From then, our server (which accesses thru the 2 fabrics the LUNS from
> our 2 sites) started to climb in terms of load average (up to 250 for a
> dual proc quadcore machine!) with a high percentage of iowait (up to
> 50%). 
>  
> We did some testing, bypassing DM-MP by issuing dd commands to the
> physical /dev/sdX devices (more than 30 LUNS are presented to the
> server, seen each thru 4 paths making more than 120 /dev/sd devices)
> and half of our dd processes went to D state, as well as some unitary
> scsi_id that we manually run on the same physical devices. 
>  
> Multipathd itself was also in D state. 
>  
> The only way to restore the whole thing was to reset the server HBA
> connected to FABRIC2, after 2 hours of investigation 
>  
> No kind of scsi log, or whatever did appear during the outage duration
> (~2 hours) despite the fact that the scsi timeouts set on the physical
> devices is 60s, that the HBA's timeout is 14s. 
>  
> The /sys/block/sdX/device/state were showing running state despite the
> fact that the devices (well half of them) were actually inaccessible. 
>  
> What leads me to : 
>  
> 1) assumption: it looks the lpfc driver following this SAN event goes in
> a black hole mode not returning any io error or whatever to the scsi
> upper layer 
>  
> 2) question: how come the scsi timers don't trigger and declare the
> device faulty (the answer may be in the above assumption). 
>  
> Any idea or tip on what could cause this, some FC SCN message not well
> handled or whatever ?
> 
> Regards
> 
> Brem
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
