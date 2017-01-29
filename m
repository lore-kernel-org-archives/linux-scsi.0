From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight host.
Date: Sun, 29 Jan 2017 00:56:10 -0800
Message-ID: <20170129085610.GA10258@infradead.org>
References: <1485437940-18706-1-git-send-email-cavery@redhat.com>
 <20170126145159.GA29683@infradead.org>
 <DM5PR03MB24902D4813941D2722030DA1A0480@DM5PR03MB2490.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <DM5PR03MB24902D4813941D2722030DA1A0480@DM5PR03MB2490.namprd03.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "famz@redhat.com" <famz@redhat.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 29, 2017 at 12:35:32AM +0000, KY Srinivasan wrote:
> Windows has chosen this model for virtualizing FC devices to the guest -
> without rports (or vports). As I noted in my earlier email, James came
> up with this notion of a lightweight template almost a year ago. We can
> certainly pick a  more appropriate name and include better documentation. 

Can we take a step back and figure out what you're trying to
archive here.

storsvc is a paravirtualized device interface, and whatever underlies
it should be of no relevance for the guest.

Despite that fact Microsoft apparently wants to expose a FC-like
port_name and node_name to guests for some virtual disks.  Can you
please explain what the guest is supposed to use them for?

And second I'd like to understand what the fascination with the FC
transport class is to expose these two attributes.  Given that
your sysfs layout will be entirely different from real FC devices
I simply don't see any need for that.

Why can't this whole thing simply be solved by adding sdev_attrs
for the port_name and node_name to storsvc directly?
