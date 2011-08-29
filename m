From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: Broken pci_block_user_cfg_access interface
Date: Mon, 29 Aug 2011 20:47:07 +0200
Message-ID: <4E5BDEAB.5000405@siemens.com>
References: <20110829150552.GA6851@redhat.com> <4E5BB358.3060705@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <4E5BB358.3060705@siemens.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2011-08-29 17:42, Jan Kiszka wrote:
> I still don't get what prevents converting ipr to allow plain mutex
> synchronization. My vision is:
>  - push reset-on-error of ipr into workqueue (or threaded IRQ?)

I'm starting to like your proposal: I had a look at ipr, but it turned
out to be anything but trivial to convert that driver. It runs its
complete state machine under spin_lock_irq, and the functions calling
pci_block/unblock_user_cfg_access are deep inside this thing. I have no
hardware to test whatever change, and I feel a bit uncomfortable asking
Brian to redesign his driver that massively.

So back to your idea: I would generalize pci_block_user_cfg_access to
pci_block_cfg_access. It should fail when some other site already holds
the access lock, but it should remain non-blocking - for the sake of ipr.

We should still provide generic pci-2.3 IRQ masking services, but that
could be done in a second step. I could have a look at this.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
