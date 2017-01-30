From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight host.
Date: Mon, 30 Jan 2017 22:55:56 +0000
Message-ID: <DM5PR03MB24909EA721FA054CA86DFC54A04B0@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1485437940-18706-1-git-send-email-cavery@redhat.com>
 <20170126145159.GA29683@infradead.org>
 <DM5PR03MB24902D4813941D2722030DA1A0480@DM5PR03MB2490.namprd03.prod.outlook.com>
 <20170129085610.GA10258@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170129085610.GA10258@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "famz@redhat.com" <famz@redhat.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, January 29, 2017 12:56 AM
> To: KY Srinivasan <kys@microsoft.com>
> Cc: Christoph Hellwig <hch@infradead.org>; Cathy Avery
> <cavery@redhat.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
> dan.carpenter@oracle.com; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org; famz@redhat.com
> Subject: Re: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight host.
> 
> On Sun, Jan 29, 2017 at 12:35:32AM +0000, KY Srinivasan wrote:
> > Windows has chosen this model for virtualizing FC devices to the guest -
> > without rports (or vports). As I noted in my earlier email, James came
> > up with this notion of a lightweight template almost a year ago. We can
> > certainly pick a  more appropriate name and include better documentation.
> 
> Can we take a step back and figure out what you're trying to
> archive here.
> 
> storsvc is a paravirtualized device interface, and whatever underlies
> it should be of no relevance for the guest.
> 
> Despite that fact Microsoft apparently wants to expose a FC-like
> port_name and node_name to guests for some virtual disks.  Can you
> please explain what the guest is supposed to use them for?

My initial implementation of the virtual FC support on Hyper-V was exactly
what you are proposing here - FC disks were being treated exactly as SCSI
disks. We then had customers (HP Enterprise) that were building storage 
appliances based on FC disks on the host and they required port name and 
node name information to be published in sysfs so that their management tools
would work. They required the port and node ID information to be published
precisely the way the FC transport would publish them (in terms of location).

> 
> And second I'd like to understand what the fascination with the FC
> transport class is to expose these two attributes.  Given that
> your sysfs layout will be entirely different from real FC devices
> I simply don't see any need for that.
> 
> Why can't this whole thing simply be solved by adding sdev_attrs
> for the port_name and node_name to storsvc directly?

No fascination with the FC transport other than it already allowed for publishing the
port and node IDs. We can certainly look at other ways to publish this information -
the proposal by James to have this "light weight" FC transport was precisely for this reason.

Regards,

K. Y
