From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: mpt2sas: BUG? corrupted nvram after using linkrate in sysfs
Date: Tue, 20 Mar 2012 15:20:48 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E732484@inbmail02.lsi.com>
References: <20120318182916.GA16862@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:49563 "EHLO
	na3sys009amx257.postini.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755399Ab2CTJu4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 05:50:56 -0400
In-Reply-To: <20120318182916.GA16862@crust.elkhashab.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ayman El-Khashab <ayman@elkhashab.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,
I verified on SAS2008 B1 the max/min changing value for link rate.
I set the max link speed of the NVRAM value to 1.5 Gbps and rebooted. After reboot I read the current and NVRAM value of the max link speed for the phy that I set before. It shown value 1.5 Gbps.

I dint face any issue. 

Are you facing problem in this scenario only?

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ayman El-Khashab
Sent: Sunday, March 18, 2012 11:59 PM
To: linux-scsi@vger.kernel.org
Subject: mpt2sas: BUG? corrupted nvram after using linkrate in sysfs

We have the SAS2008 on our board but we don't have the NVRAM
populated.  We do have a flash on the board that holds the
firmware and so on.  What we found (by experimentation) is
that the firmware detects or knows there isn't an NVRAM and
stores some of the NVRAM settings somewhere in the flash
(we've dumped the flash and confirmed there are things in
it).  

We've seen a problem where we use the max/min linkrate in
sysfs -- it looks like the linkrates get set correctly in
page1, we also copy the port/port flags/phy flags per some
errata.  The problem shows up when it updates pg1.  At that
point, the following code is executed ... I guess this would
be ok, except what we see happen is that whatever gets
written to the NVRAM fails to make anything work and since
it is in the NVRAM, even rebooting doesn't help.  We have
figured out that using restore defaults in lsiutil fixes the
problem, but we would rather figure out why the linkrate
doesn't work.  

 mpt2sas_config_set_sas_iounit_pg1(struct MPT2SAS_ADAPTER
*ioc, Mpi2ConfigReply_t
     *mpi_reply, Mpi2SasIOUnitPage1_t *config_page, u16
...
MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
         r = _config_request(ioc, &mpi_request, mpi_reply,
            MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT,
config_page, sz);


What it looks like is that Pg1 has the autoconfig set, but
rather than having "0" in the dynamic port group, it how has
many phy numbers so it seems that on the next reboot, the
dynamic setup doesn't work -- however, I don't know that for
sure since I don't really know what the f/w does with it.

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
