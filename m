From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Wed, 9 Jul 2014 18:51:38 +0000
Message-ID: <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
 <20140709084415.GF6012@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140709084415.GF6012@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "apw@canonical.com" <apw@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:44 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
> 
> On Tue, Jul 08, 2014 at 05:46:50PM -0700, K. Y. Srinivasan wrote:
> > Implement a simple abort handler. The host does not support "Abort";
> > just ensure that all inflight I/Os have been accounted for.
> 
> The abort handler should abort a single command, not wait for all of them.
> What issue do you see that this tries to address?

On Azure, we sometimes have unbounded I/O latencies and some distributions (such as SLES12) based on recent kernels are invoking
the "Abort Handler". Unfortunately, our scsi emulation on the host does not support aborting a command.
The issue I have seen is that the upper level scsi code attempts error recovery when the command times out and finally frees up the command.
The host subsequently responds to the command that has timed out and since the memory has been freed up, we end up touching freed memory
in this driver. Since the host is also doing error recovery, by just delaying the error handler in the guest until we can account for all the in-flight commands,
we can get around the problem.

Regards,

K. Y
