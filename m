From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: [PATCH 0/3] Enable discard on Hyper-V
Date: Thu, 24 Jul 2014 08:47:39 +0100
Message-ID: <20140724074739.GA15127@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
 <20140723141558.GA9705@infradead.org>
 <20140723201341.GA10292@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140723201341.GA10292@sucs.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 23, 2014 at 09:13:41PM +0100, Sitsofe Wheeler wrote:
> On Wed, Jul 23, 2014 at 07:15:58AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 23, 2014 at 03:10:28PM +0100, Sitsofe Wheeler wrote:
> > > I'm not sure this alone will work - won't sdev_bflags/bflags have
> > > already been built at this point?
> > 
> > They've been built up, but we can still or new values into it.  It looks
> > fine to me from review, but if you can test it on an actualy hypverv
> > setup that would be valueable feedback.
> 
> The previous patches didn't work for me with a Windows 2012 R2 host with a
> 3.16.0-rc6.x86_64-00076-g2f7d2ec-dirty guest. After applying
> 
> > term project, this late in the 3.17 cycle I'd just like to merge
> > something that gets discards on hyperv to work.

OK how about the following patches:

Sitsofe Wheeler (3):
  [SCSI] Add quirk for forcing logical block provisioning tests
  [SCSI] storvsc: Add Hyper-V logical block provisioning quirk
  [SCSI] Make LBP quirk skip lbpme checks

 drivers/scsi/scsi_scan.c    |  4 +++-
 drivers/scsi/sd.c           | 12 ++++++++++--
 drivers/scsi/storvsc_drv.c  |  6 ++++++
 include/scsi/scsi_device.h  |  1 +
 include/scsi/scsi_devinfo.h |  2 ++
 5 files changed, 22 insertions(+), 3 deletions(-)

-- 
1.9.3

-- 
Sitsofe | http://sucs.org/~sits/
