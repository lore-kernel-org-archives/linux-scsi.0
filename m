From: Eric Seppanen <eric@purestorage.com>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Fri, 4 Oct 2013 11:12:34 -0700
Message-ID: <CADOQvuMY6NMY4U9jpbR+oi5N6=bLGFez0d5_PEf-G85_VWMZuA@mail.gmail.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
 <20130920203222.GA14306@kroah.com>
 <a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
 <524180B7.7090307@gmail.com>
 <3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
 <5241C9E7.2000404@cs.wisc.edu>
 <bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
 <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
 <1380802143.19256.95.camel@haakon3.risingtidesystems.com>
 <CADOQvuPWaSntci+4pNCbsP-Ug6P=xf1_5ZqqoaA+fXumgfHmeA@mail.gmail.com>
 <1380889136.4010.313.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1380889136.4010.313.camel@localhost.localdomain>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: emilne@redhat.com
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 4, 2013 at 5:18 AM, Ewan Milne <emilne@redhat.com> wrote:
> On Thu, 2013-10-03 at 13:48 -0700, Eric Seppanen wrote:
>> Do I/O timeouts and flush timeouts need to be independently adjusted?
>> If you're having trouble with slow operations, it seems likely to be
>> across the board.
>>
>> Flush timeout could be defined as 2x the read/write timeout.  Any
>> other command-specific timeouts could be scaled the same way.
>
> It seems to me that there isn't any reason to expect that the maximum
> amount of time a device might take to perform various operations are
> related by any coefficient.  And, an HBA (particularly iSCSI or FC)
> could very well have different device types connected at different
> target IDs.  So I think the flush timeout should be adjustable on
> a per-device basis.  It's probably related more to the cache size
> on the device than anything else...

There are two possible delays: how long the device might possibly
take, and how long the storage fabric might take.

On a local device, only the first matters.  But there are environments
where the second dominates (e.g. a virtual machine, where the
hypervisor's storage uses multipath with a long failover delay).

If somebody wants to set flush timeouts > 60 seconds, I would like to
know if they're trying to address a slow device or a slow fabric.  If
it's the fabric, then it's kind of silly to make them set three
different timeouts to address the same problem.

An alternate way of handling long fabric delays would be to have a
fabric_timeout that gets added to all the other timeouts... could be a
scsi_host parameter but that's probably overengineering the problem.

There are already VM vendors that tell customers to adjust the current
sysfs timeout, so the least amount of work would be to make all of the
other timeouts track that one in some way (additive or
multiplicative).
