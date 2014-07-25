From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Fri, 25 Jul 2014 16:47:35 +0000
Message-ID: <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
 <yq1egxakb0z.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq1egxakb0z.fsf@sermon.lab.mkp.net>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, July 24, 2014 8:54 AM
> To: Sitsofe Wheeler
> Cc: Martin K. Petersen; Christoph Hellwig; KY Srinivasan;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
> 
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> So we can see it is really a SATA device that announces discard
> Sitsofe> correctly and supports discard through WRITE_SAME(16).
> 
> No, that's the SATA device that announces support for DSM TRIM, and as a
> result the Linux SATL reports support for WRITE SAME(16) w. the UNMAP bit
> set and LBPME.
> 
> Sitsofe> It is the act of passing it through Hyper-V that turned it into
> Sitsofe> a SCSI device that supports UNMAP (but not WRITE_SAME(16)),
> Sitsofe> doesn't announce its SCSI conformance number and doesn't
> Sitsofe> correctly announce which features it supports. Surely in this
> Sitsofe> case it's reasonable to quirk our way around the problem?
> 
> No. That's an issue in Hyper-V that'll you'll have to take up with Microsoft. I
> don't know what their passthrough limitations are for SCSI-ATA translation.
> Maybe K. Y. has some insight into this?

For the pass through case, the host validates the request and passes the request to the device.
However, not all scsi commands are passed through even though the device it is being passed through
may support the command. WRITE_SAME is one such command. Consequently, in the EVPD page,
we will set state indicating that WRITE_SAME is not supported (even if the device supports it).

Hope this helps.

K. Y 
> 
> There must be a reason why the VPD page was added and yet the device not
> flagged as LBPME=1.
> 
> Many vendors do not support UNMAP/WRITE SAME to DSM TRIM
> translation.
> Additionally, many vendors explicitly only whitelist drives that are known to
> be working correctly. Your drive is an ADATA and therefore very likely to be
> blacklisted by default by a vendor SATL.
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
