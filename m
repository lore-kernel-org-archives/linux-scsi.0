From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Thu, 24 Jul 2014 09:54:24 -0400
Message-ID: <yq1iommkgkv.fsf@sermon.lab.mkp.net>
References: <20140724122223.GA31798@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140724122223.GA31798@sucs.org> (Sitsofe Wheeler's message of
 "Thu, 24 Jul 2014 13:22:23 +0100")
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
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> Fix incorrectly named variable.  Some block devices (such as
Sitsofe> Hyper-V passthrough SSDs) support logical block provisioning
Sitsofe> (e.g. via UNMAP) but don't set lbpme thus disabling discard. 

The fix for an SSD that is known to support LBP but which does not claim
support for it is to use:

    echo unmap > /sys/class/scsi_disk/foo/provisioning_mode

I'm very much against short-circuiting the LBP logic in a passthrough
driver because then we might end up in the exact situation we were
trying to avoid with this patch series. Namely sending down commands
unsupported by the target device.

This kind of thing really needs to be a sysadmin decision and can be
handled with a udev rule.

-- 
Martin K. Petersen	Oracle Linux Engineering
