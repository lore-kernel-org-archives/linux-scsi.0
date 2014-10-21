From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 0/3] scsi: Add Hyper-V logical block provisioning quirks
Date: Tue, 21 Oct 2014 05:17:08 +0100
Message-ID: <20141021041707.GA11691@sucs.org>
References: <20141010074901.GA32028@sucs.org>
 <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <yq1r3ya6t0i.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 14, 2014 at 09:06:37PM -0400, Martin K. Petersen wrote:
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> A previous patch attempted to add a quirk to workaround this
> Sitsofe> but the quirk was only enabled after the features had been
> Sitsofe> scanned for, wouldn't work for "small" disks 
> 
> What does that mean, exactly?

It means:

1. The committed patches never worked because the running of the code to
test whether the quirk should be enabled happened after the probing code
the quirk would have affected ran. So roughly:

bflag = 0;
if (feature || bflag) {
	do_stuff();
}
if (matching_dev) {
	bflag = 1; // Too late...
}

See https://lkml.org/lkml/2014/7/23/615 for prior details.

2. On top of the above, when a disk is "small" (has less than 2^32
sectors which is typically < 2 TBytes in size) READ CAPACITY(16) won't
be triggered. If READ CAPACITY(16) isn't triggered then the lbpme bytes
won't be checked, thin provisioning will never be enabled and the
committed patch would doubly not work for such disks.

Apologies for the delay in replying.

-- 
Sitsofe | http://sucs.org/~sits/
