From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: make INQUIRY response SPC-compliant
Date: Fri, 3 Jul 2015 16:28:25 +0000
Message-ID: <BY2PR0301MB1654779EEF1205C4A009C5F6A0960@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1435741448-29070-1-git-send-email-vkuznets@redhat.com>
 <20150703161903.GA20449@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150703161903.GA20449@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, July 3, 2015 9:19 AM
> To: Vitaly Kuznetsov
> Cc: linux-scsi@vger.kernel.org; Long Li; KY Srinivasan; Haiyang Zhang; James
> E.J. Bottomley; devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi: storvsc: make INQUIRY response SPC-compliant
> 
> On Wed, Jul 01, 2015 at 11:04:08AM +0200, Vitaly Kuznetsov wrote:
> > SPC-2/3/4 specs state that "The standard INQUIRY data (see table ...)
> > shall contain at least 36 bytes". Hyper-V host doesn't always honor this
> > requirement, e.g. when there is no physical device present at a particular
> > LUN host sets Peripheral qualifier to 011b and Additional length to 0
> > (thus making the reply 5-bytes long). Upper level SCSI stack complains
> > with 'INQUIRY result too short (5), using 36'. Fix the issue by mangling
> > Additional length field in host's reply at the driver level.
> 
> This looks like a big mess, and usage of phys_to_virt is not generally
> safe to start with.
> 
> If HyperV really is that broken the warning seems correct, but if you
> really have to get rid of it we could add a blist flag to not issue
> the warning in the core code instead of hacking around it in the driver.

Agreed. We have fixed this issue in win10 and I am trying to get the fix backported.

Regards,

K. Y
