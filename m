From: Adrian Bunk <bunk@stusta.de>
Subject: drivers/message/fusion/mptsas.c: inconsequent NULL checking
Date: Mon, 19 Mar 2007 10:24:49 +0100
Message-ID: <20070319092449.GM752@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbXCSJYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 05:24:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in
drivers/message/fusion/mptsas.c:

<--  snip  -->

...
static void
mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
{
...
                if (port_info->phy_info &&
                    (!(port_info->phy_info[0].identify.device_info &
                    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
                        continue;

                if (mptsas_sas_expander_pg0(ioc, &buffer,
                     (MPI_SAS_EXPAND_PGAD_FORM_HANDLE <<
                     MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
                     port_info->phy_info[0].handle)) {
...

<--  snip  -->

port_info->phy_info is first checked but later dereferenced 
unconditionally.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

