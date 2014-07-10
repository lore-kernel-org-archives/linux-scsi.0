From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Thu, 10 Jul 2014 03:13:20 -0700
Message-ID: <20140710101320.GB1151@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-6-git-send-email-kys@microsoft.com>
 <20140709084415.GF6012@infradead.org>
 <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, Christoph Hellwig <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 09, 2014 at 06:51:38PM +0000, KY Srinivasan wrote:
> On Azure, we sometimes have unbounded I/O latencies and some distributions
> (such as SLES12) based on recent kernels are invoking the "Abort Handler".

Any kernel will invoke the abort handler if present, and then escalate
to the various resets.

> Unfortunately, our scsi emulation on the host does not support aborting 
> a command. The issue I have seen is that the upper level scsi code attempts
> error recovery when the command times out and finally frees up the command.
> The host subsequently responds to the command that has timed out and since
> the memory has been freed up, we end up touching freed memory in this
> driver. Since the host is also doing error recovery, by just delaying the
> error handler in the guest until we can account for all the in-flight 
> commands, we can get around the problem.

The storvsc driver does implement an bus reset error handler, and
after that completes successfully the midlayer frees the commands,
and the driver has to deal with this and not call scsi_done after
the reset finished (normally you'd expect the hardware to not complete
requests after an reset).

Note that you could increase the timeout and/or implement an
eh_timed_out handler that just returns BLK_EH_RESET_TIMER, but if the
completion takes too long the expectation is that a command will
eventually finish instead of beeing delayed by an unmound amount.
