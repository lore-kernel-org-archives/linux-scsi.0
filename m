From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bugfix 3/3] eata: Enhance eata driver to support PCI device
 hot-removal
Date: Wed, 16 Sep 2015 06:42:11 -0700
Message-ID: <20150916134211.GA21535@infradead.org>
References: <CAErSpo4oignSpK-LCLO=deW_FZ-V58GUhBxJ5uvmXe4DYo4WdA@mail.gmail.com>
 <1442200140-30808-1-git-send-email-jiang.liu@linux.intel.com>
 <1442200140-30808-4-git-send-email-jiang.liu@linux.intel.com>
 <55F6837A.5020807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55F6837A.5020807@suse.de>
Sender: linux-pci-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Arthur Marsh <arthur.marsh@internode.on.net>, Dario Ballabio <ballabio_dario@emc.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 14, 2015 at 10:21:14AM +0200, Hannes Reinecke wrote:
> Welll ... if you don't have hardware (and I strongly hope you refer to
> 'hardware able to do hotplugging', not 'hardware for the eata driver'
> ...) why add the code at all?
> Chances are no-one will ever need eata PCI hotplug; SCSI parallel
> typically isn't very good at hotplugging, so throwing in PCI hotplug
> will only confuse matters more.
> Plus due to the sheer mechanics involved here I find it very unlikely
> anyone will be using it in real life.

Because it's used for module removal and we want every driver to use
the standard interface that.

Jiang, you also need to convert the driver to
scsi_add_host/scsi_remove_host from the legacy scsi_register interface,
otherwise the SCSI layer will be very unhappy.

Take a look at commit 0d31f8759109cbc1e6fc196d08e6b0e8a9e93b3f for
example, the change should be straight forward.
