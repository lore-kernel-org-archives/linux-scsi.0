From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH V2] scsi: storvsc: Allow only one remove lun work item to
 be issued per lun
Date: Thu, 19 Oct 2017 22:06:37 +0000
Message-ID: <MWHPR21MB0190591322F553B49D3033C0CE420@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1508261721-24144-1-git-send-email-cavery@redhat.com>
 <20171019153510.GA7633@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171019153510.GA7633@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Cathy Avery <cavery@redhat.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

> On Tue, Oct 17, 2017 at 01:35:21PM -0400, Cathy Avery wrote:
> > +	/*
> > +	 * Set the error handler work queue.
> > +	 */
> > +	snprintf(host_dev->work_q_name, sizeof(host_dev-
> >work_q_name),
> > +		 "storvsc_error_wq_%d", host->host_no);
> > +	host_dev->handle_error_wq =3D
> > +			create_singlethread_workqueue(host_dev-
> >work_q_name);
>=20
> If you use alloc_ordered_workqueue directly instead of
> create_singlethread_workqueue you can pass a format string and don't need
> the separate allocation.
>=20
> But I'm not sure if Tejun is fine with using __WQ_LEGACY directly..
>=20
> Except for this nit this looks fine to me:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>

The work storvsc_host_scan (scheduled from function storvsc_on_receive) sho=
uld also use this workqueue. We can do it in another patch.

Reviewed-by: Long Li <longli@microsoft.com>

> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> https://na01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fdriverd
> ev.linuxdriverproject.org%2Fmailman%2Flistinfo%2Fdriverdev-
> devel&data=3D02%7C01%7Clongli%40microsoft.com%7C9c303c3630ef490cecc3
> 08d5170702a2%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C636440
> 241242573253&sdata=3DtbCBOnKxtRR38rAdsBDa7zA0Jc2XwrySTsH3uyRxHxA%
> 3D&reserved=3D0
