From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Drivers: scsi
Date: Sun, 04 Nov 2012 09:39:09 +0000
Message-ID: <1352021949.2427.19.camel@dabdike.int.hansenpartnership.com>
References: <1351960806-16240-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1351960806-16240-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, ohering@suse.com, linux-kernel@vger.kernel.org, hch@infradead.org, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2012-11-03 at 09:40 -0700, K. Y. Srinivasan wrote:
> Do we currently support dynamic re-sizing of LUNs. Hyper-V can
> notify capacity change via sense data and I was wondering if this
> is handled in the generic scsi code.

Depends what you mean by "dynamic".  Experience shows that most users
really don't want all this to happen without manual intervention
(particularly on shrink).  However, we have the mechanics in place.
Just send ASC/Q 2A/09 and it can get vectored up to LVM which resizes
the volume and can be scripted automatically to resize the filesystem.

hypervisor people tend to have problems with scripting, so there are
some hacks that do this outside of the normal event system ... see for
example virtio_scsi.c

James
