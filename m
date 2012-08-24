From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/8] csiostor: Chelsio FCoE offload driver submission
Date: Fri, 24 Aug 2012 13:04:06 -0400 (EDT)
Message-ID: <20120824.130406.1059160453285824849.davem@davemloft.net>
References: <1345760873-12101-1-git-send-email-naresh@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1345760873-12101-1-git-send-email-naresh@chelsio.com>
Sender: netdev-owner@vger.kernel.org
To: naresh@chelsio.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, dm@chelsio.com, netdev@vger.kernel.org, chethan@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Naresh Kumar Inna <naresh@chelsio.com>
Date: Fri, 24 Aug 2012 03:57:45 +0530

> This is the initial submission of the Chelsio FCoE offload driver (csiostor)
> to the upstream kernel. This driver currently supports FCoE offload
> functionality over Chelsio T4-based 10Gb Converged Network Adapters.
> 
> The following patches contain the driver sources for csiostor driver and
> updates to firmware/hardware header files shared between csiostor and
> cxgb4 (Chelsio T4-based NIC driver). The csiostor driver is dependent on these
> header updates. These patches have been generated against scsi 'misc' branch.
> 
> csiostor is a low level SCSI driver that interfaces with PCI, SCSI midlayer and
> FC transport subsystems. This driver claims the FCoE PCIe function on the
> Chelsio Converged Network Adapter. It relies on firmware events for slow path
> operations like discovery, thereby offloading session management. The driver
> programs firmware via Work Request interfaces for fast path I/O offload
> features.

You are going to have to get rid of these module parameters.

That have to do with things that are in no way specific to your device,
and therefore should be configured using generic kernel facilities.

Using driver specific module parameters results in a poor user
experience, because in order to make a configuration change the user
has to know exactly what kind of device and driver is underneath,
and then learn what the unique method is to make that configuration
change.

If you use a generic facility, the user only needs to learn one way to
make a configuration change, regardless of device type and driver.
