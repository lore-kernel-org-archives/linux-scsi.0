From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
Date: Wed, 23 Jul 2014 15:39:16 +0000
Message-ID: <c8cff1e18d9c456ea98ada869fe4b2bf@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723100448.GA2540@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140723100448.GA2540@sucs.org>
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
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, July 23, 2014 3:05 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; apw@canonical.com;
> jasowang@redhat.com; jbottomley@parallels.com; hch@infradead.org;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Add blist flags
> 
> On Mon, Jul 21, 2014 at 04:06:01PM -0700, K. Y. Srinivasan wrote:
> > Add blist flags to permit the reading of the VPD pages even when the
> > target may claim SPC-2 compliance. MSFT targets currently claim SPC-2
> > compliance while they implement post SPC-2 features.
> > With this patch we can correctly handle WRITE_SAME_16 issues.
> 
> OK I've just seen this as I was about to post a similar patch to get discard
> going on Hyper-V. Will your patches handle Hyper-V pass through devices
> that support discard? The SSD I have here reports the following in the Linux

It should. Hyper-V does support pass through devices.

K. Y
> VM:
> 
> # sg_vpd -p lbpv  /dev/sdc
> Logical block provisioning VPD page (SBC):
>   Unmap command supported (LBPU): 1
>   Write same (16) with unmap bit supported (LBWS): 0
>   Write same (10) with unmap bit supported (LBWS10): 0
>   Logical block provisioning read zeros (LBPRZ): 0
>   Anchored LBAs supported (ANC_SUP): 1
>   Threshold exponent: 0
>   Descriptor present (DP): 0
>   Provisioning type: 0
> 
> # sg_readcap -l /dev/sdc
> Read Capacity results:
>    Protection: prot_en=0, p_type=0, p_i_exponent=0
>    Logical block provisioning: lbpme=0, lbprz=0
>    Last logical block address=234441647 (0xdf94baf), Number of logical
> blocks=234441648
>    Logical block length=512 bytes
>    Logical blocks per physical block exponent=0
>    Lowest aligned logical block address=0
> Hence:
>    Device size: 120034123776 bytes, 114473.5 MiB, 120.03 GB
> 
> --
> Sitsofe | http://sucs.org/~sits/
