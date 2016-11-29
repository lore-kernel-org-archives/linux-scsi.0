From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Tue, 29 Nov 2016 10:16:18 +0100
Message-ID: <1480410978.7926.12.camel@suse.de>
References: <20161121140429.12788-1-mwilck@suse.de>
         <20161121140429.12788-2-mwilck@suse.de>
         <4993A297653ECB4581FA5C3C31323D193B0CCCB7@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48629 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756513AbcK2JQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 04:16:22 -0500
In-Reply-To: <4993A297653ECB4581FA5C3C31323D193B0CCCB7@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: dl-esc-Team ESD Storage Dev Support <esc-TeamESDStorageDevSupport@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley <jejb@linux.vnet.ibm.com> . hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Hi Don,

On Tue, 2016-11-29 at 01:52 +0000, Don Brace wrote:
> > -----Original Message-----
> > From: Martin Wilck [mailto:mwilck@suse.de]
> > Sent: Monday, November 21, 2016 8:04 AM
> > To: Don Brace
> > Cc: dl-esc-Team ESD Storage Dev Support; iss_storagedev@hp.com;
> > linux-
> > scsi@vger.kernel.org; JBottomley@odin.com; hch@lst.de; hare@suse.de
> > ;
> > Martin Wilck
> > Subject: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
> > unloading
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > When the hpsa module is unloaded using rmmod, dangling
> > symlinks remain under /sys/class/sas_phy. Fix this by
> > calling sas_phy_delete() rather than sas_phy_free (which,
> > according to comments, should not be called for PHYs that
> > have been set up successfully, anyway).
> > 
> > References: bsc#1010946.
> > Signed-off-by: Martin Wilck <mwilck@suse.de>
> > ---
> >  drivers/scsi/hpsa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index efe2f36..8ec77c3 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -9547,9 +9547,9 @@ static void hpsa_free_sas_phy(struct
> > hpsa_sas_phy
> > *hpsa_sas_phy)
> >         struct sas_phy *phy = hpsa_sas_phy->phy;
> > 
> >         sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
> > -       sas_phy_free(phy);
> >         if (hpsa_sas_phy->added_to_port)
> >                 list_del(&hpsa_sas_phy->phy_list_entry);
> > +       sas_phy_delete(phy);
> >         kfree(hpsa_sas_phy);
> >  }
> > 
> > --
> > 2.10.1
> 
> I tried these patches on: 4.9.0-rc7, was this correct?
> 
> I got the following stack trace:
> [  231.192289] ------------[ cut here ]------------
> [  231.214333] WARNING: CPU: 51 PID: 15876 at fs/sysfs/group.c:237
> sysfs_remove_group+0x8e/0x90
> [  231.254371] sysfs group 'power' not found for kobject '4:0:0:0'

[...]

The stack traces should be gone if you apply the 2nd patch of the
series ("hpsa: destroy sas transport properties before scsi_host").

My testing (done with a SLES12 kernel), without my patches, showed
these traces for the removal of "sas_port" structures. Adding PATCH 1/2
indeed adds more of these warnings (now for "sas_port" *and*
"sas_phy"). But that's not the fault of this patch; it's caused by the
sequence of actions in hpsa_remove_one() and it's fixed in PATCH 2/2.

Regards
Martin

