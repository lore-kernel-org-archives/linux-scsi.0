From: jd <jpd_hp_linux_scsi@yahoo.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 30 Oct 2003 05:34:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031030133449.70869.qmail@web60208.mail.yahoo.com>
References: <3F9FF8C7.70909@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web60208.mail.yahoo.com ([216.109.118.103]:4794 "HELO
	web60208.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262461AbTJ3Nev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 08:34:51 -0500
In-Reply-To: <3F9FF8C7.70909@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>, 'Christoph Hellwig' <hch@infradead.org>
Cc: "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com, Richard Bealkowski <ennui@us.ibm.com>


--- Mike Christie <mikenc@us.ibm.com> wrote:
> Hi Surekha,
> 
> >>This is again needed for network boot. The n/w driver and iSCSI
> driver
> >>are loaded during early boot. Since the n/w interface is not setup
> at
> >>that time, we need to bring up the interface through this call in
> iSCSI
> >>driver.
> > 
> > 
> > That's bogus.  Look at the ip autoconfig code used by rootnfs and
> reuse
> > that instead of creating such bogus hacks.  A driver has no
> business dealing
> > with the network configuration.
> > 
> 
> Your driver does not even need to mess with that code. Just modify
> your 
> usersapce tools in the linux-iscsi package that run in the initrd to
> do 
> this in userspace.
> 
> 
> Mike
> 

  Hi Surekha,

  You can use a set of tools from "busybox" that 
  includes a small statically linked "shell" and
  dhcp client utility program(s) and create a initrd 
  (ramdisk) that download via pxelinux.

   The linuxrc script would then bring up the 
   network something like :

   insmod <your nic>
   ifconfig up eth0 my_ip_addr
   dhcpl  >  target_info   # query the server 
   insmod iscsi_mod 
   iscsi_conf   cat `target_info`  # user utility to start iscsi

  Ping me offline and I can share the 
  diskless boot sequence I did with unh-iscsi
  ramdisk if your interested.

  
 John Donnelly  AATTTT   HH PP  dott COM 


__________________________________
Do you Yahoo!?
Exclusive Video Premiere - Britney Spears
http://launch.yahoo.com/promos/britneyspears/
