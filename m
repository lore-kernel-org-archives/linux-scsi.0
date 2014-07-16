From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 16 Jul 2014 15:08:13 -0400
Message-ID: <yq17g3drujm.fsf@sermon.lab.mkp.net>
References: <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
 <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
 <yq1a98d2z5x.fsf@sermon.lab.mkp.net>
 <20140716110111.GA7382@infradead.org>
 <yq14myhtijx.fsf@sermon.lab.mkp.net>
 <20140716173827.GB20528@infradead.org>
 <yq1fvi1rya0.fsf@sermon.lab.mkp.net>
 <1405533734.3165.12.camel@dabdike.int.hansenpartnership.com>
 <yq1bnsprvl1.fsf@sermon.lab.mkp.net>
 <1405536631.3165.23.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1405536631.3165.23.camel@dabdike.int.hansenpartnership.com>
 (James Bottomley's message of "Wed, 16 Jul 2014 18:50:31 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <jbottomley@parallels.com> writes:

James> It's the code we identified in sd.c:read_capacity_16():

That's there to support devices that implement thin provisioning but
which predate the LBP VPD page. And thus have no way to tell us their
preferred command variant.

James> If the inquiry shows LBPME set, we'll do write same regardless of
James> the no_write_same bit.  That's why for SPC-2 devices it only
James> shows up on >> 2TB devices because they force RC16.

But we only do so if they have LBPME set. Generally they don't.

The problem for hyperv was that LBPME was set. And because it claimed
SBC-2 we did not check the LBP VPD page to see that it prefers UNMAP.

I believe we did consider unconditionally checking for VPDs when LBPME
was set but I seem to recall that it broke some device that had garbage
in the READ CAPACITY(16) response. I'll see if I can locate the details.

Otherwise I'm willing to entertain that idea.

-- 
Martin K. Petersen	Oracle Linux Engineering
