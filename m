From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Fri, 11 Jul 2014 08:54:18 -0400
Message-ID: <yq1vbr42gzp.fsf@sermon.lab.mkp.net>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140711063216.GA20660@infradead.org> (hch@infradead.org's
 message of "Thu, 10 Jul 2014 23:32:16 -0700")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, James Bottomley <jbottomley@parallels.com>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "hch" == hch@infradead org <hch@infradead.org> writes:

(Back from vacation: Bear with me while I'm catching up on two weeks of
linux-scsi stuff...)

hch> I think the problem is a differnet one.  If we have the logical
hch> provisioning EVPD it configures what method to use, but if we don't
hch> have one we simply check for a max unmap blocks field, and if
hch> that's not present use WRITE SAME.

Yeah, that was done to accommodate the devices out there that predate
the LBP VPD. There sadly are several still. And it's hard to motivate
people to update their storage array firmware even when updates are
readily available.

hch> The patch checks the no_write_same flag before doing that, for
hch> which we also have to do the write_same setup before the discard
hch> setup in sd_revalidate_disk.

The no_write_same was introduced to disable the REQ_WRITE_SAME use case
where we have no INQUIRY/READ CAPACITY/VPD flags to key off of to
determine whether it is safe to send the commands.

no_write_same does not preclude the REQ_DISCARD variants of
WRITE_SAME. Those are gated by the discard heuristics exclusively.

So first of all I'd like to know whether it's a WRITE SAME(16) or a
WRITE SAME(16) with the UNMAP bit set that's coming down.

hch> Ky: does hyperv support UNMAP?  If so any idea why it doesn't set
hch> the maximum unmap block count field in the EVPD?

We shouldn't be sending down WRITE SAME(16) with the UNMAP bit set
unless the device sets LBPME=1 in the READ CAPACITY(16) response.

So what does the storsvc report as its thin provisioning capabilities?

-- 
Martin K. Petersen	Oracle Linux Engineering
