From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
 Hyper-V
Date: Thu, 17 Mar 2016 00:01:28 +0000
Message-ID: <SN2PR03MB2142C30620CAC6F633AAFB52A08B0@SN2PR03MB2142.namprd03.prod.outlook.com>
References: <1457819568-6586-1-git-send-email-kys@microsoft.com>
 <20160315134009.GA3595@infradead.org>
 <SN2PR03MB21423A42522A21C145896431A0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq1twk7e8nl.fsf@sermon.lab.mkp.net>
 <SN2PR03MB21425F84DAC997491DD4C2ACA0890@SN2PR03MB2142.namprd03.prod.outlook.com>
 <yq14mc6dpbu.fsf@sermon.lab.mkp.net>
 <1458169666.4793.62.camel@HansenPartnership.com>
 <SN2PR03MB2142B8D8C2B1831522F6EB1AA08A0@SN2PR03MB2142.namprd03.prod.outlook.com>
 <1458171653.4793.68.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1458171653.4793.68.camel@HansenPartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "hare@suse.de" <hare@suse.de>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Wednesday, March 16, 2016 4:41 PM
> To: KY Srinivasan <kys@microsoft.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@infradead.org>; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> hare@suse.de
> Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC hosts on
> Hyper-V
> 
> On Wed, 2016-03-16 at 23:15 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: James Bottomley
> [mailto:James.Bottomley@HansenPartnership.com
> > > ]
> > > Sent: Wednesday, March 16, 2016 4:08 PM
> > > To: Martin K. Petersen <martin.petersen@oracle.com>; KY Srinivasan
> > > <kys@microsoft.com>
> > > Cc: Christoph Hellwig <hch@infradead.org>;
> > > gregkh@linuxfoundation.org;
> > > linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > ohering@suse.com; jbottomley@parallels.com;
> > > linux-scsi@vger.kernel.org;
> > > apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> > > hare@suse.de
> > > Subject: Re: [PATCH 1/1] scsi: storvsc: Support manual scan of FC
> > > hosts on
> > > Hyper-V
> > >
> > > On Wed, 2016-03-16 at 18:34 -0400, Martin K. Petersen wrote:
> > > > > > > > > "KY" == KY Srinivasan <kys@microsoft.com> writes:
> > > >
> > > > KY> How would I get the sysfs files under fc_host if I don't use
> > > > the
> > > > FC
> > > > KY> transport.  The customer scripts expect these sysfs files.
> > > >
> > > > Right, but I was interested in finding out why they need those
> > > > files. And whether an alternative to the FC transport would be a
> > > > better solution.
> > >
> > > If it's just the wwn file (or a set of other values), we might be
> > > able
> > > to separate that bit out of the FC transport class so you can use
> > > it
> > > independently ... do you have a full list of the files being used?
> >
> > Wwn files are what we can support on Hyper-V and that is what I want
> > to support (to address customer requirements).
> 
> There is no wwn file.  These are all the possible attributes they could
> use; which one(s) do you want:
> 
> 	/*
> 	 * Setup SCSI Host Attributes.
> 	 */
> 	SETUP_HOST_ATTRIBUTE_RD(node_name);
> 	SETUP_HOST_ATTRIBUTE_RD(port_name);
> 	SETUP_HOST_ATTRIBUTE_RD(permanent_port_name);
> 	SETUP_HOST_ATTRIBUTE_RD(supported_classes);
> 	SETUP_HOST_ATTRIBUTE_RD(supported_fc4s);
> 	SETUP_HOST_ATTRIBUTE_RD(supported_speeds);
> 	SETUP_HOST_ATTRIBUTE_RD(maxframe_size);
> 	if (ft->vport_create) {
> 		SETUP_HOST_ATTRIBUTE_RD_NS(max_npiv_vports);
> 		SETUP_HOST_ATTRIBUTE_RD_NS(npiv_vports_inuse);
> 	}
> 	SETUP_HOST_ATTRIBUTE_RD(serial_number);
> 	SETUP_HOST_ATTRIBUTE_RD(manufacturer);
> 	SETUP_HOST_ATTRIBUTE_RD(model);
> 	SETUP_HOST_ATTRIBUTE_RD(model_description);
> 	SETUP_HOST_ATTRIBUTE_RD(hardware_version);
> 	SETUP_HOST_ATTRIBUTE_RD(driver_version);
> 	SETUP_HOST_ATTRIBUTE_RD(firmware_version);
> 	SETUP_HOST_ATTRIBUTE_RD(optionrom_version);
> 
> 	SETUP_HOST_ATTRIBUTE_RD(port_id);
> 	SETUP_HOST_ATTRIBUTE_RD(port_type);
> 	SETUP_HOST_ATTRIBUTE_RD(port_state);
> 	SETUP_HOST_ATTRIBUTE_RD(active_fc4s);
> 	SETUP_HOST_ATTRIBUTE_RD(speed);
> 	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
> 	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
> 	SETUP_HOST_ATTRIBUTE_RW(system_hostname);
> 
> 	/* Transport-managed attributes */
> 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(dev_loss_tmo);
> 	SETUP_PRIVATE_HOST_ATTRIBUTE_RW(tgtid_bind_type);
> 	if (ft->issue_fc_host_lip)
> 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(issue_lip);
> 	if (ft->vport_create)
> 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_create);
> 	if (ft->vport_delete)
> 		SETUP_PRIVATE_HOST_ATTRIBUTE_RW(vport_delete);
> 	/*
> 	 * Setup Remote Port Attributes.
> 	 */
> 	count=0;
> 	SETUP_RPORT_ATTRIBUTE_RD(maxframe_size);
> 	SETUP_RPORT_ATTRIBUTE_RD(supported_classes);
> 	SETUP_RPORT_ATTRIBUTE_RW(dev_loss_tmo);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(node_name);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_name);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_id);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(roles);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(port_state);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RD(scsi_target_id);
> 	SETUP_PRIVATE_RPORT_ATTRIBUTE_RW(fast_io_fail_tmo);
> 
> 	/*
> 	 * Setup Virtual Port Attributes.
> 	 */
> 	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_state);
> 	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_last_state);
> 	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(node_name);
> 	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(port_name);
> 	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(roles);
> 	SETUP_PRIVATE_VPORT_ATTRIBUTE_RD(vport_type);
> 	SETUP_VPORT_ATTRIBUTE_RW(symbolic_name);
> 	SETUP_VPORT_ATTRIBUTE_WR(vport_delete);
> 	SETUP_VPORT_ATTRIBUTE_WR(vport_disable);
> 
> I'm assuming it's host and rport port_id?

The only attributes I would be interested are:
1) node name
2) port name

Ideally, if this can show under /sys/class/fc_host/hostx/port_name and node_name,
it will be ideal since all user scripts can work.

Regards,

K. Y 
