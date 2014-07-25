From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Fri, 25 Jul 2014 12:57:02 -0400
Message-ID: <yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
 <yq1egxakb0z.fsf@sermon.lab.mkp.net>
 <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
 (KY Srinivasan's message of "Fri, 25 Jul 2014 16:47:35 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, Christoph Hellwig <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Sitsofe Wheeler <sitsofe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:

KY> For the pass through case, the host validates the request and passes
KY> the request to the device.  However, not all scsi commands are
KY> passed through even though the device it is being passed through may
KY> support the command. WRITE_SAME is one such command. Consequently,
KY> in the EVPD page, we will set state indicating that WRITE_SAME is
KY> not supported (even if the device supports it).

The LBP VPD page flags UNMAP as being supported. Do you actually support
UNMAP to DSM TRIM SCSI-ATA translation?

One challenge in that department is that a single UNMAP command may turn
into many, many, many DSM TRIM commands on the underlying SATA device.
That's why we went with WRITE SAME for the internal Linux SATL, capping
the maximum number of blocks to what we can fit in a single DSM TRIM
command.

-- 
Martin K. Petersen	Oracle Linux Engineering
