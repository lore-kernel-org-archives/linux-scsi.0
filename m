From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs
 that may have been removed.
Date: Fri, 29 Aug 2014 13:53:42 +0000
Message-ID: <1409320422.2036.5.camel@jarvis.lan>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
 <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de>
 <53FFE87B.9040802@cs.wisc.edu> <54001B5F.9040506@suse.de>
 <54002E2E.7030301@acm.org> <54003638.5010301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <54003638.5010301@suse.de>
Content-Language: en-US
Content-ID: <39D09D14E9FB88409B62F001C01BFF34@sw.swsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "hare@suse.de" <hare@suse.de>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-08-29 at 10:13 +0200, Hannes Reinecke wrote:
> On 08/29/2014 09:39 AM, Bart Van Assche wrote:
> > On 08/29/14 08:19, Hannes Reinecke wrote:
> >> On 08/29/2014 04:42 AM, Mike Christie wrote:
> >>> How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
> >>> gets passed to userspace? Is everyone kicking off a new full (add and
> >>> delete) scan to handle this or logging it? Is the driver returning this
> >>> when the LUNs change?
> >>>
> >> Currently it's logged to userspace and ignored.
> >> Doing an automated rescan has proven to be dangerous, as it
> >> might disconnect any LUNs which are still in use by applications.
> >> Especially HA or database setups tends to become very annoyed
> >> when you do an automated rescan.
> >
> > Has it already been considered to add newly discovered LUNs
> > automatically and to leave it to the user to remove stale LUNs manually
> > ? That would be similar to what the rescan-scsi-bus.sh script does
> > without option -r/--remove.
> >
> 
> As of now we're still missing an in-kernel infrastructure which 
> would allow us to react on any sense codes; currently we're relying 
> on the administrator to setup a udev rule here.

Um, I thought this was supposed to solve that problem:

commit 279afdfe78a020b4b1a68bffd0009b961b12982e
Author: Ewan D. Milne <emilne@redhat.com>
Date:   Thu Aug 8 15:07:48 2013 -0400

    [SCSI] Generate uevents on certain unit attention codes

The idea was supposed to be that, as you say, log scrubbers are hard to
configure and break every time someone fixes a spelling error, so we
could now listen for a report luns data change uevent instead.

James
