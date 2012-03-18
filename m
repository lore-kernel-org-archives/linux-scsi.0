From: Ayman El-Khashab <ayman@elkhashab.com>
Subject: mpt2sas: BUG? corrupted nvram after using linkrate in sysfs
Date: Sun, 18 Mar 2012 13:29:16 -0500
Message-ID: <20120318182916.GA16862@crust.elkhashab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2CRS3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Mar 2012 14:29:18 -0400
Received: from crust.elkhashab.com (localhost [127.0.0.1])
	by crust.elkhashab.com (8.14.3/8.14.3/Debian-9.4) with ESMTP id q2IITGZp017265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 18 Mar 2012 13:29:16 -0500
Received: (from ayman@localhost)
	by crust.elkhashab.com (8.14.3/8.14.3/Submit) id q2IITGdT017264
	for linux-scsi@vger.kernel.org; Sun, 18 Mar 2012 13:29:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

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
