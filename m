From: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Subject: Re: [PATCH][2.5] SCSI hosts.c missing device_register
Date: Sat, 23 Nov 2002 14:00:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211232000.gANK00903642@localhost.localdomain>
References: <zwane@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA03869
	for <linux-scsi@vger.kernel.org>; Sat, 23 Nov 2002 12:00:03 -0800
In-Reply-To: Message from Zwane Mwaikambo <zwane@holomorphy.com>
   of "Sat, 23 Nov 2002 13:35:29 EST." <Pine.LNX.4.50.0211231330110.1462-100000@montezuma.mastecende.com>
List-Id: linux-scsi@vger.kernel.org
To: Zwane Mwaikambo <zwane@holomorphy.com>
Cc: linux-scsi@vger.kernel.org

zwane@holomorphy.com said:
> Does this patch look correct? Please CC as i am not subscribed. 

Actually, I'm afraid not.  It would lead to double registrations of hosts.  It 
might be the correct fix if you take the device_register() out of 
scsi_add_host(), but I'd like to understand what the problem is first.

The sequence should be:

scsi_register_host(template)
	template->detect()
		for each host, scsi_register(host)
	[...]
	for each detected host, scsi_add_host(host)
		device_register()

It looks like you're getting an error between scsi_register and scsi_add_host 
that's causing the HBA to bail and something to think it needs to deregister a 
curently unregistered host_driverfs_dev.

Most likely, the problem is in the HBA driver.  Which host adapter is this?

James


