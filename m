From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 31/43] hpsa: call pci_release_regions after pci_disable_device
Date: Fri, 17 Apr 2015 15:44:07 +0200
Message-ID: <55310E27.1050801@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134931.30238.90240.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbbDQNoK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:44:10 -0400
In-Reply-To: <20150416134931.30238.90240.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> Despite the fact that PCI devices are enabled in this order:
>     1. pci_enable_device
>     2. pci_request_regions
>
>     Documentation/PCI/pci.txt specifies that they be undone
>     in this order
>     1. pci_disable_device
>     2. pci_release_regions
>
>     Tested by injecting error in the call to pci_enable_device
>     in hpsa_init_one -> hpsa_pci_init:
>     [    9.095001] hpsa 0000:04:00.0: failed to enable PCI device
>     [    9.095005] hpsa: probe of 0000:04:00.0 failed with error -22
>     (-22 is -EINVAL)
>     and then in the call pci_request_regions:
>     [    9.178623] hpsa 0000:04:00.0: failed to obtain PCI resources
>     [    9.178671] hpsa: probe of 0000:04:00.0 failed with error -16
>     (-16 is -EBUSY)
>
>     and then by adding
>         reset_devices
>     to the kernel command line and inject errors into the two
>     calls to pci_enable_device and the call to pci_request_regions
>     in hpsa_init_one -> hpsa_init_reset_devices.
>
>     (inject on 6th call, 1st to hpsa2)
>     [   62.413750] hpsa 0000:04:00.0: Failed to enable PCI device
>
>     (inject on 7th call, 2nd to hpsa2)
>     [   62.807571] hpsa 0000:04:00.0: failed to enable device.
>
>     (inject on 8th call, 3rd to hpsa2)
>     [   62.697198] hpsa 0000:04:00.0: failed to obtain PCI resources
>     [   62.697234] hpsa: probe of 0000:04:00.0 failed with error -16
>
>     The reset_devices path calls return -ENODEV on failure
>     rather than passing the result, which apparently doesn't
>     cause the pci driver to print anything.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace < don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


