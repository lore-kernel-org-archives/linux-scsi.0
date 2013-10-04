From: Ewan Milne <emilne@redhat.com>
Subject: Re: Drivers: scsi: FLUSH timeout
Date: Fri, 04 Oct 2013 08:18:56 -0400
Message-ID: <1380889136.4010.313.camel@localhost.localdomain>
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
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CADOQvuPWaSntci+4pNCbsP-Ug6P=xf1_5ZqqoaA+fXumgfHmeA@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Eric Seppanen <eric@purestorage.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-10-03 at 13:48 -0700, Eric Seppanen wrote:
> On Thu, Oct 3, 2013 at 5:09 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > On Wed, 2013-10-02 at 18:29 +0000, KY Srinivasan wrote:
> > > Ideally, I want this to be adjustable like the way we can change the I/O timeout.
> > > Since that has been attempted earlier and rejected (not clear what the reasons were),
> > > I was suggesting that we pick a larger number. James, let me know how I should proceed here.
> > >
> >
> > I think the objection was to making a module parameter for doing this
> > globally for all struct scsi_disk, and not the idea of making it
> > adjustable on an individual basis per-say..
> >
> > What about adding a /sys/class/scsi_disk/$HCTL/flush_timeout..?
> 
> Do I/O timeouts and flush timeouts need to be independently adjusted?
> If you're having trouble with slow operations, it seems likely to be
> across the board.
> 
> Flush timeout could be defined as 2x the read/write timeout.  Any
> other command-specific timeouts could be scaled the same way.

It seems to me that there isn't any reason to expect that the maximum
amount of time a device might take to perform various operations are
related by any coefficient.  And, an HBA (particularly iSCSI or FC)
could very well have different device types connected at different
target IDs.  So I think the flush timeout should be adjustable on
a per-device basis.  It's probably related more to the cache size
on the device than anything else...

Also note that there is a SD_WRITE_SAME_TIMEOUT value that is currently
4x the default SD_TIMEOUT value.  That should probably be adjustable
as well.

-Ewan
