From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Wed, 16 Jul 2014 15:20:00 -0400
Message-ID: <yq138e1rtzz.fsf@sermon.lab.mkp.net>
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
 <94D0CD8314A33A4D9D801C0FE68B402958BA721F@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958BA721F@G9W0745.americas.hpqcorp.net>
 (Robert Elliott's message of "Wed, 16 Jul 2014 18:43:43 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Rob" == Elliott, Robert (Server Storage) <Elliott@hp.com> writes:

Rob> WRITE SAME with the UNMAP bit set to one (and a few other
Rob> conditions) guarantees that the data is zeroed out, while the UNMAP
Rob> command is just a hint.  They're not fully interchangeable.  Which
Rob> semantics are implied by REQ_DISCARD and these functions?

Voluntary deprovisioning of a block range.

Rob> One benefit of UNMAP is that UNMAP supports a list of discontiguous
Rob> LBA ranges, whereas WRITE SAME just supports one LBA range.
Rob> sd_setup_discard_cmnd is not taking advantage of this feature,
Rob> though.

The block layer can only describe one contiguous block range in a
request. My copy offload patches introduces the bi_special field that
allows us to attach additional information to an I/O. I have
experimented with doing that for discards to overcome the suck of DSM
TRIM. Splitting and merging requests in MD/DM gets much more cumbersome,
though.

Rob> Ideally, the block layer would merge multiple discards into one
Rob> UNMAP command if they're stuck on the request queue for a while,
Rob> like it merges adjacent reads and writes. 

We support merging contiguous smaller discard requests.

We did discuss having a (separate) I/O scheduler to coalesce
discontiguous discard requests. However, the attempts at this turned out
to be pretty hideous.

It also wasn't evident that it was worth the hassle. While UNMAP allows
us to express large regions, DSM TRIM on the SATA side is limited to 32
MB per range. So in many cases we end up maxing out the payload capacity
even with a single contiguous range.

We expect LBP SCSI devices to queue commands. Being able to express
multiple ranges in one shot is less critical in that case.

-- 
Martin K. Petersen	Oracle Linux Engineering
