From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 0/9] PCI: Eliminate race conditions between hotplug and sysfs rescan/remove (Was: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once)
Date: Fri, 10 Jan 2014 15:20:44 +0100
Message-ID: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <CAErSpo6edmz5nkSYogbYk1FFYsCCwNV_-rir2jGP2JBnvOx+iw@mail.gmail.com> <1992931.Zv6xBcN8V4@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1992931.Zv6xBcN8V4@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
List-Id: linux-scsi@vger.kernel.org

[Cc: adding linux-scsi for the MPT changes, Ben for powerpc, Matthew for
 platform/x86 and Konrad for Xen]

On Friday, December 06, 2013 02:21:50 AM Rafael J. Wysocki wrote:

[...]

> 
> OK
> 
> To be a bit more constructive, as the next step I'd try to use
> pci_remove_rescan_mutex to serialize all PCI hotplug operations (as I said
> above) without making the other changes made by my patch.  Does that sound
> reasonable?

Well, no answer here, so as a followup, a series implementing that idea
follows.

I *hope* I found all of the places that need to be synchronized vs the bus
rescan and device removal that can be triggered via sysfs, but I might overlook
something.  Also in some cases I wasn't quite sure how much stuff to put under
the lock, because said stuff is not exactly straightforward.

Enjoy!

Rafael
