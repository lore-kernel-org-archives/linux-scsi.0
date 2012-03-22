From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: mpt2sas: BUG? corrupted nvram after using linkrate in sysfs
Date: Thu, 22 Mar 2012 12:45:27 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E732788@inbmail02.lsi.com>
References: <20120318182916.GA16862@crust.elkhashab.com>
 <A6888A6805518E4EA4AF7072A28264A6067E732484@inbmail02.lsi.com>
 <20120320135754.GA9339@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43799 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab2CVHPe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 03:15:34 -0400
In-Reply-To: <20120320135754.GA9339@crust.elkhashab.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ayman El-Khashab <ayman@elkhashab.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Which version of mpt2sas are you testing? If it is older version can you try it on latest version of mpt2sas 12.100.00.00 updated on main stream.

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ayman El-Khashab
Sent: Tuesday, March 20, 2012 7:28 PM
To: Nandigama, Nagalakshmi
Cc: linux-scsi@vger.kernel.org
Subject: Re: mpt2sas: BUG? corrupted nvram after using linkrate in sysfs

On Tue, Mar 20, 2012 at 03:20:48PM +0530, Nandigama, Nagalakshmi wrote:
> Hi,
> I verified on SAS2008 B1 the max/min changing value for link rate.
> I set the max link speed of the NVRAM value to 1.5 Gbps and rebooted. After reboot I read the current and NVRAM value of the max link speed for the phy that I set before. It shown value 1.5 Gbps.
> 
> I dint face any issue. 
> 
> Are you facing problem in this scenario only?
> 

BTW, I am on V9.0 of the firmware -- there was an email that
said this was fixed in 11.0, but I don't see it mentioned in
the errata unless I missed it.  Also flashing already
deployed systems isn't always easy.

So I did some more experiments, and the problem seems to be
both intermittent and relies on a particular drive
configuration.  I start with a brand new system (i.e.
never been run) and put 4 SAS drives in, each with 2 ports
(so I use all 8 phys of the controller).  These drives can
run at 6G and work fine.  Now I can power down, pull 2
drives, start again and it is still good.  I can change the
drive setup many times and all is fine.  Now if I go back to
the original setup (4 SAS drives) and change the link rate
to 6G then everything works.  Now, if I power down and pull
a drive or 2, then some phys will come up at 6G, some will
indicate Unknown, but accessing the drives won't work
correctly.  One drive *might* work, but the other usually
will give an error with "Read Capacity Fail" or something
different.  If I use lsiutil to reset the Pg1 configuration
to the defaults and reboot, then the drives will work again
at 6G. 

In fails, each drive is dual-ports so I'd expect both phys 
to come up at 6G.  What happens is that 1 phy will come up 
at 6G the other at Unknown and nothing works right. (i..e
we get drive errors as seen in Linux).

Upon first boot, our Pg1 current config looks like this.
0014 : a8000100
0018 : 00000071
001c : 00000000

The dynamic port group is 0, the autoconfig is enabled for
each of the 8 ports. (just showing 1 here).

After we attach drives and set the link rate, the port group
gets set to something [0:7].  Then when the data is written
back to the flash during the NVRAM update, the dynamic port
group is now an ordinal from 0,7 instead of port group 0.
It appears to us that this is the only difference but I
can't verify that other than when I restore defaults it
works.

In another test, I subverted the writes to NVRAM in the
driver.  In this case, I can make it run and fail, but at
least upon reboot it works again.

Thanks,
Ayman








> 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ayman El-Khashab
> Sent: Sunday, March 18, 2012 11:59 PM
> To: linux-scsi@vger.kernel.org
> Subject: mpt2sas: BUG? corrupted nvram after using linkrate in sysfs
> 
> We have the SAS2008 on our board but we don't have the NVRAM
> populated.  We do have a flash on the board that holds the
> firmware and so on.  What we found (by experimentation) is
> that the firmware detects or knows there isn't an NVRAM and
> stores some of the NVRAM settings somewhere in the flash
> (we've dumped the flash and confirmed there are things in
> it).  
> 
> We've seen a problem where we use the max/min linkrate in
> sysfs -- it looks like the linkrates get set correctly in
> page1, we also copy the port/port flags/phy flags per some
> errata.  The problem shows up when it updates pg1.  At that
> point, the following code is executed ... I guess this would
> be ok, except what we see happen is that whatever gets
> written to the NVRAM fails to make anything work and since
> it is in the NVRAM, even rebooting doesn't help.  We have
> figured out that using restore defaults in lsiutil fixes the
> problem, but we would rather figure out why the linkrate
> doesn't work.  
> 
>  mpt2sas_config_set_sas_iounit_pg1(struct MPT2SAS_ADAPTER
> *ioc, Mpi2ConfigReply_t
>      *mpi_reply, Mpi2SasIOUnitPage1_t *config_page, u16
> ...
> MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
>          r = _config_request(ioc, &mpi_request, mpi_reply,
>             MPT2_CONFIG_PAGE_DEFAULT_TIMEOUT,
> config_page, sz);
> 
> 
> What it looks like is that Pg1 has the autoconfig set, but
> rather than having "0" in the dynamic port group, it how has
> many phy numbers so it seems that on the next reboot, the
> dynamic setup doesn't work -- however, I don't know that for
> sure since I don't really know what the f/w does with it.
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
