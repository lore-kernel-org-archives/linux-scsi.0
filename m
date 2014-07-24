From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Thu, 24 Jul 2014 11:54:20 -0400
Message-ID: <yq1egxakb0z.fsf@sermon.lab.mkp.net>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140724153612.GA23648@sucs.org> (Sitsofe Wheeler's message of
 "Thu, 24 Jul 2014 16:36:12 +0100")
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
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, gregkh@linuxfoundation.org, jasowang@redhat.com, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, Christoph Hellwig <hch@infradead.org>, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> So we can see it is really a SATA device that announces discard
Sitsofe> correctly and supports discard through WRITE_SAME(16).

No, that's the SATA device that announces support for DSM TRIM, and as a
result the Linux SATL reports support for WRITE SAME(16) w. the UNMAP
bit set and LBPME.

Sitsofe> It is the act of passing it through Hyper-V that turned it into
Sitsofe> a SCSI device that supports UNMAP (but not WRITE_SAME(16)),
Sitsofe> doesn't announce its SCSI conformance number and doesn't
Sitsofe> correctly announce which features it supports. Surely in this
Sitsofe> case it's reasonable to quirk our way around the problem?

No. That's an issue in Hyper-V that'll you'll have to take up with
Microsoft. I don't know what their passthrough limitations are for
SCSI-ATA translation. Maybe K. Y. has some insight into this?

There must be a reason why the VPD page was added and yet the device not
flagged as LBPME=1.

Many vendors do not support UNMAP/WRITE SAME to DSM TRIM translation.
Additionally, many vendors explicitly only whitelist drives that are
known to be working correctly. Your drive is an ADATA and therefore very
likely to be blacklisted by default by a vendor SATL.

-- 
Martin K. Petersen	Oracle Linux Engineering
